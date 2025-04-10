package flixel.system;

import haxe.macro.TypeTools;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

class BufferMacro
{
	public static function build(isVector:Bool, includeGetters = true):ComplexType
	{
		final local = Context.getLocalType();
		switch local {
			// Extract the type parameter
			case TInst(local, [type]):
				return buildBuffer(getFields(type, includeGetters), type, isVector);
			default:
				throw "Expected TInst";
		}
	}
	
	static function getFields(type:Type, includeGetters:Bool):Array<ClassField>
	{
		// Follow it to get the underlying anonymous structure
		switch type.follow()
		{
			case TAbstract(abType, []):
				final fields = getFields(abType.get().type, includeGetters).copy();
				// add abstract fields too
				if (includeGetters && (abType.get().impl != null || abType.get().impl.get() != null))
				{
					final statics = abType.get().impl.get().statics.get();
					for (field in statics)
					{
						if (field.kind.match(FVar(AccCall, _)))
						{
							fields.push(field);
						}
					}
				}
				return fields;
			case TAnonymous(type):
				return type.get().fields;
			case TInst(found, _):
				throw 'Expected type parameter to be an anonymous structure, got ${found.get().name}';
			case TEnum(found, _):
				throw 'Expected type parameter to be an anonymous structure, got ${found.get().name}';
			case found:
				throw 'Expected type parameter to be an anonymous structure, got ${found.getName()}';
		}
	}
	
	static function buildBuffer(fields:Array<ClassField>, type:Type, isVector:Bool)
	{
		// Sort fields by pos to ensure order is maintained (weird that this is needed)
		fields.sort((a, b)->a.pos.getInfos().max - b.pos.getInfos().max);
		
		// Distinguish getters from actual fields
		final getters:Array<ClassField> = fields.copy();
		var i = fields.length;
		while (i-- > 0)
		{
			// TODO: Prevent double adds for getters over typedef fields?
			final field = fields[i];
			if (field.kind.match(FVar(AccCall, _)))
			{
				fields.remove(field);
			}
		}
		
		// Generate unique name for each type
		final arrayType = fields[0].type;
		final arrayTypeName = getTypeName(arrayType);
		final prefix = (isVector ? "" : "Array_") + arrayTypeName + "_" + getTypeIdentifier(type);
		final name = "Buffer_" + prefix;
		final complexType = type.toComplexType();
		
		// Check whether the generated type already exists
		try
		{
			Context.getType(name);
			
			// Return a `ComplexType` for the generated type
			return TPath({pack: [], name: name});
		}
		catch (e) {} // The generated type doesn't exist yet
		
		final length = fields.length;
		if (length < 2)
			throw "Just use an array";
		
		// Make sure all fields use the same type
		for (i in 1...length)
		{
			if (arrayType.toString() != fields[i].type.toString())
			{
				throw 'Cannot build buffer for type: { ${fields.map((f)->f.type.toString()).join(", ")} }';
			}
		}
		
		final pushEachFunc:Field =
		{
			doc:"Creates an item with the given values and adds it at the end of this Buffer and returns the new length of this Array.\n\n"
				+ "This operation modifies this Array in place.\n\n"
				+ "this.length increases by 1.",
			pos: Context.currentPos(),
			name: "push",
			access: [APublic, AOverload, AExtern, AInline],
			kind:FFun
			({
				args: fields.map(function (f):FunctionArg return { type: f.type.toComplexType(), name: f.name }),
				expr:macro {
					$b{[for (field in fields)
					{
						macro this.push($i{field.name});
					}]}
					return length;
				}
			})
		}
		
		final bufferCt = TPath({pack: [], name: name});
		// Get the iterator complex types (which are actually created later)
		final itemTypeName = getTypeName(type);
		final arrayCT = arrayType.toComplexType();
		
		// define the buffer
		final def = macro class $name
		{
			static inline var FIELDS:Int = $v{length};
			
			/** The number of items in this buffer */
			public var length(get, never):Int;
			inline function get_length() return Std.int(this.length / FIELDS);
			
			public inline function new ()
			{
				$e{ isVector
					? macro this = new openfl.Vector()
					: macro this = []
				}
			}
			
			/**
			 * Set the length of the Array.
			 * If len is shorter than the array's current size, the last length - len elements will
			 * be removed. If len is longer, the Array will be extended
			 * 
			 * **Note:** Since FlxBuffers are actually Arrays of some primitive, often `Float`, it
			 * will likely add all zeros
			 * 
			 * @param   length  The desired length
			 */
			public inline function resize(length:Int)
			{
				$e{isVector
					? macro this.length = length * FIELDS
					: macro this.resize(length * FIELDS)
				}
			}
		};
		
		// Generate unique doc, but with static example
		def.doc = 'An `${isVector ? "openfl.Vector" : "Array"}<$arrayTypeName>` disguised as an `Array<$itemTypeName>`.'
			+ "\nOften used in under-the-hood Flixel systems, like rendering,"
			+ "\nwhere creating actual instances of objects every frame would balloon memory."
			+ "\n"
			+ "\n## Example"
			+ "\nIn the following example, see how it behaves quite similar to an Array"
			+ "\n```haxe"
			+ "\n	var buffer = new FlxBuffer<{final x:Float; final y:Float;}>();"
			+ "\n	for (i in 0...100)"
			+ "\n		buffer.push(i % 10, Std.int(i / 10));"
			+ "\n	"
			+ "\n	buffer.forEach(function (x, y)"
			+ "\n		{"
			+ "\n			trace('$x: $x, $y: $y');"
			+ "\n		}"
			+ "\n	);"
			+ "\n```"
			+ "\n"
			+ "\n## Caveats"
			+ "\n- Can only be modified via `push` and `resize`. Missing notable"
			+ "\nfeatures like , `pop`, `shift` and setting via array access operator, these can be"
			+ "\nimplemented but are low priority"
			+ "\n- all retrieved items must be handled via inline functions to avoid ever actually"
			+ "\ninstantiating an anonymous structure. This includes `Std.string(item)`";
		
		// Add our overloaded push methods from before
		def.fields.push(pushEachFunc);
		
		for (i => field in getters)
		{
			final fieldName = field.name;
			final funcName = "get" + fieldName.charAt(0).toUpperCase() + fieldName.substr(1);
			// Create the field in another class (for easy reification) then move it over
			def.fields.push((macro class TempClass
			{
				/** Helper for `get(item).$name` */
				public inline function $funcName(index:Int)
				{
					return this.get(index + $i);
				}
			}).fields[0]);
		}
		
		// `macro class` gives a TDClass, so that needs to be replaced
		// Determine our buffer's base
		final listType = (isVector ? macro:openfl.Vector<$arrayCT> : macro:Array<$arrayCT>);
		def.kind = TDAbstract(listType, [listType], [listType]);
		Context.defineType(def);
		
		// Return a `ComplexType` for the generated type
		return bufferCt;
	}
	
	static function getTypeIdentifier(type:Type)
	{
		return switch(type)
		{
			case TAnonymous(type): type.get().fields.map((f)->'${f.name}').join("_");
			default: getTypeName(type);
		}
	}
	
	static function getTypeName(type:Type)
	{
		return switch(type)
		{
			case TAbstract(type, []): type.get().name;
			case TAnonymous(type): 
				'{ ${type.get().fields.map((f)->'${f.name}: ${getTypeName(f.type)}').join(", ")} }';
			case TInst(type, []): type.get().name;
			case TType(type, []): type.get().name;
			default: type.getName();
		}
	}
}
#else

@:genericBuild(flixel.system.FlxBuffer.BufferMacro.build(true))
class FlxBuffer<T> {}

@:genericBuild(flixel.system.FlxBuffer.BufferMacro.build(false))
class FlxBufferArray<T> {}
#end
package tools.macro;

import haxe.macro.Context;
import haxe.macro.Expr;

using Lambda;
using haxe.macro.ComplexTypeTools;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.Type;

class ScriptedClassMacro
{
	static var secondaryPassInitialized:Bool = false;

	/**
	 * The first step creates the interface functions.
	 * The second build step (called in an onAfterTyping callback) creates the rest of the functions,
	 *   which require initial typing to be completed before they can be created.
	 */
	public static macro function build():Array<Field>
	{
		final cls = Context.getLocalClass().get();
		final fields = Context.getBuildFields().copy();
		
		// If the class already has `@:hscriptClassPreProcessed` on it, we don't need to do anything.
		final processed = cls.meta.get().find(function(m) return m.name == ':hscriptClassPreProcessed') != null;
		
		if (processed)
			return null;
		
		cls.meta.add(":hscriptClassPreProcessed", [], cls.pos);
		final overridenFields = buildScriptedClassFieldOverrides(cls);
		for (field in overridenFields)
			outputFieldData(cls.name, field);
		
		return fields.concat(overridenFields);
	}
	
	static function outputFieldData(className:String, field:Field)
	{
		switch(field.kind)
		{
			case FFun(func): switch(func.ret)
			{
				case TPath(p):
					trace('class: $className field: ${field.name} ret: TPATH({ name: ${p.name}, pack: ${p.pack} })');
				default:
			}
			default:
		}
	}

	/**
	 * For each function in the superclass, create a function in the subclass
	 		* that redirects to the internal abstract script class.
	 */
	static function buildScriptedClassFieldOverrides(classType:ClassType):Array<Field>
	{
		final fieldsDone = new Array<String>();
		final fields = new Array<Field>();

		final mappedParams = new Map<String, Type>();
		final tClass = Context.toComplexType(Context.getType(classType.name));

		while (classType != null)
		{
			// Context.info('Processing overrides for class: ${classType.name}<${mappedParams}>', Context.currentPos());
			// Values will be either of type haxe.macro.Expr.Field or Bool. This is because setting a Map value to null removes the key.
			final newFields = buildScriptedClassFieldOverrides_inner(classType.fields.get(), mappedParams);
			for (newFieldName => newField in newFields)
			{
				if (fieldsDone.contains(newFieldName))
					continue;
				
				fieldsDone.push(newFieldName);
				fields.push(newField);
			}
			
			if (classType.superClass == null)
				break;
			
			var targetParams:Array<Type> = classType.superClass.params;
			classType = classType.superClass.t.get();
			for (paramIndex in 0...classType.params.length)
			{
				var paramType = targetParams[paramIndex];
				var paramName = classType.params[paramIndex].name;
				var paramFullName = '${classType.pack.join('.')}.${classType.name}.${paramName}';
				trace(paramFullName);
				mappedParams.set(paramFullName, paramType);
			}
		}

		return fields;
	}

	static function buildScriptedClassFieldOverrides_inner(fields:Array<ClassField>, targetParams:Map<String, Type>):Map<String, Field>
	{
		final newFields = new Map<String, Field>();
		for (field in fields)
		{
			final results = overrideField(field, false, targetParams);
			for (result in results)
			{
				newFields.set(result.name, result);
			}
		}
		
		return newFields;
	}

	static function getBaseParamsOfType(parentType:Type, paramTypes:Array<Type>):Array<TypeParameter>
	{
		var parentParams:Array<TypeParameter> = [];

		switch (parentType)
		{
			case TMono(t):
				var ty = t.get();
				return getBaseParamsOfType(ty, paramTypes);

			case TInst(t, params):
				// Continue
				parentParams = t.get().params;

			case TType(t, params):
				// Recurse
				var ty:Type = t.get().type;
				return getBaseParamsOfType(ty, paramTypes);

			case TDynamic(t):
				// Recurse
				return getBaseParamsOfType(t, paramTypes);

			case TLazy(f):
				// Recurse
				var ty:Type = f();
				return getBaseParamsOfType(ty, paramTypes);

			case TAbstract(t, _params):
				// Continue
				parentParams = t.get().params;

			// case TEnum(t:Ref<EnumType>, params:Array<Type>):
			// case TFun(args:Array<{name:String, opt:Bool, t:Type}>, ret:Type):
			// case TAnonymous(a:Ref<AnonType>):
			default:
				Context.error('Unsupported type: ${parentType}', Context.currentPos());
		}

		var result:Array<TypeParameter> = [];

		for (i => parentParam in parentParams)
		{
			var newParam:TypeParameter = {
				name: parentParam.name,
				t: paramTypes[i],
			};
			result.push(newParam);
		}

		return result;
	}

	static function scanBaseTypes(targetType:Type):Array<Type>
	{
		switch (targetType)
		{
			case TFun(args, ret):
				var results:Array<Type> = [];

				for (result in scanBaseTypes(ret))
				{
					results.push(result);
				}
				for (arg in args)
				{
					for (result in scanBaseTypes(arg.t))
					{
						results.push(result);
					}
				}
				return results;
			case TAbstract(ty, params):
				if (params.length == 0)
				{
					return [targetType];
				}
				else
				{
					var results:Array<Type> = [];
					for (param in params)
					{
						for (result in scanBaseTypes(param))
						{
							results.push(result);
						}
					}
					return results;
				}
			default:
				return [targetType];
		}
	}

	/**
	 * Insert real types into a parameterized type.
	 * For example, `TypeA<TypeB<TypeC<T>>>` becomes `TypeA<TypeB<TypeC<int>>>` if T is `int`.
	 *
	 * Note, function runs recursively.
	 */
	static function deparameterizeType(targetType:Type, targetParams:Map<String, Type>):Type
	{
		var resultType:Type = targetType;

		switch (targetType)
		{
			case TFun(args, ret):
				// Function type.
				// This is not referring to functions of a class, but rather a function taken as a parameter (like a callback).

				// Deparameterize the return type.
				var retType:Type = deparameterizeType(ret, targetParams);
				// Deparameterize the argument types.
				var argTypes:Array<{name:String, opt:Bool, t:Type}> = args.map(function(arg)
				{
					return {
						name: arg.name,
						opt: arg.opt,
						t: deparameterizeType(arg.t, targetParams),
					};
				});

				// Construct the new type.
				resultType = TFun(argTypes, retType);
				// recursive call in case result is a parameter
				resultType = deparameterizeType(resultType, targetParams);

			case TAbstract(ty, params):
				// Abstract type. Sometimes used by types like Null<T>.

				var name = ty.toString();
				var typ = ty.get();

				// Check if the Abstract type is a parameter we recognize and can replace.
				if (targetParams.exists(ty.toString()))
				{
					// If so, replace it with the real type.
					resultType = targetParams.get(ty.toString());
					// recursive call in case result is a parameter
					resultType = deparameterizeType(resultType, targetParams);
				}
				else if (params.length != 0)
				{
					var oldParams:Array<Type> = [];
					var newParams:Array<Type> = [];
					for (param in params)
					{
						var baseTypes = scanBaseTypes(param);

						for (baseType in baseTypes)
						{
							var newParam = deparameterizeType(baseType, targetParams);
							if (newParam.toString() == "Void")
							{
								// Skipping Void...
							}
							else
							{
								oldParams.push(baseType);
								newParams.push(newParam);
							}
						}
					}
					var baseParams = getBaseParamsOfType(resultType, oldParams);
					newParams = newParams.slice(0, baseParams.length);

					if (newParams.length > 0)
					{
						// Context.info('Building new abstract (${baseParams} + ${newParams})...', Context.currentPos());
						resultType = resultType.applyTypeParameters(baseParams, newParams);
						// recursive call in case result is a parameter
						resultType = deparameterizeType(resultType, targetParams);
						// Context.info('Deparameterized abstract type: ${resultType.toString()}', Context.currentPos());
					}
					else
					{
						// Leave the type as is.
					}
				}
				else
				{
					// Else, there are no parameters related this type and we don't need to mutate it.
				}
			case TInst(ty, params):
				// Instance type. Used by most variables.

				// Check if the Instance type is a parameter we recognize and can replace.
				if (targetParams.exists(ty.toString()))
				{
					// If so, replace it with the real type.
					resultType = targetParams.get(ty.toString());
					// recursive call in case result is a parameter
					resultType = deparameterizeType(resultType, targetParams);
				}
				else if (params.length != 0)
				{
					var oldParams:Array<Type> = [];
					var newParams:Array<Type> = [];
					for (param in params)
					{
						var baseTypes = scanBaseTypes(param);

						for (baseType in baseTypes)
						{
							var newParam = deparameterizeType(baseType, targetParams);
							if (newParam.toString() == "Void")
							{
								// Skipping Void...
							}
							else
							{
								oldParams.push(baseType);
								newParams.push(newParam);
							}
						}
					}
					var baseParams = getBaseParamsOfType(resultType, oldParams);
					newParams = newParams.slice(0, baseParams.length);

					if (newParams.length > 0)
					{
						// Context.info('Building new abstract (${baseParams} + ${newParams})...', Context.currentPos());
						resultType = resultType.applyTypeParameters(baseParams, newParams);
						// recursive call in case result is a parameter
						resultType = deparameterizeType(resultType, targetParams);
						// Context.info('Deparameterized abstract type: ${resultType.toString()}', Context.currentPos());
					}
					else
					{
						// Leave the type as is.
					}
				}
				else
				{
					// Else, there are no parameters related this type and we don't need to mutate it.
				}

			default:
				// Do nothing.
				// Muted because I haven't actually seen any issues caused by this. Maybe investigate in the future.
				// Context.warning('You failed to handle this! ${targetType}', Context.currentPos());
		}

		return resultType;
	}

	/**
	 * Given a ClassField from the target class, create one or more Fields that override the target field,
	 * redirecting any calls to the internal AbstractScriptedClass.
	 */
	static function overrideField(field:ClassField, isStatic:Bool, targetParams:Map<String, Type>, ?type:Type = null):Array<Field>
	{
		if (type == null)
		{
			type = field.type;
		}

		switch (type)
		{
			case TLazy(lt):
				// A lazy wrapper for another field.
				// We have to call the function to get the true value.
				var ltv:Type = lt();
				return overrideField(field, isStatic, targetParams, ltv);
			case TFun(args, ret):
				// This field is a function of the class.
				// We need to redirect to the scripted class in case our scripted class overrides it.
				// If it isn't overridden, the AbstractScriptClass will call the original function.

				// We need to skip overriding functions which meet have a private type as an argument.
				// Normal Haxe classes can't override these functions anyway, so we can skip them.
				for (arg in args)
				{
					switch (arg.t)
					{
						case TInst(ty, pa):
							var typ = ty.get();
							if (typ != null && typ.isPrivate)
							{
								// Context.info('  Skipping: "${field.name}" contains private type ${typ.module}.${typ.name}', Context.currentPos());
								return [];
							}
						default: // Do nothing.
					}
				}

				// We need to skip overriding functions which are inline.
				// Normal Haxe classes can't override these functions anyway, so we can skip them.
				switch (field.kind)
				{
					case FMethod(k):
						switch (k)
						{
							case MethInline:
								// Context.info('  Skipping: "${field.name}" is inline function', Context.currentPos());
								return [];
							default: // Do nothing.
						}
					default: // Do nothing.
				}

				// Skip overriding functions which are Generics.
				// This is because this actually creates several different functions at compile time.
				// TODO: Can we somehow override these functions?
				for (fieldMeta in field.meta.get())
				{
					if (fieldMeta.name == ':generic')
					{
						// Context.info('  Skipping: "${field.name}" is marked with @:generic', Context.currentPos());
						return [];
					}
				}

				var func_inputArgs:Array<FunctionArg> = [];

				// We only get limited information about the args from Type, we need to use TypedExprDef.

				if (field == null || field.expr() == null)
				{
					// Context.info('  Skipping: "${field.name}" is not an expression', Context.currentPos());
					return [];
				}

				var func_access = [field.isPublic ? APublic : APrivate];
				if (field.isFinal)
					func_access.push(AFinal);
				if (isStatic)
				{
					func_access.push(AStatic);
				}
				else
				{
					func_access.push(AOverride);
				}

				switch (field.expr().expr)
				{
					case TFunction(tfunc):
						// Create an array of FunctionArg from the TFunction's argument objects.
						// Context.info('  Processing args of function "${field.name}"', Context.currentPos());
						for (arg in tfunc.args)
						{
							// Whether the argument is optional.
							var isOptional = (arg.value != null);
							// The argument's metadata (if any).
							var tfuncMeta:haxe.macro.Metadata = arg.v.meta.get();
							// The argument's expression/default value (if any).
							var tfuncExpr:haxe.macro.Expr = arg.value == null ? null : Context.getTypedExpr(arg.value);
							// The argument type. We have to handle any type parameters, and deparameterizeType does so recursively.
							var tfuncType:haxe.macro.ComplexType = Context.toComplexType(deparameterizeType(arg.v.t, targetParams));

							var tfuncArg:FunctionArg = {
								name: arg.v.name,
								type: tfuncType,
								// opt: isOptional,
								meta: tfuncMeta,
								value: tfuncExpr,
							};
							func_inputArgs.push(tfuncArg);
						}
					case TConst(tcon):
						// Okay, so uh, this is actually a VARIABLE storing a function.
						// Don't attempt to re-define it.

						return [];
					default:
						Context.warning('Expected a function and got ${field.expr().expr}', Context.currentPos());
				}

				// Is there a better way to do this?
				var doesReturnVoid:Bool = ret.toString() == "Void";

				// Generate the list of call arguments for the function.
				// Context.info('${args}', Context.currentPos());
				var func_callArgs:Array<Expr> = [for (arg in args) macro $i{arg.name}];

				var func_params = [for (param in field.params) {name: param.name}];

				// Context.info('  Processing return of function "${field.name}"', Context.currentPos());
				var func_ret = doesReturnVoid ? null : Context.toComplexType(deparameterizeType(ret, targetParams));

				var funcName:String = field.name;
				var func_over:Field = {
					name: funcName,
					doc: field.doc == null ? 'Polymod HScriptedClass override of ${field.name}.' : 'Polymod HScriptedClass override of ${field.name}.\n${field.doc}',
					access: func_access,
					meta: field.meta.get(),
					pos: field.pos,
					kind: FFun({
						args: func_inputArgs,
						params: func_params,
						ret: func_ret,
						expr: macro
						{
							var fieldName:String = $v{funcName};
							
							// Fallback, call the original function.
							// trace('ASC: Fallback to original ${fieldName}');
							$
							{
								doesReturnVoid ? (macro super.$funcName($a{func_callArgs})) : (macro return super.$funcName($a{func_callArgs}))
							}
						},
					}),
				};
				var func_superCall:Field = {
					name: '__super_' + funcName,
					doc: 'Calls the original ${field.name} function while ignoring the ScriptedClass override.',
					access: [APrivate],
					meta: field.meta.get(),
					pos: field.pos,
					kind: FFun({
						args: func_inputArgs,
						params: func_params,
						ret: func_ret,
						expr: macro
						{
							var fieldName:String = $v{funcName};
							// Fallback, call the original function.
							// trace('ASC: Force call to super ${fieldName}');
							$
							{
								doesReturnVoid ? (macro super.$funcName($a{func_callArgs})) : (macro return super.$funcName($a{func_callArgs}))
							}
						},
					}),
				}

				return [func_over, func_superCall];
			case TInst(_t, _params):
				// This field is an instance of a class.
				// Example: var test:TestClass = new TestClass();

				// Originally, I planned to replace all variables on the class with properties,
				// however this is not possible because properties are merely a compile-time feature.

				// However, since scripted classes correctly access the superclass variables anyway,
				// there is no need to override the value.
				// Context.info('Field: Instance variable "${field.name}"', Context.currentPos());
				return [];
			case TEnum(_t, _params):
				// Enum instance
				// Context.info('Field: Enum variable "${field.name}"', Context.currentPos());
				return [];
			case TMono(_t):
				// Monomorph instance
				// https://haxe.org/manual/types-monomorph.html
				// Context.info('Field: Monomorph variable "${field.name}"', Context.currentPos());
				return [];
			case TAnonymous(_t):
				// Context.info('Field: Anonymous variable "${field.name}"', Context.currentPos());
				return [];
			case TDynamic(_t):
				// Context.info('Field: Dynamic variable "${field.name}"', Context.currentPos());
				return [];
			case TAbstract(_t, _params):
				// Context.info('Field: Abstract variable "${field.name}"', Context.currentPos());
				return [];
			default:
				// Context.info('Unknown field type: ${field}', Context.currentPos());
				return [];
		}
	}

	/**
	 * Create the type corresponding to an array of the given type.
	 * For example, toComplexTypeArray(String) will return Array<String>.
	 */
	static function toComplexTypeArray(inputType:ComplexType):haxe.macro.ComplexType
	{
		var typeParams = (inputType != null) ? [TPType(inputType)] : [
			TPType(TPath({
				pack: [],
				name: 'Dynamic',
				sub: null,
				params: []
			}))
		];

		var result:ComplexType = TPath({
			pack: [],
			name: 'Array',
			sub: null,
			params: typeParams,
		});

		return result;
	}
}

typedef HScriptClassParams =
{
	?baseClass:String,
}

enum OverrideType
{
	SKIP;
	VALID(field:Field);
}
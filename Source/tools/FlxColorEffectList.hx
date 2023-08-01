package tools;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.geom.ColorTransform;

using StringTools;

class FlxColorEffectList extends flixel.FlxBasic
{
	public var target:FlxSprite;
	public var length(get, never):Int;
	inline function get_length() return list.length;
	
	final list:Array<FlxColorEffect> = [];
	
	public function new (target:FlxSprite)
	{
		this.target = target;
		super();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (list.length == 0 || target == null)
			return;
		
		var isDirty = false;
		for (transform in list)
		{
			if (transform.isDirty)
			{
				isDirty = true;
				break;
			}
		}
		
		if (isDirty == false)
			return;
		
		target.setColorTransform();
		
		final out = target.colorTransform;
		for (transform in list)
		{
			transform.concatTo(out);
			transform.isDirty = false;
		}
		
		// reapply
		target.setColorTransform
		(
			out.redMultiplier, out.greenMultiplier, out.blueMultiplier, out.alphaMultiplier,
			Std.int(out.redOffset), Std.int(out.greenOffset), Std.int(out.blueOffset), Std.int(out.alphaOffset)
		);
	}
	
	public function add<T:FlxColorEffect>(transform:T):T
	{
		if (transform == null)
		{
			FlxG.log.warn("Cannot add a `null` colorTransform to a FlxColorEffectList.");
			return null;
		}
		
		// Don't bother adding twice.
		if (list.indexOf(transform) == -1)
			list.push(transform);
		
		return transform;
	}
	
	public function insert<T:FlxColorEffect>(position:Int, transform:T):T
	{
		if (transform == null)
		{
			FlxG.log.warn("Cannot add a `null` colorTransform to a FlxColorEffectList.");
			return null;
		}
		
		final index = list.indexOf(transform);
		if (index == -1)
			list.insert(position, transform);
		else if (index != position)
		{
			// move to target position
			list.remove(transform);
			list.insert(position, transform);
		}
		
		return transform;
	}
	
	inline public function remove<T:FlxColorEffect>(transform:T):T
	{
		list.remove(transform);
		return transform;
	}
	
	//@:generic
	public function getFirst<T:FlxColorEffect>(type:Class<T>):Null<T>
	{
		for (effect in list)
		{
			if (Std.isOfType(effect, type))
				return cast effect;
		}
		
		return null;
	}
}

class FlxColorEffect
{
	@:allow(tools.FlxColorEffectList)
	var isDirty:Bool = true;
	var transform:ColorTransform = new ColorTransform();
	
	public function new () {}
	
	/**
	 * Does what `ColorTransform.concat` is supposed to do, according to the doc
	 */
	public function concatTo(base:ColorTransform)
	{
		base.redOffset = base.redOffset * transform.redMultiplier + transform.redOffset;
		base.greenOffset = base.greenOffset * transform.greenMultiplier + transform.greenOffset;
		base.blueOffset = base.blueOffset * transform.blueMultiplier + transform.blueOffset;
		base.alphaOffset = base.alphaOffset * transform.alphaMultiplier + transform.alphaOffset;
		
		base.redMultiplier *= transform.redMultiplier;
		base.greenMultiplier *= transform.greenMultiplier;
		base.blueMultiplier *= transform.blueMultiplier;
		base.alphaMultiplier *= transform.alphaMultiplier;
	}
}

class FlxColorTransformEffect extends FlxColorEffect
{
	/** A decimal value that is multiplied with the alpha transparency channel value. **/
	public var alphaMultiplier(get, set):Float;
	public function get_alphaMultiplier() return transform.alphaMultiplier;
	public function set_alphaMultiplier(value:Float)
	{
		isDirty = transform.alphaMultiplier != value;
		return transform.alphaMultiplier = value;
	}
	
	/** A decimal value that is multiplied with the red channel value **/
	public var redMultiplier(get, set):Float;
	public function get_redMultiplier() return transform.redMultiplier;
	public function set_redMultiplier(value:Float)
	{
		isDirty = transform.redMultiplier != value;
		return transform.redMultiplier = value;
	}
	
	/** A decimal value that is multiplied with the green channel value **/
	public var greenMultiplier(get, set):Float;
	public function get_greenMultiplier() return transform.greenMultiplier;
	public function set_greenMultiplier(value:Float)
	{
		isDirty = transform.greenMultiplier != value;
		return transform.greenMultiplier = value;
	}
	
	/** A decimal value that is multiplied with the blue channel value. **/
	public var blueMultiplier(get, set):Float;
	public function get_blueMultiplier() return transform.blueMultiplier;
	public function set_blueMultiplier(value:Float)
	{
		isDirty = transform.blueMultiplier != value;
		return transform.blueMultiplier = value;
	}
	
	/**
	 * A number from -255 to 255 that is added to the alpha transparency channel
	 * value after it has been multiplied by the `alphaMultiplier` value.
	**/
	public var alphaOffset(get, set):Float;
	public function get_alphaOffset() return transform.alphaOffset;
	public function set_alphaOffset(value:Float)
	{
		isDirty = transform.alphaOffset != value;
		return transform.alphaOffset = value;
	}
	
	/**
	 * A number from -255 to 255 that is added to the red channel value after it
	 * has been multiplied by the `redMultiplier` value.
	**/
	public var redOffset(get, set):Float;
	public function get_redOffset() return transform.redOffset;
	public function set_redOffset(value:Float)
	{
		isDirty = transform.redOffset != value;
		return transform.redOffset = value;
	}
	
	/**
	 * A number from -255 to 255 that is added to the green channel value after
	 * it has been multiplied by the `greenMultiplier` value.
	**/
	public var greenOffset(get, set):Float;
	public function get_greenOffset() return transform.greenOffset;
	public function set_greenOffset(value:Float)
	{
		isDirty = transform.greenOffset != value;
		return transform.greenOffset = value;
	}
	
	/**
	 * A number from -255 to 255 that is added to the blue channel value after it
	 * has been multiplied by the `blueMultiplier` value.
	**/
	public var blueOffset:Float;
	public function get_blueOffset() return transform.blueOffset;
	public function set_blueOffset(value:Float)
	{
		isDirty = transform.blueOffset != value;
		return transform.blueOffset = value;
	}
	
	/**
	 * The RGB color value for a ColorTransform object.
	 * 
	 * When you set this property, it changes the three color offset values
	 * (`redOffset`, `greenOffset`, and
	 * `blueOffset`) accordingly, and it sets the three color
	 * multiplier values(`redMultiplier`,
	 * `greenMultiplier`, and `blueMultiplier`) to 0. The
	 * alpha transparency multiplier and offset values do not change.
	 * 
	 * When you pass a value for this property, use the format
	 * 0x_RRGGBB_. _RR_, _GG_, and _BB_ each consist of two
	 * hexadecimal digits that specify the offset of each color component. The 0x
	 * tells the ActionScript compiler that the number is a hexadecimal
	 * value.
	**/
	public var color(get, set):Int;
	public function get_color() return transform.color;
	public function set_color(value:Int)
	{
		isDirty = transform.color != value;
		return transform.color = value;
	}
	
}

class FlxBrightnessEffect extends FlxColorEffect
{
	public var amount(default, set):Float;
	
	public function new (amount:Float)
	{
		super();
		this.amount = amount;
	}
	
	function set_amount(value:Float)
	{
		
		final mult = 1.0 - Math.abs(value);
		final offset = Math.round(Math.max(0, 0xFF * value));
		
		transform.redMultiplier = mult;
		transform.greenMultiplier = mult;
		transform.blueMultiplier = mult;
		transform.alphaMultiplier = 1.0;
		transform.redOffset = offset;
		transform.greenOffset = offset;
		transform.blueOffset = offset;
		transform.alphaOffset = 0.0;
		
		return value;
	}
}

class FlxTintEffect extends FlxColorEffect
{
	/** The color of this tint */
	public var rgb(default, set):FlxColor;
	
	/** The strength of this tint, ranges from 0.0 to 1.0 */
	public var strength(default, set):Float;
	
	public function new (rgb:FlxColor, strength:Float)
	{
		super();
		this.set(rgb, strength);
	}
	
	public function set(rgb:FlxColor, strength:Float)
	{
		final mult = 1 - strength;
		transform.redMultiplier = mult;
		transform.greenMultiplier = mult;
		transform.blueMultiplier = mult;
		transform.alphaMultiplier = 1.0;
		transform.redOffset = Math.round(rgb.red * strength);
		transform.greenOffset = Math.round(rgb.green * strength);
		transform.blueOffset = Math.round(rgb.blue * strength);
		transform.alphaOffset = 0.0;
		isDirty = true;
	}
	
	public function set24Bit(tint:FlxColor)
	{
		set(tint, tint.alphaFloat);
	}
	
	public function to24Bit():FlxColor
	{
		var tint = rgb;
		tint.alphaFloat = strength;
		return rgb;
	}
	
	function set_rgb(value:FlxColor)
	{
		set(value, strength);
		return value;
	}
	
	function set_strength(value:Float)
	{
		set(rgb, value);
		return value;
	}
	
	/**
	 * Shorthand for creating a tint from an 0xAARRRGGBB,
	 * where alpha represents the desired strength.
	 */
	inline static function from24Bit(srgb:FlxColor):FlxTintEffect
	{
		return new FlxTintEffect(srgb.rgb, srgb.alphaFloat);
	}
}
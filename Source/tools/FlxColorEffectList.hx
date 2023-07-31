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
	
	final list:Array<ColorTransform> = [];
	
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
		
		target.setColorTransform();
		
		final out = target.colorTransform;
		for (transform in list)
			concat(out, transform);
		
		// reapply
		target.setColorTransform
		(
			out.redMultiplier, out.greenMultiplier, out.blueMultiplier, out.alphaMultiplier,
			out.redOffset, out.greenOffset, out.blueOffset, out.alphaOffset
		);
	}
	
	/**
	 * Does what `ColorTransform.concat` is supposed to do, according to the doc
	 * @param base 
	 * @param second 
	 */
	function concat(base:ColorTransform, second:ColorTransform)
	{
		base.redOffset = base.redOffset * second.redMultiplier + second.redOffset;
		base.greenOffset = base.greenOffset * second.greenMultiplier + second.greenOffset;
		base.blueOffset = base.blueOffset * second.blueMultiplier + second.blueOffset;
		base.alphaOffset = base.alphaOffset * second.alphaMultiplier + second.alphaOffset;
		
		base.redMultiplier *= second.redMultiplier;
		base.greenMultiplier *= second.greenMultiplier;
		base.blueMultiplier *= second.blueMultiplier;
		base.alphaMultiplier *= second.alphaMultiplier;
	}
	
	public function add<T:ColorTransform>(transform:T):T
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
	
	public function insert<T:ColorTransform>(position:Int, transform:T):T
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
	
	inline public function remove<T:ColorTransform>(transform:T):T
	{
		list.remove(transform);
		return transform;
	}
	
	//@:generic
	public function getFirst<T:ColorTransform>(type:Class<T>):Null<T>
	{
		for (effect in list)
		{
			if (Std.isOfType(effect, type))
				return cast effect;
		}
		
		return null;
	}
}

class FlxBrightnessTransform extends ColorTransform
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

		redMultiplier = mult;
		greenMultiplier = mult;
		blueMultiplier = mult;
		alphaMultiplier = 1.0;
		redOffset = offset;
		greenOffset = offset;
		blueOffset = offset;
		alphaOffset = 0.0;
		
		return value;
	}
}

class FlxTintTransform extends ColorTransform
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
		redMultiplier = mult;
		greenMultiplier = mult;
		blueMultiplier = mult;
		alphaMultiplier = 1.0;
		redOffset = Math.round(rgb.red * strength);
		greenOffset = Math.round(rgb.green * strength);
		blueOffset = Math.round(rgb.blue * strength);
		alphaOffset = 0.0;
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
	inline static function from24Bit(srgb:FlxColor):FlxTintTransform
	{
		return new FlxTintTransform(srgb.rgb, srgb.alphaFloat);
	}
}
package flixel.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxGradient;
import flixel.util.FlxStringUtil;
import flixel.ui.FlxBar.FlxBarFillDirection;

/**
 * FlxBar is a quick and easy way to create a graphical bar which can
 * be used as part of your UI/HUD, or positioned next to a sprite.
 * It could represent a loader, progress or health bar.
 */
class FlxBaseBar extends FlxSprite
{
	/**
	 * The current value - must always be between min and max
	 */
	public var value:Float;
	
	public var range(default, never):FlxBarRange;
	public var orientation(default, never):FlxBarRange;
	
	/**
	 * The minimum value the bar can be (can never be >= max)
	 */
	public var min(get, never):Float;
	inline function get_min()
	{
		return range.min;
	}
	
	/**
	 * The maximum value the bar can be (can never be <= min)
	 */
	public var max(get, never):Float;
	inline function get_max()
	{
		return range.min;
	}
	
	public var barWidth(get, never):Int;
	inline function get_barWidth()
	{
		return orientation.width;
	}
	
	public var barHeight(get, never):Int;
	inline function get_barHeight()
	{
		return orientation.height;
	}
	
	/**
	 * The direction from which the health bar will fill-up. Default is from left to right. Change takes effect immediately.
	 */
	public var fillDirection(get, never):FlxBarFillDirection;
	inline function get_max()
	{
		return range.min;
	}

	var _filledRect:FlxRect;
	var _prevDrawnValue:Float = Math.NaN;
	var _rangeChanged = false;
	var _orientationChanged = false;

	/**
	 * Create a new FlxBar Object
	 *
	 * @param   x          The initial X position of the sprite in the world
	 * @param   y          The initial Y position of the sprite in the world
	 * @param   width      The width of the bar in pixels
	 * @param   height     The height of the bar in pixels
	 * @param   min        The value of an empty bar
	 * @param   max        The value of a full bar
	 * @param   direction  The fill direction, LEFT_TO_RIGHT by default
	 */
	public function new(x = 0.0, y = 0.0, ?range:FlxBarRange, ?orientation:FlxBarOrientation)
	{
		super(x, y);
		
		if (range == null)
			range = {};
		
		setRange(range, true);
		setOrientation(orientation);
	}
	
	override function destroy():Void
	{
		_filledRect = FlxDestroyUtil.destroy(_filledRect);
		super.destroy();
	}
	
	public function setOrientation(?orientation:FlxBarOrientation)
	{
		if (orientation == null)
			orientation = {};
		
		this.orientation = orientation;
	}
	
	/**
	 * Set the minimum and maximum allowed values for the FlxBar
	 *
	 * @param   min          The value of an empty bar
	 * @param   max          The value of a full bar
	 * @param   updateValue  Whether to update the value so it is between min and max
	 */
	public function setRange(?range:FlxBarRange, updateValue = true):Void
	{
		range.validate();

		this.range = range;
		
		if (updateValue)
		{
			if (Math.isNaN(value))
				value = range.min;
			else
				value = Math.max(range.min, Math.min(value, range.max));
		}
		_rangeChanged = true;
	}
	
	function makeSolid(color:FlxColor)
	{
	}
	
	override function draw():Void
	{
		if (_rangeChanged || _orientationChanged || value != _prevDrawnValue)
		{
			_rangeChanged = false;
			_orientationChanged = false;
			_prevDrawnValue = value;
			updateBar();
		}
		super.draw();
	}
	
	public function updateBar()
	{
		
	}
	
	override function toString():String
	{
		return FlxStringUtil.getDebugString([
			LabelValuePair.weak("min", min),
			LabelValuePair.weak("max", max),
			LabelValuePair.weak("value", value)
		]);
	}
}

@:structInit
class FlxBarRange
{
	public final min:Float = 0.0;
	public final max:Float = 1.0;
	
	public function validate()
	{
		if (max <= min || Math.isNaN(min) || Math.isNaN(max))
		{
			throw 'Invalid range, min: $min, max: $max';
			return;
		}
	}
}

@:structInit
class FlxBarOrientation
{
	public final width:Float = 100.0;
	public final height:Float = 10.0;
	public final direction = FlxBarFillDirection.LEFT_TO_RIGHT;
}

// enum FlxBarFillDirection
// {
// 	LEFT_TO_RIGHT;
// 	RIGHT_TO_LEFT;
// 	TOP_TO_BOTTOM;
// 	BOTTOM_TO_TOP;
// 	HORIZONTAL_INSIDE_OUT;
// 	HORIZONTAL_OUTSIDE_IN;
// 	VERTICAL_INSIDE_OUT;
// 	VERTICAL_OUTSIDE_IN;
// }

enum FlxBarDisplay
{
	STRETCH
	TILE
	SLICE(rect:FlxRect)
}

private class QuadSlicer
{
	public function new (sliceRect:FlxRect, ?sourceRect:FlxRect)
	{
		
	}
	
	public function draw(graphic:FlxGraphic, width:Float, height:Float)
	{
		
	}
}

private class FillDirectionUtils
{
	static public function isHorizontal(direction:FlxBarFillDirection):Bool
	{
		return direction.match(LEFT_TO_RIGHT | RIGHT_TO_LEFT | HORIZONTAL_INSIDE_OUT | HORIZONTAL_OUTSIDE_IN);
	}
	
	static public function isVertical(direction:FlxBarFillDirection):Bool
	{
		return !isHorizontal(direction);
	}
}

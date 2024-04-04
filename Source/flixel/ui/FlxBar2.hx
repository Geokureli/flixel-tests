package flixel.ui;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSignal;

class FlxBar2 extends FlxSprite
{
	public var fillMode:FlxBarFillMode = LEFT_TO_RIGHT;
	
	public var positionMode:FlxBarPositionMode = GLOBAL;
	
	public var onEmpty = new FlxSignal();
	public var onFill = new FlxSignal();
	
	public var frameSprite:FlxSprite;
	public var barSprite:FlxSprite;
	
	public var barWidth(default, set):Float;
	public var barHeight(default, set):Float;
	
	/**
	 * The current value of this bar. If tracking, this gets set every frame.
	 * Can also be set manually.
	 */
	public var value(default, set):Float = 0.0;
	/** The `value` where this bar is empty */
	public var min(default, set):Float = 0.0;
	/** The `value` where this bar is full */
	public var max(default, set):Float = 100.0;
	
	/** The ratio between `value` and `min`/`max`, where `min` is `0.0` and `max` is `1.0` */
	public var ratio(get, set):Float;
	
	/** The percent of `value` compared `min` and `max`, where `min` is `0.0` and `max` is `100.0` */
	public var percent(get, set):Float;
	
	var target:FlxBarTarget = NONE;
	
	public function new(x = 0.0, y = 0.0, ?options:FlxBarOptions)
	{
		super(x, y);
		init(options);
	}
	
	public function init(options:FlxBarOptions)
	{
		inline function getField<T>(optionValue:Null<T>, backup:T):T
		{
			return optionValue != null ? optionValue : backup;
		}
		
		target = getField(options.target, NONE);
		fillMode = getField(options.fillMode, LEFT_TO_RIGHT);
		positionMode = getField(options.positionMode, GLOBAL);
		@:bypassAccessor barWidth = getField(options.barWidth, 100);
		@:bypassAccessor barHeight = getField(options.barHeight, 10);
		@:bypassAccessor min = getField(options.min, 0);
		@:bypassAccessor max = getField(options.max, 100);
		
		if (options.value != null)
			@:bypassAccessor value = options.value;
		else if (options.ratio)
			@:bypassAccessor value = calcValueFromRatio(options.ratio);
		else if (options.percent)
			@:bypassAccessor value = calcValueFromRatio(options.percent / 100);
		else
			@:bypassAccessor value = min;
		
		onBarResizeInternal();
		onPercentChangeInternal();
		redraw();
	}
	
	function setBarSize(width = 100.0, height = 10.0, ?mode:FlxBarFillMode)
	{
		setBarSizeInternal(width, height, mode);
		@:bypassAccessor
		barWidth = width;
		@:bypassAccessor
		barHeight = height;
		
		if (mode != null)
			fillMode = mode;
		
		onBarResize();
	}
	
	inline function onBarResize()
	{
		onBarResizeInternal();
		redraw();
	}
	
	function onBarResizeInternal()
	{
		
	}
	
	inline function onPercentChange()
	{
		onPercentChangeInternal();
		redraw();
	}
	
	function onPercentChangeInternal()
	{
		
	}
	
	function redraw()
	{
		
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		switch
	}
	
	inline function setRange(min = 0.0, max = 100.0)
	{
		@:bypassAccessor
		this.min = min;
		@:bypassAccessor
		this.max = max;
		
		onPercentChange();
	}
	
	function set_barWidth(value:Float):Float
	{
		if (this.barWidth != value)
		{
			this.barWidth = value;
			onBarResize();
		}
		return value;
	}
	
	function set_barHeight(value:Float):Float
	{
		if (this.barHeight != value)
		{
			this.barHeight = value;
			onBarResize();
		}
		return value;
	}
	
	function set_value(value:Float):Float
	{
		if (this.value != value)
		{
			this.value = value;
			onPercentChange();
		}
		return value;
	}
	
	function set_min(value:Float):Float
	{
		if (this.min != value)
		{
			this.min = value;
			onPercentChange();
		}
		return value;
	}
	
	function set_max(value:Float):Float
	{
		if (this.max != value)
		{
			this.max = value;
			onPercentChange();
		}
		return value;
	}
	
	inline function get_ratio():Float
	{
		return (this.value - min) / (max - min);
	}
	
	inline function set_ratio(value:Float):Float
	{
		this.value = calcValueFromRatio(value);
		return value;
	}
	
	inline function calcValueFromRatio(ratio:Float):Float
	{
		return min + ratio * (max - min);
	}
	
	inline function get_percent():Float
	{
		return ratio * 100;
	}
	
	inline function set_percent(value:Float):Float
	{
		this.ratio = value / 100;
		return value;
	}
}

typedef FlxBarOptions
{
	@:optional var target:FlxBarTarget;
	@:optional var positionMode:FlxBarPositionMode;
	@:optional var fillMode:FlxBarFillMode;
	@:optional var barWidth:Float;
	@:optional var barHeight:Float;
	
	@:optional var min:Float;
	@:optional var max:Float;
	@:optional var value:Float;
	
	@:optional var showFrame:Bool;
	@:optional var frameSprite:FlxSprite;
	@:optional var frameGraphic:FlxGraphicAsset;
	@:optional var barSprite:FlxSprite;
	@:optional var barGraphic:FlxGraphicAsset;
}

@:using(flixel.ui.FlxBar2.FillDirectionTools);
enum FlxBarFillMode
{
	LEFT_TO_RIGHT;
	RIGHT_TO_LEFT;
	TOP_TO_BOTTOM;
	BOTTOM_TO_TOP;
	HORIZONTAL_INSIDE_OUT;
	HORIZONTAL_OUTSIDE_IN;
	VERTICAL_INSIDE_OUT;
	VERTICAL_OUTSIDE_IN;
}

private class FillDirectionTools
{
	public static inline function isHorizontal(mode:FlxBarFillMode)
	{
		return this.match(LEFT_TO_RIGHT | RIGHT_TO_LEFT | HORIZONTAL_INSIDE_OUT | HORIZONTAL_OUTSIDE_IN);
	}
	
	public static inline function isVertical(mode:FlxBarFillMode)
	{
		return !isHorizontal(mode);
	}
}

enum FlxBarPositionMode
{
	GLOBAL;
	RELATIVE(target:FlxObject, offsetX:Float, offsetY:Float);
}

enum FlxBarTarget
{
	NONE;
	FIELD(target:Dynamic, field:String);
	FUNCTION(func:()->Float);
}
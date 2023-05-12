package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import openfl.display.Shape;

using flixel.util.FlxStringUtil;

class EaseGraphState extends flixel.FlxState
{
    final inOld    = new Shape();
    final inNew    = new Shape();
    final outOld   = new Shape();
    final outNew   = new Shape();
    final inOutOld = new Shape();
    final inOutNew = new Shape();
    
    var currentEase:EaseType = BOUNCE;
    
    var inText:FlxText;
    var outText:FlxText;
    var inOutText:FlxText;
    
    static inline var BUFFER = 150;
    
    override function create()
    {
        super.create();
        
        add(inText    = new FlxText(4, 4, "", 24));
        add(outText   = new FlxText(4, 4, "", 24));
        add(inOutText = new FlxText(4, 4, "", 24));
        inText   .color = 0xFF0000ff;
        outText  .color = 0xFF008000;
        inOutText.color = 0xFFff0000;
        
        final graphs = new Sprite();
        graphs.graphics.lineStyle(1, 0xFFffffff);
        graphs.graphics.drawRect(BUFFER, BUFFER, FlxG.width - BUFFER * 2, FlxG.height - BUFFER * 2);
        FlxG.addChildBelowMouse(graphs);
        
        graphs.addChild(inOld   );
        graphs.addChild(outOld  );
        graphs.addChild(inOutOld);
        graphs.addChild(inNew   );
        graphs.addChild(outNew  );
        graphs.addChild(inOutNew);
        
        drawEase(BOUNCE);
        
        FlxG.console.registerFunction("drawEase", drawEase);
        // FlxG.console.registerFunction("drawBounceEase", drawBounceEase);
        // FlxG.console.registerFunction("drawBounceEaseScaled", drawBounceEaseScaled);
        // FlxG.console.registerFunction("drawBounceEaseSteps", drawBounceEaseSteps);
        // FlxG.console.registerFunction("drawBounceEaseComplex", drawBounceEaseComplex);
        // FlxG.console.registerObject("B1", 1 / 2.75);
        // FlxG.console.registerObject("B2", 2 / 2.75);
        // FlxG.console.registerObject("B3", 1.5 / 2.75);
        // FlxG.console.registerObject("B4", 2.5 / 2.75);
        // FlxG.console.registerObject("B5", 2.25 / 2.75);
        // FlxG.console.registerObject("B6", 2.625 / 2.75);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.SPACE)
        {
            final list = EaseType.list;
            currentEase = list[(list.indexOf(currentEase) + 1) % list.length];
            drawEase(currentEase);
        }
    }
    /*
    inline function drawBounceEase()
    {
        drawBounceEaseSteps();
    }
    
    inline function drawBounceEaseScaled(value = 2.75)
    {
        drawBounceEaseSteps
            ( 1.000 / value
            , 2.000 / value
            , 1.500 / value
            , 2.500 / value
            , 2.250 / value
            , 2.625 / value
            );
    }
    
    
    inline function drawBounceEaseSteps(b1 = 1.0, b2 = 2.0, b3 = 1.5, b4 = 2.5, b5 = 2.25, b6 = 2.625, value = 2.75)
    {
        drawBounceEaseComplex
            ( b1 / value
            , b2 / value
            , b3 / value
            , b4 / value
            , b5 / value
            , b6 / value
            );
    }
    
    function drawBounceEaseComplex(b1:Float, b2:Float, b3:Float, b4:Float, b5:Float, b6:Float)
    {
        final newEases =
            { bounceIn    : NewEase.createBounceIn   (b1, b2, b3, b4, b5, b6)
            , bounceOut   : NewEase.createBounceOut  (b1, b2, b3, b4, b5, b6)
            , bounceInOut : NewEase.createBounceInOut(b1, b2, b3, b4, b5, b6)
            };
        
        drawEaseComplex(OldEase, newEases, BOUNCE);
    }
    */
    
    function drawEase(easeType:EaseType)
    {
        drawEaseComplex(OldEase, NewEase, easeType);
    }
    
    function drawEaseComplex(oldEase:Any, newEase:Any, easeType:EaseType)
    {
        inText   .text =  easeType + "In";
        outText  .text =  easeType + "Out";
        inOutText.text =  easeType + "InOut";
        outText  .x = inText .x + inText .width + 4;
        inOutText.x = outText.x + outText.width + 4;
        
        inOld   .graphics.clear();
        outOld  .graphics.clear();
        inOutOld.graphics.clear();
        inNew   .graphics.clear();
        outNew  .graphics.clear();
        inOutNew.graphics.clear();
        
        inOld   .graphics.lineStyle(11, 0xFF0000FF);
        outOld  .graphics.lineStyle(11, 0xFF008000);
        inOutOld.graphics.lineStyle(11, 0xFFFF0000);
        inNew   .graphics.lineStyle(5, 0xFFA0A0FF);
        outNew  .graphics.lineStyle(5, 0xFF80FF80);
        inOutNew.graphics.lineStyle(5, 0xFFFFA0A0);
        
        final easeOldIn   :EaseFunction = cast Reflect.field(oldEase, easeType + "In"   );
        final easeOldOut  :EaseFunction = cast Reflect.field(oldEase, easeType + "Out"  );
        final easeOldInOut:EaseFunction = cast Reflect.field(oldEase, easeType + "InOut");
        final easeNewIn   :EaseFunction = cast Reflect.field(newEase, easeType + "In"   );
        final easeNewOut  :EaseFunction = cast Reflect.field(newEase, easeType + "Out"  );
        final easeNewInOut:EaseFunction = cast Reflect.field(newEase, easeType + "InOut");
        
        final left = BUFFER;
        final top = BUFFER;
        final width = FlxG.width - BUFFER * 2;
        final height = FlxG.height - BUFFER * 2;
        
        inOld   .graphics.moveTo(left, top + easeOldIn   (0) * height);
        outOld  .graphics.moveTo(left, top + easeOldOut  (0) * height);
        inOutOld.graphics.moveTo(left, top + easeOldInOut(0) * height);
        inNew   .graphics.moveTo(left, top + easeNewIn   (0) * height);
        outNew  .graphics.moveTo(left, top + easeNewOut  (0) * height);
        inOutNew.graphics.moveTo(left, top + easeNewInOut(0) * height);
        
        for (x in 1...width)
        {
            inOld   .graphics.lineTo(left + x, top + easeOldIn   (x / width) * height);
            outOld  .graphics.lineTo(left + x, top + easeOldOut  (x / width) * height);
            inOutOld.graphics.lineTo(left + x, top + easeOldInOut(x / width) * height);
            inNew   .graphics.lineTo(left + x, top + easeNewIn   (x / width) * height);
            outNew  .graphics.lineTo(left + x, top + easeNewOut  (x / width) * height);
            inOutNew.graphics.lineTo(left + x, top + easeNewInOut(x / width) * height);
        }
        
        inOld   .graphics.lineTo(left + width, top + easeOldIn   (1) * height);
        outOld  .graphics.lineTo(left + width, top + easeOldOut  (1) * height);
        inOutOld.graphics.lineTo(left + width, top + easeOldInOut(1) * height);
        inNew   .graphics.lineTo(left + width, top + easeNewIn   (1) * height);
        outNew  .graphics.lineTo(left + width, top + easeNewOut  (1) * height);
        inOutNew.graphics.lineTo(left + width, top + easeNewInOut(1) * height);
    }
}

enum abstract EaseType(String) to String
{
    public static var list = 
        [ EXPO
        , CUBE
        , QUAD
        , QUART
        , QUINT
        , SMOOTHSTEP
        , SMOOTHERSTEP
        , SINE
        , CIRC
        , BOUNCE
        , BACK
        , ELASTIC
        ];
    
    var EXPO = "expo";
    var CUBE = "cube";
    var QUAD = "quad";
    var QUART = "quart";
    var QUINT = "quint";
    var SMOOTHSTEP = "smoothStep";
    var SMOOTHERSTEP = "smootherStep";
    var SINE = "sine";
    var CIRC = "circ";
    var BOUNCE = "bounce";
    var BACK = "back";
    var ELASTIC = "elastic";
}

typedef OldEase = FlxEaseLegacy;
typedef NewEase = flixel.tweens.FlxEase;
// FlxEase before any changes were made
class FlxEaseLegacy
{
	/** Easing constants */
	static var PI2:Float = Math.PI / 2;
	static var EL:Float = 2 * Math.PI / .45;
	static var B1:Float = 1 / 2.75;
	static var B2:Float = 2 / 2.75;
	static var B3:Float = 1.5 / 2.75;
	static var B4:Float = 2.5 / 2.75;
	static var B5:Float = 2.25 / 2.75;
	static var B6:Float = 2.625 / 2.75;
	static var ELASTIC_AMPLITUDE:Float = 1;
	static var ELASTIC_PERIOD:Float = 0.4;
	
	/** @since 4.3.0 */
	public static inline function linear(t:Float):Float
	{
		return t;
	}

	public static inline function quadIn(t:Float):Float
	{
		return t * t;
	}
	
	public static inline function quadOut(t:Float):Float
	{
		return -t * (t - 2);
	}
	
	public static inline function quadInOut(t:Float):Float
	{
		return t <= .5 ? t * t * 2 : 1 - (--t) * t * 2;
	}
	
	public static inline function cubeIn(t:Float):Float
	{
		return t * t * t;
	}
	
	public static inline function cubeOut(t:Float):Float
	{
		return 1 + (--t) * t * t;
	}
	
	public static inline function cubeInOut(t:Float):Float
	{
		return t <= .5 ? t * t * t * 4 : 1 + (--t) * t * t * 4;
	}

	public static inline function quartIn(t:Float):Float
	{
		return t * t * t * t;
	}
	
	public static inline function quartOut(t:Float):Float
	{
		return 1 - (t -= 1) * t * t * t;
	}
	
	public static inline function quartInOut(t:Float):Float
	{
		return t <= .5 ? t * t * t * t * 8 : (1 - (t = t * 2 - 2) * t * t * t) / 2 + .5;
	}
	
	public static inline function quintIn(t:Float):Float
	{
		return t * t * t * t * t;
	}
	
	public static inline function quintOut(t:Float):Float
	{
		return (t = t - 1) * t * t * t * t + 1;
	}
	
	public static inline function quintInOut(t:Float):Float
	{
		return ((t *= 2) < 1) ? (t * t * t * t * t) / 2 : ((t -= 2) * t * t * t * t + 2) / 2;
	}
	
	/** @since 4.3.0 */
	public static inline function smoothStepIn(t:Float):Float
	{
		return 2 * smoothStepInOut(t / 2);
	}
	
	/** @since 4.3.0 */
	public static inline function smoothStepOut(t:Float):Float
	{
		return 2 * smoothStepInOut(t / 2 + 0.5) - 1;
	}
	
	/** @since 4.3.0 */
	public static inline function smoothStepInOut(t:Float):Float
	{
		return t * t * (t * -2 + 3);
	}
	
	/** @since 4.3.0 */
	public static inline function smootherStepIn(t:Float):Float
	{
		return 2 * smootherStepInOut(t / 2);
	}
	
	/** @since 4.3.0 */
	public static inline function smootherStepOut(t:Float):Float
	{
		return 2 * smootherStepInOut(t / 2 + 0.5) - 1;
	}
	
	/** @since 4.3.0 */
	public static inline function smootherStepInOut(t:Float):Float
	{
		return t * t * t * (t * (t * 6 - 15) + 10);
	}
	
	public static inline function sineIn(t:Float):Float
	{
		return -Math.cos(PI2 * t) + 1;
	}
	
	public static inline function sineOut(t:Float):Float
	{
		return Math.sin(PI2 * t);
	}
	
	public static inline function sineInOut(t:Float):Float
	{
		return -Math.cos(Math.PI * t) / 2 + .5;
	}
	
	public static function bounceIn(t:Float):Float
	{
		t = 1 - t;
		if (t < B1) return 1 - 7.5625 * t * t;
		if (t < B2) return 1 - (7.5625 * (t - B3) * (t - B3) + .75);
		if (t < B4) return 1 - (7.5625 * (t - B5) * (t - B5) + .9375);
		return 1 - (7.5625 * (t - B6) * (t - B6) + .984375);
	}
	
	public static function bounceOut(t:Float):Float
	{
		if (t < B1) return 7.5625 * t * t;
		if (t < B2) return 7.5625 * (t - B3) * (t - B3) + .75;
		if (t < B4) return 7.5625 * (t - B5) * (t - B5) + .9375;
		return 7.5625 * (t - B6) * (t - B6) + .984375;
	}
	
	public static function bounceInOut(t:Float):Float
	{
		if (t < .5)
		{
			t = 1 - t * 2;
			if (t < B1) return (1 - 7.5625 * t * t) / 2;
			if (t < B2) return (1 - (7.5625 * (t - B3) * (t - B3) + .75)) / 2;
			if (t < B4) return (1 - (7.5625 * (t - B5) * (t - B5) + .9375)) / 2;
			return (1 - (7.5625 * (t - B6) * (t - B6) + .984375)) / 2;
		}
		t = t * 2 - 1;
		if (t < B1) return (7.5625 * t * t) / 2 + .5;
		if (t < B2) return (7.5625 * (t - B3) * (t - B3) + .75) / 2 + .5;
		if (t < B4) return (7.5625 * (t - B5) * (t - B5) + .9375) / 2 + .5;
		return (7.5625 * (t - B6) * (t - B6) + .984375) / 2 + .5;
	}
	
	public static inline function circIn(t:Float):Float
	{
		return -(Math.sqrt(1 - t * t) - 1);
	}
	
	public static inline function circOut(t:Float):Float
	{
		return Math.sqrt(1 - (t - 1) * (t - 1));
	}
	
	public static function circInOut(t:Float):Float
	{
		return t <= .5 ? (Math.sqrt(1 - t * t * 4) - 1) / -2 : (Math.sqrt(1 - (t * 2 - 2) * (t * 2 - 2)) + 1) / 2;
	}
	
	public static inline function expoIn(t:Float):Float
	{
		return Math.pow(2, 10 * (t - 1));
	}
	
	public static inline function expoOut(t:Float):Float
	{
		return -Math.pow(2, -10 * t) + 1;
	}
	
	public static function expoInOut(t:Float):Float
	{
		return t < .5 ? Math.pow(2, 10 * (t * 2 - 1)) / 2 : (-Math.pow(2, -10 * (t * 2 - 1)) + 2) / 2;
	}
	
	public static inline function backIn(t:Float):Float
	{
		return t * t * (2.70158 * t - 1.70158);
	}
	
	public static inline function backOut(t:Float):Float
	{
		return 1 - (--t) * (t) * (-2.70158 * t - 1.70158);
	}
	
	public static function backInOut(t:Float):Float
	{
		t *= 2;
		if (t < 1) return t * t * (2.70158 * t - 1.70158) / 2;
		t--;
		return (1 - (--t) * (t) * (-2.70158 * t - 1.70158)) / 2 + .5;
	}
	
	public static inline function elasticIn(t:Float):Float
	{
		return -(ELASTIC_AMPLITUDE * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t - (ELASTIC_PERIOD / (2 * Math.PI) * Math.asin(1 / ELASTIC_AMPLITUDE))) * (2 * Math.PI) / ELASTIC_PERIOD));
	}
	
	public static inline  function elasticOut(t:Float):Float
	{
		return (ELASTIC_AMPLITUDE * Math.pow(2, -10 * t) * Math.sin((t - (ELASTIC_PERIOD / (2 * Math.PI) * Math.asin(1 / ELASTIC_AMPLITUDE))) * (2 * Math.PI) / ELASTIC_PERIOD) + 1);
	}
	
	public static function elasticInOut(t:Float):Float
	{
		if (t < 0.5)
		{
			return -0.5 * (Math.pow(2, 10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * (2 * Math.PI) / ELASTIC_PERIOD));
		}
		return Math.pow(2, -10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * (2 * Math.PI) / ELASTIC_PERIOD) * 0.5 + 1;
	}
}

typedef EaseFunction = Float->Float;
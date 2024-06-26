package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;

class FeeshyColorTestState extends FlxState
{
    private static var defaultStroke:FlxColor = FlxColor.fromRGB(51, 51, 51);

    private var __giantMatrix:Array<Array<FlxColor>>;
	private var __bitmap:BitmapData;
	private var __canvas:FlxSprite;

	private var __dirtyMouseX:Int;
	private var __dirtyMouseY:Int;
	private var __mouseDown:Bool = false;

	override public function create()
	{
		super.create();

		__giantMatrix = new Array<Array<FlxColor>>();
		__dirtyMouseX = -1;
		__dirtyMouseY = -1;

		for(i in 0...FlxG.width)
		{
			__giantMatrix[i] = new Array<FlxColor>();
			for(j in 0...FlxG.height)
			{
				__giantMatrix[i][j] = FlxColor.BLACK;
			}
		}

		__bitmap = new BitmapData(FlxG.width, FlxG.height, false, FlxColor.BLACK);
		__canvas = new FlxSprite();
		__canvas.pixels = __bitmap;

		add(__canvas);

		FlxG.stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		FlxG.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		
		for (i in 0...10000)
		{
			paint(FlxG.random.int(0, FlxG.width), FlxG.random.int(0, FlxG.height));
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	inline function onMove(event:MouseEvent) {
		if(__mouseDown)
		{
			var x:Int = Std.int(FlxG.mouse.x);
			var y:Int = Std.int(FlxG.mouse.y);

			if(!boundsCheck(x, y))
			{
				return;
			}

			if(x != __dirtyMouseX || y != __dirtyMouseY)
			{
				paint(x, y);
				__dirtyMouseX = x;
				__dirtyMouseY = y;
			}
		}
	}

	inline function onDown(event:MouseEvent)
	{
		var x:Int = Std.int(event.stageX);
		var y:Int = Std.int(event.stageY);

		if(!boundsCheck(x, y))
		{
			return;
		}

		__dirtyMouseX = x;
		__dirtyMouseY = y;
		__mouseDown = true;

		paint(x, y);
	}

	inline function onUp(event:MouseEvent)
	{
		__mouseDown = false;
	}

	inline function paint(x:Int, y:Int)
	{
		for(i in -3...4)
		{
			for(j in -3...4)
			{
				if(boundsCheck(x + i, y + j))
				{
				    var curColor:FlxColor = __giantMatrix[x + i][y + j];
				    curColor = curColor + defaultStroke;
					__giantMatrix[x + i][y + j] = curColor;

					__bitmap.setPixel(x + i, y + j, curColor);
				}
			}
		}
	}

	inline function boundsCheck(x:Int, y:Int):Bool
	{
		return x >= 0 && x < FlxG.width && y >= 0 && y < FlxG.height;
	}
}
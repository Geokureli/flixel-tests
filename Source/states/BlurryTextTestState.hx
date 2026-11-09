package states;

import flixel.FlxG;

// import flixel.util.FlxNullChecker;
// using flixel.util.FlxNullUtil;

class BlurryTextTestState extends flixel.FlxState
{
	override function create()
	{
		FlxG.addChildBelowMouse(new BitmapTest());
		
		final foo:String = null;
		// FlxG.safety.require(foo);
		// foo.require();
		
		// final checker = new FlxNullChecker((id:String, ?pos)->haxe.Log.trace('$id is null', pos));
		// checker.check(foo);
	}
}

class BitmapTest extends openfl.display.Sprite
{
	public function new()
	{
		super();
		final field = new openfl.text.TextField();
		field.text = "Text with some blur\none line without blur\nand another with blur";
		field.autoSize = NONE;
		field.width = 120;
		field.height = 34;
		field.defaultTextFormat = new openfl.text.TextFormat("Nokia Cellphone FC Small", 8, 0xFFffffff, CENTER);
		
		addChild(field);
		
		final bmd1 = new openfl.display.BitmapData(120, 34, true, 0x0);
		bmd1.draw(field, null, null, null, null, false);
		
		final bmd2 = bmd1.clone();
		
		for (x in 0...bmd2.width)
		{
			for (y in 0...bmd2.height)
			{
				final color = bmd2.getPixel32(x, y);
				if (color != 0xFFffffff && color != 0x0)
					bmd2.setPixel32(x, y, 0xFFff0000);
			}
		}
		
		final bitmap1 = new openfl.display.Bitmap(bmd1);
		bitmap1.y = 50;
		bitmap1.scaleX = 2;
		bitmap1.scaleY = 2;
		
		addChild(bitmap1);
		
		final bitmap2 = new openfl.display.Bitmap(bmd2);
		bitmap2.y = 150;
		bitmap2.scaleX = 2;
		bitmap2.scaleY = 2;
		
		addChild(bitmap2);
	}
}
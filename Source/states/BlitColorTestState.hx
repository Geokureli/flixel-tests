package states;

import flixel.FlxG;
import flixel.FlxStrip;
import flixel.graphics.tile.FlxDrawTrianglesItem;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class BlitColorTestState extends flixel.FlxState
{
	override function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.GRAY;

		final bitmap = new BitmapData(300, 300, false);
		bitmap.fillRect(new Rectangle(0, 0, 300, 300), FlxColor.WHITE);
		bitmap.fillRect(new Rectangle(0, 150, 300, 150), FlxColor.GRAY.getLightened(0.5));

		final strip = new FlxStrip(0, 0, bitmap);
		strip.vertices = new DrawData(8, true, [0.0, 0.0, strip.width, 0.0, 0.0, strip.height, strip.width, strip.width]);
		strip.uvtData = new DrawData(8, true, [0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0]);
		strip.indices = new DrawData(6, true, [0, 1, 2, 1, 2, 3]);
		add(strip.screenCenter());

		// following code have no effect on FlxG.renderBlit
		strip.color = FlxColor.RED;
		strip.alpha = 0.5;
	}
}

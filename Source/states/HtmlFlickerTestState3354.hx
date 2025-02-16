package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class HtmlFlickerTestState3354 extends flixel.FlxState
{
	override function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.GRAY;

		for (i in 0...16)
		{
			var sprite = new FlxSprite(i);
			sprite.screenCenter();
			sprite.x += i * 20;
			sprite.color = (i % 4 == 0) ? FlxColor.RED : FlxColor.WHITE;
			add(sprite);
		}
	}
}
package states;

import flixel.FlxG;
import flixel.tweens.FlxTween;

class TemplateTestState extends flixel.FlxState
{
	override function create()
	{
		final img = new FlxSprite(0, 0);
		img.makeGraphic(100, 100, FlxColor.MAGENTA);
		add(img);
		var point1 = FlxPoint.get(100,100);
		var point2 = FlxPoint.get(100,100);
		var point3 = FlxPoint.get(0,100);
		var point4 = FlxPoint.get(100,0);
		var point5 = FlxPoint.get(200,200);
		FlxTween.quadPath(img, [point1, point2, point3, point4, point5], 10);
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
	}
}
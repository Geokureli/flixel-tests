package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HistogramTestState extends flixel.FlxState
{
	var zoomText:FlxText;
	
	override function create():Void
	{
		super.create();
		
		final bitmap = new FlxSprite("assets/images/origin.png").graphic.bitmap;
		trace(bitmap.histogram());
	}
}
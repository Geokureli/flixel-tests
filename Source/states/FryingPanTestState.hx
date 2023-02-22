package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxBitmapFont;

import openfl.utils.Assets;

class FryingPanTestState extends flixel.FlxState
{
	var text:FlxBitmapText;
	
	override function create()
	{
		super.create();
		
		  add(text = new MonospaceText(50, 50));
		  text.fieldWidth = FlxG.width - 100;
		  text.autoSize = false;
		  text.text = Assets.getText("assets/data/lorem_ipsum.txt");
	}
}
*


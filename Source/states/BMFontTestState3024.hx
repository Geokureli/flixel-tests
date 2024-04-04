package states;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import openfl.utils.Assets;

class BMFontTestState3024 extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		final font = FlxBitmapFont.fromAngelCode('fonts/bmpFont3024.png', 'fonts/bmpFont3024.xml');
		final text = new FlxBitmapText(0, 0, 'HELLO', font);
		text.screenCenter();
		add(text);
	}
}
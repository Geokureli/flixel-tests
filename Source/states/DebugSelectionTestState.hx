package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

import openfl.filters.ShaderFilter;
import openfl.display.StageQuality;

class DebugSelectionTestState extends flixel.FlxState
{
	override public function create():Void
	{
		super.create();
		
		for (i in 0...100)
		{
			final sprite = new FlxSprite(FlxG.random.float(0, FlxG.width - 16), FlxG.random.float(0, FlxG.height - 16));
			sprite.makeGraphic(16, 16, FlxColor.GREEN);
			add(sprite);
		}
	}
}
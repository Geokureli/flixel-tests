package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

import openfl.filters.ShaderFilter;
import openfl.display.StageQuality;

class AustinPixelTestState extends flixel.FlxState
{
	var sprite:FlxSprite;
	override public function create():Void
	{
		super.create();
		
		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.resizeWindow(400, 400);
		
		sprite = new FlxSprite(FlxG.width * 0.5 - 8, FlxG.height * 0.5 - 8);
		sprite.makeGraphic(16, 16, FlxColor.GREEN);
		sprite.angularVelocity = 20;
		add(sprite);
	}
}
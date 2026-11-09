package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets;

class MaxTexTestState extends flixel.FlxState
{
	
	override public function create()
	{
		super.create();

		// by uncommenting the trace here the crash no longer happens
		// the PR does something similar by querying maxTextureSize asap
		// when the window is created

		// trace(FlxG.bitmap.maxTextureSize);

		// var f = new lime.app.Future(() -> {
		// 	FlxG.bitmap.create(1000, 1000, 0);
		// }, true);
		
		// trace(FlxG.VERSION.toString());
	}
}
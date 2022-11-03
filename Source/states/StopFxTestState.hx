package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;

class StopFxTestState extends flixel.FlxState
{
	override function create()
	{
		// FlxG.scaleMode = new flixel.system.scaleModes.StageSizeScaleMode();
		
		var backdrop = new FlxBackdrop("Assets/images/haxe.png");
		// var backdrop = new FlxSprite("Assets/images/haxe.png");
		backdrop.screenCenter();
		backdrop.velocity.set(50, 100);
		backdrop.antialiasing = true;
		add(backdrop);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.F)
			FlxG.camera.fade(FlxColor.BLACK, 5);
		
		if (FlxG.keys.justPressed.A)
			FlxG.camera.flash(5.0);
		
		if (FlxG.keys.justPressed.S)
			FlxG.camera.shake(0.05, 5.0);
		
		if (FlxG.keys.justPressed.SPACE)
			FlxG.camera.stopFX();
	}
}
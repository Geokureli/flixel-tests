package states;

import flixel.FlxG;
import flixel.ui.FlxButton;

class VolumeTestState extends flixel.FlxState
{
	
	var volume:Float = 1;
	
	override function create()
	{
		super.create();
		
		FlxG.sound.volume = volume;
		FlxG.sound.muted = false;

		var soundtest:FlxButton = new FlxButton(0, 0, "play sound", playSound);
		soundtest.screenCenter();
		add(soundtest);
	}
	
	function playSound()
	{
		FlxG.sound.play("assets/sounds/pickup.mp3");
	}
}
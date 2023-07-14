package states;

import flixel.FlxG;
import flixel.sound.FlxSound;


class SoundPanTestState2852 extends flixel.FlxState
{
	var sound:FlxSound;
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		final soundPlaying = sound != null && sound.playing;
		final left = FlxG.keys.pressed.LEFT;
		final right = FlxG.keys.pressed.RIGHT;
		
		if ((left || right) && soundPlaying == false)
		{
			sound = new FlxSound().loadEmbedded("flixel/sounds/flixel.ogg");
			sound.pan = (right ? 1 : 0) - (left ? 1 : 0);
			// sound.play();
			// sound = FlxG.sound.play("flixel/sounds/flixel.ogg", 1);
		}
		
		if (soundPlaying)
			sound.pan = (right ? 1 : 0) - (left ? 1 : 0);
	}
}
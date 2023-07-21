package states;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.sound.FlxSound;


class SoundPanTestState2852 extends flixel.FlxState
{
	var sound:FlxSound;
	
	override function create()
	{
		super.create();
		
		final text = new FlxText("press left or right to play or change pan");
		text.screenCenter();
		add(text);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		final soundPlaying = sound != null && sound.playing;
		final left = FlxG.keys.pressed.LEFT;
		final right = FlxG.keys.pressed.RIGHT;
		
		if ((left || right) && soundPlaying == false)
		{
			sound = new FlxSound().loadEmbedded("flixel/sounds/flixel.ogg");
			sound.play();
			sound.pan = (right ? 1 : 0) - (left ? 1 : 0);
			// sound = FlxG.sound.play("flixel/sounds/flixel.ogg", 1);
		}
		
		if (soundPlaying)
			sound.pan = (right ? 1 : 0) - (left ? 1 : 0);
	}
}
package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.utils.Assets;


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
		final left = FlxG.keys.justPressed.LEFT;
		final right = FlxG.keys.justPressed.RIGHT;
		
		if (left || right)
		{
			if (soundPlaying)
				sound.pan = (right ? 1 : 0) - (left ? 1 : 0);
			else
			{
				sound = new FlxSound().loadEmbedded("flixel/sounds/flixel.ogg");
				sound.pan = (right ? 1 : 0) - (left ? 1 : 0);
				sound.play();
				// sound = FlxG.sound.play("flixel/sounds/flixel.ogg", 1);
			}
		}
	}
}
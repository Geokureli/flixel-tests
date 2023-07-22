package states;

import openfl.media.SoundTransform;
import flixel.FlxG;
import flixel.text.FlxText;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.utils.Assets;


class SoundFLPanTestState2852 extends flixel.FlxState
{
	var sound:Sound;
	var soundChannel:SoundChannel;
	
	override function create()
	{
		super.create();
		
		final text = new FlxText("press left or right to play or change pan");
		text.screenCenter();
		add(text);
		
		sound = Assets.getSound("flixel/sounds/flixel.ogg");
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		final soundPlaying = soundChannel != null && (soundChannel.position > 0);
		final left = FlxG.keys.justPressed.LEFT;
		final right = FlxG.keys.justPressed.RIGHT;
		
		if (left || right)
		{
			final pan = (right ? 1 : 0) - (left ? 1 : 0);
			
			if (soundPlaying)
				setPan(soundChannel, pan);
			else
				soundChannel = sound.play(new SoundTransform(1, pan));
		}
	}
	
	static public function setPan(channel:SoundChannel, value:Float)
	{
		final transform = channel.soundTransform;
		transform.pan = value;
		channel.soundTransform = transform;
	}
}
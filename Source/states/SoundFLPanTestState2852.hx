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
		
		final text = new FlxText(0, 0, 0, "press left or right to play or change pan");
		text.screenCenter();
		add(text);
		
		// sound = Assets.getSound("flixel/sounds/flixel.ogg");
		sound = Assets.getSound("assets/sounds/flixel-mono.ogg");
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
			
			if (!soundPlaying)
				soundChannel = sound.play(0.0, 0, new SoundTransform(1, pan));
			else
				setPan(soundChannel, pan);
				// setStereoPan(soundChannel, pan);
		}
	}
	
	static public function setPan(channel:SoundChannel, value:Float)
	{
		final transform = channel.soundTransform;
		transform.pan = value;
		channel.soundTransform = transform;
	}
	
	static public function setStereoPan(channel:SoundChannel, value:Float)
	{
		final transform = new SoundTransform(channel.soundTransform.volume, value);
		transform.leftToLeft = 1 - Math.max(0, Math.min(1, value));
		transform.leftToRight = Math.max(0, Math.min(1, value));
		transform.rightToLeft = 1 - Math.min(1, value + 1);
		transform.rightToRight = Math.min(1, value + 1);
		channel.soundTransform = transform;
	}
	
	// static public function setPan(sound:Sound, value:Float)
	// {
	// 	sound.pan = value;
	// 	@:privateAccess
	// 	var channel = sound._channel;
	// 	channel.soundTransform = new SoundTransform(sound.volume, pan);
	// }
}
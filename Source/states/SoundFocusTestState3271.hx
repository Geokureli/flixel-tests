package states;

import flixel.system.debug.log.LogStyle;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.sound.FlxSound;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.utils.Assets;


class SoundFocusTestState3271 extends flixel.FlxState
{
	public var sound:FlxSound;
	
	override function create()
	{
		super.create();
		
		final text = new FlxText("press space to play, pause or resume the sound");
		text.screenCenter();
		add(text);
		FlxG.log.add('defaultSoundExtension: ${FlxG.assets.defaultSoundExtension}');
		
		LogStyle.NOTICE.onLog.add((d)->log.error(d));
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.SPACE)
		{
			if (sound == null)
				sound = FlxG.sound.play("assets/sounds/long-sound.ogg", ()->sound = null);
			else if (sound.playing)
				sound.pause();
			else
				sound.resume();
		}
	}
}
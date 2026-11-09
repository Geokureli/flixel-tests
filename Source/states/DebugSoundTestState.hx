package states;

import flixel.FlxG;
import flixel.sound.FlxSound;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Input;
import openfl.events.SampleDataEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.utils.ByteArray;

class DebugSoundTestState extends flixel.FlxState
{
	static inline var SAMPLE_RATE = 44100;
	static inline var BYTES_PER_SAMPLE = 4;
	static inline var BITS_PER_SAMPLE = BYTES_PER_SAMPLE << 3;
	
	override function create()
	{
		super.create();
		
		#if lime_cffi trace("lime_cffi"); #end
		#if lime_howlerjs trace("lime_howlerjs"); #end
		#if lime_vorbis trace("lime_vorbis"); #end
		
		// final sound = new FlxSound().load(new DebugSound(1000)).setup(1.0, true).play();
		// FlxG.watch.addFunction('time', ()->'${sound.time}');
		
		FlxG.sound.applySoundCurve = function (volume:Float)
		{
			final clampedVolume = Math.max(0, Math.min(1, volume));
			return Math.exp(Math.log(0.001) * (1 - clampedVolume));
		}
	
		FlxG.sound.reverseSoundCurve = function (curvedVolume:Float)
		{
			final clampedVolume = Math.max(0.001, Math.min(1, curvedVolume));
			return 1 - (Math.log(clampedVolume) / Math.log(0.001));
		}
	}
	
    override function update(elapsed)
    {
        super.update(elapsed);
		
		if (FlxG.mouse.justPressed)
		{
			// playSound("assets/sounds/flixel.ogg", 0.5);
			// playSound("assets/sounds/flixel-mono.mp3");
			playSound("assets/sounds/long-sound.wav", 1, 2);
			// playSound("assets/sounds/1s-silence-8uint.wav");
			// playSoundCompressed("assets/sounds/long-sound.wav.geo");
			// playSoundCompressed("assets/sounds/0.001s-silence-8uint.wav.geo2");
			// playSoundCompressed("assets/sounds/1s-silence-8uint.wav.geo");
			// playSoundByteArray();
			// playSourceFromBytes("assets/sounds/1s-silence-8uint.wav.geo");
			// playSourceFromBytes("assets/sounds/long-sound.wav.geo");
			// playGeneratedSilenceWav(1.000);
			// playGeneratedSilenceWav(0.001);
			// playGeneratedWav(1.000);
			// playDebugSound(1.000);
			// 80808080808080808080808080808080808080808080
			// 524946467c00000057415645666d7420100000000100020044ac00008858010002000800646174615800000080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080
			// 524946467c00000057415645666d7420100000000100020044ac0000885801000200080064617461580000008080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
		}
    }
	
	function playSound(asset, volume = 1.0, pitch = 1.0)
	{
		final sound = FlxG.sound.create(FlxG.assets.getSound(asset));
		sound.volume = volume;
		sound.pan = -1;
		#if FLX_PITCH
		sound.pitch = pitch;
		#end
		sound.play();
		@:privateAccess
		final channel = sound._channel;
		FlxG.watch.addFunction('time', ()->'${channel.position}');
		FlxG.watch.addFunction('left', ()->'${sound.amplitudeLeft}');
		FlxG.watch.addFunction('right', ()->'${sound.amplitudeRight}');
		
	}
	
	function playSoundByteArray(duration:Float, channels = 2)
	{
		final mySound:Sound = new Sound();
		final numSamples = Math.ceil(SAMPLE_RATE * duration);
		final samples = new ByteArray(numSamples * BYTES_PER_SAMPLE * channels);
		sineWaveGenerator(cast samples, numSamples, channels, Math.PI / 4);
		samples.position = 0;
		mySound.loadPCMFromByteArray(samples, numSamples);
		
		final channel = mySound.play();
		FlxG.watch.addFunction('time', ()->'${channel.position}');
	}
	
	function playSourceFromBytes(path:String)
	{
		final bytes = FlxG.assets.getBytes(path);
		final buffer = lime.media.AudioBuffer.fromBytes(bytes);
		final source = new lime.media.AudioSource(buffer);
		source.play();
		FlxG.watch.addFunction('time', ()->'${source.position}');
	}
	
	function sineWaveGenerator(data:Bytes, samples:Int, channels = 2, freq:Float, phase = 0.0)
	{
		for (i in 0...samples)
		{
			final sample = Math.sin((i + phase) * freq);
			for (channel in 0...channels)
				data.setFloat(((i * channels) + channel) * BYTES_PER_SAMPLE , sample);
		}
	}
    
	function onSample(event:SampleDataEvent)
	{
		// mySound.addEventListener(SampleDataEvent.SAMPLE_DATA, sineWaveGenerator);
		sineWaveGenerator(cast event.data, 8192, 2, 1 / Math.PI / 4, event.position);
	}
	
	function playSoundCompressed(path:String)
	{
		final mySound:Sound = new Sound();
		final bytes = FlxG.assets.getBytes(path);
		// trace(bytes.sub(0, 50).toHex());
		mySound.loadCompressedDataFromByteArray(cast bytes, bytes.length);
		trace(mySound.length);
		final channel = mySound.play();
        FlxG.watch.addFunction('time', ()->'${channel.position}');
	}
	
	function playDebugSound(seconds:Float)
	{
		final sound = new DebugSound().loadSilence(seconds);
		final channel = sound.play();
		FlxG.watch.addFunction('time', ()->'${channel.position}');
	}
}

class DebugSound extends openfl.media.Sound
{
	inline static var SAMPLE_RATE = 44100;
	var _ = 0x44ac0000;
	var n = 0x0000ac44;
	inline static var HEADER_BYTES
		= '524946460000000057415645666d7420100000000100010044ac000044ac0000020008006461746100000000';
		// |       |       |       |       |       |   |   |       |       |   |   |       |       
		// R_I_F_F_<-size->W_A_V_E_f_m_t_ _<--16--><01><ch><44100-><bytrte><ba><br>d_a_t_a_<sampls>
		
		// 52494646efbfbd58010057415645666d7420100000000100020044efbfbd0000efbfbd5801000200080064617461efbfbd58
		// |       |           |       |       |       |   |   |       |       |   |   |       |       
		// R_I_F_F_<-size->????W_A_V_E_f_m_t_ _<--16--><01><ch><44100-><bytrte><ba><br>d_a_t_a_<sampls>
	
	public function new ()
	{
		super();
	}
	
	public function loadSilence(seconds:Float)
	{
		final numSamples = Std.int(SAMPLE_RATE * seconds);
		final samples = haxe.io.Bytes.alloc(numSamples);
		for (i in 0...numSamples)
			samples.set(i, 0x80);
		
		final rawBytes = haxe.io.Bytes.ofHex(HEADER_BYTES + samples.toHex());
		rawBytes.setInt32(4, 36 + samples.length);
		rawBytes.setInt32(40, samples.length);
		
		final bytes = openfl.utils.ByteArray.fromBytes(rawBytes);
		loadCompressedDataFromByteArray(bytes, bytes.length);
		return this;
	}
}

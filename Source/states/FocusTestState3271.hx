package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.system.debug.log.LogStyle;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxVirtualPad;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.utils.Assets;


class FocusTestState3271 extends flixel.FlxState
{
	public var sound:FlxSound;
	public var foo = 10;
	public var pad:FlxVirtualPad;
	public var mouse:FlxSprite;
	
	override function create()
	{
		super.create();
		bgColor = 0xFF808080;
		
		// mouse = new FlxSprite("assets/images/origin.png");
		// mouse.offset.set(3, 3);
		// add(mouse);
		
		// final text = new FlxText(0, 0, 0, "press space to play, pause or resume the sound");
		// text.screenCenter();
		// add(text);
		
		final text = new FlxText(0, 0, 0, "Hello, world!", 16);
		text.screenCenter();
		text.y += 20;
		add(text);
		
		// final field = new FlxInputText(5, 5, 0, "The default text input.");
		// field.screenCenter();
		// field.y += 40;
		// add(field);
		
		// pad = new FlxVirtualPad(FULL, A_B_X_Y);
		// add(pad);
		
		// final keys = FlxG.keys.pressed;
		// FlxG.watch.add(this, "foo");
		// FlxG.watch.addFunction("focus", ()->FlxG.stage.focus);
		// FlxG.watch.addFunction("keys", ()->'${keys.UP ? "U" : "X"}${keys.DOWN ? "D" : "X"}${keys.LEFT ? "L" : "X"}${keys.RIGHT ? "R" : "X"}');

	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// mouse.x = FlxG.mouse.x;
		// mouse.y = FlxG.mouse.y;
		
		// if (FlxG.keys.justPressed.SPACE)
		// {
		// 	if (sound == null)
		// 		sound = FlxG.sound.play("assets/sounds/long-sound", 1.0, false, null, true, ()->sound = null);
		// 	else if (sound.playing)
		// 		sound.pause();
		// 	else
		// 		sound.resume();
		// }
		
		// function pressPadButton(btn, key)
		// {
		// 	@:privateAccess
		// 	final input = pad.getButton(btn);
		// 	if (FlxG.keys.checkStatus(key, JUST_PRESSED))
		// 		input.animation.play("pressed");
		// 	else if (FlxG.keys.checkStatus(key, JUST_RELEASED))
		// 		input.animation.play("normal");
			
		// 	// final input = pad.getButton(btn).input;
		// 	// if (FlxG.keys.checkStatus(key, PRESSED))
		// 	// 	input.press();
		// 	// if (FlxG.keys.checkStatus(key, RELEASED))
		// 	// 	input.release();
		// }
		
		// pressPadButton(UP, UP);
		// pressPadButton(DOWN, DOWN);
		// pressPadButton(LEFT, LEFT);
		// pressPadButton(RIGHT, RIGHT);
		
		if (FlxG.keys.pressed.Q && FlxG.camera.zoom > 0.5)
			FlxG.camera.zoom -= elapsed * 0.5;
		
		if (FlxG.keys.pressed.E && FlxG.camera.zoom < 4.0)
			FlxG.camera.zoom += elapsed * 0.5;
		
		if (FlxG.keys.justPressed.ONE)
			FlxG.camera.zoom = 0.5;
		
		if (FlxG.keys.justPressed.TWO)
			FlxG.camera.zoom = 1.0;
		
		if (FlxG.keys.justPressed.ONE)
			FlxG.camera.zoom = 2.0;
		
		if (FlxG.keys.justPressed.ONE)
			FlxG.camera.zoom = 4.0;
		
	}
}
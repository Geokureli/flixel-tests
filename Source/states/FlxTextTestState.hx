package states;

import flixel.FlxG;
import flixel.text.FlxText;
import tools.CameraControl;
import tools.SpriteMover;

class FlxTextTestState extends flixel.FlxState
{
	final textStr = "The quick brown fox jumps over the lazy dog";
	var text:FlxText;
	
	override function create():Void
	{
		super.create();
		bgColor = 0xFF808080;
		
		// final text1 = new FlxText(0, 0, FlxG.width, "Hello World!");
		final text1 = new FlxText(0, 0, 0, "Hello, world!", 43);
		text1.alignment = CENTER;
		text1.screenCenter();
		text1.y += 20;
		add(text1);
		
		// final spriteMover = new SpriteMover(text1);
		// spriteMover.flip = null;
		// spriteMover.move = WASD;
		// spriteMover.moveOrigin = null;
		// spriteMover.moveOffset = null;
		// add(spriteMover);
		
		final camControls = new CameraControl(FlxG.camera);
		add(camControls);
		
		text = new FlxText(0, text1.y + text1.height + 2, FlxG.width, textStr, 43);
		text.alignment = CENTER;
		text.screenCenter(X);
		add(text);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			text.textField.antiAliasType = text.textField.antiAliasType == NORMAL ? ADVANCED : NORMAL;
			text.textField.sharpness = text.textField.sharpness == 400 ? 100 : 400;
			@:privateAccess
			text._regen = true;
		}
		
		if (FlxG.keys.justPressed.RIGHT && text.text.length < textStr.length)
			text.text = textStr.substr(0, text.text.length + 1);
		
		if (FlxG.keys.justPressed.LEFT && text.text.length > 0)
			text.text = textStr.substr(0, text.text.length - 1);
	}
}
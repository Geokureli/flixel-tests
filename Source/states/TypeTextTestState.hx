package states;

import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.addons.text.FlxTextTyper;

class TypeTextTestState extends flixel.FlxState
{
	inline static public var TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
	
	var typer:FlxTextTyper;
	
	override function create()
	{
		super.create();
		
		final prefix = "Prefix:";
		
		final bitmapField = new FlxBitmapText(2, 2, prefix);
		bitmapField.fieldWidth = FlxG.width - 4;
		bitmapField.autoSize = false;
		
		final field = new FlxText(0, 0, FlxG.width, prefix);
		field.y = FlxG.height - field.frameHeight;
		field.textField.defaultTextFormat.leading = 0;
		
		add(typer = new FlxTextTyper(prefix));
		typer.skipKeys = [SPACE];
		typer.onChange.add(function ()
		{
			bitmapField.text 
				= field.text = typer.text;
			field.y = FlxG.height - field.frameHeight;
		});
		typer.onCharsType.add(FlxG.sound.play.bind("assets/sounds/type.ogg", 0.3));

		add(bitmapField);
		add(field);
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.LEFT)
			typer.startErasing();
		
		if (FlxG.keys.justPressed.RIGHT)
			typer.startTyping(TEXT, FlxG.keys.released.SHIFT);
	}
}

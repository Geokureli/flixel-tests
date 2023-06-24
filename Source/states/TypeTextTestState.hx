package states;

import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.addons.text.FlxTextTyper;

class TypeTextTestState extends flixel.FlxState
{
	inline static public var TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
	
	var typer:FlxTextTyper;
	
	override function create()
	{
		super.create();
		
		var field = new FlxBitmapText(2, 2, "Prefix:");
		field.fieldWidth = FlxG.width - 4;
		field.autoSize = false;
		field.wordWrap = true;
		field.wrapByWord = true;
		field.multiLine = true;
		
		add(typer = new FlxTextTyper(field.text));
		typer.skipKeys = [SPACE];
		typer.onChange.add(()->field.text = typer.text);
		// typer.onCharsType.add(FlxG.sound.play.bind("assets/sounds/type.ogg", 0.3));

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

package states;

import flixel.FlxG;
import flixel.addons.text.FlxTextTyper;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;

class TypeTextTestState extends flixel.FlxState
{
	inline static public var TEXT = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
	
	var typer:FlxTextTyper;
	var bitmapField:FlxBitmapText;
	var field:FlxText;
	
	override function create()
	{
		super.create();
		bgColor = 0xFFc0c0c0;
		js.Syntax.code("console.log({0}, {1})", "hi", 42);
		
		final prefix = "Prefix:";
		
		bitmapField = new FlxBitmapText(2, 2, prefix);
		bitmapField.fieldWidth = FlxG.width - 4;
		bitmapField.autoSize = false;
		bitmapField.background = true;
		bitmapField.backgroundColor = 0xFF808080;
		bitmapField.padding = 2;
		bitmapField.setBorderStyle(OUTLINE, 0xFF000000);
		final adv = bitmapField.font.getCharAdvance("n".code);
		final wid = bitmapField.font.getCharWidth("n".code);
		trace('adv: $adv, wid: $wid');
		
		field = new FlxText(0, 0, FlxG.width, prefix);
		field.y = FlxG.height - field.frameHeight;
		field.textField.defaultTextFormat.leading = 0;
		
		add(typer = new FlxTextTyper(prefix));
		typer.skipKeys = [SPACE];
		typer.onChange.add(function ()
		{
			bitmapField.text = typer.text;
			field.text = typer.text.split("\n").join("");
			field.y = FlxG.height - field.frameHeight;
		});
		// typer.onCharsType.add(FlxG.sound.play.bind("assets/sounds/type.ogg", 0.3));

		add(bitmapField);
		add(field);
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.LEFT)
			typer.startErasing();
		
		if (FlxG.keys.justPressed.RIGHT)
		{
			final text = if (typer.prefix != null)
				bitmapField.getRenderedText(typer.prefix + TEXT).substr(typer.prefix.length);
			else
				bitmapField.getRenderedText(TEXT);
			typer.startTyping(text, FlxG.keys.released.SHIFT);
		}
		
		if (FlxG.keys.released.ENTER)
			trace(field.textField.htmlText);
	}
}

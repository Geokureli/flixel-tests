package states;

import haxe.ui.components.TextArea;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.text.FlxInputTextManager;
import flixel.util.FlxColor;

class FlxInputTextTest extends flixel.FlxState
{
	var actions:FlxText;
	override function create()
	{
		super.create();
		
		bgColor = 0xFF808080;
		
		final textInput = new FlxInputText(5, 5, 0, "This is a default text input.", 16);
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This is a multiline text input with fieldWidth and fieldHeight set.", 16);
		textInput.fieldHeight = 44;
		textInput.multiline = true;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This is a multiline text input with word wrapping.", 16);
		textInput.fieldHeight = 44;
		textInput.wordWrap = textInput.multiline = true;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This is an uneditable text input.", 16);
		textInput.editable = false;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This is an unselectable text input.", 16);
		textInput.selectable = false;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This is a formatted text input.");
		textInput.setFormat(FlxAssets.FONT_DEBUGGER, 16, FlxColor.LIME);
		textInput.italic = textInput.bold = true;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This text input is aligned to the center.", 16);
		textInput.alignment = CENTER;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This text input is aligned to the right.", 16);
		textInput.alignment = RIGHT;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"Maximum characters: 30", 16);
		textInput.maxLength = 30;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"only lowercase", 16);
		textInput.forceCase = LOWER_CASE;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"ONLY UPPERCASE", 16);
		textInput.forceCase = UPPER_CASE;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"OnlyAlphanumeric123", 16);
		textInput.filterMode = ALPHANUMERIC;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"password", 16);
		textInput.passwordMode = true;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This is a text input with custom selection colors.", 16);
		textInput.caretWidth = 2;
		textInput.caretColor = FlxColor.BLUE;
		textInput.selectionColor = FlxColor.BLUE;
		textInput.selectedTextColor = FlxColor.WHITE;
		add(textInput);
		
		final textInput = new FlxInputText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20,
			"This is a text input without a background.", 16,
			FlxColor.WHITE, FlxColor.TRANSPARENT);
		add(textInput);
		
		actions = new FlxText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20, "", 16);
		// actions.textField.background = true;
		// actions.textField.backgroundColor = 0xFFffffff;
		// actions.textField.textColor = 0xFF000000;
		add(actions);
		function addAction(msg:String)
		{
			if (actions.text.charAt(actions.text.length - 1) != "\n")
				msg = ', $msg';
			
			actions.text += msg;
		}
		
		FlxInputText.globalManager.onTypingAction.add((action)->switch(action)
		{
			case ADD_TEXT(text):
				addAction('Add "$text"');
			case MOVE_CURSOR(type, true):
				addAction('Selection "${type.getName()}"');
			case MOVE_CURSOR(type, false):
				addAction('Cursor "${type.getName()}"');
			case COMMAND(cmd):
				addAction(cmd.getName());
		});
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (actions.text.charAt(actions.text.length - 1) != "\n")
			actions.text += "\n";
		
		final lines = actions.text.split("\n");
		if (lines.length > 17)
			lines.shift();
		actions.text = lines.join("\n");
	}
}
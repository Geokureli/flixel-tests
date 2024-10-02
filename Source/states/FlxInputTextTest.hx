package states;

import flixel.group.FlxGroup;
import haxe.ui.components.TextArea;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.text.FlxInputTextManager;
import flixel.util.FlxColor;

class FlxInputTextTest extends flixel.FlxState
{
	var fields:FlxTypedGroup<FlxText>;
	
	override function create()
	{
		super.create();
		
		bgColor = 0xFF808080;
		
		add(fields = new FlxTypedGroup());
		
		final textX = 5;
		var textY = 5.0;
		
		/** Helper to create similar input texts below each other*/
		function createInputText(?fieldWidth:Float, text = "", size = 16)
		{
			if (fieldWidth == null)
				fieldWidth = FlxG.width - 20;
			
			final length = fields.members.length;
			// add the new text below the previous text
			if (length > 0)
				textY += fields.members[length - 1].height + 5;
			
			final field = new FlxInputText(textX, textY, fieldWidth, text, size);
			fields.add(field);
			return field;
		}
		
		createInputText(0, "This is a default text input.");
		
		final textInput = createInputText("This is a multiline text input with fieldWidth and fieldHeight set.");
		textInput.fieldHeight = 44;
		textInput.multiline = true;
		
		final textInput = createInputText("This is a multiline text input with word wrapping.");
		textInput.fieldHeight = 44;
		textInput.wordWrap = textInput.multiline = true;
		
		final textInput = createInputText("This is an uneditable text input.");
		textInput.editable = false;
		
		final textInput = createInputText("This is an unselectable text input.");
		textInput.selectable = false;
		
		final textInput = createInputText("This is a formatted text input.");
		textInput.setFormat(FlxAssets.FONT_DEBUGGER, 16, FlxColor.LIME);
		textInput.italic = textInput.bold = true;
		
		final textInput = createInputText("This text input is aligned to the center.");
		textInput.alignment = CENTER;
		
		final textInput = createInputText("This text input is aligned to the right.");
		textInput.alignment = RIGHT;
		
		final textInput = createInputText("Maximum characters: 30");
		textInput.maxChars = 30;
		textInput.onTextChange.add((s,c)->trace(textInput.text));
		
		final textInput = createInputText("only lowercase and with a border");
		// textInput.fieldBorderThickness = 2;
		// textInput.fieldBorderColor = FlxColor.BLACK;
		textInput.forceCase = LOWER_CASE;
		
		final textInput = createInputText("ONLY UPPERCASE");
		textInput.forceCase = UPPER_CASE;
		
		final textInput = createInputText("OnlyAlphanumeric123");
		textInput.filterMode = ALPHANUMERIC;
		
		final textInput = createInputText("password");
		textInput.passwordMode = true;
		
		final textInput = createInputText("This is a text input with custom selection colors.");
		textInput.caretWidth = 2;
		textInput.caretColor = FlxColor.BLUE;
		// textInput.selectionColor = FlxColor.BLUE;
		// textInput.selectedTextColor = FlxColor.WHITE;
		
		final textInput = createInputText("This is a text input without a background.");
		textInput.color = FlxColor.WHITE;
		textInput.background = false;
		
		final actionList = new ActionsText(textInput.x, textInput.y + textInput.height + 5, FlxG.width - 20);
		add(actionList);
	}
}

class ActionsText extends FlxText
{
	public var maxLines:Int;
	public function new (x:Float, y:Float, fieldWidth = 0, text = "", size = 16, maxLines = 17)
	{
		this.maxLines = maxLines;
		super(x, y, fieldWidth, text, size);
		
		textField.background = true;
		setFormat(size, 0x0);
		textField.backgroundColor = 0xffffff;
		textField.type = INPUT;
		textField.selectable = true;
		setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		
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
	
	function addAction(msg:String)
	{
		if (text != "" && text.charAt(text.length - 1) != "\n")
			msg = ', $msg';
		
		text += msg;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (text != "" && text.charAt(text.length - 1) != "\n")
			text += "\n";
		
		final lines = text.split("\n");
		if (lines.length > maxLines)
			lines.shift();
		text = lines.join("\n");
		
		final end = text.indexOf("\n");
		if (end != -1)
		{
			textField.setSelection(0, end);
		}
	}
}
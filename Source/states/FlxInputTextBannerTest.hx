package states;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.text.FlxInputTextManager;
import flixel.util.FlxColor;

class FlxInputTextBannerTest extends flixel.FlxState
{
	var fields:FlxTypedGroup<FlxText>;
	
	override function create()
	{
		super.create();
		
		bgColor = 0xFF808080;
		
		add(fields = new FlxTypedGroup());
		
		/** Helper to create similar input texts below each other*/
		function createInputTextHelper(?fieldWidth:Float, text = "", size = 12, below = true)
		{
			var textX = 5.0;
			var textY = 5.0;
			if (fields.members.length > 0)
			{
				final prev = fields.members[fields.members.length - 1];
				if (below)
				{
					textY = prev.y + prev.height + 3;
				}
				else
				{
					textX = prev.x + prev.width + 3;
					textY = prev.y;
				}
			}
			
			if (fieldWidth == null)
				fieldWidth = FlxG.width - 5 - textX;
			
			final field = new FlxInputText(textX, textY, fieldWidth, text, size);
			fields.add(field);
			return field;
		}
		
		function createInputTextBelow(?fieldWidth:Float, text = "", size = 16)
		{
			return createInputTextHelper(fieldWidth, text, size, true);
		}
		
		function createInputText(?fieldWidth:Float, text = "", size = 16)
		{
			return createInputTextHelper(fieldWidth, text, size, false);
		}
		
		final textInput = createInputTextBelow
			( "This is my input text. There are many like it, but this one is mine.\n"
			+ "My input text is my best friend. It is my life. I must master it as I must master my life.\n"
			+ "Without me, my input text is useless. Without my input text, I am useless."
			);
		// textInput.fieldHeight = 24;
		textInput.multiline = textInput.wordWrap = true;
		
	}
}

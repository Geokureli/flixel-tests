package states;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

class TextAutoSizeTestState extends FlxState
{
	override public function create()
	{
		bgColor = 0xFFffffff;
		super.create();

		var autoSizedText = new MorphingText("This text has an ", "auto width and height");
		autoSizedText.screenCenter(X);
		autoSizedText.y = 30;
		add(autoSizedText);

		var fixedSize = new MorphingText("This text has a ", "fixed width and height");
		fixedSize.fieldWidth = 140;
		fixedSize.fieldHeight = 70;
		fixedSize.screenCenter(X);
		fixedSize.y = autoSizedText.getScreenBounds().bottom + 10;
		add(fixedSize);

		var autoHeight = new MorphingText("This text has a ", "fixed width\nand auto height");
		autoHeight.fieldWidth = 100;
		autoHeight.fieldHeight = 0;
		autoHeight.screenCenter(X);
		autoHeight.y = fixedSize.getScreenBounds().bottom + 10;
		add(autoHeight);
		
		var autoWidth = new MorphingText("This text has a ", "fixed height\nand auto width");
		autoWidth.fieldWidth = 0;
		autoWidth.fieldHeight = 100;
		autoWidth.screenCenter(X);
		autoWidth.y = autoHeight.getScreenBounds().bottom + 10;
		add(autoWidth);
	}
}

/**
 * A helper class for a FlxText with a dark blue background, cyan text and ever-changing text
 */
@:forward
abstract MorphingText(FlxText) to FlxText
{
	/**
	 * @param   morphingText  The text that disappears and reappears
	 * @param   staticText    The text that always shows
	 * @param   size          The size of the text
	 */
	public function new (morphingText:String, staticText:String, size = 16)
	{
		this = new FlxText(0, 0, 0, morphingText + staticText, size);
		colorize();
		
		FlxTween.num(0, 1, 1.0, { loopDelay: 1.0, type: PINGPONG }, function(num)
		{
			this.text = morphingText.substr(0, Math.round(morphingText.length * num)) + staticText;
		});
	}
	
	function colorize()
	{
		this.color = FlxColor.CYAN;
		// accessing background through underlying openfl TextField object
		this.textField.background = true;
		this.textField.backgroundColor = 0x0C365F;
	}
}
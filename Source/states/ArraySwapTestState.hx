package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;

using flixel.util.FlxArrayUtil;

/**
 * Test state for [flixel#2685](https://github.com/HaxeFlixel/flixel/pull/2685)
**/
class ArraySwapTestState extends FlxState
{
	var card1:FlxSprite;
	var card2:FlxSprite;
	var helpText:FlxText;

	override public function create()
	{
		super.create();
		card1 = new FlxSprite().makeGraphic(100, 100, FlxColor.RED);
		card1.screenCenter();
		card1.x -= 20;

		card2 = new FlxSprite().makeGraphic(100, 100, FlxColor.YELLOW);
		card2.screenCenter();
		card2.x += 20;
		card2.y += 20;

		helpText = new FlxText(0, FlxG.height - 20, 0, 'Press ENTER to toggle which card is at the front');
		helpText.setFormat(null, 12, FlxColor.BLACK);
		helpText.screenCenter(X);
		add(helpText);

		FlxG.camera.bgColor = FlxColor.WHITE;
		add(card1);
		add(card2);
		
		trace([1, 2, 3, 4, 5, 6].swap(2, 5).equals([1, 5, 3, 4, 2, 6]));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
		{
			members.swap(card1, card2);
		}
	}
}
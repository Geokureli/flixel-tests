package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxBar;

/**
 * https://github.com/HaxeFlixel/flixel/pull/2938
 */
class FlxBarTestState2938 extends FlxState
{
	var bar:FlxBar;

	override public function create()
	{
		bar = new FlxBar();
		bar.value = 50;
		bar.screenCenter();
		add(bar);

		super.create();
	}

	@:access(flixel.ui.FlxBar)
	override public function update(elapsed:Float)
	{
		if (bar != null)
		{
			if (FlxG.keys.justReleased.ONE)
			{
				// With the old code, the game will now crash when trying to draw the FlxBar,
				// as the front/filled graphic has been incorrectly cleared
				FlxG.bitmap.clearUnused();

				FlxG.log.add('Cleared unused graphics.');
			}
			else if (FlxG.keys.justReleased.TWO)
			{
				FlxG.log.add('Destroying the FlxBar...');

				final _frontFrame = bar._frontFrame;

				bar.destroy();

				// With the old code, these variables will not have been set to `null`
				if (FlxG.renderTile)
				{
					FlxG.log.add('frontFrames is null: ${bar.frontFrames == null}');
				}
				else
				{
					FlxG.log.add('_emptyBar is null: ${bar._emptyBar == null}');
				}

				// With the old code, _frontFrame will not have been destroyed
				FlxG.log.add('_frontFrame was destroyed: ${_frontFrame.sourceSize == null}');

				remove(bar, true);
				bar = null;
			}
		}

		super.update(elapsed);
	}
}
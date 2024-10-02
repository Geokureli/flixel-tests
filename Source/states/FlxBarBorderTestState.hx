package states;

import flixel.FlxG;
import flixel.FlxState;

import flixel.ui.FlxBar;

import flixel.util.FlxColor;

class FlxBarBorderTestState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.WHITE;

		var fivePixelBorder:FlxBar = new FlxBar(0.0, 0.0, LEFT_TO_RIGHT, 300, 30, null, "", 0.0, 100.0, true);

		fivePixelBorder.createFilledBar(FlxColor.RED, FlxColor.LIME, true, FlxColor.BLACK, 5);

		add(fivePixelBorder);

		var tenPixelBorder:FlxBar = new FlxBar(0.0, 0.0, LEFT_TO_RIGHT, 300, 30, null, "", 0.0, 100.0, true);

		tenPixelBorder.createFilledBar(FlxColor.RED, FlxColor.LIME, true, FlxColor.BLACK, 10);

		tenPixelBorder.setPosition(0.0, tenPixelBorder.height + 15.0);

		add(tenPixelBorder);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
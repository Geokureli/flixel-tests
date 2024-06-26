package states;

import flixel.FlxG;
import flixel.ui.FlxButton;

class ResetStateTestState extends flixel.FlxState
{
	override public function create():Void
	{
		FlxG.log.add("state created");
		var resetButton = new FlxButton(0, 0, "Reset", () -> FlxG.resetState());
		resetButton.screenCenter();
		add(resetButton);
	}
}
package states;

import flixel.FlxG;
import flixel.ui.FlxButton;

class ResetStateTestState extends flixel.FlxState
{
	override public function create():Void
	{
		FlxG.log.add("state created");
		var resetButton = new FlxButton(0, 0, "Reset", function()
		{
			FlxG.resetState();// breakpoint here
		});
		resetButton.screenCenter();
		add(resetButton);
	}
}
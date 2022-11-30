package states;

import flixel.ui.FlxButton;

class ButtonZoomTestState extends flixel.FlxState
{
	override public function create():Void
	{
		camera.zoom = 2;
		
		var oldButton = new FlxButton("button");
		oldButton.screenCenter();
		oldButton.x -= oldButton.width;
		add(oldButton);
	}
}
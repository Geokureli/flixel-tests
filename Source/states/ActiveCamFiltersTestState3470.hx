package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import openfl.filters.BlurFilter;

class ActiveCamFiltersTestState3470 extends flixel.FlxState
{
	var topCamera:FlxCamera;

	override public function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.WHITE;

		var dummyGraphic:FlxSprite = new FlxSprite();

		dummyGraphic.screenCenter();
		persistentDraw = false;

		add(dummyGraphic);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			pause();
		}
	}

	public function pause():Void
	{
		// Commenting this line fixes the issue.
		// camera.active = false;

		openSubState(new PauseScreen());
	}
}

class PauseScreen extends FlxSubState
{
	var blur:BlurFilter = new BlurFilter(10.0, 10.0, 1);

	override function create():Void
	{
		super.create();

		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];

		FlxG.state.camera.filters = [blur];

		trace("Filter should be applying");
	}
}
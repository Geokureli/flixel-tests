package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.Transition;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;

/**
 * https://github.com/HaxeFlixel/flixel-addons/pull/410
 */
class TransitionCameraTestState extends FlxTransitionableState
{
	public function new()
	{
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, FlxPoint.weak(0, -1));
		FlxTransitionableState.defaultTransOut = new TransitionData(NONE, FlxColor.BLACK, 1, FlxPoint.weak(0, 1));

		super();
	}

	override function create()
	{
		FlxG.camera.bgColor = 0xFFffffff;

		var bg = new FlxSprite(50, 50);
		bg.makeGraphic(FlxG.width - 100, FlxG.height - 100, 0xFF000080);
		add(bg);

		var fg = new FlxSprite(10, 10);
		fg.makeGraphic(FlxG.width - 20, 100, 0xFFa00000);
		fg.camera = new FlxCamera();
		fg.camera.bgColor = 0x0;
		FlxG.cameras.add(fg.camera, false);
		add(fg);

		super.create();
	}

	override function update(elapsed)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
			FlxG.switchState(new TransitionCameraTestState());
	}
}

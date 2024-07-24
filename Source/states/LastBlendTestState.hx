package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;

class LastBlendTestState extends FlxState
{
	static final blendModes:Array<BlendMode> = [
		NORMAL, ADD, ALPHA, DARKEN, DIFFERENCE, ERASE, HARDLIGHT, INVERT, LAYER, LIGHTEN, MULTIPLY, OVERLAY, SCREEN, SHADER, SUBTRACT
	];
	static final fadeColors:Array<FlxColor> = [
		FlxColor.WHITE, FlxColor.GRAY, FlxColor.BLACK, FlxColor.GREEN, FlxColor.LIME, FlxColor.YELLOW, FlxColor.ORANGE, FlxColor.RED, FlxColor.PURPLE,
		FlxColor.BLUE, FlxColor.BROWN, FlxColor.PINK, FlxColor.MAGENTA, FlxColor.CYAN
	];

	var light:FlxSprite;
	var curBlendMode:Int = 0;
	var curFadeColor:Int = 0;

	var _resetTimer:Float = 0.0;

	override public function create():Void
	{
		super.create();

		/**	stage setup	**/

		FlxG.camera.bgColor = FlxColor.fromHSL(0, 0, 0.26);

		light = new FlxSprite().makeGraphic(200, 200, fadeColors[FlxG.random.int(0, fadeColors.length - 1)]);
		light.blend = ADD;
		curBlendMode = blendModes.indexOf(light.blend);
		add(light.screenCenter());

		/**	end stage setup	**/

		// start camera fade cycle
		fadeCamera();
	}

	override public function update(elapsed:Float):Void
	{
		// state reset timer
		if (FlxG.keys.pressed.R)
		{
			_resetTimer += elapsed;
			if (_resetTimer >= 0.5)
			{
				FlxG.resetState();
				return;
			}
		}
		else
			_resetTimer = 0.0;

		super.update(elapsed);

		// change light sprite blend mode
		final ARROW_LEFT = FlxG.keys.justPressed.LEFT;
		final ARROW_RIGHT = FlxG.keys.justPressed.RIGHT;
		if (ARROW_LEFT || ARROW_RIGHT && !(ARROW_LEFT && ARROW_RIGHT))
		{
			if (ARROW_RIGHT)
				curBlendMode++;
			else
				curBlendMode--;

			curBlendMode = FlxMath.wrap(curBlendMode, 0, blendModes.length - 1);
			light.blend = blendModes[curBlendMode];
		}

		// switch light sprite visibility
		if (FlxG.keys.justPressed.Z)
			light.visible = !light.visible;
	}

	function fadeCamera():Void
	{
		FlxG.camera.fade(fadeColors[curFadeColor], 1.0, false, () -> new FlxTimer().start(0.5, _ -> fadeCamera()));
		curFadeColor = (++curFadeColor % fadeColors.length);
		trace(curFadeColor);
	}
}
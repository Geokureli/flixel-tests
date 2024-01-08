package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.ui.FlxButton;
// import flixel.input.actions.FlxAction;
import flixel.input.gamepad.FlxGamepad;

import flixel.addons.ui.FlxMultiGamepad;
import flixel.addons.ui.FlxUICursor;

class CursorTestState extends flixel.FlxState
{
	var text:FlxButton;
	
	override public function create()
	{
		text = new FlxButton(0, 0, "Substate", openState);
		text.screenCenter();
		add(text);
		
		super.create();
	}
	
	function openState()
	{
		openSubState(new ButtonList());
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

class ButtonList extends flixel.addons.ui.FlxUIPopup
{
	override public function create()
	{
		_makeCursor = true;

		super.create();
		
		// final button = _ui.hasAsset("btn0");
		// final box = new FlxSprite().makeGraphic(10, 10);

		cursor.setDefaultKeys(KEYS_ARROWS | KEYS_WASD #if FLX_GAMEPAD | GAMEPAD_DPAD | GAMEPAD_LEFT_STICK #end);
		// Set gamepad
		cursor.gamepadAutoConnect = LastActive;

		FlxG.gamepads.deviceConnected.add(setGamepadButtons);
		cursor.keysClick.push(new FlxMultiGamepad(cursor.gamepad, A));
	}
	
	override function myGetTextFallback(flag, context = "ui", safe = true)
	{
		if (flag == "$POPUP_BODY_DEFAULT")
			return "Lorem ipsum dolor dolor bill, yall.";
		
		return super.myGetTextFallback(flag, context, safe);
	}

	function setGamepadButtons(gamepad:FlxGamepad = null)
	{
		setupGamepad(cursor);
	}

	public static function setupGamepad(cursor:FlxUICursor)
	{
		if (cursor.gamepad == null)
		{
			// Look for an available gamepad
			var g = getGamepad();

			if (g == null)
				return;
		}
	}

	public static function getGamepad(exhaustive:Bool = true):FlxGamepad
	{
		var gamepad = FlxG.gamepads.getFirstActiveGamepad();
		if (gamepad == null && exhaustive)
		{
			for (i in 0...FlxG.gamepads.numActiveGamepads)
			{
				gamepad = FlxG.gamepads.getByID(i);
				if (gamepad != null)
				{
					return gamepad;
				}
			}
		}
		return gamepad;
	}
}

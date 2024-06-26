package states;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.system.FlxSound;
import flixel.system.FlxAssets;

class ButtonUpTestState extends flixel.FlxState
{
	override public function create():Void
	{
		var oldButton = new FlxButtonExt("old");
		oldButton.screenCenter();
		oldButton.x -= oldButton.width;
		oldButton.y -= oldButton.height;
		add(oldButton);
		
		var newButton = new FlxButtonExt("new");
		newButton.upHandlerState = HIGHLIGHT;
		newButton.screenCenter();
		newButton.x += newButton.width;
		newButton.y -= newButton.height;
		add(newButton);
		
		var oldSwipeButton = new FlxButtonExt("old no swipe");
		oldSwipeButton.allowSwiping = false;
		oldSwipeButton.screenCenter();
		oldSwipeButton.x -= oldSwipeButton.width;
		oldSwipeButton.y += oldSwipeButton.height;
		add(oldSwipeButton);
		
		var newSwipeButton = new FlxButtonExt("new no swipe");
		newSwipeButton.allowSwiping = false;
		newSwipeButton.upHandlerState = HIGHLIGHT;
		newSwipeButton.screenCenter();
		newSwipeButton.x += newSwipeButton.width;
		newSwipeButton.y += newSwipeButton.height;
		add(newSwipeButton);
	}
}

class FlxButtonExt extends FlxButton
{
	public var upHandlerState = NORMAL;
	
	public function new (x = 0.0, y = 0.0, ?text)
	{
		super(x, y, text, ()->trace(text));
		onOver.sound = FlxG.sound.load(FlxAssets.getSound("flixel/sounds/beep"));
		// onOut.sound = FlxG.sound.load(FlxAssets.getSound("flixel/sounds/beep"));
	}
	
	override function onUpHandler()
	{
		status = upHandlerState;
		input.release();
		currentInput = null;
		// Order matters here, because onUp.fire() could cause a state change and destroy this object.
		onUp.fire();
	}
}
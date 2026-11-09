package states;

import flixel.FlxG;
import flixel.text.FlxText;

class HeldKeysTestState extends flixel.FlxState
{
	override public function create()
	{
		super.create();
		
		add(new FlxText("Main state").screenCenter());
		new flixel.FlxObject().health;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		FlxG.inputs.resetOnStateSwitch = false;
		
		if (FlxG.keys.justPressed.SPACE)
			openSubState(new RedPlace());
	}
}


class RedPlace extends flixel.FlxSubState
{
	final text:FlxText;
	public function new():Void
	{
		super(0xFFff0000);
		
		add(text = new FlxText("Red substate"));
		text.screenCenter();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		text.text = 'Red Substate: ${FlxG.keys.justPressed.SPACE}';
		
		if (FlxG.keys.justPressed.SPACE)
			close();
	}
}
package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class OriginTestState2981 extends flixel.FlxState
{
	var _repairBot:FlxSpriteGroup;
	var _block:FlxSprite;

	override public function create()
	{
		super.create();
		FlxG.camera.bgColor = 0xff008080;

		// Repair Bot
		repairBot();
	}

	function repairBot():Void
	{
		_repairBot = new FlxSpriteGroup(FlxG.width / 2.0, FlxG.height / 2.0);
		_repairBot.screenCenter();
		add(_repairBot);

		var bot = new FlxSprite();
		bot.makeGraphic(100, 100);

		_block = new FlxSprite(90, 90);
		_block.drag.set(400, 400);
		_block.maxVelocity.set(100, 100);
		_block.makeGraphic(20, 20, FlxColor.RED);

		_repairBot.add(bot);
		_repairBot.add(_block);

		add(_repairBot);

		_repairBot.origin.set(50, 50);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Repair bot movement
		if (FlxG.keys.pressed.A)
		{
			_repairBot.angle -= 10;
		}
		else if (FlxG.keys.pressed.D)
		{
			_repairBot.angle += 10;
		}
		
		if (FlxG.keys.justReleased.H)
		{
			_repairBot.scale.set(3.0, 3.0);
		}
		else if (FlxG.keys.justReleased.J)
		{
			_repairBot.scale.set(0.5, 0.5);
		}
		
		if (FlxG.keys.pressed.UP) _block.velocity.y = -100;
		else if (FlxG.keys.pressed.DOWN) _block.velocity.y = 100;
		
		if (FlxG.keys.pressed.LEFT) _block.velocity.x = -100;
		else if (FlxG.keys.pressed.RIGHT) _block.velocity.x = 100;
	}
}
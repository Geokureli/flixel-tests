package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class NestingTestState extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		final player = new Player();
		player.screenCenter();
		add(player);
	}
}

class Player extends FlxSprite
{
	inline static var SPEED = 200;
	inline static var ACCEL_TIME = 0.25;
	inline static var ACCEL = SPEED / ACCEL_TIME;
	
	public var weapon:FlxSprite;
	
	public function new(x = 0.0, y = 0.0)
	{
		weapon = new FlxSprite();
		weapon.makeGraphic(80, 12, FlxColor.RED);
		super(x, y);
		
		drag.set(ACCEL, ACCEL);
		maxVelocity.set(SPEED, SPEED);
		makeGraphic(40, 40, FlxColor.BLUE);
		facing = RIGHT;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		acceleration.set(0, 0);
		
		if (FlxG.keys.pressed.LEFT) 
		{
			acceleration.x = -ACCEL;
			facing = LEFT;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			acceleration.x = ACCEL;
			facing = RIGHT;
		}
		
		if (FlxG.keys.pressed.UP) acceleration.y = -ACCEL;
		else if (FlxG.keys.pressed.DOWN) acceleration.y = ACCEL;
		
		// position weapon relative
		weapon.update(elapsed);
		weapon.x = facing == RIGHT ? x : x + width - weapon.width;
		weapon.y = y + 8;
	}
	
	override function draw()
	{
		super.draw();
		
		weapon.draw();
	}
}
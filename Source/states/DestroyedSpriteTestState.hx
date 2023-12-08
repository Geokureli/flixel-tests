package states;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;

class DestroyedSpriteTestState extends flixel.FlxState
{
	var sprite1 = new FlxSprite(100, 100, "assets/images/haxe.png");
	var sprite2:FlxSprite;
	
	override function create()
	{
		super.create();
		
		add(new FlxSprite(0, 100));
		add(sprite2 = new FlxSprite(100, 0, "assets/images/haxe.png"));
		add(sprite1);
	}
	
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SPACE)
			sprite2.destroy();
		
		if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(new DestroyedSpriteTestState());
	}
	
	override function draw()
	{
		super.draw();
	}
}
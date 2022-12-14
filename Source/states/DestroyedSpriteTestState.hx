package states;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;

class DestroyedSpriteTestState extends flixel.FlxState
{
	var sprite = new FlxSprite("Assets/images/haxe.png");
	
	override function create()
	{
		super.create();
		
		add(new FlxSprite());
		add(new FlxSprite("Assets/images/haxe.png"));
		add(sprite);
	}
	
	override function add(object:FlxBasic):FlxBasic
	{
		if (object is FlxSprite)
		{
			var sprite:FlxSprite = cast object;
			if (sprite.animation == null)
				FlxG.log.error("Attempting to add a destroyed FlxObject");
			if (sprite.graphic != null && sprite.graphic.key == null)
				FlxG.log.error("Attempting to add a FlxSprite with a destroyed graphic");
		}
		
		return super.add(object);
	}
}
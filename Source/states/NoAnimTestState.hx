package states;

import flixel.FlxSprite;

class NoAnimTestState extends flixel.FlxState
{
	override public function create():Void
	{
		var sprite = new FlxSprite().loadGraphic("assets/images/haxe-anim.png", true);
		sprite.animation.add("idle", [for (i in 0... sprite.animation.numFrames) i]);
		sprite.screenCenter();
		trace(sprite.animation.curAnim);
		add(sprite);
	}
}
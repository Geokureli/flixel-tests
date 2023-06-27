package states;

import flixel.FlxG;
import flixel.FlxSprite;

class AnimationFrameTestState2847 extends flixel.FlxState
{
	var poyo_talk:FlxSprite;

	override public function create():Void
	{
		super.create();
		
		final asset = tools.AnimationCreator.create(545, 309, 7);

		poyo_talk = new FlxSprite();
		poyo_talk.loadGraphic(asset, true, 545, 309);
		add(poyo_talk);
		poyo_talk.animation.frameIndex = 0;
	}

	override public function update(elapsed:Float)
	{
		final anim = poyo_talk.animation;
		if (FlxG.keys.justPressed.RIGHT)
		{
			if (anim.frameIndex == anim.numFrames - 1)
				anim.frameIndex = 0;
			else
				anim.frameIndex++;
		}
		
		if (FlxG.keys.justPressed.LEFT)
		{
			if (anim.frameIndex == 0)
				anim.frameIndex = anim.numFrames - 1;
			else
				anim.frameIndex--;
		}
	}
}
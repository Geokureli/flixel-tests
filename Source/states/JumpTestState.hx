package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class JumpTestState extends flixel.FlxState
{
	override function create():Void
	{
		var sprite = new JumpSprite(FlxG.width * .25, FlxG.height * 0.75);
		add(sprite);
		
		var jumpRight = true;
		final width = FlxG.width * 0.5;
		final height = FlxG.height * 0.5;
		function onJumpComplete()
		{
			sprite.jumpTo(sprite.x + (jumpRight ? width : -width), sprite.y, sprite.y - height, 2, ()->{
				new FlxTimer().start(0.5, (_)->onJumpComplete());
			});
			jumpRight = !jumpRight;
		}
		onJumpComplete();
	}
	
}

class JumpSprite extends flixel.FlxSprite
{
	public function new (x = 0.0, y = 0.0)
	{
		super(x, y);
		makeGraphic(100, 100, 0xFFffffff);
	}
	
	public function jumpTo(toX:Float, toY:Float, apex:Float, time:Float, ?onComplete:()->Void)
	{
		var func:(FlxTween)->Void = null;
		if (onComplete != null)
			func = (_)->onComplete();
		
		// FlxTween.tween(this, { y: apex }, time / 2, { ease: FlxEase.expoOut });
		// FlxTween.tween(this, { y: newY }, time / 2, { ease: FlxEase.expoIn, startDelay: time / 2 });
		// FlxTween.tween(this, { x: x }, time, { ease: FlxEase.linear, onComplete:func });
		
		final oldX = x;
		final oldY = y;
		FlxTween.num(0, 1, time, { ease: FlxEase.linear, onComplete:func },
			function update (num)
			{
				x = oldX + (toX - oldX) * FlxEase.linear(num);
				if (num < 0.5)
					y = oldY + (apex - oldY) * FlxEase.circOut(num * 2);
				else
					y = apex + (toY - apex) * FlxEase.circIn((num - 0.5) * 2);
			}
		);
	}
}
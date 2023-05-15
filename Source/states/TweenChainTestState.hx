package states;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;

class TweenChainTestState extends flixel.FlxState
{
    var tween:FlxTween;
    
    override function create()
    {
        super.create();
        
        final ball = new FlxSprite().makeGraphic(10, 10);
        add(ball);
        
        tween = FlxTween.tween(ball, { x:FlxG.width - ball.width, y:FlxG.height - ball.height }, 1.0)
            .then(FlxTween.tween(ball, { x:FlxG.width - ball.width, y:0 }, 1.0))
            .then(FlxTween.tween(ball, { x:0, y:FlxG.height - ball.height }, 1.0));
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (FlxG.keys.pressed.SPACE)
            tween.cancelChain();
    }
}

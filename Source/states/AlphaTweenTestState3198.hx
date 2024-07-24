package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class AlphaTweenTestState3198 extends flixel.FlxState
{
    var sprite:FlxSprite;
    
    override function create()
    {
        super.create();
        
        sprite = new FlxSprite();
        sprite.makeGraphic(100, 100);
        sprite.screenCenter();
        add(sprite);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final shift = FlxG.keys.justPressed.SHIFT;
        
        if (FlxG.keys.justPressed.RIGHT)
            onEvent(true, sprite, 0.0, false);
        else if (FlxG.keys.justPressed.LEFT)
            onEvent(false, sprite, 0.0, false);
    }
    
    function onEvent(show:Bool, sprite:FlxSprite, duration:Float, persist:Bool)
    {
        final options = { type: persist ? PERSIST : ONESHOT };
        if (show)
        {
            sprite.alpha = 0;
            FlxTween.tween(sprite, { alpha: 1 }, duration, options);
        }
        else
        {
            sprite.alpha = 1;
            FlxTween.tween(sprite, { alpha : 0 }, duration, options);
        }
    }
}

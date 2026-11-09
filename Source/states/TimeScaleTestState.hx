package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class TimeScaleTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final sprite = new FlxSprite().makeGraphic(100, 100);
        add(sprite);
        FlxTween.tween(sprite, { x: 100 }, 1, { type:PINGPONG });
        FlxG.timeScale = 2;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

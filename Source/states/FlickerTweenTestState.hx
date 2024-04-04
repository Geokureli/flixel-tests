package states;

import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;

class FlickerTweenTestState extends flixel.FlxState
{
    var sprite1:FlxSprite;
    var sprite2:FlxSprite;
    
    override function create()
    {
        super.create();
        
        sprite1 = new FlxSprite();
        sprite1.makeGraphic(100, 100, 0xFFff0000);
        sprite1.screenCenter();
        sprite1.x -= 100;
        add(sprite1);
        
        
        sprite2 = new FlxSprite();
        sprite2.makeGraphic(100, 100, 0xFF0000ff);
        sprite2.screenCenter();
        sprite2.x += 100;
        add(sprite2);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.mouse.justPressed)
        {
            // FlxG.vcr.pause();
            if (FlxTween.isFlickering(sprite1))
                FlxTween.stopFlickering(sprite1);
            else
            {
                final flicker = FlxTween.flicker(sprite1, 1.0, 0.08, {startDelay: 0.5});
                FlxG.watch.addFunction("t", ()->flicker.time);
            }
            
            if (FlxFlicker.isFlickering(sprite2))
                FlxFlicker.stopFlickering(sprite2);
            else
                FlxFlicker.flicker(sprite2, 1.0);
        }
    }
}

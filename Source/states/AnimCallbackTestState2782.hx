package states;

import flixel.FlxG;
import flixel.FlxSprite;

class AnimCallbackTestState2782 extends flixel.FlxState
{
    override function create()
    {
        var sprite:FlxSprite = new FlxSprite().makeGraphic(100, 100);
        sprite.animation.add("anim", [0, 0, 0, 0], 4, false);
        add(sprite);
        
        // insert animation code here
        sprite.animation.finishCallback = function(anim:String)
        {
            sprite.destroy();
        }
        
        sprite.animation.play('anim');
    }
}
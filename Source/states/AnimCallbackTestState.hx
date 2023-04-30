package states;

import flixel.FlxG;
import flixel.FlxSprite;

class AnimCallbackTestState extends flixel.FlxState
{
    override function create()
    {
        var sprite:FlxSprite = new FlxSprite().loadGraphic("assets/images/haxe-anim.png", true, 100, 100);
        sprite.animation.add("anim", [0,1,2,3,4,5,6,7,6,5,4,3,2,1,0], false);
        add(sprite);
        
        // insert animation code here
        sprite.animation.finishCallback = function(anim:String)
        {
            trace(anim);
            
            sprite.kill();
            remove(sprite, true);
            
            sprite.destroy();
            sprite = null;
        }
        
        sprite.animation.play('anim');
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

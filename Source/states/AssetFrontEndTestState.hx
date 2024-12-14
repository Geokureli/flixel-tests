package states;

import flixel.FlxSprite;
import flixel.FlxG;

class AssetFrontEndTestState extends flixel.FlxState
{
    
    override function create()
    {
        super.create();
        
        final sprite = new FlxSprite(100, 100);
        sprite.loadGraphic("assets/images/haxe-anim.png", true);
        sprite.animation.add("loop", [for (i in 0...sprite.animation.numFrames) i], 8);
        sprite.animation.play("loop");
        add(sprite);
        
        trace(FlxG.assets.list().join("\n"));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
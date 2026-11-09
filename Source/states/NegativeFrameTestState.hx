package states;

import flixel.FlxG;
import flixel.FlxSprite;
import openfl.display.BitmapData;

class NegativeFrameTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final sprite = new FlxSprite();
        add(sprite);
        var bitmapData = new BitmapData(4, 1);
        sprite.loadGraphic(bitmapData, true, 1, 1);
        
        sprite.animation.add("test", [0, 1, 2, 3]);
        sprite.animation.play("test");
        
        sprite.animation.frameIndex = -1;
        trace(sprite.animation.frameIndex);
        // Assert.areEqual(3, sprite.animation.frameIndex);
        
        sprite.animation.frameIndex = -4;
        trace(sprite.animation.frameIndex);
        // Assert.areEqual(0, sprite.animation.frameIndex);
        
        sprite.animation.frameIndex = 4;
        trace(sprite.animation.frameIndex);
        // Assert.areEqual(0, sprite.animation.frameIndex);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

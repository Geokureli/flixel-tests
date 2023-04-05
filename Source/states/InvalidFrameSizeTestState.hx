package states;

import flixel.FlxSprite;
import openfl.display.BitmapData;

class InvalidFrameSizeTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final size = 100;
        
        // works fine
        testLoadGraphic(size * 12, size, size, size);
        
        
        /* Warnings:
        * frameHeight:100 is larger than the graphic's height:99
        * Could not create animation: a, this sprite has no frames
        * Could not create animation: b, this sprite has no frames
        * Could not create animation: c, this sprite has no frames
        * No animation called "a"
        * No animation called "b"
        * No animation called "c"
        */
        testLoadGraphic(size * 12, size - 1, size, size);
        
        /* Warnings:
        * Could not add frames above 5 to animation: b
        * Could not create animation: c, no valid frames were given
        * No animation called "c"
        */
        testLoadGraphic(size * 6, size, size, size);
        
    }
    
    function testLoadGraphic(bitmapWidth:Int, bitmapHeight:Int, frameWidth:Int, frameHeight:Int)
    {
        final bmd = new BitmapData(bitmapWidth, bitmapHeight, false);
        final sprite = new FlxSprite();
        sprite.loadGraphic(bmd, true, frameWidth, frameHeight);
        sprite.animation.add("a", [ 0,  1,  2,  3]);
        sprite.animation.add("b", [ 4,  5,  6,  7]);
        sprite.animation.add("c", [ 8,  9, 10, 11]);
        
        sprite.animation.play("a");
        sprite.animation.play("b");
        sprite.animation.play("c");
    }
}
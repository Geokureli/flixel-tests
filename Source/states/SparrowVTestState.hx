package states;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;

class SparrowVTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var v1 = new FlxSprite();
        var v2 = new FlxSprite();
        
        try
        {
            v1.frames = FlxAtlasFrames.fromSparrow("assets/images/man-hi/v1.png", "assets/images/man-hi/v1.xml");
        }
        catch (e)
        {
            trace(e.message);
        }
        
        try
        {
            v2.frames = FlxAtlasFrames.fromSparrow("assets/images/man-hi/v2.png", "assets/images/man-hi/v2.xml");
        }
        catch (e)
        {
            trace(e.message);
        }
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
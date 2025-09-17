package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.filters.BitmapFilter;

class CamMemLeakTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        // add(new FlxSprite().makeGraphic(1, 1, 0x0));
        // ^ remove this line and the game will leak memory like crazy
        
        var cam:FlxCamera = new FlxCamera();
        cam.bgColor = 0x0;
        FlxG.cameras.add(cam, true);
        cam.filters = [new BitmapFilter()];
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

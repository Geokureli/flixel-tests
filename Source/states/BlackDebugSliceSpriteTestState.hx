package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxStrip;
import flixel.graphics.tile.FlxDrawTrianglesItem;

class BlackDebugSliceSpriteTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        FlxG.camera.bgColor = 0xFF808080;
        
        final scale = 1;
        final strip = new FlxStrip(20, 20, "assets/images/haxe.png");
        strip.vertices = DrawData.ofArray([0.0, 0, 160, 0.0, 160, 80, 0, 80]);
        strip.uvtData = DrawData.ofArray([0.0, 0, 2 / scale, 0, 2 / scale, 1 / scale, 0, 1 / scale]);
        strip.indices = DrawData.ofArray([0, 1, 2, 0, 2, 3]);
        strip.repeat = true;
        strip.drawDebugCollider = false;
        strip.drawDebugWireframe = true;
        add(strip);
        
        FlxG.debugger.drawDebug = true;
    }
}
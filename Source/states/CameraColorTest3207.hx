package states;

import openfl.display.Shape;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class CameraColorTest3207 extends flixel.FlxState
{
    var shape:Shape;
    
    override function create()
    {
        super.create();
        
        // add(new FlxSprite(50, 50).makeGraphic(100, 100, FlxColor.WHITE));
        // FlxG.camera.color = FlxColor.RED;
        
        shape = new Shape();
        final color = shape.transform.colorTransform;
        color.blueMultiplier = 0.0;
        color.redMultiplier = 0.0;
        color.greenMultiplier = 1.0;
        shape.transform.colorTransform = color;
        FlxG.game.parent.addChild(shape);
        
        @:privateAccess
        FlxG.watch.addFunction("_flashBitmap", ()->FlxG.camera._flashBitmap == null ? "null" : "exists");
        @:privateAccess
        FlxG.watch.addFunction("contains", ()->FlxG.camera._scrollRect.contains(FlxG.camera._flashBitmap));
        FlxG.watch.addFunction("blit", ()->FlxG.renderBlit);
        FlxG.watch.addFunction("tile", ()->FlxG.renderTile);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final stage = FlxG.stage;
        
        shape.graphics.clear();
        shape.graphics.beginFill(0xffffff, 1);
        shape.graphics.drawRect(stage.mouseX, stage.mouseY, 100, 100);
        shape.graphics.endFill();
    }
}
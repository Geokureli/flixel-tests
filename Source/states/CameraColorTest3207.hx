package states;

import openfl.display.Shape;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class CameraColorTest3207 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        add(new FlxSprite(50, 50).makeGraphic(100, 100, FlxColor.WHITE));
        FlxG.camera.color = FlxColor.RED;
        
        final shape = new Shape();
        shape.x = 150;
        shape.y = 150;
        shape.graphics.beginFill(0xffffff, 1);
        shape.graphics.drawRect(0, 0, 100, 100);
        shape.graphics.endFill();
        final color = shape.transform.colorTransform;
        color.blueMultiplier = 0.0;
        color.redMultiplier = 0.0;
        color.greenMultiplier = 1.0;
        shape.transform.colorTransform = color;
        FlxG.game.parent.addChild(shape);
    }
}
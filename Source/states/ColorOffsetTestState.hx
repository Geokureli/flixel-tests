package states;

import flixel.FlxG;
import flixel.FlxSprite;
import lime.math.Rectangle;

class ColorOffsetTestState extends flixel.FlxState
{
    var sprite:FlxSprite;
    
    override function create()
    {
        add(sprite = new FlxSprite(10, 10).makeGraphic(100, 100, 0x0));
        sprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(25, 25, 50, 50), 0xFFffffff);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.SPACE)
        {
            // sprite.alpha = 0;
            // sprite.setColorTransform(0.0, 1, 1, 0.0, 0.5, 0, 0, 0.5);
            // sprite.setColorTransform(1, 1, 1, 0, 0, 0, 0, 0.5);
            sprite.setColorTransform(1, 1, 1, 1, 0, 0, 0, 1.0);
        }
        else if (FlxG.keys.justReleased.SPACE)
        {
            sprite.alpha = 1;
            sprite.setColorTransform();
        }
    }
}

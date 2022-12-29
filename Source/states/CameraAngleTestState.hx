package states;

import flixel.FlxG;
import flixel.FlxSprite;

class CameraAngleTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        FlxG.cameras.bgColor = 0xFF404040;
        
        final top = -FlxG.height * 0.5;
        final left = -FlxG.width * 0.5;
        var y = top;
        while (y < FlxG.height * 1.5)
        {
            var x = left;
            while (x < FlxG.width * 1.5)
            {
                final sprite = new FlxSprite(x, y);
                sprite.loadGraphic("assets/images/haxe-anim.png", true, 100, 100);
                add(sprite);
                x += 150;
            }
            y += 150;
        }
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.pressed.D)
            FlxG.camera.angle += 1;
        
        if (FlxG.keys.pressed.A)
            FlxG.camera.angle -= 1;
    }
}

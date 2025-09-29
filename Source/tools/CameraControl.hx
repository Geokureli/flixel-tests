package tools;

import flixel.FlxCamera;
import flixel.FlxG;

class CameraControl extends flixel.FlxBasic
{
    final target:FlxCamera;
    public var scrollKeys:KeyControls = IJKL;
    
    public function new (camera)
    {
        this.target = camera;
        super();
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final pressed = FlxG.keys.pressed;
        final justPressed = FlxG.keys.justPressed;
        
        if (pressed.Q && target.zoom > 0.1) target.zoom -= 0.01;
        if (pressed.E && target.zoom < 2.0) target.zoom += 0.01;
        
        final num =
            if (justPressed.ONE) 1;
            else if (justPressed.TWO) 2;
            else if (justPressed.THREE) 3;
            else if (justPressed.FOUR) 4;
            else Math.NaN;
        
        if (false == Math.isNaN(num))
            target.zoom = pressed.SHIFT ? 1 / num : num;
        
        final scrollX = scrollKeys.x();
        final scrollY = scrollKeys.y();
        if (scrollX != 0) target.scroll.x += scrollX;
        if (scrollY != 0) target.scroll.y += scrollY;
    }
}
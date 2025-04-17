package tools;

import flixel.FlxG;
import flixel.util.FlxAxes;

class SpriteMover extends flixel.FlxBasic
{
    final target:flixel.FlxSprite;
    
    public function new (target)
    {
        this.target = target;
        super();
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final W = FlxG.keys.pressed.W;
        final A = FlxG.keys.pressed.A;
        final S = FlxG.keys.pressed.S;
        final D = FlxG.keys.pressed.D;
        
        final UP = FlxG.keys.pressed.UP;
        final DN = FlxG.keys.pressed.DOWN;
        final LF = FlxG.keys.pressed.LEFT;
        final RT = FlxG.keys.pressed.RIGHT;
        
        final L = FlxG.keys.justPressed.L;
        final J = FlxG.keys.justPressed.J;
        final K = FlxG.keys.justPressed.K;
        final I = FlxG.keys.justPressed.I;
        
        if (FlxG.keys.pressed.SHIFT)
        {
            if (A) target.origin.x += 1;
            if (D) target.origin.x -= 1;
            if (S) target.origin.y += 1;
            if (W) target.origin.y -= 1;
            
            if (RT) target.offset.x += 1;
            if (LF) target.offset.x -= 1;
            if (DN) target.offset.y += 1;
            if (UP) target.offset.y -= 1;
        }
        else if (FlxG.keys.pressed.ALT)
        {
            if (A) camera.scroll.x += 1;
            if (D) camera.scroll.x -= 1;
            if (S) camera.scroll.y += 1;
            if (W) camera.scroll.y -= 1;
        }
        else
        {
            if (L) target.flipX = true;
            if (J) target.flipX = false;
            if (K) target.flipY = true;
            if (I) target.flipY = false;
            
            if (D) target.scale.x += 0.01;
            if (A) target.scale.x -= 0.01;
            if (S) target.scale.y += 0.01;
            if (W) target.scale.y -= 0.01;
            
            if (RT) target.x += 1;
            if (LF) target.x -= 1;
            if (DN) target.y += 1;
            if (UP) target.y -= 1;
        }
        
        if (FlxG.keys.pressed.Q && camera.zoom > 0.1) camera.zoom -= 0.01;
        if (FlxG.keys.pressed.E && camera.zoom < 2.0) camera.zoom += 0.01;
        
        if (FlxG.keys.pressed.PERIOD) target.angle++;
        if (FlxG.keys.pressed.COMMA ) target.angle--;
    }
    
    function fromBools(x:Bool, y:Bool):FlxAxes
    {
        return cast (x ? (cast X:Int) : 0) | (y ? (cast Y:Int) : 0);
    }
}
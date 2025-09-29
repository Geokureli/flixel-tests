package tools;

import flixel.FlxG;
import flixel.util.FlxAxes;

class SpriteMover extends flixel.FlxBasic
{
    public final target:flixel.FlxSprite;
    public var move:KeyControls = ARROWS;
    public var moveOffset:KeyControls = ARROWS;
    public var flip:KeyControls = IJKL;
    public var moveScroll:KeyControls = WASD;
    public var moveOrigin:KeyControls = WASD;
    public var scale:KeyControls = WASD;
    
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
            target.origin.x += moveOrigin.x();
            target.origin.y += moveOrigin.y();
            
            target.offset.x += moveOffset.x();
            target.offset.y += moveOffset.y();
        }
        else
        {
            if (flip.leftJust()) target.flipX = true;
            if (flip.rightJust()) target.flipX = false;
            if (flip.downJust()) target.flipY = true;
            if (flip.upJust()) target.flipY = false;
            
            target.scale.x += scale.x() * 0.01;
            target.scale.y += scale.y() * 0.01;
            
            target.x += move.x();
            target.y += move.y();
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
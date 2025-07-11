package tools;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.mouse.FlxMouseEvent;
import flixel.math.FlxPoint;

class SpriteDragger extends flixel.FlxBasic
{
    public var state(default, null):State;
    
    final target:FlxObject;
    
    public function new (target:FlxObject)
    {
        this.target = target;
        state = IDLE;
        super();
        
        FlxMouseEvent.add(target, onMouseDown, onMouseUp);
    }
    
    override function destroy()
    {
        super.destroy();
        FlxMouseEvent.remove(target);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        switch state
        {
            case IDLE:
            case DRAG(offsetX, offsetY):
                target.x = FlxG.mouse.x - offsetX;
                target.y = FlxG.mouse.y - offsetY;
        }
    }
    
    function onMouseDown(_)
    {
        if (target.overlapsPoint(FlxG.mouse.getWorldPosition(FlxPoint.weak())))
            state = DRAG(FlxG.mouse.x - target.x, FlxG.mouse.y - target.y);
    }
    
    function onMouseUp(_)
    {
        state = IDLE;
    }
}

enum State
{
    IDLE;
    DRAG(offsetX:Float, offsetY:Float);
}
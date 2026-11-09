package states;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class CallbackPointTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        trace("creating point");
        final p:FlxPoint = new FlxCallbackPoint(p->trace('set x: ${p.x}'), p->trace('set y: ${p.y}'), p->trace('set { x: ${p.x} | y: ${p.y} }'));
        trace("set(10,5)");
        p.set(10, 5);
        trace("add(1, 2)");
        p.add(1, 2);
        trace("subtract(2, 1)");
        p.subtract(2, 1);
        trace("scale(2, 2)");
        p.subtract(2, 2);
        trace("rotateByDegrees(90)");
        p.rotateByDegrees(90);
        
        trace("bounceWithFriction(p(sqrt2), 0.5, 0.25)");
        final sqrt2 = Math.sqrt(2);
        p.bounceWithFriction(new FlxPoint(sqrt2, sqrt2), 0.5, 0.25);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

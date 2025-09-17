package states;

import flixel.FlxG;
import flixel.math.FlxPoint.FlxCallbackPoint;

class CallbackPointTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final point = new FlxCallbackPoint((_)->trace("set x"), (_)->trace("set y"), (_)->trace("set xy"));
        
        point.set(5, 10);
    }
}

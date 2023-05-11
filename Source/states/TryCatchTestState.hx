package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import haxe.Exception;

class TryCatchTestState extends flixel.FlxState
{
    override function create()
    {
        untyped __global__.__hxcpp_set_critical_error_handler( function(err) { trace(err); } );
        
        var point:FlxPoint = null;
        try
        {
            point.set();
        }
        catch(e:Exception) {}
        
        add(new FlxText("it worked"));
    }
}

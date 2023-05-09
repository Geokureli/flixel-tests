package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import haxe.Exception;

class TryCatchTestState extends flixel.FlxState
{
    override function create()
    {
        var point:FlxPoint = null;
        try
        {
            point.set();
        }
        catch(e:Exception) {}
        
        add(new FlxText("it worked"));
    }
}

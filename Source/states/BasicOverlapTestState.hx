package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;

class BasicOverlapTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final a = new FlxBasic();
        final b = new FlxObject(0, 0, 50, 50);
        final group = new FlxGroup();
        group.add(new FlxObject(0, 0, 50, 50));
        
        trace(FlxG.overlap(a, b)); // false
        trace(FlxG.overlap(a, group)); // false
        trace(FlxG.overlap(b, group)); // true
        
        group.add(new FlxBasic());
        trace(FlxG.overlap(a, group)); // false
        trace(FlxG.overlap(b, group)); // true
    }
}

package states;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;

class GroupTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final group = makeGroup();
        final subGroup = makeGroup();
        group.add(subGroup);
        
        final oldLength = group.length;
        group.recycle(FlxBasic);
        trace(oldLength + 1 == group.length);
    }
    
    function makeGroup():FlxGroup
    {
        var group = new FlxGroup();
        for (i in 0...10)
        {
            group.add(new FlxBasic());
        }
        return group;
    }
}

package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;

class OverlapTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final player = addObj();
        add(new FlxBasic());
        for (i in 0...10)
        {
            final obj = addObj();
            if (i == 3)
                remove(obj);
        }
        
        FlxG.overlap(player, this, (p, o:FlxBasic)->trace('player is touching $o'));
    }
    
    function addObj(x = 50, y = 50, w = 50, h = 50)
    {
        return add(new FlxObject(x, y, w, h));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

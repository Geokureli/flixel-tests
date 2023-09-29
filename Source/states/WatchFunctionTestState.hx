package states;

import flixel.FlxG;

class WatchFunctionTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        FlxG.watch.addFunction("foo", ()->1);
        FlxG.watch.addFunction("foo", ()->2);
        FlxG.watch.addFunction("foo", ()->3);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

package states;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class NoneKeyTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        FlxG.watch.addFunction("first", ()->FlxKey.toStringMap.get(FlxG.keys.firstJustPressed()));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
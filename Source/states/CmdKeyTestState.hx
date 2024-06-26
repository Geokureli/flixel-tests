package states;

import openfl.events.KeyboardEvent;
import flixel.FlxG;

class CmdKeyTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        // FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, (e)->
        // {
        //     trace(e.keyCode);
        // });
        
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.WINDOWS)
        {
            FlxG.log.add("PRESSED");
        }
    }
}

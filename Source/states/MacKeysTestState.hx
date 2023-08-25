package states;

import openfl.events.KeyboardEvent;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class MacKeysTestState extends flixel.FlxState
{
    var text:FlxText;
    var pressingC:Bool = false;
    var pressingCmd:Bool = false;
    override function create()
    {
        super.create();
        
        text = new FlxText("nothing is happening.");
        text.screenCenter();
        add(text);
        
        FlxG.stage.addEventListener(KeyboardEvent.KEY_UP,
            function (e)
            {
                if (e.keyCode == FlxKey.C)
                    text.text = "C released";
            }
        );
        
        FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,
            function (e)
            {
                if (e.keyCode == FlxKey.C && e.ctrlKey)
                    text.text = "Cmd + C pressed";
            }
        );
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        // checkFlxKeys(elapsed);
    }
    
    function checkFlxKeys(elapsed:Float)
    {
        if (FlxG.keys.pressed.WINDOWS)
        {
            if (FlxG.keys.pressed.C)
                text.text = "Command and C keys are held.";
            else
                text.text = "Command is held.";
        }
        else
        {
            if (FlxG.keys.pressed.C)
                text.text = "C key is held.";
            else
                text.text = "nothing is happening.";
        }
        text.screenCenter();
    }
}

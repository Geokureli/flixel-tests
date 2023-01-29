package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;

class VscDebuggerTestState extends flixel.FlxState
{
    var nullMap:Map<State, FlxObject> = null;
    
    override function create()
    {
        super.create();
        
        final text = new FlxText("Press the mouse to throw an exception");
        text.screenCenter();
        add(text);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.mouse.justPressed)
            testThrow();
    }
    
    function testThrow()
    {
        try
        {
            getFromString("A");
        }
        catch(e)
        {
            FlxG.log.error("Exception: " + e);
        }
    }
    
    function getFromString(state:String)
    {
        return nullMap.get(state);
    }
}

enum abstract State(String) from String
{
    var A = "A";
    var B = "B";
    var C = "C";
}
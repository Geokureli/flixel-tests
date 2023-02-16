package states;

import flixel.FlxG;
import flixel.text.FlxText;

class FlxTextWidthTestState2729 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        FlxG.debugger.drawDebug = true;
        
        var label = new FlxText(100, 100, 150, "hello", 24);
        // label.width = 50; // causes error
        label.fieldWidth = 50; // avoids error
        label.alignment = RIGHT;
        add(label);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

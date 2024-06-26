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
        label.wordWrap = false;
        label.fieldWidth = 50;
        label.alignment = RIGHT;
        add(label);
        
        FlxG.random.shuffle([for (i in 0...8) i]);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

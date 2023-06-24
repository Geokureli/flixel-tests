package states;

import flixel.FlxG;
import flixel.text.FlxText;

class EmptyTextTestState extends flixel.FlxState
{
    var text:FlxText;
    
    override function create()
    {
        super.create();
        
        text = new FlxText(20, 20, 400, "Something");
        add(text);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.A)
            text.text = "Something";
        
        if (FlxG.keys.justPressed.S)
            text.text = "Something Else";
        
        if (FlxG.keys.justPressed.D)
            text.text = "";
    }
}
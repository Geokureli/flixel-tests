package states;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.addons.ui.FlxInputText;

class InputTextTestState extends flixel.FlxState
{
    var text1:FlxText;
    var text2:FlxText;
    var inputText:FlxInputText;
    
    override function create()
    {
        super.create();
        add(text1 = new FlxText(0, 0, FlxG.width, ""));
        add(text2 = new FlxText(0, text1.y + text1.height + 10, FlxG.width, "foo"));
        add(inputText = new FlxInputText(0, text2.y + text2.height + 10, FlxG.width));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.ONE)
            text1.text = text2.text = "foo";
        
        if (FlxG.keys.justPressed.TWO)
            text1.text = text2.text = "";
    }
}

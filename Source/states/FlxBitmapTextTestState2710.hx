package states;

import flixel.FlxG;
import flixel.text.FlxBitmapText;

import openfl.utils.Assets;

class FlxBitmapTextTestState2710 extends flixel.FlxState
{
    var text:FlxBitmapText;
    
    override function create()
    {
        super.create();
        
        add(text = new FlxBitmapText());
        text.scale.set(2, 2);
        // text.width = FlxG.width;
        text.fieldWidth = FlxG.width;
        text.autoSize = false;
        text.wrapByWord = true;
        text.multiLine = true;
        text.wordWrap = true;
        text.text = Assets.getText("assets/data/lorem_ipsum.txt");
        // text.y = FlxG.height;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        // text.y -= elapsed * 100;
    }
}

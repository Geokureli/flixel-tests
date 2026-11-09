package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxBitmapText;
import flixel.util.FlxColor;

class FlxBitmapTextTestState3600 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final bg = new FlxSprite().makeGraphic(100, 10, FlxColor.GREEN);
        bg.screenCenter(XY);
        final text = new FlxBitmapText(bg.x, bg.y + 2, "");
        final str = text.getRenderedText("line1\n\nline3\nline4\n\n\nline7");
        trace(str);
        text.text = str;
        
        text.fieldWidth = 100;
        text.alignment = RIGHT;
        add(bg);
        add(text);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

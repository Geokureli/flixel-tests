package states;

import flixel.FlxG;
import flixel.text.FlxBitmapText;

class FlxBitmapTextTestState3623 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final text = new FlxBitmapText(0, 0, null);
        trace(text.textHeight);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

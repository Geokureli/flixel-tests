package states;

import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;

class JustifyTextTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final field = new openfl.text.TextField();
        field.wordWrap = true;
        
        final format = field.defaultTextFormat;
        format.align = JUSTIFY;
        format.color = 0xFFffffff;
        format.font = "Arial";
        field.defaultTextFormat = format;
        
        final useNewLine = true;
        final separator = useNewLine ? "\n" : " ";
        
        field.text = "Just as you take my hand"
            + separator + "Just as you write my number down"
            + separator + "Just as the drinks arrive"
            + separator + "Just as they play your favorite song"
            + separator + "As your bad day disappears"
            + separator + "No longer wound up like a spring"
            + separator + "Before you had too much"
            + separator + "Come back in focus again";
        field.width = 200;
        field.height = 200;
        FlxG.game.parent.addChild(field);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

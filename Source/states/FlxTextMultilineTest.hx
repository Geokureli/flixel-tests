package states;

import flixel.text.FlxText;
import flixel.FlxG;

import openfl.text.TextField;

class FlxTextMultilineTest extends flixel.FlxState
{
    var flx:FlxText;
    var ofl:TextField;
    
    override function create()
    {
        super.create();
        
        add(flx = new FlxText());
        flx.fieldWidth = 100;
        flx.text = "The quick brown fox jumps over the lazy dog";
        flx.screenCenter();
        
        ofl = new TextField();
        ofl.width = 100;
        ofl.x = flx.x;
        ofl.y = 10;
        ofl.text = flx.text;
        ofl.textColor = 0xFFfffff;
        ofl.wordWrap = flx.wordWrap;
        ofl.type = INPUT;
        ofl.addEventListener(openfl.events.Event.CHANGE, (e)->trace(ofl.text));
        FlxG.game.parent.addChild(ofl);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.SPACE)
        {
            ofl.multiline = !ofl.multiline;
        }
        
        if (FlxG.keys.justPressed.ENTER)
        {
            @:privateAccess flx._regen = true;
        }
    }
}

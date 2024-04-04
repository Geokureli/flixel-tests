package states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.ui.FlxBaseBar;

class BarTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var bar = new FlxBaseBar(0, 0, 200, 50, LEFT_TO_RIGHT);
        add(bar);
        bar.screenCenter();
        
        
        bar.value = 0.0;
        FlxTween.tween(bar, { value:100 }, 1.0, { ease:FlxEase.circInOut, type: PINGPONG });
    }
}

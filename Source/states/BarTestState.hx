package states;

import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
// import flixel.ui.FlxBaseBar;
import flixel.ui.FlxBar;

class BarTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var bar = new FlxBar(0, 0, LEFT_TO_RIGHT, 48, 10);
        bar.createImageBar("assets/images/bar_empty.png", "assets/images/bar_filled.png", 0x0, 0x0);
        add(bar);
        bar.screenCenter();
        @:privateAccess
        FlxRect._pool
        
        bar.value = 0.0;
        FlxTween.tween(bar, { value:100 }, 1.0, { ease:FlxEase.circInOut, type: PINGPONG });
    }
}

package states;

import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;

class TransitionTestState extends FlxTransitionableState
{
    override function create()
    {
        transIn = new TransitionData(FADE, FlxColor.RED);
        transOut = new TransitionData(FADE, FlxColor.BLACK);
        
        super.create();
        
        final text = new FlxBitmapText("TransitionTestState");
        text.scale.scale(4);
        text.updateHitbox();
        // show in random position so it's clear that a state switch happened
        text.x = FlxG.random.float(0, FlxG.width - text.width);
        text.y = FlxG.random.float(0, FlxG.height - text.height);
        add(text);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justReleased.SPACE)
            FlxG.switchState(new TransitionTestState());
    }
}

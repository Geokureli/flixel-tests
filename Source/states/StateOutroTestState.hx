package states;

import flixel.text.FlxBitmapText;
import flixel.FlxState;
import flixel.FlxG;

class StateOutroTestState extends FlxState
{
    var switchingStates:Bool = false;
    
    override function create()
    {
        super.create();
        
        final text = new FlxBitmapText("StateOutroTestState");
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
        
        if (FlxG.keys.justReleased.SPACE && switchingStates == false)
        {
            // prevents switch state calls while already playing the outro
            switchingStates = true;
            FlxG.switchState(new StateOutroTestState());
        }
    }
    
    override function startOutro(onOutroComplete:()->Void)
    {
        camera.fade(onOutroComplete);
    }
    
    // override function startOutro(onOutroComplete:()->Void)
    // {
    //     camera.fade(onOutroComplete);
    // }
}

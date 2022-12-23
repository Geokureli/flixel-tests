package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.debug.log.LogStyle;

class ErrorSoundTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        LogStyle.ERROR.errorSound = "assets/sounds/pickup.mp3";
        LogStyle.WARNING.errorSound = null;//"assets/sounds/pickup.mp3";
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.mouse.pressed)
            FlxG.log.warn("click");
    }
}

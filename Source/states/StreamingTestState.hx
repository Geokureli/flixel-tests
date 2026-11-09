package states;

import flixel.FlxG;

class StreamingTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        // FlxG.assets.streamSound("assets/sounds/long-sound.ogg");
        // FlxG.sound.loadStreamed("assets/sounds/long-sound.ogg", 1.0, true, null, false, true);
        FlxG.sound.loadStreamed("assets/sounds/long-sound.wav", 1.0, true, null, false, true);
        // FlxG.sound.load("assets/sounds/long-sound.ogg", 1.0, true, null, false, true);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

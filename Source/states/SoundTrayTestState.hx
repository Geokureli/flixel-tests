package states;

import flixel.FlxG;

class SoundTrayTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        FlxG.watch.add(FlxG.stage, "frameRate", "frameRate");
        FlxG.watch.add(FlxG.game, "_elapsedMS", "_elapsedMS");
        FlxG.watch.addFunction("FlxG.elapsed", ()->FlxG.elapsed * 1000);
        // FlxG.drawFramerate = 10;
        // FlxG.updateFramerate = 10;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

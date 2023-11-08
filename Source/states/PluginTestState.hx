package states;

import flixel.tweens.FlxTween;
import flixel.FlxG;

class PluginTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final tweens1 = FlxG.plugins.add(new FlxTweenManager());
        if (FlxG.plugins.list.contains(tweens1) == false)
            FlxG.log.error("tweens1 not added to plugins");
        
        final tweens2 = FlxG.plugins.addPlugin(new FlxTweenManager());
        if (FlxG.plugins.list.contains(tweens2) == false)
            FlxG.log.error("tweens2 not added to plugins");
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

package states;

import flixel.FlxG;
import flixel.util.FlxSignal;

class LogErrorTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var foo:Dynamic = null;
        FlxG.log.error("helpful error: foo is null");
        
        trace(foo.bar);
        
        // function foo(){ FlxG.log.error("Called"); }
        // final signal = new FlxSignal();
        // signal.add(foo);
        // trace('has: ${signal.has(foo)}');
        // signal.remove(foo);
        // signal.dispatch();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

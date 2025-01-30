package states;

import flixel.util.FlxTimer;
import flixel.FlxG;
import event.MultiLock;

class MultiLockTestState extends flixel.FlxState
{
    override function create()
    {
        // trace message when both timers finish
        var locks = new MultiLock(() -> trace("Haxe is great!"));
        final initLock = locks.add("init");
        
        waitAndLog(Math.random() * 5, locks.add("wait1"));
        waitAndLog(Math.random() * 5, locks.add("wait2"));
        initLock();
    }
    
    function waitAndLog(time:Float, f:() -> Void)
    {
        FlxTimer.wait(time, function(_)
        {
            trace('waited $time seconds');
            f();
        });
    }
}
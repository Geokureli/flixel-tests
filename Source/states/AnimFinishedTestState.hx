package states;

import flixel.FlxSprite;
import flixel.FlxG;

class AnimFinishedTestState extends flixel.FlxState
{
    var anim:FlxSprite;
    var frameCalls = 0;
    
    override function create()
    {
        super.create();
        
        add(anim = new FlxSprite());
        anim.loadGraphic("assets/images/haxe-anim.png", true, 100, 100);
        anim.animation.add("idle-once", [0], 1, false);
        anim.animation.add("idle-loop", [0], 1, true);
        anim.animation.add("anim-once", [for (i in 0...anim.numFrames) i], 2, false);
        anim.animation.add("anim-loop", [for (i in 0...anim.numFrames) i], 2, true);
        anim.animation.add("fast-once", [0, 2], 2 * 20 * FlxG.updateFramerate, false);
        anim.animation.add("fast-loop", [0, 2], 2 * 20 * FlxG.updateFramerate, true);
        trace('num frames: ${anim.numFrames}');
        anim.screenCenter();
        
        anim.animation.onFinish.add(
            function (name)
            {
                trace('anim "$name" finished');
            }
        );
        anim.animation.onLoop.add(
            function (name)
            {
                frameCalls++;
                // trace('anim "$name" looped, frame:${anim.animation.curAnim.curFrame}');
            }
        );
        anim.animation.play("idle-once");
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (frameCalls > 0)
            trace('$frameCalls loops last frame');
        frameCalls = 0;
        
        final shift = FlxG.keys.pressed.SHIFT;
        final alt = FlxG.keys.pressed.ALT;
        
        if (FlxG.keys.justPressed.ONE)
            anim.animation.play("idle-" + (shift ? "once" : "loop"), false, alt);
        
        if (FlxG.keys.justPressed.TWO)
            anim.animation.play("anim-" + (shift ? "once" : "loop"), false, alt);
        
        if (FlxG.keys.justPressed.THREE)
            anim.animation.play("fast-" + (shift ? "once" : "loop"), false, alt);
    }
}

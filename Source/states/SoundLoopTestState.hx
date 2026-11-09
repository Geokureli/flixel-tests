package states;

import flixel.FlxG;
import flixel.sound.FlxSound;

class SoundLoopTestState extends flixel.FlxState
{
    var sound:FlxSound;
    override function create()
    {
        super.create();
        
        
        function onComplete()
        {
            trace('Completed, loops: ${sound.loopCount} < ${sound.loopUntil}');
        }
        
        sound = FlxG.sound.play("assets/sounds/long-sound.ogg", 0.5, true, null, true, ()->trace("dun"));
        // trace(FlxG.assets.getBytes("assets/sounds/long-sound.geo").toHex());
        // @:privateAccess
        // trace(sound._sound.bytesLoaded, sound._sound.bytesTotal);
        sound.ID = 69;
        sound.loopUntil = 1;
        // #if FLX_STREAM_SOUND
        // sound = FlxG.sound.createStreamed("assets/sounds/long-sound")
        // // sound = FlxG.sound.create("assets/sounds/long-sound")
        // #else
        // sound = FlxG.sound.create("assets/sounds/long-sound")
        // #end
        //     .setup(1.0, 2, onComplete)
        //     .play();
        
        FlxG.watch.addFunction("sounds", function ()
        {
            final group = FlxG.sound.defaultSoundGroup;
            return group.sounds.length;
        });
        
        FlxG.watch.addFunction("time", function ()
        {
            return '${sound.time} / ${sound.length}';
        });
        
        FlxG.watch.addFunction("loops", function ()
        {
            return '${sound.loopCount} / ${sound.loopUntil}';
        });
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        // if (FlxG.keys.justPressed.SPACE)
        //     sound.play(FlxG.keys.pressed.SHIFT);
        if (FlxG.keys.justPressed.SPACE)
        {
            // sound.play();
            sound = FlxG.sound.play("assets/sounds/long-sound");
            trace(sound.ID);
            // @:privateAccess
            // trace(sound._sound.bytesLoaded, sound._sound.bytesTotal);
            // sound = FlxG.sound.play("assets/sounds/long-sound", FlxG.keys.pressed.SHIFT);
            // trace(sound);
            // sound.setup().play();
        }
    }
}
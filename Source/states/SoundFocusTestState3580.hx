package states;

import flixel.FlxG;
import flixel.sound.FlxSound;

class SoundFocusTestState3580 extends flixel.FlxState
{
    override function create()
    {
        super.create();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.mouse.justPressed)
            playMusic("assets/sounds/long-sound.wav");
        
        if (FlxG.keys.justPressed.ENTER)
            FlxG.resetState();
    }
    
    public function playMusic(asset)
    {
        // FlxG.sound.music = new FlxSound().load(asset).play();
        FlxG.sound.playMusic(asset);
        final music = FlxG.sound.music;
        FlxG.watch.addFunction("music.time", ()->music.time);
        @:privateAccess
        // FlxG.watch.addFunction("music._resumeOnFocus", ()->music._resumeOnFocus);
        FlxG.watch.addQuick("music.focused", true);
        function updateFocus(isFocused:Bool)
        {
            // @:privateAccess
            // trace('focus: $isFocused, resume: ${music._resumeOnFocus}');
            FlxG.watch.addQuick("music.focused", isFocused); // Note: doesn't seem to matter when unfocused, use traces
        }
        FlxG.signals.focusLost.add(updateFocus.bind(false));
        FlxG.signals.focusGained.add(updateFocus.bind(true));
    }
} 
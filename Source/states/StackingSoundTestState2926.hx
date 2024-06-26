package states;

import flixel.FlxG;

#if !ALL_SOUNDS
#error "cannot run StackingSoundTestState2926 without defining ALL_SOUNDS";
#end

class StackingSoundTestState2926 extends flixel.FlxState
{
    override public function create()
    {
        super.create();
        
        var text = new flixel.text.FlxText(0, 0, 0, "There is no music playing right now. 
        1) If you hit the +/-/0 keys, it will start playing, and if you pause/unpause, all is good.
        2) If you refresh and just pause/unpause, the music will start paying but with at least 2 channels.
        3) If you hit Enter, a sound fx will play and this will unpause the music as well.", 8);
        text.screenCenter();
        add(text);
        
        // With a smaller size file, you might get 2 tracks stacking, but one of them eventually stops
        // FlxG.sound.playMusic("assets/music/testTrack.ogg", 0.5);
        
        // Things are worse with larger files
        FlxG.sound.playMusic("assets/music/20-MB-OGG.ogg", 0.5);
    }
    
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.play("assets/sounds/wajit.ogg", 0.5);
        }
    }
}

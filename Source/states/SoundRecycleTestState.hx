package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.ui.FlxButton;

class SoundRecycleTestState extends FlxState
{
    override public function create()
    {
        super.create();

        var confirmSound:FlxSound = FlxG.sound.load("assets/sounds/pickup.mp3");
        // confirmSound.autoDestroy = false;

        var confirmBtn:FlxButton = new FlxButton(10, 10, "Play Confirm Sound");
        confirmBtn.onDown.callback = () -> confirmSound.play(true);
        add(confirmBtn);

        var cancelBtn:FlxButton = new FlxButton(10, 30, "Play Cancel Sound");
        cancelBtn.onDown.callback = () -> FlxG.sound.play("assets/sounds/type.ogg");//.autoDestroy = false;
        add(cancelBtn);

        FlxG.watch.add(FlxG.sound.list.members, "length");
    }
}
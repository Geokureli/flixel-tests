package states;

import flixel.FlxG;
import flixel.ui.FlxButton;

class BluePlayTestState extends flixel.FlxState
{
    public static var currentLevel:String;
    public static var curLevelName:String;

    public function new(level:String)
    {
        super();
        currentLevel = level;
    }

    override public function create()
    {
        switch (currentLevel)
        {
            case "level_1":
            {
                curLevelName = "Level 1"; // this might be used for something else in the future.
            }
        }
        trace("level: " + curLevelName + ", level data: " + currentLevel);

        super.create();
    }
}

class BlueTestState extends flixel.FlxState
{
    var playButton:FlxButton;
    
    override public function create()
    {
        playButton = new FlxButton(0, 0, "Play", clickPlay);
        playButton.screenCenter();
        playButton.scale.set(1.5, 1.5);
        add(playButton);

        super.create();
    }
    
    function clickPlay()
    {
        FlxG.switchState(new BluePlayTestState("level_1"));
    }
}
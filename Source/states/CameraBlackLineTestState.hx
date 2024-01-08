package states;

import flixel.FlxG;
import flixel.FlxCamera;

class CameraBlackLineTestState extends flixel.FlxState
{
    override function create()
    {
        // setup the cameras
        final camGame = new FlxCamera();
        final camHUD = new FlxCamera();
        
        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD, false); // false so it's not a default camera
        
        camHUD.bgColor.alpha = 0;
    }
}
package states;

import flixel.FlxG;

class ResizeGameTestState2744 extends flixel.FlxState
{
    override function create()
    {
        final newWidth = FlxG.width + 1;
        FlxG.resizeGame(newWidth, FlxG.height);
        if (FlxG.width != newWidth)
            trace('incorrect width, expected "$newWidth" got: "${FlxG.width}"');
    }
}

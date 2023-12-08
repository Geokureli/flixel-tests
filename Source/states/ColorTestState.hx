package states;

import flixel.FlxG;
import flixel.util.FlxColor;

class ColorTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        trace(FlxColor.fromString("0xff3c1f83").toHexString());
        trace(FlxColor.fromInt(0xff3c1f83).toHexString());
        
        trace(FlxColor.fromString("0x003c1f83").toHexString());
    }
}

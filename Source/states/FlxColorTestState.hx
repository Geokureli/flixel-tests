package states;

import flixel.FlxG;
import flixel.util.FlxColor;

class FlxColorTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        trace(Std.parseInt("0xff112233"));
        trace(FlxColor.fromString("0xff112233"));
        trace(FlxColor.fromString("0xff112233").toHexString());
        
        var col:FlxColor = 0xFF40ff00;
        final r:Int = col.red;
        col.red = 0xFF - r;
        trace(col.toHexString());
        trace(StringTools.hex(0xFF-0x40));
    }
}

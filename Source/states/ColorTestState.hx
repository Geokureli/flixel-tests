package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class ColorTestState extends flixel.FlxState
{
    var sprite:FlxSprite;
    var time:Float = 0;
    
    override function create()
    {
        super.create();
        
        sprite = new FlxSprite().makeGraphic(100, 100);
        add(sprite);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        time += elapsed;
        if (time > 10)
            time = 10;
        
        sprite.color = tweenColor (time / 10, 0xFF8000, 0x80FFFF) | 0xFF000000;
    }
    
    static function tweenColor (percent:Float, fromColor:Int, toColor:Int):Int
    {
        final fromB = fromColor & 0xff;
        final toB = toColor & 0xff;
        final fromG = (fromColor >> 8) & 0xff;
        final toG = (toColor >> 8) & 0xff;
        final fromR = (fromColor >> 16) & 0xff;
        final toR = (toColor >> 16) & 0xff;

        final roundR = (toR > fromR ? Math.floor : Math.ceil);
        final roundG = (toG > fromG ? Math.floor : Math.ceil);
        final roundB = (toB > fromB ? Math.floor : Math.ceil);

        return 0xff000000
            | (roundR(fromR + (toR - fromR) * percent) << 16)
            | (roundG(fromG + (toG - fromG) * percent) << 8)
            | roundB(fromB + (toB - fromB) * percent);
    }
    
    // function lerp(from:Int, to:Int, percent:Float)
    // {
        
    // }
}

package states;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class NullSafetyTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var tilemap = new FlxTilemap();
        var sampleMapString:String = "";
        var sampleMapArray:Array<Int> = [];
		var map = new BitmapData(2, 2);
		map.setPixel32(0, 0, FlxColor.WHITE);
		map.setPixel32(1, 0, FlxColor.BLACK);
		map.setPixel32(0, 1, FlxColor.BLUE);
		map.setPixel32(1, 1, FlxColor.YELLOW);

		tilemap.loadMapFromGraphic(map, false, 1, [FlxColor.WHITE, FlxColor.BLACK, FlxColor.BLUE, FlxColor.YELLOW], new BitmapData(4, 1));
		trace(tilemap.getData());
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

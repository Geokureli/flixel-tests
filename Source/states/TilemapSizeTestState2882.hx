package states;

import flixel.math.FlxPoint;
import lime.math.Rectangle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class TilemapSizeTestState2882 extends FlxState
{
	var tiles = new openfl.display.BitmapData(64, 32, true, 0x0);

	var mapCam:FlxCamera;
	var map:FlxTilemap;

	override public function create()
	{
		mapCam = new FlxCamera(0, 0, 1280, 720);
		mapCam.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(mapCam, false);
		
		tiles.fillRect(new openfl.geom.Rectangle(32, 0, 32, 32), FlxColor.WHITE);
		
		map = new FlxTilemap();
		final mapData = [for (y in 0...3)[for (x in 0...10) (x+y+1) % 2 ]];
		map.loadMapFrom2DArray(mapData, tiles, 32, 32, OFF, -1, 0);
		add(map);
		map.cameras = [mapCam];
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.L)
		{
			final mapData = [for (y in 0...3)[for (x in 0...11) (x+y) % 2 ]];
			map.loadMapFrom2DArray(mapData, tiles, 32, 32, OFF, -1, 0);
		}
		
		if (FlxG.mouse.justPressed)
		{
			var index = map.getTileIndexByCoords(FlxG.mouse.getWorldPosition(FlxPoint.weak()));
			map.setTileByIndex(index, 1 - map.getTileByIndex(index));
		}
	}
}
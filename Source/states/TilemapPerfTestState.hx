package states;

import flixel.FlxG;
import flixel.tile.FlxTilemap;

class TilemapPerfTestState extends flixel.FlxState
{
	override public function create()
	{
		super.create();
		
		final mapGraphic = createBitmap();
		// final mapGraphic = "assets/images/chipsetcaveback_strip12.png";
		
		add(createTilemap(mapGraphic));
		add(createTilemap(mapGraphic));
		add(createTilemap(mapGraphic));
		add(createTilemap(mapGraphic));
		
		FlxG.debugger.visible = true;
	}
	
	function createBitmap()
	{
		final TILE_SIZE = 16;
		final bitmap = new openfl.display.BitmapData(TILE_SIZE * 2, TILE_SIZE, false, 0xFFffffff);
		final rect = new openfl.geom.Rectangle(TILE_SIZE, 0, TILE_SIZE, TILE_SIZE);
		bitmap.fillRect(rect, 0xFFff0000);
		return bitmap;
	}
	
	function createTilemap(width = 30, height = 20, graphic)
	{
		final tilemap = new FlxTilemap();
		final ranInt = FlxG.random.int.bind(0, 1);
		final arrayTile = [for (i in 0...(width * height)) ranInt()];
		tilemap.loadMapFromArray(arrayTile, width, height, graphic, 0, 0, null, 0, 0);
		return tilemap;
	}
}
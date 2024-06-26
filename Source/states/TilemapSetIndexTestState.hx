package states;

import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.path.FlxPathfinder;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxDirectionFlags;
import openfl.display.BitmapData;

class TilemapSetIndexTestState extends flixel.FlxState
{
	final size:FlxPoint = FlxPoint.get(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
	override function create()
	{
		super.create();
		
		final mapData = [
			0, 0, 0,
			0, 1, 0,
			0, 0, 0
		];
		final tilemap = new FlxTilemap();
		tilemap.loadMapFromArray(mapData, 3, 3, new BitmapData(8 * 16, 8));
		tilemap.setTileIndex(1, -2);
		
		// cover entire map
		final object = new FlxObject(4, 4, 16, 16);
		object.last.set(object.x, object.y);
		
		trace(tilemap.overlaps(object));
		trace(tilemap.ray(FlxPoint.weak(0, 0), new FlxPoint(tilemap.width, tilemap.height)));
		
		testPath();
	}
	
	function testPath()
	{
		final UNIT = 8;
		final bitmapData = new BitmapData(UNIT * 16, UNIT);
		
		final map = new FlxTilemap();
		map.loadMapFromCSV(TileData.CSV_6X5, bitmapData, UNIT, UNIT, AUTO);
		final start = map.getTilePos(0, 0, true);
		final end = map.getTilePos(4, 0, true);
		
		final bigMover = new BigMoverPathfinder(2, 2);
		bigMover.diagonalPolicy = NONE;
		trace(bigMover.findPathIndices(cast map, 0, 4));
		trace(map.findPath(start, end, NONE, NONE));
	}
}

class TileData
{
	public static inline var CSV_4X4
		= "0,1,0,0\n"
		+ "0,1,0,0\n"
		+ "0,0,1,0\n"
		+ "0,0,0,0\n"
		;

	public static inline var CSV_6X5  
		= "0,0,1,1,0,0\n"
		+ "0,0,1,1,0,0\n"
		+ "0,0,0,1,0,0\n"
		+ "0,0,0,0,0,0\n"
		+ "0,0,0,0,0,0\n"
		;
}

class BigMoverPathfinder extends FlxDiagonalPathfinder
{
	public var widthInTiles:Int;
	public var heightInTiles:Int;

	public function new(widthInTiles:Int, heightInTiles:Int, diagonalPolicy:FlxTilemapDiagonalPolicy = NONE)
	{
		this.widthInTiles = widthInTiles;
		this.heightInTiles = heightInTiles;
		super(diagonalPolicy);
	}

	override function getInBoundDirections(data:FlxPathfinderData, from:Int)
	{
		var x = data.getX(from);
		var y = data.getY(from);
		return FlxDirectionFlags.fromBools
		(
			x > 0,
			x < data.map.widthInTiles - widthInTiles,
			y > 0,
			y < data.map.heightInTiles - heightInTiles
		);
	}

	override function canGo(data:FlxPathfinderData, to:Int, dir:FlxDirectionFlags = ANY)
	{
		final cols = data.map.widthInTiles;

		for (x in 0...widthInTiles)
		{
			for (y in 0...heightInTiles)
			{
				if (!super.canGo(data, to + x + (y * cols), dir))
					return false;
			}
		}

		return true;
	}

	override function hasValidInitialData(data:FlxPathfinderData):Bool
	{
		final cols = data.map.widthInTiles;
		final maxX = data.map.widthInTiles - widthInTiles;
		final maxY = data.map.heightInTiles - heightInTiles;
		return data.hasValidStartEnd()
			&& data.getX(data.startIndex) <= maxX
			&& data.getY(data.startIndex) <= maxY
			&& data.getX(data.endIndex) <= maxX
			&& data.getY(data.endIndex) <= maxY
			&& canGo(data, data.startIndex)
			&& canGo(data, data.endIndex);
	}
}
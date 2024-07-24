package states;

import openfl.display.BitmapData;
import flixel.util.FlxDirectionFlags;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.path.FlxPathfinder;

class BigMoverPathfinderTestState extends flixel.FlxState
{
	static inline var UNIT = 8;
	
	static inline var CSV  
		= "0,0,1,1,0,0\n"
		+ "0,0,1,1,0,0\n"
		+ "0,0,0,1,0,0\n"
		+ "0,0,0,0,0,0\n"
		+ "0,0,0,0,0,0\n"
		;
	
	override function create()
	{
		super.create();
		
		final bitmapData = new BitmapData(UNIT * 16, UNIT);
		
		final map = new FlxTilemap();
		map.loadMapFromCSV(CSV, bitmapData, UNIT, UNIT, AUTO);
		
		final bigMover = new BigMoverPathfinder(2, 2);
		bigMover.diagonalPolicy = NONE;
		
		final indices = bigMover.findPathIndices(cast map, 0, 4);
	}
	override function update(elapsed)
	{
		super.update(elapsed);
	}
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
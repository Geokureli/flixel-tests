package flixel.tile;

import flixel.tile.FlxTilemap;

typedef FlxSlopedTilemap = FlxTypedSlopedTilemap<FlxTile>;

class FlxTypedSlopedTilemap<T:FlxTile> extends FlxTypedTilemap<T>
{
	public var snapping = 2;
	
	final solvers = new Map<Int, (FlxTile, FlxObject)->Void>();
	
	override function destroy()
	{
		super.destroy();
		
		solvers.clear();
	}
	
	/**
	 * Adds a slope separator to the tile's onCollide signal
	 * 
	 * @param   tileIndex  The id of the tile
	 * @param   slope      The type of slope
	 */
	public function setTileSlope(tileIndex:Int, slope:FlxTileSlope)
	{
		final tile = getTileData(tileIndex);
		if (tile == null)
		{
			FlxG.log.error('Cannot set slope on tile index $tileIndex, max tile index is ${_tileObjects.length - 1}');
			return;
		}
		
		// remove any existing slope solvers
		if (solvers.exists(tileIndex))
		{
			tile.onCollide.remove(solvers[tileIndex]);
		}
		
		// create slope resolver
		final solver = function (t, o) FlxSlopeUtils.solveCollisionSlope(t, o, slope);
		solvers[tileIndex] = solver;
		tile.onCollide.add(solver);
	}
	
	/**
	 * Adds a slope separator to each tile's `onCollide` signal
	 * 
	 * @param   tileIndices  List of ids of the tiles
	 * @param   slope        The type of slope
	 */
	public overload extern inline function setTilesSlope(tileIndices:Array<Int>, slope:FlxTileSlope)
	{
		for (tileIndex in tileIndices)
		{
			setTileSlope(tileIndex, slope);
		}
	}
	
	/**
	 * Adds a slope separator to each tile's `onCollide` signal
	 * 
	 * @param   tileIndex  List id of the first tile
	 * @param   range      The number of tiles to change, after the first
	 * @param   slope      The type of slope
	 */
	public overload extern inline function setTilesSlope(tileIndex:Int, range:Int, slope:FlxTileSlope)
	{
		for (i in 0...range)
		{
			setTileSlope(tileIndex + i, slope);
		}
	}
}

class FlxSlopeUtils
{
	
	static function getTilemap(tile:FlxTile)
	{
		return Std.downcast(tile.tilemap, FlxSlopedTilemap);
	}
	
	static function checkThinSteep(slope:FlxTileSlope)
	{
		return slope.match
				( NW(STEEP(false))
				| NE(STEEP(false))
				| SW(STEEP(false))
				| SE(STEEP(false))
				);
	}
	
	static function checkThickSteep(slope:FlxTileSlope)
	{
		return slope.match
				( NW(STEEP(true))
				| NE(STEEP(true))
				| SW(STEEP(true))
				| SE(STEEP(true))
				);
	}
	
	static function checkThinGentle(slope:FlxTileSlope)
	{
		return slope.match
				( NW(GENTLE(false))
				| NE(GENTLE(false))
				| SW(GENTLE(false))
				| SE(GENTLE(false))
				);
	}
	
	static function checkThickGentle(slope:FlxTileSlope)
	{
		return slope.match
				( NW(GENTLE(true))
				| NE(GENTLE(true))
				| SW(GENTLE(true))
				| SE(GENTLE(true))
				);
	}
	
	/**
	 * Is called if an object collides with a ceiling slope
	 *
	 * @param   tile    The ceiling slope
	 * @param   object  The object that collides with that slope
	 * @param   slopeY  The point of contant for the object's current X
	 */
	function onCollideFloorSlope(tile:FlxTile, object:FlxObject, slopeY:Float):Void
	{
		// Set the object's touching flag
		object.touching = FLOOR;

		// Adjust the object's velocity
		// if (_downwardsGlue)
		// 	object.velocity.y = _velocityYDownSlope;
		// else
			object.velocity.y = Math.min(object.velocity.y, 0);

		// Reposition the object
		object.y = slopeY - object.height;

		if (object.y < tile.y - object.height)
		{
			object.y = tile.y - object.height;
		}
	}
	
	/**
	 * Is called if an object collides with a ceiling slope
	 *
	 * @param   tile    The ceiling slope
	 * @param   object  The object that collides with that slope
	 * @param   slopeY  The point of contant for the object's current X
	 */
	static function onCollideCeilSlope(tile:FlxTile, object:FlxObject, slopeY:Float):Void
	{
		// Set the object's touching flag
		object.touching = CEILING;
		
		// Adjust the object's velocity
		object.velocity.y = Math.max(object.velocity.y, 0);
		
		// Reposition the object
		object.y = slopeY;
		
		if (object.y > tile.y + tile.height)
		{
			object.y = tile.y + tile.height;
		}
	}
	
	public static function solveCollisionSlope(tile:FlxTile, object:FlxObject, slope:FlxTileSlope):Void
	{
		switch(slope)
		{
			case NW(_): solveCollisionSlopeNorthwest(tile, object, slope);
			case NE(_): solveCollisionSlopeNortheast(tile, object, slope);
			case SW(_): solveCollisionSlopeSouthwest(tile, object, slope);
			case SE(_): solveCollisionSlopeSoutheast(tile, object, slope);
		}
	}
	
	/**
	 * Solves collision against a left-sided floor slope
	 *
	 * @param   slope   The slope to check against
	 * @param   object  The object that collides with the slope
	 */
	public static function solveCollisionSlopeNorthwest(tile:FlxTile, object:FlxObject, slope:FlxTileSlope):Void
	{
		final tilemap = getTilemap(tile);
		final snapping = tilemap.snapping;
		final tileWidth = tilemap.tileWidth;
		final tileHeight = tilemap.tileHeight;
		
		if (object.x + object.width > tile.x + slope.width + snapping)
		{
			return;
		}
		
		// Calculate the corner point of the object
		final objX = Math.floor(object.x + object.width + snapping);
		final objY = Math.floor(object.y + object.height);

		// Calculate position of the point on the slope that the object might overlap
		// this would be one side of the object projected onto the slope's surface
		final slopePX = objX;
		final slopePY = (tile.y + tileHeight) - (slopePX - tile.x);

		final tileId:Int = tile.index;
		if (checkThinSteep(slope))
		{
			if (slopePX - tile.x <= tileWidth / 2)
			{
				return;
			}
			else
			{
				slopePY = tile.y + tileHeight * (2 - (2 * (slopePX - tile.x) / tileWidth)) + snapping;
				if (_downwardsGlue && object.velocity.x > 0)
					object.velocity.x *= 1 - (1 - _slopeSlowDownFactor) * 3;
			}
		}
		else if (checkThickSteep(tileId))
		{
			slopePY = tile.y + tileHeight * (1 - (2 * ((slopePX - tile.x) / tileWidth))) + snapping;
			if (_downwardsGlue && object.velocity.x > 0)
				object.velocity.x *= 1 - (1 - _slopeSlowDownFactor) * 3;
		}
		else if (checkThickGentle(tileId))
		{
			slopePY = tile.y + (tileHeight - slopePX + tile.x) / 2;
			if (_downwardsGlue && object.velocity.x > 0)
				object.velocity.x *= _slopeSlowDownFactor;
		}
		else if (checkThinGentle(tileId))
		{
			slopePY = tile.y + tileHeight - (slopePX - tile.x) / 2;
			if (_downwardsGlue && object.velocity.x > 0)
				object.velocity.x *= _slopeSlowDownFactor;
		}
		else
		{
			if (_downwardsGlue && object.velocity.x > 0)
				object.velocity.x *= _slopeSlowDownFactor;
		}
		// Fix the slope point to the slope tile
		fixSlopePoint(tile);

		// Check if the object is inside the slope
		if (objX > tile.x + snapping
			&& objX < tile.x + tileWidth + object.width + snapping
			&& objY >= slopePY
			&& objY <= tile.y + tileHeight)
		{
			// Call the collide function for the floor slope
			onCollideFloorSlope(tile, object, slopePY);
		}
	}

	/**
	 * Solves collision against a right-sided floor slope
	 *
	 * @param   tile    The tile to check against
	 * @param   object  The object that collides with the slope
	 */
	public static function solveCollisionSlopeNortheast(tile:FlxTile, object:FlxObject, slope:FlxTileSlope):Void
	{
		final tilemap = getTilemap(tile);
		final snapping = tilemap.snapping;
		final tileWidth = tilemap.tileWidth;
		final tileHeight = tilemap.tileHeight;
		
		if (object.x < tile.x - snapping)
			return;
		
		// Calculate the corner point of the object
		final objX = Math.floor(object.x - snapping);
		final objY = Math.floor(object.y + object.height);
		
		// Calculate position of the point on the slope that the object might overlap
		// this would be one side of the object projected onto the slope's surface
		final slopePX = objX;
		final slopePY = (tile.y + tileHeight) - (tile.x - slopePX + tileWidth);
		
		final tileId:Int = tile.index;
		if (checkThinSteep(tileId))
		{
			if (slopePX - tile.x >= tileWidth / 2)
			{
				return;
			}
			else
			{
				slopePY = tile.y + tileHeight * 2 * ((slopePX - tile.x) / tileWidth) + snapping;
			}
			if (_downwardsGlue && object.velocity.x < 0)
				object.velocity.x *= 1 - (1 - _slopeSlowDownFactor) * 3;
		}
		else if (checkThickSteep(tileId))
		{
			slopePY = tile.y - tileHeight * (1 + (2 * ((tile.x - slopePX) / tileWidth))) + snapping;
			if (_downwardsGlue && object.velocity.x < 0)
				object.velocity.x *= 1 - (1 - _slopeSlowDownFactor) * 3;
		}
		else if (checkThickGentle(tileId))
		{
			slopePY = tile.y + (tileHeight - tile.x + slopePX - tileWidth) / 2;
			if (_downwardsGlue && object.velocity.x < 0)
				object.velocity.x *= _slopeSlowDownFactor;
		}
		else if (checkThinGentle(tileId))
		{
			slopePY = tile.y + tileHeight - (tile.x - slopePX + tileWidth) / 2;
			if (_downwardsGlue && object.velocity.x < 0)
				object.velocity.x *= _slopeSlowDownFactor;
		}
		else
		{
			if (_downwardsGlue && object.velocity.x < 0)
				object.velocity.x *= _slopeSlowDownFactor;
		}
		// Fix the slope point to the slope tile
		fixSlopePoint(tile);

		// Check if the object is inside the slope
		if (objX > tile.x - object.width - snapping
			&& objX < tile.x + tileWidth + snapping
			&& objY >= slopePY
			&& objY <= tile.y + tileHeight)
		{
			// Call the collide function for the floor slope
			onCollideFloorSlope(tile, object, slopePY);
		}
	}
	
	/**
	 * Solves collision against a left-sided ceiling slope
	 *
	 * @param 	slope 	The slope to check against
	 * @param 	object 	The object that collides with the slope
	 */
	public static function solveCollisionSlopeSouthwest(tile:FlxTile, object:FlxObject, slope:FlxTileSlope):Void
	{
		final tilemap = getTilemap(tile);
		final snapping = tilemap.snapping;
		final tileWidth = tilemap.tileWidth;
		final tileHeight = tilemap.tileHeight;
		
		// Calculate the corner point of the object
		final objX = Math.floor(object.x + object.width + snapping);
		final objY = Math.ceil(object.y);
		
		// Calculate position of the point on the slope that the object might overlap
		// this would be one side of the object projected onto the slope's surface
		final slopePX = objX;
		final slopePY = tile.y + (slopePX - tile.x);
		
		final tileId:Int = slop.index;
		if (checkThinSteep(tileId))
		{
			if (slopePX - tile.x <= tileWidth / 2)
			{
				return;
			}
			else
			{
				slopePY = tile.y - tileHeight * (1 + (2 * ((tile.x - slopePX) / tileWidth))) - snapping;
			}
		}
		else if (checkThickSteep(tileId))
		{
			slopePY = tile.y + tileHeight * 2 * ((slopePX - tile.x) / tileWidth) - snapping;
		}
		else if (checkThickGentle(tileId))
		{
			slopePY = tile.y + tileHeight - (tile.x - slopePX + tileWidth) / 2;
		}
		else if (checkThinGentle(tileId))
		{
			slopePY = tile.y + (tileHeight - tile.x + slopePX - tileWidth) / 2;
		}
		
		// Fix the slope point to the slope tile
		fixSlopePoint(tile);
		
		// Check if the object is inside the slope
		if (objX > tile.x + snapping
			&& objX < tile.x + tileWidth + object.width + snapping
			&& objY <= slopePY
			&& objY >= tile.y)
		{
			// Call the collide function for the floor slope
			onCollideCeilSlope(tile, object, slopePY);
		}
	}
	
	/**
	 * Solves collision against a right-sided ceiling slope
	 *
	 * @param 	slope 	The slope to check against
	 * @param 	object 	The object that collides with the slope
	 */
	public static function solveCollisionSlopeSoutheast(tile:FlxTile, object:FlxObject, slope:FlxTileSlope):Void
	{
		final tilemap = getTilemap(tile);
		final snapping = tilemap.snapping;
		final tileWidth = tilemap.tileWidth;
		final tileHeight = tilemap.tileHeight;
		
		// Calculate the corner point of the object
		final objX = Math.floor(object.x - snapping);
		final objY = Math.ceil(object.y);

		// Calculate position of the point on the slope that the object might overlap
		// this would be one side of the object projected onto the slope's surface
		final slopePX = objX;
		final slopePY = (tile.y) + (tile.x - slopePX + tileWidth);

		final tileId:Int = tile.index;
		if (checkThinSteep(tileId))
		{
			if (slopePX - tile.x >= tileWidth / 2)
			{
				return;
			}
			else
			{
				slopePY = tile.y + tileHeight * (1 - (2 * ((slopePX - tile.x) / tileWidth))) - snapping;
			}
		}
		else if (checkThickSteep(tileId))
		{
			slopePY = tile.y + tileHeight * (2 - (2 * (slopePX - tile.x) / tileWidth)) - snapping;
		}
		else if (checkThickGentle(tileId))
		{
			slopePY = tile.y + tileHeight - (slopePX - tile.x) / 2;
		}
		else if (checkThinGentle(tileId))
		{
			slopePY = tile.y + (tileHeight - slopePX + tile.x) / 2;
		}

		// Fix the slope point to the slope tile
		fixSlopePoint(tile);

		// Check if the object is inside the slope
		if (objX > tile.x - object.width - snapping
			&& objX < tile.x + tileWidth + snapping
			&& objY <= slopePY
			&& objY >= tile.y)
		{
			// Call the collide function for the floor slope
			onCollideCeilSlope(tile, object, slopePY);
		}
	}
}

/**
 * How steep a slope is
 */
enum FlxSlopeSteepness
{
	/**
	 * Slope runs at a 45 degree angle
	 */
	NORMAL;
	
	/**
	 * Slope has a rise of 2 or -2 over 1
	 * @param thick represent the thicker tile in this two tile pair
	 */
	STEEP(thick:Bool);
	
	/**
	 * Slope has a rise of 1 or -1 over 2
	 * @param thick represent the thicker tile in this two tile pair
	 */
	GENTLE(thick:Bool);
}

/**
 * Slopes are denoted by the direction of their surface's normal
 */
enum FlxTileSlope
{
	/** This floor slope goes up and right */
	NW(steepness:FlxSlopeSteepness);
	
	/** This floor slope goes up and left */
	NE(steepness:FlxSlopeSteepness);
	
	/** This ceiling slope goes up and right */
	SW(steepness:FlxSlopeSteepness);
	
	/** This ceiling slope goes up and left */
	SE(steepness:FlxSlopeSteepness);
}
package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class RayTestState extends FlxState
{
	var map:FlxTilemap;
	var findMap:FlxTilemap;
	var eachMap:FlxTilemap;
	
	var start:FlxSprite;
	
	var end:FlxSprite;
	
	var hitPoint:FlxPoint;
	
	var backLine:FlxSprite;
	var line:FlxSprite;
	
	override function create()
	{
		// FlxG.mouse.useSystemCursor = true;
		
		final back = new FlxSprite();
		add(back);
		
		map = new FlxTilemap();
		map.loadMapFromCSV(csv, "assets/images/tiles.png");
		map.setTileProperties(2, LEFT | RIGHT);
		map.setTileProperties(3, UP | DOWN);
		map.setTileProperties(4, LEFT | DOWN);
		map.setTileProperties(5, RIGHT | UP);
		map.screenCenter();
		
		final c = map.widthInTiles;
		final r = map.heightInTiles;
		
		findMap = new FlxTilemap();
		findMap.loadMapFromArray([for (i in 0...map.totalTiles) 0], c, r, new GraphicAuto(), 0, 0, AUTO);
		findMap.scale.setXY(2);
		findMap.screenCenter();
		
		eachMap = new FlxTilemap();
		eachMap.loadMapFromArray([for (i in 0...map.totalTiles) 0], c, r, new GraphicAuto(), 0, 0, AUTO);
		eachMap.scale.setXY(2);
		eachMap.alpha = 0.5;
		eachMap.screenCenter();
		eachMap.color = 0xFF0000ff;
		
		
		add(findMap);
		add(map);
		add(eachMap);
		
		back.setPosition(map.x, map.y);
		back.makeGraphic(Math.round(map.width), Math.round(map.height));
		
		var instructions = new FlxText();
		instructions.text = "Click anywhere to place the target";
		instructions.color = FlxColor.BLACK;
		instructions.x = 4;
		instructions.y = FlxG.height - instructions.height - 4;
		add(instructions);
		
		add(start = new FlxSprite("assets/images/sprite.png"));
		start.offset.copyFrom(start.origin);
		start.screenCenter();
		start.visible = false;
		
		add(end = new FlxSprite("assets/images/sprite.png"));
		end.offset.copyFrom(end.origin);
		end.visible = false;
		
		add(backLine = new FlxSprite().makeGraphic(1, 1));
		backLine.scale.y = 2;
		backLine.origin.set(0, 0.5);
		backLine.color = 0xFF0000ff;
		
		add(line = new FlxSprite().makeGraphic(1, 1));
		line.scale.y = 2;
		line.origin.set(0, 0.5);
		
		hitPoint = FlxPoint.get();
		
		super.create();
	}
	
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		updateInput();
		
		final startP = start.getPosition();
		final endP = end.getPosition();
		FlxG.watch.addQuick("start", startP);
		FlxG.watch.addQuick("end", endP);
		
		final result = map.rayAdvanced(startP, endP, true);
		final resultP = endP.clone();
		final resultIndex = switch result
		{
			case END:
				-1;
			
			case STOPPED(mapIndex, x, y, entry):
				resultP.set(x, y);
				mapIndex;
		}
		FlxG.watch.addQuick("result", '$result');
		
		backLine.setPosition(start.x, start.y);
		if (endP.x == startP.x && endP.y == startP.y)
		{
			backLine.scale.x = 2;
			backLine.angle = 0;
		}
		else
		{
			final dis = endP.subtractNew(startP);
			backLine.scale.x = dis.length;
			backLine.angle = dis.degrees;
			
			dis.put();
		}
		
		backLine.origin.x = 0.5 / backLine.scale.x;
		
		line.setPosition(start.x, start.y);
		if (resultP.x == startP.x && resultP.y == startP.y)
		{
			line.scale.x = 2;
			line.angle = 0;
			line.color = 0xFFff0000;
		}
		else
		{
			final dis = resultP.subtractNew(startP);
			line.scale.x = dis.length;
			line.angle = dis.degrees;
			line.color = result.match(END) ? 0xFF00ff00 : 0xFFff0000;
			findMap.color = result.match(END) ? 0xFF00ff00 : 0xFFff0000;
			
			dis.put();
		}
		
		line.origin.x = 0.5 / line.scale.x;
		
		for (t in 0...map.totalTiles)
		{
			findMap.setTileIndex(t, 0, true);
			eachMap.setTileIndex(t, 0, true);
		}
		
		final steps = new Array<String>();
		findMap.findInRay(startP, endP, (i:Int, tile)->
		{
			if (i != resultIndex)
				findMap.setTileIndex(i, 1, true);
			
			if (tile != null)
				steps.push('${tile.x}|${tile.y}');
			
			return i == resultIndex;
		});
		FlxG.watch.addQuick("steps", steps);
		
		eachMap.forEachInRay(startP, endP, (i:Int, _)->eachMap.setTileIndex(i, 1, true));
		
		startP.put();
		endP.put();
		resultP.put();
		
		// final i = map.findIndexInRay(startP, endP, (i,t)->false);
	}
	
	function updateInput()
	{
		if (FlxG.mouse.pressed)
		{
			start.x = FlxG.mouse.x;
			start.y = FlxG.mouse.y;
		}
		else
		{
			end.x = FlxG.mouse.x;
			end.y = FlxG.mouse.y;
		}
	}
}

inline final csv
= " 0, 0, 0, 0, 0, 4, 4, 4, 0, 0, 0\n"
+ " 1, 1, 0, 0, 0, 0, 4, 0, 0, 0, 0\n"
+ " 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0\n"
+ " 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0\n"
+ " 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5\n"
+ " 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0\n"
+ " 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0\n"
+ " 2, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0\n"
+ " 0, 0, 0, 0, 0, 3, 3, 3, 0, 0, 0"
;
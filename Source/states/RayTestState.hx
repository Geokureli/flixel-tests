package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class RayTestState extends FlxState
{
	var map:FlxTilemap;
	
	var start:FlxSprite;
	
	var end:FlxSprite;
	
	var hitPoint:FlxPoint;
	
	var line:FlxSprite;
	
	override function create()
	{
		FlxG.mouse.useSystemCursor = true;
		
		final back = new FlxSprite();
		add(back);
		
		add(map = new FlxTilemap());
		map.loadMapFromCSV(csv, "assets/images/tiles.png");
		map.setTileProperties(2, LEFT | RIGHT);
		map.setTileProperties(3, UP | DOWN);
		map.setTileProperties(4, LEFT | DOWN);
		map.setTileProperties(5, RIGHT | UP);
		map.screenCenter();
		
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
		final dis = end.getPosition();
		final reachedTarget = map.ray(startP, endP, dis);
		if (dis.x == startP.x && dis.y == startP.y)
		{
			line.scale.x = 2;
			line.angle = 0;
		}
		else
		{
			dis.subtractPoint(startP);
			line.setPosition(start.x, start.y);
			line.scale.x = dis.length;
			line.angle = dis.degrees;
			line.color = reachedTarget ? 0xFF00ff00 : 0xFFff0000;
			
			startP.put();
			endP.put();
			dis.put();
		}
		line.origin.x = 0.5 / line.scale.x;
		
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
= "0,0,0,0,0,4,4,4,0,0,0\n"
+ "1,1,0,0,0,0,4,0,0,0,0\n"
+ "1,1,0,0,0,0,0,0,0,0,0\n"
+ "0,0,0,0,0,0,0,0,0,0,0\n"
+ "0,0,0,0,0,0,0,5,5,5,5\n"
+ "0,2,0,0,0,0,0,0,0,0,0\n"
+ "2,2,0,0,0,0,0,0,0,0,0\n"
+ "2,0,0,0,0,0,0,3,0,0,0\n"
+ "0,0,0,0,0,3,3,3,0,0,0"
;
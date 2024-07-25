package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.system.scaleModes.*;

class ResizeGameTestState extends flixel.FlxState
{
	static inline var SIZE = 64;
	
	override function create()
	{
		FlxG.scaleMode = new StageSizeScaleMode();
		createMess(2.0);
	}
	
	function createMess(density = 0.5)
	{
		final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
		var count = Std.int(area.width * area.height / (SIZE * SIZE) * density);
		while (count-- > 0)
		{
			final sprite = new FlxSprite();
			sprite.makeGraphic(SIZE, SIZE);
			sprite.x = FlxG.random.float(area.left, area.right - SIZE);
			sprite.y = FlxG.random.float(area.top, area.bottom - SIZE);

			final hue = 60 * FlxG.random.int(0, 6);
			sprite.color = FlxColor.fromHSB(hue, 1, 1);
			add(sprite);
		}
	}
	
	
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ONE)
		{
			final scale = 1;
			@:privateAccess
			FlxG.resizeGame(Std.int(FlxG.stage.stageWidth / scale), Std.int(FlxG.stage.stageHeight / scale));
			FlxG.log.add('(w: ${FlxG.width} | h: ${FlxG.height} )');
		}
		
		if (FlxG.keys.justPressed.TWO)
		{
			final scale = 2;
			@:privateAccess
			FlxG.resizeGame(Std.int(FlxG.stage.stageWidth / scale), Std.int(FlxG.stage.stageHeight / scale));
			FlxG.log.add('(w: ${FlxG.width} | h: ${FlxG.height} )');
		}
		
		if (FlxG.keys.justPressed.THREE)
		{
			final scale = 4;
			@:privateAccess
			FlxG.resizeGame(Std.int(FlxG.stage.stageWidth / scale), Std.int(FlxG.stage.stageHeight / scale));
			FlxG.log.add('(w: ${FlxG.width} | h: ${FlxG.height} )');
		}
		
		if (FlxG.keys.anyPressed([D, RIGHT]))
			camera.scroll.x += (FlxG.width / 2) * elapsed;
		
		if (FlxG.keys.anyPressed([A, LEFT]))
			camera.scroll.x -= (FlxG.width / 2) * elapsed;
		
		if (FlxG.keys.anyPressed([W, UP]))
			camera.scroll.y -= (FlxG.height / 2) * elapsed;
		
		if (FlxG.keys.anyPressed([S, DOWN]))
			camera.scroll.y += (FlxG.height / 2) * elapsed;
	}
}

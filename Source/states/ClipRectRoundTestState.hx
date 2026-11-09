package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import sprites.FlxSliceSprite;
import sprites.slice.FlxSliceSection;

private function drawBG(sprite:FlxSprite)
{
	final graphic = FlxG.bitmap.get("mainBG");
	if (graphic != null)
	{
		sprite.loadGraphic(graphic);
	}
	else
	{
		final graphic = FlxG.bitmap.create(100, 100, FlxColor.WHITE, false, "mainBG");
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(20, 20,  60,  60), FlxColor.BLUE);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(40, 40,  20,  20), FlxColor.WHITE);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(19,  0,   1, 100), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle( 0, 19, 100,   1), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(80,  0,   1, 100), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle( 0, 80, 100,   1), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(25,  7,  50,   6), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(25, 87,  50,   6), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle( 7, 25,   6,  50), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(87, 25,   6,  50), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(40, 40,  20,  20), FlxColor.LIME);
		sprite.loadGraphic(graphic);
	}
}

class ClipRectRoundTestState extends flixel.FlxState
{
	var sourceBg:FlxSprite;
	var source:FlxSprite;
	var resultBg:FlxSliceSprite;
	var result:FlxSliceSprite;
	var clipRect = FlxRect.get();
	var clipSprite:FlxSliceSprite;
	var mousePixel:FlxSprite;
	
	override function create()
	{
		super.create();
		
		clipRect = FlxRect.get(10, 10, 80, 80);
		
		sourceBg = new FlxSprite(10, 10);
		sourceBg.alpha = 0.5;
		drawBG(sourceBg);
		add(sourceBg);
		
		source = new FlxSprite(10, 10);
		drawBG(source);
		add(source);
		source.clipRect = clipRect;
		
		resultBg = new FlxSliceSprite(10, 200);
		drawBG(resultBg);
		resultBg.sliceRect = FlxRect.get(20, 20, 60, 60);
		// resultBg.frame.slice = FlxRect.get(20, 20, 60, 60);
		resultBg.displayWidth = 100;
		resultBg.displayHeight = 100;
		resultBg.alpha = 0.5;
		add(resultBg);
		
		result = new FlxSliceSprite(10, 200);
		drawBG(result);
		result.sliceRect = FlxRect.get(20, 20, 60, 60);
		// result.frame.slice = FlxRect.get(20, 20, 60, 60);
		result.displayWidth = 100;
		result.displayHeight = 100;
		result.clipRect = FlxRect.get();
		add(result);
		
		clipSprite = new FlxSliceSprite(source.x + clipRect.x, source.y + clipRect.y);
		clipSprite.sliceRect = new FlxRect(2, 2, 1, 1);
		clipSprite.makeGraphic(5, 5, FlxColor.WHITE);
		clipSprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(1, 1, 3, 3), FlxColor.BLACK);
		clipSprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(2, 2, 1, 1), FlxColor.TRANSPARENT);
		add(clipSprite);
		
		mousePixel = new FlxSprite().makeGraphic(10, 10);
		add(mousePixel);
		
		function getFrame(sprite:FlxSliceSprite, section:FlxSliceSection)
		{
			@:privateAccess
			final frame = sprite.slicer.subframes[section];
			return '${frame.frame} + ${frame.offset}';
		}
		
		function getDest(sprite:FlxSliceSprite, section:FlxSliceSection)
		{
			@:privateAccess
			if (sprite.slicer.destRects == null)
				return "";
			@:privateAccess
			return sprite.slicer.destRects[section].toString();
		}
		
		FlxG.watch.addFunction("result.frames.TL", ()->getFrame(result, TL));
		FlxG.watch.addFunction("result.frames.CC", ()->getFrame(result, CC));
		FlxG.watch.addFunction("result.frames.BR", ()->getFrame(result, BR));
		FlxG.watch.addFunction("resultBG.frames.TL", ()->getFrame(resultBg, TL));
		FlxG.watch.addFunction("resultBG.frames.CC", ()->getFrame(resultBg, CC));
		FlxG.watch.addFunction("resultBG.frames.BR", ()->getFrame(resultBg, BR));
		FlxG.watch.addFunction("result.dest.TL", ()->getDest(result, TL));
		FlxG.watch.addFunction("result.dest.CC", ()->getDest(result, CC));
		FlxG.watch.addFunction("result.dest.BR", ()->getDest(result, BR));
		FlxG.watch.addFunction("resultBG.dest.TL", ()->getDest(resultBg, TL));
		FlxG.watch.addFunction("resultBG.dest.CC", ()->getDest(resultBg, CC));
		FlxG.watch.addFunction("resultBG.dest.BR", ()->getDest(resultBg, BR));
		FlxG.watch.addFunction("result.dis", ()->'${result.displayWidth} x ${result.displayHeight}');
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
		
		final deltaScale = elapsed * 0.5 * ((FlxG.keys.pressed.E ? 1 : 0) - (FlxG.keys.pressed.Q ? 1 : 0));
		if (deltaScale != 0)
		{
			// trace(sourceBg.origin, sourceBg.frameWidth);
			sourceBg.scale.x = sourceBg.scale.y += deltaScale;
			// sourceBg.updateHitbox();
			// trace(sourceBg.origin, sourceBg.frameWidth);
			source.scale.copyFrom(sourceBg.scale);
			// source.updateHitbox();
		}
		
		clipRect.x += (FlxG.keys.pressed.D ? 1.0 : 0.0) - (FlxG.keys.pressed.A ? 1.0 : 0.0);
		clipRect.y += (FlxG.keys.pressed.S ? 1.0 : 0.0) - (FlxG.keys.pressed.W ? 1.0 : 0.0);
		
		clipRect.width += (FlxG.keys.pressed.RIGHT ? 1.0 : 0.0) - (FlxG.keys.pressed.LEFT ? 1.0 : 0.0);
		clipRect.height += (FlxG.keys.pressed.DOWN ? 1.0 : 0.0) - (FlxG.keys.pressed.UP ? 1.0 : 0.0);
		
		if (FlxG.keys.pressed.SPACE)
		{
			source.clipRect = null;
			clipSprite.visible = false;
		}
		else
		{
			source.clipRect = clipRect;
			clipSprite.visible = true;
			clipSprite.x = source.x + clipRect.x;
			clipSprite.y = source.y + clipRect.y;
			clipSprite.displayWidth = clipRect.width;
			clipSprite.displayHeight = clipRect.height;
			clipSprite.origin.x = sourceBg.origin.x + sourceBg.x - clipSprite.x;
			clipSprite.origin.y = sourceBg.origin.y + sourceBg.y - clipSprite.y;
			clipSprite.scale.copyFrom(sourceBg.scale);
		}
		
		final mouse = FlxPoint.get();
		final pixelColor = source.getPixelAt(FlxG.mouse.getWorldPosition(mouse));
		mousePixel.visible = pixelColor != null;
		mousePixel.color = pixelColor != null ? pixelColor.rgb : FlxColor.WHITE;
		
		if (result != null)
		{
			// result.angle += elapsed * 45 * ((FlxG.keys.pressed.PERIOD ? 1 : 0) - (FlxG.keys.pressed.COMMA ? 1.0 : 0));
			
			resultBg.scale.copyFrom(sourceBg.scale);
			// resultBg.updateHitbox();
			result.scale.copyFrom(sourceBg.scale);
			// result.updateHitbox();
			// FlxG.watch.addQuick("result.origin", result.origin);
			// FlxG.watch.addQuick("result.offset", result.offset);
			
			result.displayWidth += (FlxG.keys.pressed.L ? 1.0 : 0.0) - (FlxG.keys.pressed.J ? 1.0 : 0.0);
			result.displayHeight += (FlxG.keys.pressed.K ? 1.0 : 0.0) - (FlxG.keys.pressed.I ? 1.0 : 0.0);
			if (resultBg != null)
			{
				resultBg.displayWidth = result.displayWidth;
				resultBg.displayHeight = result.displayHeight;
			}
			
			if (clipSprite.visible == false)
				result.clipToWorldBoundsSimple(result.x + clipRect.x, result.y + clipRect.y, result.x + clipRect.right, result.y + clipRect.bottom);
			else
				result.clipRect.copyFrom(clipRect);
			
			if (pixelColor == null)
			{
				final pixelColor = result.getPixelAt(FlxG.mouse.getWorldPosition(mouse));
				mousePixel.visible = pixelColor != null;
				mousePixel.color = pixelColor != null ? pixelColor.rgb : FlxColor.WHITE;
			}
		}
		
		mouse.put();
	}
}
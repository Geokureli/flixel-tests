package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
// import flixel.graphics.FlxSliceSprite;
import flixel.graphics.frames.FlxFrame;
// import flixel.graphics.frames.slice.FlxSliceSection;
// import flixel.graphics.frames.slice.FlxSpriteSlicer;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxDestroyUtil;

private function drawBG(sprite:FlxSprite)
{
	sprite.makeGraphic(100, 100);
	sprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(20, 20, 60, 60), 0xFF0000ff);
	sprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(40, 40, 20, 20), 0xFFffffff);
	sprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(19, 0, 1, 100), 0xFFff0000);
	sprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(0, 19, 100, 1), 0xFFff0000);
	sprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(80, 0, 1, 100), 0xFFff0000);
	sprite.graphic.bitmap.fillRect(new openfl.geom.Rectangle(0, 80, 100, 1), 0xFFff0000);
}

class ClipRectRoundTestState extends flixel.FlxState
{
	var sourceBg:FlxSprite;
	var source:FlxSprite;
	// var resultBg:FlxSliceSprite;
	// var result:FlxSliceSprite;
	var clipRect = FlxRect.get();
	
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
		
		// resultBg = new FlxSliceSprite(120, 10);
		// drawBG(resultBg);
		// resultBg.sliceRect = FlxRect.get(20, 20, 60, 60);
		// // resultBg.frame.slice = FlxRect.get(20, 20, 60, 60);
		// resultBg.displayWidth = 100;
		// resultBg.displayHeight = 100;
		// resultBg.alpha = 0.5;
		// // add(resultBg);
		
		// result = new FlxSliceSprite(120, 10);
		// drawBG(result);
		// result.sliceRect = FlxRect.get(20, 20, 60, 60);
		// // result.frame.slice = FlxRect.get(20, 20, 60, 60);
		// result.displayWidth = 100;
		// result.displayHeight = 100;
		// add(result);
		// result.clipRect = clipRect;
		
		// function getFrame(sprite:FlxSliceSprite, section:FlxSliceSection)
		// {
		// 	@:privateAccess
		// 	final frame = sprite.slicer.subframes[section];
		// 	return '${frame.frame} + ${frame.offset}';
		// }
		
		// function getDest(sprite:FlxSliceSprite, section:FlxSliceSection)
		// {
		// 	@:privateAccess
		// 	if (sprite.slicer.destRects == null)
		// 		return "";
		// 	@:privateAccess
		// 	return sprite.slicer.destRects[section].toString();
		// }
		
		// FlxG.watch.addFunction("result.frames.TL", ()->getFrame(result, TL));
		// FlxG.watch.addFunction("result.frames.CC", ()->getFrame(result, CC));
		// FlxG.watch.addFunction("result.frames.BR", ()->getFrame(result, BR));
		// FlxG.watch.addFunction("resultBG.frames.TL", ()->getFrame(resultBG, TL));
		// FlxG.watch.addFunction("resultBG.frames.CC", ()->getFrame(resultBG, CC));
		// FlxG.watch.addFunction("resultBG.frames.BR", ()->getFrame(resultBG, BR));
		// FlxG.watch.addFunction("result.dest.TL", ()->getDest(result, TL));
		// FlxG.watch.addFunction("result.dest.CC", ()->getDest(result, CC));
		// FlxG.watch.addFunction("result.dest.BR", ()->getDest(result, BR));
		// FlxG.watch.addFunction("resultBG.dest.TL", ()->getDest(resultBG, TL));
		// FlxG.watch.addFunction("resultBG.dest.CC", ()->getDest(resultBG, CC));
		// FlxG.watch.addFunction("resultBG.dest.BR", ()->getDest(resultBG, BR));
		// FlxG.watch.addFunction("result.dis", ()->'${result.displayWidth} x ${result.displayHeight}');
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
		
		source.clipRect = FlxG.keys.pressed.SPACE ? null : clipRect;
		
		clipRect.x += (FlxG.keys.pressed.D ? 1.0 : 0.0) - (FlxG.keys.pressed.A ? 1.0 : 0.0);
		clipRect.y += (FlxG.keys.pressed.S ? 1.0 : 0.0) - (FlxG.keys.pressed.W ? 1.0 : 0.0);
		
		clipRect.width += (FlxG.keys.pressed.RIGHT ? 1.0 : 0.0) - (FlxG.keys.pressed.LEFT ? 1.0 : 0.0);
		clipRect.height += (FlxG.keys.pressed.DOWN ? 1.0 : 0.0) - (FlxG.keys.pressed.UP ? 1.0 : 0.0);
		// if (result != null)
		// {
		// 	result.angle += elapsed * 45 * ((FlxG.keys.pressed.PERIOD ? 1 : 0) - (FlxG.keys.pressed.COMMA ? 1.0 : 0));
		// 	result.scale.x = result.scale.y += elapsed * 0.5 * ((FlxG.keys.pressed.E ? 1 : 0) - (FlxG.keys.pressed.Q ? 1 : 0));
		// 	result.clipRect = FlxG.keys.pressed.SPACE ? null : clipRect;
			
		// 	result.displayWidth += (FlxG.keys.pressed.L ? 1.0 : 0.0) - (FlxG.keys.pressed.J ? 1.0 : 0.0);
		// 	result.displayHeight += (FlxG.keys.pressed.K ? 1.0 : 0.0) - (FlxG.keys.pressed.I ? 1.0 : 0.0);
		// 	if (resultBg != null)
		// 	{
		// 		resultBg.displayWidth = result.displayWidth;
		// 		resultBg.displayHeight = result.displayHeight;
		// 	}
		// }
	}
}
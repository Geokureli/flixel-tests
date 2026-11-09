package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import sprites.SliceSprite;
import sprites.slice.SliceSection;

class FrameSlicerTestState extends flixel.FlxState
{
	var result:SliceSprite;
	
	override function create()
	{
		super.create();
		bgColor = 0xFF808080;
		
		result = new SliceSprite(10, 200);
		result.makeSliceGraphic(0xFFff0000, FlxColor.BLACK);
		// result.sliceRect = FlxRect.get(20, 20, 60, 60);
		result.displayWidth = 100;
		result.displayHeight = 100;
		add(result);
		
		function getFrame(sprite:SliceSprite, section:SliceSection)
		{
			@:privateAccess
			final frame = sprite.subframes[section];
			return '${frame.frame} + ${frame.offset}';
		}
		
		function getDest(sprite:SliceSprite, section:SliceSection)
		{
			@:privateAccess
			if (sprite.destRects == null)
				return "";
			@:privateAccess
			return sprite.destRects[section].toString();
		}
		
		FlxG.watch.addFunction("result.frames.TL", ()->getFrame(result, TL));
		FlxG.watch.addFunction("result.frames.CC", ()->getFrame(result, CC));
		FlxG.watch.addFunction("result.frames.BR", ()->getFrame(result, BR));
		FlxG.watch.addFunction("result.dest.TL", ()->getDest(result, TL));
		FlxG.watch.addFunction("result.dest.CC", ()->getDest(result, CC));
		FlxG.watch.addFunction("result.dest.BR", ()->getDest(result, BR));
		FlxG.watch.addFunction("result.dis", ()->'${result.displayWidth} x ${result.displayHeight}');
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
		
		result.displayWidth += (FlxG.keys.pressed.L ? 1.0 : 0.0) - (FlxG.keys.pressed.J ? 1.0 : 0.0);
		result.displayHeight += (FlxG.keys.pressed.K ? 1.0 : 0.0) - (FlxG.keys.pressed.I ? 1.0 : 0.0);
	}
}
package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;

class DebugSelectionTestState extends flixel.FlxState
{
	static inline var SIZE = 16;
	
	final sprites = new FlxTypedGroup<FlxSprite>();
	
	override function create():Void
	{
		super.create();
		
		add(sprites);
		createMess(2.0, true);
		
		// scroll to center of mess
		FlxG.camera.scroll.x = FlxG.width / 2;
		FlxG.camera.scroll.y = FlxG.height / 2;
		
		#if FLX_DEBUG
		FlxG.debugger.drawDebug = true;
		FlxG.debugger.visible = true;
		#end
	}
	
	function createMess(density = 0.5, sortColors = true)
	{
		final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
		var count = Std.int(area.width * area.height / (SIZE * SIZE) * density);
		while (count-- > 0)
		{
			final sprite = sprites.recycle(()->new FlxSprite());
			sprite.makeGraphic(SIZE, SIZE);
			sprite.x = FlxG.random.float(area.left, area.right - SIZE);
			sprite.y = FlxG.random.float(area.top, area.bottom - SIZE);
			final hue = 60 * FlxG.random.int(0, 6);
			sprite.color = FlxColor.fromHSB(hue, 1, 1);
			sprite.ignoreDrawDebug = true;
		}
	}
}
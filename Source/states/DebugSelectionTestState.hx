package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import lime.math.Rectangle;

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
		FlxG.console.registerEnum(TestEnum);
		#end
	}
	
	function createMess(density = 0.5, sortColors = true)
	{
		final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
		var count = 1;//Std.int(area.width * area.height / (SIZE * SIZE) * density);
		while (count-- > 0)
		{
			final sprite = sprites.recycle(()->new FlxSprite());
			initSprite(sprite, area);
		}
	}
	
	function initSprite(sprite:FlxSprite, area:FlxRect)
	{
		sprite.makeGraphic(SIZE, SIZE);
			sprite.x = FlxG.random.float(area.left, area.right - SIZE);
			sprite.y = FlxG.random.float(area.top, area.bottom - SIZE);
		final hue = 60 * FlxG.random.int(0, 6);
		sprite.color = FlxColor.fromHSB(hue, 1, 1);
		sprite.ignoreDrawDebug = true;
		sprite.scrollFactor.set(0.5, 0.5);
        // sprite.graphic.bitmap.fillRect(new Rectangle(10, 10, 80, 80), 0x0000ff);
	}
}

enum TestEnum { A; B; C; }
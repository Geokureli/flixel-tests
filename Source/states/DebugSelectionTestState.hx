package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import lime.math.Rectangle;

class DebugSelectionTestState extends flixel.FlxState
{
	final sprites = new FlxTypedGroup<FlxSprite>();
	var drawSize = 10;
	var mult = 1;
	
	override function create():Void
	{
		super.create();
		
		add(sprites);
		autoCreateMess();
		
		// scroll to center of mess
		FlxG.camera.scroll.x = FlxG.width / 2;
		FlxG.camera.scroll.y = FlxG.height / 2;
		
		#if FLX_DEBUG
		FlxG.debugger.drawDebug = true;
		FlxG.debugger.visible = true;
		// FlxG.watch.addFunction('forceHardware', ()->FlxDebugDrawGraphic.forceHardware);
		FlxG.watch.addFunction('drawSize', ()->drawSize);
		FlxG.watch.addFunction('sprites', sprites.countLiving);
		#end
	}
	
	function autoCreateMess()
	{
		createMess(drawSize, mult * (drawSize / 16) * (drawSize / 16));
	}
	
	function createMess(size = 16, density = 0.5, sortColors = true)
	{
		sprites.killMembers();
		
		final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
		var count = Std.int(area.width * area.height / (size * size) * density);
		while (count-- > 0)
		{
			final sprite = sprites.recycle(()->new FlxSprite());
			initSprite(size, sprite, area);
		}
	}
	
	function initSprite(size, sprite:FlxSprite, area:FlxRect)
	{
		sprite.makeGraphic(size, size);
		sprite.x = FlxG.random.float(area.left, area.right - size);
		sprite.y = FlxG.random.float(area.top, area.bottom - size);
		final hue = 60 * FlxG.random.int(0, 6);
		sprite.color = FlxColor.fromHSB(hue, 1, 1);
		sprite.solid = FlxG.random.bool();
		// sprite.ignoreDrawDebug = true;
		// sprite.scrollFactor.set(0.5, 0.5);
        // sprite.graphic.bitmap.fillRect(new Rectangle(10, 10, 80, 80), 0x0000ff);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// if (FlxG.keys.justPressed.SPACE)
		// 	FlxDebugDrawGraphic.forceHardware = !FlxDebugDrawGraphic.forceHardware;
		
		if (FlxG.keys.justPressed.ONE)
		{
			mult = (mult == 1 ? 10 : 1);
			autoCreateMess();
		}
		
		if (FlxG.keys.justPressed.ENTER)
		{
			drawSize = switch drawSize
			{
				case 10: 100;
				case 100: 1600;
				default: 10;
			}
			autoCreateMess();
		}
		
		if (FlxG.keys.pressed.Q && camera.zoom > 0.1) camera.zoom *= 0.99;
		if (FlxG.keys.pressed.E) camera.zoom *= 1.01;
	}
}
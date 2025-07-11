package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class FlxQuadTreeTestState extends flixel.FlxState
{
	final sprites = new FlxTypedGroup<FlxSprite>();
	var drawSize = 100;
	var mult = 1;
	
	override function create():Void
	{
		super.create();
		
		add(sprites);
		createMess(100, 0.5);
		
		// scroll to center of mess
		FlxG.camera.scroll.x = FlxG.width / 2;
		FlxG.camera.scroll.y = FlxG.height / 2;
		
		#if FLX_DEBUG
		FlxG.watch.addFunction('drawSize', ()->drawSize);
		FlxG.watch.addFunction('sprites', sprites.countLiving);
		#end
	}
	
	function createMess(size = 16, density = 0.5)
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
		sprite.velocity.x = FlxG.random.float(-100, 100);
		sprite.velocity.y = FlxG.random.float(-100, 100);
		final hue = 60 * FlxG.random.int(0, 6);
		sprite.color = FlxColor.fromHSB(hue, 1, 1);
		// sprite.solid = FlxG.random.bool();
		// sprite.ignoreDrawDebug = true;
		sprite.scrollFactor.set(0.5, 0.5);
        // sprite.graphic.bitmap.fillRect(new Rectangle(10, 10, 80, 80), 0x0000ff);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.collision.collide(this);
		}
	}
}
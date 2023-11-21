package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DebugSelectionTestState extends flixel.FlxState
{
	var zoomText:FlxText;
	
	override function create():Void
	{
		super.create();
		
		createMess();
		
		// create ui on separate camera
		add(zoomText = new UIText(4, 4, "Zoom: 1.0"));
		
		// scroll to center of mess
		FlxG.camera.scroll.x = FlxG.width / 2;
		FlxG.camera.scroll.y = FlxG.height / 2;
	}
	
	function createMess(size = 32, density = 0.5)
	{
		final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
		final count = Std.int(area.width * area.height / (size * size) * density);
		for (i in 0...count)
		{
			final x = FlxG.random.float(area.left, area.right - size);
			final y = FlxG.random.float(area.top, area.bottom - size);
			final sprite = new FlxSprite(x, y);
			sprite.makeGraphic(size, size, FlxColor.WHITE);
			sprite.color = FlxColor.fromHSB(FlxG.random.float(0, 360), 1, 1);
			add(sprite);
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.anyPressed([D, RIGHT]))
			camera.scroll.x += (FlxG.width / 2) * elapsed;
		
		if (FlxG.keys.anyPressed([A, LEFT]))
			camera.scroll.x -= (FlxG.width / 2) * elapsed;
		
		if (FlxG.keys.anyPressed([W, UP]))
			camera.scroll.y -= (FlxG.height / 2) * elapsed;
		
		if (FlxG.keys.anyPressed([S, DOWN]))
			camera.scroll.y += (FlxG.height / 2) * elapsed;
		
		
		var deltaZoom = 0.0;
		if (FlxG.mouse.wheel != 0)
			deltaZoom = FlxG.mouse.wheel / 1000;
		else if (FlxG.keys.pressed.COMMA)
			deltaZoom = 0.1;
		else if (FlxG.keys.pressed.PERIOD)
			deltaZoom = -0.1;
		
		FlxG.camera.zoom = Math.min(2.0, Math.max(0.2, FlxG.camera.zoom - deltaZoom));
	}
}

abstract UIText(FlxText) to FlxText
{
	static var camera:FlxCamera;
	
	public function new (x = 0, y = 0, ?text:String, size = 8)
	{
		// create ui on separate camera
		this = new FlxText(x, y, 0.0, text, size);
		this.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		
		if (camera == null)
		{
			camera = new FlxCamera();
			camera.bgColor = 0x0;
			FlxG.cameras.add(camera, false);
		}
		this.camera = camera;
	}
}
package states;

import flixel.util.FlxSpriteUtil;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class DebugSelectionTestState extends flixel.FlxState
{
	static inline var SIZE = 16;
	
	var zoomText:FlxText;
	
	final sprites = new FlxTypedGroup<FlxSprite>();
	
	override function create():Void
	{
		super.create();
		
		add(sprites);
		createMess(2.0, true);
		
		// create ui on separate camera
		add(zoomText = new UIText(4, 4, "Zoom: 1.0"));
		
		// scroll to center of mess
		FlxG.camera.scroll.x = FlxG.width / 2;
		FlxG.camera.scroll.y = FlxG.height / 2;
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
			// sort by color, allowing better batch drawing
			// final hue = 60 * FlxG.random.int(0, 6);
			// sprite.color = FlxColor.fromHSB(hue, 1, 1);
			sprite.color = FlxG.random.bool(50) ? 0xff003200 : FlxColor.WHITE;
		}
		
		if (sortColors)
			sortByColor();
	}
	
	function randomizeColors(hueMode = false)
	{
		final members = sprites.members;
		var i = sprites.length;
		while (i-- > 0)
		{
			if (hueMode)
			{
				final hue = 60 * FlxG.random.int(0, 6);
				members[i].color = FlxColor.fromHSB(hue, 1, 1);
			}
			else
			{
				members[i].color = FlxG.random.bool() ? FlxColor.WHITE : 0xff003200;
			}
		}
	}
	
	function sortByColor(ascending = true)
	{
		final members = sprites.members;
		var i = sprites.length;
		while (i-- > 0)
		{
			final member = members[i];
			if ((i > sprites.length / 2) == ascending)
			{
				member.color = FlxColor.WHITE;
			}
		}
	}
	
	function removeMess(density = 0.5, sortColors = true)
	{
		final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
		var count = Std.int(area.width * area.height / (SIZE * SIZE) * density);
		if (count > sprites.length)
			count > sprites.length;
		
		while (count-- > 0)
		{
			sprites.getFirstAlive().kill();
		}
		
		if (sortColors)
		{
			sortByColor();
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		final shift = FlxG.keys.pressed.SHIFT;
		
		if (FlxG.keys.justPressed.ONE)
			FlxG.camera.zoom = 1;
		else if (FlxG.keys.justPressed.TWO)
			FlxG.camera.zoom = 0.5;
		
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
		
		if (deltaZoom != 0)
			zoomText.text = 'Zoom: ' + (Math.round(FlxG.camera.zoom * 10) / 10);
		
		// if (FlxG.keys.pressed.ENTER)
		// 	flixel.system.debug.FlxDebugDrawGraphic.debugUseFill = flixel.system.debug.FlxDebugDrawGraphic.debugUseFill;
		
		if (FlxG.keys.justPressed.LBRACKET)
			removeMess(1, shift);
		else if (FlxG.keys.justPressed.RBRACKET)
			createMess(1, shift);
		
		if (FlxG.keys.justPressed.P)
			randomizeColors(shift);
		
		if (FlxG.keys.justPressed.O)
			sortByColor(shift);
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
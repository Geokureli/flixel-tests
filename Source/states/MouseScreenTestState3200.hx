package states;

import openfl.display.Shape;
import flixel.ui.FlxButton;
import flixel.system.scaleModes.*;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MouseScreenTestState3200 extends flixel.FlxState
{
	static inline final MARGIN = 80;
	
	var button:FlxButton;
	var mainCam:FlxCamera;
	
	override function create()
	{
		super.create();
		
		final stage = FlxG.stage;
		final game = FlxG.game;
		function redrawBg()
		{
			game.graphics.clear();
			game.graphics.beginFill(0xffffff, 1);
			game.graphics.drawRect(-game.x, -game.y, stage.stageWidth, stage.stageHeight);
		}
		redrawBg();
		FlxG.signals.gameResized.add((w, h)->redrawBg());
		FlxG.stage.color = FlxColor.BLACK;
		FlxG.scaleMode = new RatioScaleMode(false);
		// FlxG.resizeGame(FlxG.width - MARGIN * 2, FlxG.height);
		final bgCam = FlxG.camera;
		bgCam.bgColor = FlxColor.BLUE;
		
		mainCam = new FlxCamera();
		FlxG.cameras.add(mainCam, false);
		// trace(FlxG.cameras.list.indexOf(bgCam) == 0);
		// bgCam.bgColor = 0x0;
		
		final uiCam = new FlxCamera();
		FlxG.cameras.add(uiCam, false);
		uiCam.bgColor = 0x0;
		
		mainCam.setSize(FlxG.width - MARGIN * 2, FlxG.height - MARGIN * 2);
		mainCam.setPosition(MARGIN, MARGIN);
		mainCam.bgColor = FlxColor.WHITE;
		
		createMess();
		
		// button = new FlxButton(0, 0, "text", ()->trace("click"));
		// button.camera = uiCam;
		// add(button);
		
		this.camera = mainCam;
		
		inline function round(num:Float):String
		{
			return Std.string(Math.round(num * 10) / 10);
		}
		
		final scaleMode = FlxG.scaleMode;
		final p = FlxPoint.get();
		FlxG.watch.addFunction("view", ()->'(l:${round(mainCam.viewMarginLeft)} | t:${round(mainCam.viewMarginTop)} | r:${round(mainCam.viewMarginRight)} | b:${round(mainCam.viewMarginBottom)})');
		FlxG.watch.addFunction("viewMouse", ()->FlxG.mouse.getViewPosition(mainCam, p).toString());
		FlxG.watch.addFunction("game", ()->'(x: ${game.x} | y: ${game.y} | w:${FlxG.width} | h:${FlxG.height})');
		FlxG.watch.addFunction("gameSize", ()->FlxG.scaleMode.gameSize.toString());
		FlxG.watch.addFunction("gameMouse", ()->FlxG.mouse.getGamePosition(p).toString());
		FlxG.watch.addFunction("window", ()->'(w:${stage.stageWidth} | h:${stage.stageHeight})');
		FlxG.watch.addFunction("stageMouse", ()->'( x:${stage.mouseX} | y:${stage.mouseY})');
		FlxG.watch.addFunction("zoom/initial", ()->'${round(mainCam.zoom)} / ${round(mainCam.initialZoom)}');
		FlxG.watch.addFunction("scroll", ()->mainCam.scroll.toString());
		FlxG.watch.addFunction("scale", ()->FlxG.scaleMode.scale.toString());
		FlxG.watch.addFunction("worldMouse", ()->FlxG.mouse.getWorldPosition(mainCam, p).toString());
		// FlxG.watch.addFunction("btn-hl", ()->button.status == HIGHLIGHT);
	}
	
	function createMess(size = 32, density = 0.5)
	{
		final sprite = new FlxSprite();
		sprite.makeGraphic(size, size);
		sprite.color = FlxColor.BLACK;
		add(sprite);
		
		final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
		final spacing = size / density;
		final cols = Std.int(area.width / spacing);
		final rows = Std.int(area.height / spacing);
		var count = Std.int(area.width * area.height / spacing / spacing) - 1;
		while (count-- > 0)
		{
			final sprite = new FlxSprite();
			sprite.makeGraphic(size, size);
			sprite.x = (FlxG.random.float(-0.5, 0.5) + (count % cols)) * spacing;
			sprite.y = (FlxG.random.float(-0.5, 0.5) + Std.int(count / cols)) * spacing;
			final hue = FlxG.random.int(0, 360);
			sprite.color = FlxColor.fromHSB(hue, 1, 1);
			add(sprite);
		}
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
		
		final shift = FlxG.keys.pressed.SHIFT;
		
		if (FlxG.keys.justPressed.ONE)
			mainCam.zoom = 1;
		else if (FlxG.keys.justPressed.TWO)
			mainCam.zoom = 0.5;
		
		final scrollSpeed = shift ? 1 : (FlxG.width / 2) * elapsed;
		
		if (FlxG.keys.anyPressed([D, RIGHT]))
			mainCam.scroll.x += scrollSpeed;
		
		if (FlxG.keys.anyPressed([A, LEFT]))
			mainCam.scroll.x -= scrollSpeed;
		
		if (FlxG.keys.anyPressed([W, UP]))
			mainCam.scroll.y -= scrollSpeed;
		
		if (FlxG.keys.anyPressed([S, DOWN]))
			mainCam.scroll.y += scrollSpeed;
		
		var deltaZoom = 0.0;
		if (FlxG.mouse.wheel != 0)
			deltaZoom = FlxG.mouse.wheel / 1000;
		else if (FlxG.keys.pressed.COMMA)
			deltaZoom = 0.1;
		else if (FlxG.keys.pressed.PERIOD)
			deltaZoom = -0.1;
		
		mainCam.zoom = Math.min(2.0, Math.max(0.2, mainCam.zoom - deltaZoom));
	}
}

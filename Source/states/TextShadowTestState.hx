package states;

import flixel.system.debug.log.LogStyle;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.text.FlxBitmapText;

class TextShadowTestState extends flixel.FlxState
{
	final styles:Array<()->FlxTextBorderStyle> = [];
	
	var text:FlxText;
	var bmText:FlxBitmapText;
	var showBorder = true;
	var size = 4;
	var quality = 0;
	var styleIndex = 0;
	var offsetX = 1;
	var offsetY = 1;
	
	var instructions:FlxText;
	
	override public function create()
	{
		super.create();
		bgColor = 0xFF808080;
		
		styles.push(()->SHADOW);
		styles.push(()->SHADOW_XY(offsetX, offsetY));
		styles.push(()->OUTLINE);
		styles.push(()->OUTLINE_FAST);
		
		text = new flixel.addons.ui.FlxInputText(0, 0, FlxG.width, "FlxText shadow clipping test lol", 8);
		text.color = 0xFF0000ff;
		// text = new FlxText(0, 0, 0, "FlxText shadow clipping test lol", 8);
		text.screenCenter();
		add(text);
		
		bmText = new FlxBitmapText(0, 0, "FlxText shadow clipping test lol");
		bmText.screenCenter();
		add(bmText);
		
		final gap = (text.height + bmText.height) * 0.5;
		text.y -= gap;
		bmText.y += gap;
		
		applyShadow();
		
		// debug watch
		FlxG.watch.addFunction("bmd", function ()
		{
			final bmp = text.graphic.bitmap;
			return '( w: ${bmp.width} | h: ${bmp.height} )';
		});
		FlxG.watch.addFunction("shd.offset", ()->'( x: $offsetX | y: $offsetY )');
		FlxG.watch.addFunction("shd.size", ()->size);
		FlxG.watch.addFunction("shd.quality", ()->quality);
		FlxG.watch.addFunction("shd.style", ()->'$styleIndex : ${text.borderStyle}');
		FlxG.log.notice("LEFT RIGHT UP DOWN: change shadowOffset");
		FlxG.log.notice("SPACE: reset shadowOffset");
		FlxG.log.notice("< >: change borderSize");
		FlxG.log.notice("SHIFT + < >: change borderQuality");
		FlxG.log.notice("CLICK: toggle border");
		FlxG.log.notice("ENTER: change style");
		FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		LogStyle.WARNING.callbackFunction = function ()
		{
			trace("Warning");
		}
	}
	
	function applyShadow()
	{
		if (showBorder)
		{
			text.setBorderStyle(styles[styleIndex](), 0xFF000000, size, quality);
			bmText.setBorderStyle(styles[styleIndex](), 0xFF000000, size, quality);
		}
		else
		{
			text.setBorderStyle(NONE);
			bmText.setBorderStyle(NONE);
		}
		
		@:privateAccess text._regen = true;
		@:privateAccess text.regenGraphic();
		FlxG.bitmapLog.clear();
		FlxG.bitmapLog.add(text.graphic.bitmap);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		var redraw = false;
		
		if (FlxG.keys.anyJustPressed([SPACE, RIGHT, LEFT, UP, DOWN]))
		{
			if (FlxG.keys.justPressed.SPACE) { offsetX = 1; offsetY = 1; }
			if (FlxG.keys.justPressed.RIGHT) offsetX += 1;
			if (FlxG.keys.justPressed.LEFT) offsetX -= 1;
			if (FlxG.keys.justPressed.UP) offsetY -= 1;
			if (FlxG.keys.justPressed.DOWN) offsetY += 1;
			text.shadowOffset.set(offsetX, offsetY);
			bmText.shadowOffset.set(offsetX, offsetY);
			
			redraw = true;
		}
		
		if (FlxG.keys.pressed.D) { text.x += 1; bmText.x += 1; }
		if (FlxG.keys.pressed.A) { text.x -= 1; bmText.x -= 1; }
		if (FlxG.keys.pressed.W) { text.y -= 1; bmText.y -= 1; }
		if (FlxG.keys.pressed.S) { text.y += 1; bmText.y += 1; }
		
		if (FlxG.keys.justPressed.ENTER)
		{
			styleIndex = (styleIndex + 1) % styles.length;
			redraw = true;
		}
		
		if (FlxG.keys.anyJustPressed([COMMA, PERIOD]))
		{
			if (FlxG.keys.pressed.SHIFT)
			{
				if (FlxG.keys.justPressed.PERIOD && quality < 2) quality++;
				if (FlxG.keys.justPressed.COMMA && quality > 0) quality--;
			}
			else
			{
				if (FlxG.keys.justPressed.PERIOD) size++;
				if (FlxG.keys.justPressed.COMMA) size--;
			}
			
			redraw = true;
		}
		
		if (FlxG.mouse.justPressed)
		{
			showBorder = !showBorder;
			redraw = true;
		}
		
		if (redraw)
			applyShadow();
		
		if (FlxG.keys.justPressed.BACKSPACE)
		{
			text.text = text.text == "" ? "FlxText shadow clipping test lol" : "";
			bmText.text = text.text;
		}
	}
}
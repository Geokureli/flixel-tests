package states;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.geom.ColorTransform;

using flixel.util.FlxColorTransformUtil;

class ScrollingTextTestState extends flixel.FlxState
{
	final stringLong = "Lorem ipsum dolor sit (amet), consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
	final stringShort = "Lorem ipsum dolor sit (amet), consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	
    var text:FlxBitmapText;
    var bTextY:ScrollingBitmapTextY;
    var bTextX:ScrollingBitmapTextX;
    
    override function create()
    {
        super.create();
        
        FlxG.cameras.bgColor = 0xFFa0a0a0;
        FlxG.stage.color = 0xFF000000;
        
		final y = 10;
		
        // bTextY = new ScrollingBitmapTextY(10, y, stringLong, 200, 100, MAIN(COLOR(0xFFfbf236)));
        // bTextY.background = true;
        // bTextY.backgroundColor = 0xFF808080;
        // add(bTextY);
		// final y = (bTextY != null ? bTextY.y + bTextY.fieldHeight + 10 : 10);
        
		bTextX = new ScrollingBitmapTextX(10, y, stringShort, 210, MAIN(WHITE));
		FlxG.log.notice(bTextX.maxScrollX);
        bTextX.background = true;
		FlxG.log.notice(bTextX.maxScrollX);
        bTextX.backgroundColor = 0xFF808080;
		FlxG.log.notice(bTextX.maxScrollX);
        add(bTextX);
		FlxG.log.notice(bTextX.maxScrollX);
		final y = (bTextX != null ? bTextX.y + bTextX.textHeight + 20 : 10);
		
		text = new BaseTextBMP(10, y, stringLong, 210, MAIN(WHITE));
        text.background = true;
        text.backgroundColor = 0xFF808080;
		text.autoSize = false;
		text.multiLine = true;
		text.wrap = WORD(NEVER);
		text.padding = 2;
		add(text);
		
		FlxG.console.registerFunction("functionName", (arg:String)->{ return arg.split("").join(" "); });
		
		FlxG.watch.addFunction('scroll', ()->'${bTextX.scrollX}/${bTextX.maxScrollX}');
		// FlxG.watch.addFunction('scroll', ()->'${bTextY.scrollY}/${bTextY.maxScrollY}');
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final delta = (FlxG.keys.pressed.RIGHT ? 1 : 0) - (FlxG.keys.pressed.LEFT ? 1 : 0)
        	+ (FlxG.keys.justPressed.DOWN ? 1 : 0) - (FlxG.keys.justPressed.UP ? 1 : 0);
		if (delta != 0)
		{
			if (bTextY != null)
				bTextY.scrollY += delta * 50 * elapsed;
			
			if (bTextX != null)
				bTextX.scrollX += delta * 50 * elapsed;
		}
		
		if (FlxG.keys.justPressed.ENTER)
			FlxG.resetState();
    }
	
	override function draw()
	{
		// for (i in 0...100)
			super.draw();
	}
}

class ScrollBitmapText extends FlxBitmapText
{
    public var scrollX(default, set):Int;
    function set_scrollX(value:Int)
    {
        scrollX = value;
        updateScroll();
        return scrollX;
    }
    
    final clip = FlxRect.get();
    var initted = false;
    
    public function new (x = 0.0, y = 0.0, ?text, fieldWidth:Int, font)
    {
        super(x, y, text, font);
        multiLine = false;
        autoSize = true;
        clip.set(0, 0, fieldWidth, textHeight);
        initted = true;
        updateScroll();
    }
    
    function updateScroll()
    {
        clipRect = null;
        
        if (scrollX > width - clip.width)
            scrollX = Math.round(width - clip.width);
        
        if (scrollX < 0)
            scrollX = 0;
        
        clip.height = textHeight;
        clipRect = clip;
    }
    
    override function set_fieldWidth(value:Int):Int
    {
        _fieldWidth = 0;
        if (initted)
        {
            clip.width = value;
            updateScroll();
        }
        return value;
    }
    
    override function get_fieldWidth():Int
    {
        return Math.round(clip.width);
    }
    
    override function drawText(posX:Int, posY:Int, isFront = true, ?bitmap, useTiles = false)
    {
        super.drawText(posX - scrollX, posY, isFront, bitmap, useTiles);
    }
}
class BaseTextBMP extends flixel.text.FlxBitmapText
{
	public function new(x = 0.0, y = 0.0, ?text, fieldWidth = 0, ?font:FontType, alignment = LEFT)
	{
		super(x, y, text, getFont(font));
		initFont(font);
		this.fieldWidth = fieldWidth;
		setStyle(getStyle(font), alignment);
	}

	public function setFontType(?font:FontType, ?alignment:FlxTextAlign)
	{
		font = font ?? FontType.MAIN(null);
		this.font = getFont(font);
		initFont(font);
		setStyle(getStyle(font), alignment);
	}

	function initFont(font:FontType)
	{
		// Note: for backwards compatibility, we made BaseText line up with BaseTextBMP, not the other way around
		// If anything on that changes, do so here
	}
	
	public function setStyle(style:Null<TextStyle>, alignment:Null<FlxTextAlign>)
	{
		if (alignment != null)
			this.alignment = alignment;
		
		useTextColor = true;
		switch style
		{
			case BLACK | null:
				textColor = FlxColor.BLACK;
				setBorderStyle(NONE);
			case WHITE:
				textColor = FlxColor.WHITE;
				setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
			case COLOR(color):
				textColor = color;
				setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		}
	}

	static public function getFont(?font:FontType)
	{
        
        var monospaceLetters:String = " !\"#$%&'()*+,-.\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}~";
        var charSize = FlxPoint.get(7, 10);
        return FlxBitmapFont.fromMonospace("assets/fonts/RetroMedievalV3.png", monospaceLetters, charSize);
		// return switch (font)
		// {
		// 	case null | FontType.MAIN(_):
		// 		Fonts.MAIN;
		// 	case FontType.FLIXEL(_):
		// 		Fonts.FLIXEL;
		// 	case FontType.DLG(_):
		// 		Fonts.DIALOGUE;
		// 	case FontType.MINI(_):
		// 		Fonts.MINI;
		// 	case FontType.CUSTOM(name, size, _):
		// 		{name: name, size: size};
		// }
	}

	static function getStyle(?font:FontType)
	{
		return switch (font)
		{
			case null | MAIN(null):
				BLACK;
			case FontType.MAIN(style):
				style;
			case FontType.FLIXEL(style):
				style;
			case FontType.DLG(style):
				style;
			case FontType.MINI(style):
				style;
			case FontType.CUSTOM(_, _, style):
				style;
		}
	}
	
	// static final bgColorTransformDrawHelper = new ColorTransform();
	// static final borderColorTransformDrawHelper = new ColorTransform();
	// static final textColorTransformDrawHelper = new ColorTransform();
	// static final matrixDrawHelper = new FlxMatrix();
	// override function draw()
	// {
	// 	if (FlxG.renderBlit || borderSize == 0 || borderStyle == NONE)
	// 	{
	// 		super.draw();
	// 		return;
	// 	}
	// 	checkPendingChanges(true);
			
	// 		final colorHelper = Std.int(alpha * 0xFF) << 24 | this.color;
			
	// 		final textColorTransform = textColorTransformDrawHelper;//.reset();
	// 		textColorTransform.setMultipliers(colorHelper);
	// 		if (useTextColor)
	// 			textColorTransform.scaleMultipliers(textColor);
			
	// 		final borderColorTransform = borderColorTransformDrawHelper;//.reset();
	// 		borderColorTransform.setMultipliers(borderColor).scaleMultipliers(colorHelper);
			
	// 		final scaleX:Float = scale.x * _facingHorizontalMult;
	// 		final scaleY:Float = scale.y * _facingVerticalMult;
			
	// 		final originX:Float = _facingHorizontalMult != 1 ? frameWidth - origin.x : origin.x;
	// 		final originY:Float = _facingVerticalMult != 1 ? frameHeight - origin.y : origin.y;
			
	// 		final clippedFrameRect = FlxRect.get(0, 0, frameWidth, frameHeight);

	// 		if (clipRect != null)
	// 			clippedFrameRect.clipTo(clipRect);

	// 		if (clippedFrameRect.isEmpty)
	// 			return;
			
	// 		final charClipHelper = FlxRect.get();
	// 		final charClippedFrame = new FlxFrame(null);
	// 		final screenPos = FlxPoint.get();
			
	// 		final cameras = getCamerasLegacy();
	// 		for (camera in cameras)
	// 		{
	// 			if (!camera.visible || !camera.exists || !isOnScreen(camera))
	// 			{
	// 				continue;
	// 			}

	// 			getScreenPosition(screenPos, camera).subtractPoint(offset);

	// 			if (isPixelPerfectRender(camera))
	// 			{
	// 				screenPos.floor();
	// 			}

	// 			updateTrig();

	// 			if (background)
	// 			{
	// 				// backround tile transformations
	// 				final matrix = matrixDrawHelper;
	// 				matrix.identity();
	// 				matrix.scale(0.1 * clippedFrameRect.width, 0.1 * clippedFrameRect.height);
	// 				matrix.translate(clippedFrameRect.x - originX, clippedFrameRect.y - originY);
	// 				matrix.scale(scaleX, scaleY);

	// 				if (angle != 0)
	// 				{
	// 					matrix.rotateWithTrig(_cosAngle, _sinAngle);
	// 				}

	// 				matrix.translate(screenPos.x + originX, screenPos.y + originY);
	// 				final colorTransform = bgColorTransformDrawHelper.reset();
	// 				colorTransform.setMultipliers(colorHelper).scaleMultipliers(backgroundColor);
	// 				camera.drawPixels(FlxG.bitmap.whitePixel, null, matrix, colorTransform, blend, antialiasing);
	// 			}
				
	// 			final hasColorOffsets = (colorTransform != null && colorTransform.hasRGBAOffsets());
	// 			final drawItem = camera.startQuadBatch(font.parent, true, hasColorOffsets, blend, antialiasing, shader);
	// 			function addQuad(charCode:Int, x:Float, y:Float, color:ColorTransform)
	// 			{
	// 				var frame = font.getCharFrame(charCode);
	// 				if (clipRect != null)
	// 				{
	// 					charClipHelper.copyFrom(clippedFrameRect).offset(-x, -y);
	// 					if (!frame.overlaps(charClipHelper))
	// 						return;
						
	// 					if (!frame.isContained(charClipHelper))
	// 					{
	// 						final oldFrame = frame;
	// 						frame = frame.clipTo(charClipHelper, charClippedFrame);
	// 					final newFrame = frame;
	// 				}
	// 			}
				
				
	// 			final matrix = matrixDrawHelper;
	// 			frame.prepareMatrix(matrix);
	// 			matrix.translate(x - originX, y - originY);
	// 			matrix.scale(scaleX, scaleY);
	// 			if (angle != 0)
	// 			{
	// 				matrix.rotateWithTrig(_cosAngle, _sinAngle);
	// 			}
				
	// 			matrix.translate(screenPos.x + originX, screenPos.y + originY);
	// 			drawItem.addQuad(frame, matrix, color);
	// 		}
			
	// 		// extend the cliprect for the border to ensure non-black pixels are surrounded by black ones
	// 		if (clipRect != null)
	// 		{
	// 			clippedFrameRect.left -= borderSize;
	// 			clippedFrameRect.top -= borderSize;
	// 			clippedFrameRect.right += borderSize;
	// 			clippedFrameRect.bottom += borderSize;
	// 			clippedFrameRect.round();
	// 		}
			
	// 		borderDrawData.forEach(addQuad.bind(_, _, _, borderColorTransform));
			
	// 		// contract the clipRect
	// 		if (clipRect != null)
	// 		{
	// 			clippedFrameRect.left += borderSize;
	// 			clippedFrameRect.top += borderSize;
	// 			clippedFrameRect.right -= borderSize;
	// 			clippedFrameRect.bottom -= borderSize;
	// 			clippedFrameRect.round();
	// 		}
	// 		textDrawData.forEach(addQuad.bind(_, _, _, textColorTransform));
			
	// 		// if (clipRect != null)
	// 		// {
	// 		// 	clippedFrameRect.left -= borderSize;
	// 		// 	clippedFrameRect.top -= borderSize;
	// 		// 	clippedFrameRect.right += borderSize;
	// 		// 	clippedFrameRect.bottom += borderSize;
	// 		// 	clippedFrameRect.round();
	// 		// }
			
	// 		#if FLX_DEBUG
	// 		FlxBasic.visibleCount++;
	// 		#end
	// 	}
		
	// 	// dispose helpers
	// 	charClipHelper.put();
	// 	clippedFrameRect.put();
	// 	screenPos.put();
	// 	charClippedFrame.destroy();
		
	// 	#if FLX_DEBUG
	// 	if (FlxG.debugger.drawDebug)
	// 	{
	// 		drawDebug();
	// 	}
	// 	#end
	// }
}

enum FontType
{
	MAIN(?style:TextStyle);
	MINI(?style:TextStyle);
	FLIXEL(?style:TextStyle);
	CUSTOM(name:String, size:Int, ?style:TextStyle);

	/** Currently just a duplicate of MAIN, but may change */
	DLG(?style:TextStyle);
}

enum TextStyle
{
	/** Black text */
	BLACK;

	/** White text with a black outline */
	WHITE;

	/** text with a black outline, inner color defaults to white */
	COLOR(color:FlxColor);
}

class ScrollingBitmapTextX extends BaseTextBMP
{
	public var scrollX(default, set):Float = 0.0;
	public var maxScrollX(get, never):Float;
	
	function set_scrollX(value:Float)
	{
		if (value > maxScrollX)
			value = maxScrollX;

		if (value < 0)
			value = 0;

		updateScroll();

		return scrollX = value;
	}
	
	function get_maxScrollX()
	{
		checkPendingChanges(true);
		return textWidth - clip.width;
	}

	final clip = FlxRect.get();
	var initted = false;

	public function new(x = 0.0, y = 0.0, ?text:String, fieldWidth:Int, ?font:FontType)
	{
		super(x, y, text, 0, font);

		multiLine = false;
		autoSize = true;
		clip.set(0, 0, fieldWidth, lineHeight);
		initted = true;
		updateScroll();
		// checkPendingChanges();
	}

	function updateScroll()
	{
		clipRect = null;

		clip.height = lineHeight;
		clipRect = clip;
	}
	
	override function updateText()
	{
		super.updateText();
		
		updateScroll();
	}

	override function set_fieldWidth(value:Int):Int
	{
		_fieldWidth = 0;
		if (initted)
		{
			clip.width = value;
			updateScroll();
		}
		return value;
	}

	override function get_fieldWidth():Int
	{
		return Math.round(clip.width);
	}
	
	// static final borderColorTransformDrawHelper = new ColorTransform();
	// static final textColorTransformDrawHelper = new ColorTransform();
	// override function renderTileData(?frameRect:FlxRect, drawFunc:(frame:FlxFrame, x:Float, y:Float, color:ColorTransform)->Void)
	// {
	// 	final colorHelper = Std.int(alpha * 0xFF) << 24 | this.color;
		
	// 	final textColorTransform = textColorTransformDrawHelper.reset();
	// 	textColorTransform.setMultipliers(colorHelper);
	// 	if (useTextColor)
	// 		textColorTransform.scaleMultipliers(textColor);
		
	// 	final borderColorTransform = borderColorTransformDrawHelper.reset();
	// 	borderColorTransform.setMultipliers(borderColor).scaleMultipliers(colorHelper);
		
	// 	lineDrawData.forEachTrimmed(frameRect, padding - Math.round(scrollX), padding, function (frame, x, y)
	// 	{
	// 		forEachBorder(function (xOffset, yOffset)
	// 		{
	// 			drawFunc(frame, x + xOffset, y + yOffset, borderColorTransform);
	// 		});
	// 	});
		
	// 	lineDrawData.forEachTrimmedI(frameRect, padding - Math.round(scrollX), padding, drawFunc.bind(_, _, _, textColorTransform));
	// }

	override function drawText(posX:Int, posY:Int, isFront = true, ?bitmap, useTiles = false)
	{
		super.drawText(posX - Math.round(scrollX), posY, isFront, bitmap, useTiles);
	}
	
	// override function renderTileData(?frameRect:FlxRect, offsetX:Float, offsetY:Float, drawFunc:CharDrawFunction)
	// {
	// 	super.renderTileData(frameRect, offsetX - Math.round(scrollX), offsetY, drawFunc);
	// }
}


class ScrollText extends FlxText
{
    public var scrollX(default, set):Int;
    function set_scrollX(value:Int)
    {
        scrollX = value;
        updateScroll();
        return scrollX;
    }
    
    final clip = FlxRect.get();
    var initted = false;
    
    public function new (x = 0.0, y = 0.0, ?text, fieldWidth:Int, font)
    {
        super(x, y, text, font);
        wordWrap = false;
        autoSize = true;
        clip.set(0, 0, fieldWidth, frameHeight);
        initted = true;
        updateScroll();
    }
    
    function updateScroll()
    {
        clipRect = null;
        
        if (scrollX > width - clip.width)
            scrollX = Math.round(width - clip.width);
        
        if (scrollX < 0)
            scrollX = 0;
        
        clip.height = frameHeight;
        clipRect = clip;
    }
}

class ScrollingBitmapTextY extends BaseTextBMP
{
	public var scrollY(default, set):Float = 0;
	public var maxScrollY(get, never):Float;

	public var fieldHeight(get, set):Int;

	function set_scrollY(value:Float)
	{
		if (value > maxScrollY)
			value = maxScrollY;

		if (value < 0)
			value = 0;

		updateScroll();

		return scrollY = value;
	}

	function get_maxScrollY()
	{
		return textHeight - clip.height;
	}

	final clip = FlxRect.get();
	var initted = false;

	public function new(x = 0.0, y = 0.0, ?text:UnicodeString, fieldWidth:Int, fieldHeight:Int, ?font:FontType)
	{
		super(x, y, text, fieldWidth, font);

		multiLine = true;
		autoSize = false;
		clip.set(0, 0, fieldWidth, fieldHeight);
		initted = true;
		updateScroll();
	}

	function updateScroll()
	{
		clipRect = null;

		clip.width = textWidth;
		clipRect = clip;
	}

	override function updateText()
	{
		super.updateText();

		updateScroll();
	}

	override function set_fieldWidth(value:Int):Int
	{
		if (value == 0)
			throw "Cannout use autosize (fieldWidth: 0) in ScrollingBitmapTextY";
		
		super.set_fieldWidth(value);
		if (initted)
			updateScroll();
		
		return value;
	}

	function set_fieldHeight(value:Int):Int
	{
		if (initted)
		{
			clip.height = value;
			updateScroll();
		}
		return value;
	}

	function get_fieldHeight():Int
	{
		return Math.round(clip.height);
	}
	
	// static final borderColorTransformDrawHelper = new ColorTransform();
	// static final textColorTransformDrawHelper = new ColorTransform();
	// override function renderTileData(?frameRect:FlxRect, drawFunc:CharDrawFunction)
	// {
	// 	final colorHelper = Std.int(alpha * 0xFF) << 24 | this.color;
		
	// 	final borderColorTransform = borderColorTransformDrawHelper.reset();
	// 	borderColorTransform.setMultipliers(borderColor).scaleMultipliers(colorHelper);
		
	// 	// Draw the background text
	// 	lineDrawData.forEachTrimmedI(frameRect, padding, padding - Math.round(scrollY), function (frame, x, y, charIndex, lineIndex)
	// 	{
	// 		forEachBorder(function (xOffset, yOffset)
	// 		{
	// 			drawFunc(frame, x + xOffset, y + yOffset, borderColorTransform, charIndex, lineIndex, true);
	// 		});
	// 	});
		
	// 	// Draw the foreground text
	// 	final textColorTransform = textColorTransformDrawHelper.reset();
	// 	textColorTransform.setMultipliers(colorHelper);
	// 	if (useTextColor)
	// 		textColorTransform.scaleMultipliers(textColor);
		
	// 	lineDrawData.forEachTrimmedI(frameRect, padding, padding - Math.round(scrollY), drawFunc.bind(_, _, _, textColorTransform, _, _, false));
	// }
	
    override function drawText(posX:Int, posY:Int, isFront = true, ?bitmap, useTiles = false)
    {
        super.drawText(posX, posY - Math.round(scrollY), isFront, bitmap, useTiles);
    }
	
	// override function renderTileData(?frameRect:FlxRect, offsetX:Float, offsetY:Float, drawFunc:CharDrawFunction)
	// {
	// 	super.renderTileData(frameRect, offsetX, offsetY - Math.round(scrollY), drawFunc);
	// }
}

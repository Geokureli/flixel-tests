package sprites;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxMath;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.display.BitmapData;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sprites.slice.FrameSlices;
import sprites.slice.SliceSection;

/**
 * A `FlxSprite` with a 9-slice scaling. The `sliceRect` determines how to divide the 9 sections,
 * and `displayWidth` and `displayHeight` determine how much the frame is stretched when drawn.
 * If `sliceRect` is null, and the curret frame's `slice` is non-null, that slice rect is used
 * 
 * **Note:** All of the slicing functionality is done via `FlxSpriteSlicer`, making it easy to
 * add to any other class that extends FlxSprite
 * 
 * @since 6.2.0
 */
class SliceSprite extends flixel.FlxSprite
{
	/**
	 * Controls the slicing of this sprite, `null` means no slicing
	 */
	public var sliceRect:Null<FlxRect>;
	
	/**
	 * The current, active slicing rect, used internally to detect changes to `rect`
	 */
	var currentRect = new FlxRect(Math.NaN);
	var frameDirty = false;
	
	/**
	 * Internal frames used to draw each of the 9 sections
	 */
	var subframes:SliceSectionList<FlxFrame>;
	
	/**
	 * Internal rects that define where each section will be drawn
	 */
	var destRects:SliceSectionList<FlxRect>;
	
	/**
	 * How large to draw the sliced sprite, relative to the `frameWidth`.
	 * If the value is `0` or less, the frameWidth is used
	 */
	public var displayWidth:Float;
	
	/**
	 * How large to draw the sliced sprite, relative to the `frameHeight`
	 * If the value is `0` or less, the frameWidth is used
	 */
	public var displayHeight:Float;
	
	var lastDisplayWidth:Float = 0.0;
	var lastDisplayHeight:Float = 0.0;
	
	public function new (x = 0.0, y = 0.0)
	{
		subframes = [for (section in SliceSection) new FlxFrame(null)];
		super(x, y);
	}
	
	public function makeSliceGraphic(fillColor = FlxColor.BLACK, borderColor = FlxColor.WHITE, edgeRound = 1, ?uniqueKey:String)
	{
		sliceRect = new FlxRect(4, 4, 1, 1);
		final key = DrawTools.createKey();
		final graphic = FlxG.bitmap.get(uniqueKey ?? key);
		if (graphic == null)
			loadGraphic(DrawTools.drawBorderRect(fillColor, borderColor, edgeRound, uniqueKey));
	}
	
	override function initVars():Void
	{
		super.initVars();
	}
	
	override function destroy():Void
	{
		super.destroy();
		
		currentRect = FlxDestroyUtil.put(currentRect);
		FlxDestroyUtil.putArray(cast destRects);
		FlxDestroyUtil.destroyArray(cast subframes);
		destRects = null;
		subframes = null;
	}
	
	/**
	 * Whether this slicer is needed given the current slice rect and desired display size
	 */
	public function hasValidSlicing()
	{
		// The frame before the clipRect was applied, compared to targetFrame which is clipped
		final rect = frame.frame;
		return rect != null
			&& displayWidth > 0 && displayHeight > 0
			&& (displayWidth != rect.width || displayHeight != rect.height);
	}
	
	public function setDisplaySize(width:Float, height:Float)
	{
		displayWidth = width;
		displayHeight = height;
	}
	
	public function setScaledDisplaySize(width:Float, height:Float)
	{
		displayWidth = width / scale.x;
		displayHeight = height / scale.y;
	}
	
	function getValidRect(rect:FlxRect)
	{
		return clipValidRect(rect.clone());
	}
	
	function clipValidRect(rect:FlxRect)
	{
		rect.left   = FlxMath.bound(rect.left  , 0, frameWidth );
		rect.top    = FlxMath.bound(rect.top   , 0, frameHeight);
		rect.right  = FlxMath.bound(rect.right , rect.left, frameWidth );
		rect.bottom = FlxMath.bound(rect.bottom, rect.top , frameHeight);
		return rect;
	}
	
	override function updateHitbox()
	{
		return if (hasValidSlicing())
		{
			width = Math.abs(scale.x) * displayWidth;
			height = Math.abs(scale.y) * displayHeight;
			offset.set(-0.5 * (width - displayWidth), -0.5 * (height - displayHeight));
			centerOrigin();
		}
		else 
			super.updateHitbox();
	}
	
	override function getGraphicBounds(?rect:FlxRect):FlxRect
	{
		return if (hasValidSlicing())
		{
			if (rect == null)
				rect = FlxRect.get();
			
			rect.set(x, y);
			if (pixelPerfectPosition)
				rect.floor();
			
			updateCache();
			final sliceOrigin = FlxPoint.get(frameToDisplayXUnsafe(origin.x), frameToDisplayYUnsafe(origin.y));
			final scaledOrigin = FlxPoint.get(sliceOrigin.x * scale.x, sliceOrigin.y * scale.y);
			rect.x += sliceOrigin.x - offset.x - scaledOrigin.x;
			rect.y += sliceOrigin.y - offset.y - scaledOrigin.y;
			final frameWidth = displayWidth > 0 ? displayWidth : frameWidth;
			final frameHeight = displayHeight > 0 ? displayHeight : frameHeight;
			rect.setSize(frameWidth * scale.x, frameHeight * scale.y);
			
			if (angle % 360 != 0)
				rect.getRotatedBounds(angle, scaledOrigin, rect);
			scaledOrigin.put();
			sliceOrigin.put();
			
			return rect;
		}
		else
			super.getGraphicBounds(rect);
	}
	
	override function drawComplex(camera:FlxCamera):Void
	{
		if (hasValidSlicing())
		{
			updateCache();
			
			for (section in SliceSection)
				drawSectionComplex(section, camera);
		}
		else
			super.drawComplex(camera);
	}
	
	/**
	 * Calls `drawFunc` with every valid section
	 * @param   drawFunc  A custom drawing function
	 */
	public function drawCustom(drawFunc:(FlxFrame, FlxRect)->Void)
	{
		updateCache();
		
		for (section=>frame in subframes)
		{
			if (frame.frame.width > 0 && frame.frame.height > 0)
				drawFunc(frame, destRects[section]);
		}
	}
	
	override function viewToFrameHelper(viewX:Float, viewY:Float, ?camera:FlxCamera, ?result:FlxPoint):FlxPoint
	{
		result = super.viewToFrameHelper(viewX, viewY, camera, result);
		
		if (hasValidSlicing())
			displayToFrame(result, result);
		
		return result;
	}
	
	override function worldToFrameSimpleHelper(worldX:Float, worldY:Float, ?result:FlxPoint):FlxPoint
	{
		result = super.worldToFrameSimpleHelper(worldX, worldY, result);
		
		if (hasValidSlicing())
			displayToFrame(result, result);
		
		return result;
	}
	
	override function prepareComplexMatrix(matrix, frame, camera)
	{
		super.prepareComplexMatrix(matrix, frame, camera);
	}
	
	static final globalDrawMatrix = new FlxMatrix();
	@:access(flixel.FlxSprite)
	function drawSectionComplex(section:SliceSection, camera:FlxCamera):Void
	{
		final frame = subframes[section];
		if (frame.frame.width <= 0 || frame.frame.height <= 0)
			return;
		
		final rect = destRects[section];
		
		final matrix = globalDrawMatrix;
		frame.prepareMatrix(matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		// if (clipRect != null)
		// 	matrix.translate(-Math.max(0, clipRect.x), -Math.max(0, clipRect.y));
		
		matrix.scale(rect.width / frame.frame.width, rect.height / frame.frame.height);
		matrix.translate(-origin.x, -origin.y);
		matrix.translate(rect.x, rect.y);
		matrix.scale(scale.x, scale.y);
		
		if (bakedRotationAngle <= 0)
		{
			updateTrig();
			
			if (angle != 0)
				matrix.rotateWithTrig(_cosAngle, _sinAngle);
		}
		
		final point = getScreenPosition(camera).subtract(offset);
		point.add(origin.x, origin.y);
		matrix.translate(point.x, point.y);
		point.put();
		
		if (isPixelPerfectRender(camera))
		{
			matrix.tx = Math.floor(matrix.tx);
			matrix.ty = Math.floor(matrix.ty);
		}
		
		camera.drawPixels(frame, framePixels, matrix, colorTransform, blend, antialiasing, shader);
	}
	
	override function set_frame(frame)
	{
		frameDirty = true;
		return super.set_frame(frame);
	}
	
	function updateCache()
	{
		checkSourceRects();
		checkDestRects();
	}
	
	function checkSourceRects()
	{
		if (sliceRect != null)
		{
			if (rectsNotMatch(sliceRect, currentRect) || frameDirty)
				updateSourceRects(sliceRect);
		}
		else
		{
			currentRect.set(Math.NaN);
		}
	}
	
	function updateSourceRects(rect:FlxRect)
	{
		currentRect.copyFrom(rect);
		frameDirty = false;
		
		final srcBounds = FlxRect.get(0, 0, frameWidth, frameHeight);
		final srcSlice = getValidRect(rect);
		if (clipRect != null)
		{
			srcBounds.copyFrom(clipRect);
			clipValidRect(srcBounds);
			clipToSmart(srcSlice, srcBounds);
		}
		
		final x = [srcBounds.x, srcSlice.x, srcSlice.right, srcBounds.right];
		final y = [srcBounds.y, srcSlice.y, srcSlice.bottom, srcBounds.bottom];
		srcBounds.put();
		srcSlice.put();
		final rectHelper = FlxRect.get();
		
		for (section in SliceSection)
		{
			final col = section.column;
			final row = section.row;
			final sub = subframes[section];
			rectHelper.setBounds(x[col], y[row], x[col + 1], y[row + 1]);
			frame.subFrameTo(rectHelper, sub);
			sub.offset.copyFrom(frame.offset);
			@:privateAccess sub.cacheFrameMatrix();
		}
		rectHelper.put();
		
		updateDestRects();
	}
	
	function checkDestRects()
	{
		if (displayWidth != lastDisplayWidth || displayHeight != lastDisplayHeight)
		{
			lastDisplayWidth = displayWidth;
			lastDisplayHeight = displayHeight;
			
			if (displayWidth > 0 && displayHeight > 0)
				updateDestRects();
		}
	}
	
	function updateDestRects()
	{
		final srcBounds = FlxRect.get(0, 0, frameWidth, frameHeight);
		final srcSlice = getValidRect(currentRect);
		
		if (clipRect != null)
		{
			srcBounds.copyFrom(clipRect);
			clipValidRect(srcBounds);
			clipToSmart(srcSlice, srcBounds);
		}
		
		final x =
			[ frameToDisplayXUnsafe(srcBounds.x)
			, frameToDisplayXUnsafe(srcSlice.x)
			, frameToDisplayXUnsafe(srcSlice.right)
			, frameToDisplayXUnsafe(srcBounds.right)
			];
		final y =
			[ frameToDisplayYUnsafe(srcBounds.y)
			, frameToDisplayYUnsafe(srcSlice.y)
			, frameToDisplayYUnsafe(srcSlice.bottom)
			, frameToDisplayYUnsafe(srcBounds.bottom)
			];
		
		srcBounds.put();
		srcSlice.put();
		
		FlxDestroyUtil.putArray(cast destRects);
		destRects = [];
		
		for (section in SliceSection)
		{
			final col = section.column;
			final row = section.row;
			
			destRects[section] = FlxRect.get().setBounds(x[col], y[row], x[col + 1], y[row + 1]);
			// destRects[section].x += section.column - 1;
			// destRects[section].y += section.row - 1;
		}
	}
	
	/**
	 * Transforms the given position from the original frame to where it will be
	 * drawn, relative to the target's position
	 * @param   x  A position on the original frame
	 */
	public function frameToDisplayX(x:Float)
	{
		return hasValidSlicing() ? frameToDisplayXUnsafe(x) : x;
	}
	
	/**
	 * Transforms the given position from the original frame to where it will be
	 * drawn, relative to the target's position
	 * @param   y  A position on the original frame
	 */
	public function frameToDisplayY(y:Float)
	{
		return hasValidSlicing() ? frameToDisplayYUnsafe(y) : y;
	}
	
	function frameToDisplayXUnsafe(x:Float)
	{
		if (x < currentRect.x)
			return x;
		
		if (x > currentRect.right)
			return displayWidth - frameWidth + x;
		
		final middleScaleX = (displayWidth - frameWidth + currentRect.width) / currentRect.width;
		return currentRect.x + (x - currentRect.x) * middleScaleX;
	}
	
	function frameToDisplayYUnsafe(y:Float)
	{
		if (y < currentRect.y)
			return y;
		
		if (y > currentRect.bottom)
			return displayHeight - frameHeight + y;
		
		final middleScaleY = (displayHeight - frameHeight + currentRect.height) / currentRect.height;
		return currentRect.y + (y - currentRect.y) * middleScaleY;
	}
	
	overload public inline extern function displayToFrame(display:FlxPoint, ?result:FlxPoint):FlxPoint
	{
		return displayToFrameHelper(display.x, display.y, result);
	}
	
	overload public inline extern function displayToFrame(displayX:Float, displayY:Float, ?result:FlxPoint):FlxPoint
	{
		return displayToFrameHelper(displayX, displayY, result);
	}
	
	function displayToFrameHelper(displayX:Float, displayY:Float, ?result:FlxPoint):FlxPoint
	{
		if (hasValidSlicing())
		{
			result.x = displayToFrameXUnsafe(displayX);
			result.y = displayToFrameYUnsafe(displayY);
		}
		else
		{
			result.x = displayX;
			result.y = displayY;
		}
		
		return result;
	}
	
	/**
	 * Transforms the given position from the stretched display to the original frame
	 * @param   x  A position on the stretched display
	 */
	public function displayToFrameX(x:Float)
	{
		return hasValidSlicing() ? displayToFrameXUnsafe(x) : x;
	}
	
	/**
	 * Transforms the given position from the stretched display to the original frame
	 * @param   y  A position on the stretched display
	 */
	public function displayToFrameY(y:Float)
	{
		return hasValidSlicing() ? displayToFrameYUnsafe(y) : y;
	}
	
	function displayToFrameXUnsafe(x:Float)
	{
		if (x < sliceRect.x)
			return x;
		
		if (x > displayWidth - (frameWidth - sliceRect.right))
			return x - displayWidth + frameWidth;
		
		final middleScaleX = (displayWidth - frameWidth + sliceRect.width) / sliceRect.width;
		return (x - sliceRect.x) / middleScaleX + sliceRect.x;
	}
	
	function displayToFrameYUnsafe(y:Float)
	{
		if (y < sliceRect.y)
			return y;
		
		if (y > displayHeight - (frameHeight - sliceRect.bottom))
			return y - displayHeight + frameHeight;
		
		final middleScaleY = (displayHeight - frameHeight + sliceRect.height) / sliceRect.height;
		return (y - sliceRect.y) / middleScaleY + sliceRect.y;
	}
	
	/**
	 * Similar to clipTo but the result will always be inside b, even if there is no overlap
	 * @param a The rect to clip
	 * @param b The rect to which `a` is clipped
	 */
	function clipToSmart(a:FlxRect, b:FlxRect)
	{
		if (a.left > b.right)
		{
			a.x = b.right;
			a.width = 0;
		}
		else if (a.right < b.left)
		{
			a.x = b.left;
			a.width = 0;
		}
		else
		{
			a.left = a.left < b.left ? b.left : a.left;
			a.right = a.right > b.right ? b.right : a.right;
		}
		
		if (a.top > b.bottom)
		{
			a.y = b.bottom;
			a.height = 0;
		}
		else if (a.bottom < b.top)
		{
			a.y = b.top;
			a.height = 0;
		}
		else
		{
			a.top = a.top < b.y ? b.y : a.y;
			a.bottom = a.bottom > b.bottom ? b.bottom : a.bottom;
		}
		
		return a;
	}
	
	static function rectsMatch(a:FlxRect, b:FlxRect)
	{
		return (a == null && b == null) || (a != null && b != null && a.equals(b));
	}
	
	static function rectsNotMatch(a:FlxRect, b:FlxRect)
	{
		return !rectsMatch(a, b);
	}
}

class DrawTools
{
	static inline var BLACK = FlxColor.BLACK;
	static var frames:Map<String, BitmapData>;
	
	static public function initBorderImages()
	{
		if (frames != null)
			return;
		
		frames = new Map<String, BitmapData>();
		
		final source = FlxG.assets.getBitmapData("assets/images/slice-rects.png");
		FlxG.bitmapLog.add(source, "assets/images/slice-rects.png");
		function saveFrame(num:Int, name:String)
		{
			final bmd = new BitmapData(9, 9, 0x0);
			bmd.copyPixels(source, new Rectangle(9 * num, 0, 9, 9), new Point(0, 0));
			FlxG.bitmapLog.add(bmd, name);
			frames[name] = bmd;
		}
		
		saveFrame(0, "0-true-true");
		saveFrame(1, "1-true-true");
		saveFrame(2, "2-true-true");
		saveFrame(3, "0-true-false");
		saveFrame(4, "1-true-false");
		saveFrame(5, "2-true-false");
		saveFrame(6, "0-false-false");
		saveFrame(7, "1-false-false");
		saveFrame(8, "2-false-false");
	}
	
	static public function createKey(fillColor = BLACK, borderColor = FlxColor.WHITE, edgeRound = 1)
	{
		return 'SliceSprite:$edgeRound-${StringTools.hex(fillColor)}x${StringTools.hex(borderColor)}';
	}
	
	static public function drawBorderRect(fillColor = BLACK, borderColor = FlxColor.WHITE, edgeRound = 1, ?uniqueKey:String)
	{
		initBorderImages();
		
		final unique = FlxG.bitmap.get(uniqueKey);
		if (unique != null)
			return unique;
		
		final key = createKey(fillColor, borderColor, edgeRound);
		final graphic = FlxG.bitmap.get(key);
		if (graphic != null)
			return graphic;
		
		final padOuter = borderColor != BLACK;
		final padInner = borderColor != fillColor && fillColor != BLACK && borderColor != BLACK;
		final borderSize = edgeRound + (padOuter ? 1 : 0) + (padInner ? 1 : 0);
		final graphic = FlxG.bitmap.create(9, 9, 0x0, uniqueKey != null, uniqueKey ?? key);
		graphic.bitmap.fillRect(new Rectangle(edgeRound, edgeRound, 9 - (edgeRound * 2), 9 - (edgeRound * 2)), fillColor);
		final frame = frames['$edgeRound-$padOuter-$padInner'];
		final clr = new ColorTransform(borderColor.redFloat, borderColor.greenFloat, borderColor.blueFloat);
		graphic.bitmap.draw(frame, null, clr);
		FlxG.bitmapLog.add(graphic);
		return graphic;
	}
}
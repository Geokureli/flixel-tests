package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxColor;

import openfl.display.BitmapData;
import openfl.system.System;

using flixel.util.FlxStringUtil;
using flixel.util.FlxUnicodeUtil;
using StringTools;

/**
 * https://github.com/HaxeFlixel/flixel/pull/2656
 */
class FlxTextTestState2656 extends flixel.FlxState
{
	var nonFixed:FlxNonFixedText;
	var fixedText:FlxFixedText;

	var ram:FlxFixedText;
	var rambf:FlxFixedText;
	var ramaf:FlxFixedText;

	override public function create():Void
	{
		//FlxGraphic.defaultPersist = true;

		var halfWidth = Std.int(FlxG.width / 2);

		var header = new FlxFixedText(0, 70, halfWidth, "Before Fix");
		header.size = 16;
		header.alignment = CENTER;
		add(header);
		var header = new FlxFixedText(halfWidth, 70, halfWidth, "After Fix");
		header.size = 16;
		header.alignment = CENTER;
		add(header);

		ram = new FlxFixedText(0, FlxG.height - 50, FlxG.width, "0 bytes");
		ram.size = 16;
		ram.alignment = CENTER;
		add(ram);
		rambf = new FlxFixedText(0, FlxG.height - 50, halfWidth, "0");
		rambf.size = 16;
		rambf.alignment = CENTER;
		add(rambf);
		ramaf = new FlxFixedText(halfWidth, FlxG.height - 50, halfWidth, "0");
		ramaf.size = 16;
		ramaf.alignment = CENTER;
		add(ramaf);

		nonFixed = new FlxNonFixedText(0, 0, halfWidth, "");
		nonFixed.cacheKey = "b";
		nonFixed.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		nonFixed.scrollFactor.set();
		nonFixed.borderSize = 1.25;
		nonFixed.screenCenter(Y);

		fixedText = new FlxFixedText(halfWidth, 0, halfWidth, "");
		fixedText.cacheKey = "a";
		fixedText.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fixedText.scrollFactor.set();
		fixedText.borderSize = 1.25;
		fixedText.screenCenter(Y);

		add(nonFixed);
		add(fixedText);
	}

	var frame = 0;

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		frame++;

		if(!FlxG.keys.pressed.B) {
			nonFixed.text = Std.string(frame);
		}
		if(!FlxG.keys.pressed.A) {
			fixedText.text = Std.string(frame);
		}
		
		/*var ramBeforeFix = 0;
		var ramFix = 0;

		var cache = @:privateAccess FlxG.bitmap._cache;

		for(name => item in cache) {
			if(name.charAt(0) == "b") {
				ramBeforeFix += item.width * item.height * 4;
			}
			else if(name.charAt(0) == "a") {
				ramFix += item.width * item.height * 4;
			}
			//trace(name);
		}*/

		rambf.text = Std.string(nonFixed.totalGenerated);
		ramaf.text = Std.string(fixedText.totalGenerated);

		ram.text = Std.string(Math.floor(System.totalMemory / 1024)) + " kb";

		// Requires FlxGraphic.defaultPersist = true;
		//rambf.text = Std.string(Math.floor(ramBeforeFix / 1024 * 1000) / 1000) + " kb";
		//ramaf.text = Std.string(Math.floor(ramFix / 1024 * 1000) / 1000) + " kb";
	}
}

class FlxFixedText extends FlxText
{
	public var cacheKey:String = "text";
	public var totalGenerated:Int = 0;

	override function regenGraphic():Void
	{
		if (textField == null || !_regen) {
			return;
		}

		var oldWidth:Int = 0;
		var oldHeight:Int = FlxText.VERTICAL_GUTTER;

		if (graphic != null)
		{
			oldWidth = graphic.width;
			oldHeight = graphic.height;
		}

		var newWidth:Float = textField.width;
		// Account for gutter
		var newHeight:Float = textField.textHeight + FlxText.VERTICAL_GUTTER;

		// prevent text height from shrinking on flash if text == ""
		if (textField.textHeight == 0)
		{
			newHeight = oldHeight;
		}

		if (oldWidth != Std.int(newWidth) || oldHeight != Std.int(newHeight))
		{
			// Need to generate a new buffer to store the text graphic
			height = newHeight;
			var key:String = FlxG.bitmap.getUniqueKey(cacheKey);
			makeGraphic(Std.int(newWidth), Std.int(newHeight), FlxColor.TRANSPARENT, false, key);

			if (_hasBorderAlpha)
				_borderPixels = graphic.bitmap.clone();
			frameHeight = Std.int(height);
			textField.height = height * 1.2;
			_flashRect.x = 0;
			_flashRect.y = 0;
			_flashRect.width = newWidth;
			_flashRect.height = newHeight;

			totalGenerated++;
		}
		else // Else just clear the old buffer before redrawing the text
		{
			graphic.bitmap.fillRect(_flashRect, FlxColor.TRANSPARENT);
			if (_hasBorderAlpha)
			{
				if (_borderPixels == null)
					_borderPixels = new BitmapData(frameWidth, frameHeight, true);
				else
					_borderPixels.fillRect(_flashRect, FlxColor.TRANSPARENT);
			}
		}

		if (textField != null && textField.text != null && textField.text.length > 0)
		{
			// Now that we've cleared a buffer, we need to actually render the text to it
			copyTextFormat(_defaultFormat, _formatAdjusted);

			_matrix.identity();

			applyBorderStyle();
			applyBorderTransparency();
			applyFormats(_formatAdjusted, false);

			drawTextFieldTo(graphic.bitmap);
		}

		_regen = false;
		resetFrame();
	}
}

class FlxNonFixedText extends FlxText
{
	public var cacheKey:String = "text";
	public var totalGenerated:Int = 0;

	override function regenGraphic():Void
	{
		if (textField == null || !_regen) {
			return;
		}

		var oldWidth:Int = 0;
		var oldHeight:Int = FlxText.VERTICAL_GUTTER;

		if (graphic != null)
		{
			oldWidth = graphic.width;
			oldHeight = graphic.height;
		}

		var newWidth:Float = textField.width;
		// Account for gutter
		var newHeight:Float = textField.textHeight + FlxText.VERTICAL_GUTTER;

		// prevent text height from shrinking on flash if text == ""
		if (textField.textHeight == 0)
		{
			newHeight = oldHeight;
		}

		if (oldWidth != newWidth || oldHeight != newHeight)
		{
			// Need to generate a new buffer to store the text graphic
			height = newHeight;
			var key:String = FlxG.bitmap.getUniqueKey(cacheKey);
			makeGraphic(Std.int(newWidth), Std.int(newHeight), FlxColor.TRANSPARENT, false, key);

			if (_hasBorderAlpha)
				_borderPixels = graphic.bitmap.clone();
			frameHeight = Std.int(height);
			textField.height = height * 1.2;
			_flashRect.x = 0;
			_flashRect.y = 0;
			_flashRect.width = newWidth;
			_flashRect.height = newHeight;

			totalGenerated++;
		}
		else // Else just clear the old buffer before redrawing the text
		{
			graphic.bitmap.fillRect(_flashRect, FlxColor.TRANSPARENT);
			if (_hasBorderAlpha)
			{
				if (_borderPixels == null)
					_borderPixels = new BitmapData(frameWidth, frameHeight, true);
				else
					_borderPixels.fillRect(_flashRect, FlxColor.TRANSPARENT);
			}
		}

		if (textField != null && textField.text != null && textField.text.length > 0)
		{
			// Now that we've cleared a buffer, we need to actually render the text to it
			copyTextFormat(_defaultFormat, _formatAdjusted);

			_matrix.identity();

			applyBorderStyle();
			applyBorderTransparency();
			applyFormats(_formatAdjusted, false);

			drawTextFieldTo(graphic.bitmap);
		}

		_regen = false;
		resetFrame();
	}
}
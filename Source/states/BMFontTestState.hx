package states;

import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import openfl.utils.Assets;

class BMFontTestState extends flixel.FlxState
{
	override public function create()
	{
		super.create();
		
		final texts = new FlxTypedSpriteGroup();
		var y = 0.0;
		
		function createText(fontKey:String, text:String)
		{
			// use a unique bitmap data to prevent caching from using a cahced font
			final graphic = FlxG.bitmap.add('assets/fonts/DigitalPup.png', true);
			final font = FlxBitmapFont.fromAngelCode(graphic, fontKey);
			final text = new FlxBitmapText(0, y, text, font);
			y += text.height + 5;
			texts.add(text);
		}
		
		createText('assets/fonts/BMFont XML/DigitalPup.xml', 'This font uses XML');
		createText('assets/fonts/BMFont Text/DigitalPup.txt', 'This font uses Text');
		createText('assets/fonts/BMFont Binary/DigitalPup.fnt', 'This font uses Binary');
		add(texts);
		texts.screenCenter();
	}
}

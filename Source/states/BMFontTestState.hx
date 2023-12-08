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
		
		// var x = 0.0;
		var y = 0.0;
		function createGroup(assetId:String)
		{
			// var y = 0.0;
			final texts = new FlxTypedSpriteGroup<FlxBitmapText>();
			
			function createText(fontKey:String, text:String)
			{
				// use a unique bitmap data to prevent caching from using a cached font
				final graphic = FlxG.bitmap.add('assets/fonts/$assetId.png', true);
				final font = FlxBitmapFont.fromAngelCode(graphic, fontKey);
				final text = new FlxBitmapText(0, y, text, font);
				y += text.height + 5;
				trace(text.width);
				return text;
			}
			
			texts.add(createText('assets/fonts/$assetId.xml', 'This $assetId font uses XML'));
			texts.add(createText('assets/fonts/$assetId.txt', 'This $assetId font uses Text'));
			texts.add(createText('assets/fonts/$assetId.fnt', 'This $assetId font uses Binary'));
			// x += texts.width + 5;
			
			return texts;
		}
		
		final groups = new FlxTypedSpriteGroup<FlxTypedSpriteGroup<FlxBitmapText>>();
		groups.add(createGroup("DigitalPup"));
		groups.add(createGroup("arial"));
		groups.screenCenter();
		add(groups);
	}
}

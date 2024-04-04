package states;

import flixel.group.FlxSpriteContainer;
import flixel.FlxG;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import openfl.utils.Assets;

class BMFontTestState extends flixel.FlxState
{
	override public function create()
	{
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.mouse.pressed && length == 0)
		{
			createAllTexts();
		}
	}
	
	public function createAllTexts()
	{
		final groups = new FlxTypedSpriteContainer<FlxTypedSpriteContainer<FlxBitmapText>>();
		// var x = 0.0;
		var y = 0.0;
		function createGroup(assetId:String)
		{
			if (Assets.exists('fonts/$assetId.png') == false)
				return;
			
			// var y = 0.0;
			final texts = new FlxTypedSpriteContainer<FlxBitmapText>();
			groups.add(texts);
			
			function createText(fontKey:String, text:String)
			{
				// use a unique bitmap data to prevent caching from using a cached font
				final graphic = FlxG.bitmap.add('fonts/$assetId.png', true);
				final font = FlxBitmapFont.fromAngelCode(graphic, fontKey);
				final text = new FlxBitmapText(0, y, text, font);
				y += text.height + 5;
				
				texts.add(text);
			}
			
			createText('fonts/$assetId.xml', 'This $assetId font uses XML!');
			createText('fonts/$assetId.txt', 'This $assetId font uses Text!');
			createText('fonts/$assetId.fnt', 'This $assetId font uses Binary!');
			y += 5;// group spacing
			// x += texts.width + 5;
		}
		
		createGroup("digitalpup");
		createGroup("arial");
		groups.screenCenter();
		add(groups);
	}
}

package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxStrip;
import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;

class FlxStripShaderTestState extends FlxState
{
	override public function create()
	{
		super.create();

		var sprite:FlxSprite;
		add(sprite = createSprite(0, 0));
		
		add(sprite = createSprite(110, 0, FlxColor.BLUE));
		sprite.color = 0xFF000080;
		
		add(sprite = createSprite(220, 0));
		sprite.color = 0xFFff0080;
		
		add(sprite = createSprite(330, 0));
		sprite.shader = new GreenShader();
		
		add(sprite = createSprite(440, 0));
		sprite.setColorTransform(.5, 1.0, 0.0, 0x40, 0x40, 0x40);
		
		// strips
		
		var strip:FlxStrip;
		add(strip = createStrip(0, 110));

		add(strip = createStrip(110, 110, FlxColor.BLUE));
		strip.color = 0xFF000080;
		
		add(strip = createStrip(220, 110));
		strip.color = 0xFFff0080;
		
		add(strip = createStrip(330, 110));
		strip.shader = new GreenShader();
		
		add(strip = createStrip(440, 110));
		strip.setColorTransform(.5, 1.0, 0.0, 0x40, 0x40, 0x40);
		
		// tiled-sprite
		
		final background = new FlxTiledSprite("assets/images/haxe.png", FlxG.width - 20, FlxG.width - 210);
		background.x = 10;
		background.y = 200;
		add(background);
	}
	
	function createSprite(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		return new FlxSprite(x, y).makeGraphic(100, 100, color);
	}
	
	function createStrip(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		var strip:FlxStrip;
		strip = new FlxStrip(x, y);
		strip.makeGraphic(100, 100, color);
		strip.vertices = DrawData.ofArray([0.0, 0.0, 50, 0, 25, 50]);
		strip.indices = DrawData.ofArray([0, 1, 2]);
		strip.uvtData = DrawData.ofArray([0, 0, 0, 1, 1, 1.0]);
		return strip;
	}
}

class GreenShader extends FlxShader
{
	@glFragmentSource('
	#pragma header

	void main()
	{
		vec4 clr = texture2D(bitmap, openfl_TextureCoordv);
		gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0) * clr.a;
	}
	')
	public function new()
	{
		super();
	}
}
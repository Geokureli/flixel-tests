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

		createSet(0,   0, createSprite);
		createSet(0, 160, createStrip);
		createSet(0, 320, createTile);
	}
	
	inline static var WIDTH = 160;
	function createSet(x = 0.0, y = 0.0, func:(Float, Float, ?Int)->FlxSprite)
	{
		var sprite:FlxSprite;
		add(sprite = func(x, y));
		x += WIDTH;
		
		add(sprite = func(x, y, FlxColor.BLUE));
		sprite.color = 0xFF000080;
		x += WIDTH;
		
		add(sprite = func(x, y));
		sprite.color = 0xFFff0080;
		x += WIDTH;
		
		add(sprite = func(x, y));
		sprite.shader = new GreenShader();
		x += WIDTH;
		
		add(sprite = func(x, y));
		sprite.setColorTransform(1.0, 0.5, 0.0, 1.0, 0x40, 0x40, 0x40, 0);
		x += WIDTH;
	}
	
	function createSprite(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		return new FlxSprite(x, y).makeGraphic(150, 150, color);
	}
	
	function createStrip(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		var strip:FlxStrip;
		strip = new FlxStrip(x, y);
		strip.makeGraphic(150, 150, color);
		strip.vertices = DrawData.ofArray([0.0, 0.0, 150, 0.0, 75, 150]);
		strip.indices = DrawData.ofArray([0, 1, 2]);
		strip.uvtData = DrawData.ofArray([0, 0, 0, 1, 1, 1.0]);
		return strip;
	}
	
	function createTile(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		final tile = new FlxTiledSprite("assets/images/haxe.png", 150, 150);
		tile.x = x;
		tile.y = y;
		return tile;
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
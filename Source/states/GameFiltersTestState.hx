package states;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import openfl.filters.ShaderFilter;

class GameFiltersTestState extends flixel.FlxState
{
	override public function create():Void
	{
		FlxG.cameras.bgColor = 0xFF808080;
		super.create();
		FlxG.game.scrollRect = new openfl.geom.Rectangle(0, 0, FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		// @:privateAccess
		// FlxG.game. = new openfl.geom.Rectangle(0, 0, FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		
		FlxG.game.setFilters([new ShaderFilter(new BorderShader())]);
		FlxG.game.filtersEnabled = true;

		final text = new FlxText("Hello World!");
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.mouse.pressed)
			FlxG.camera.shake(0.01, 0.1);
		
		if (FlxG.keys.justPressed.SPACE)
			FlxG.game.filtersEnabled = !FlxG.game.filtersEnabled;
		
		if (FlxG.keys.justPressed.A)
		{
			FlxG.game.scrollRect = FlxG.game.scrollRect != null ? null : new openfl.geom.Rectangle(0, 0, FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		}
		
		if (FlxG.keys.justPressed.Q)
			FlxG.game.soundTray.visible = FlxG.game.soundTray.visible;
		
		if (FlxG.keys.justPressed.W)
			FlxG.game.debugger.visible = FlxG.game.debugger.visible;
		
		for (i=>key in [FlxKey.ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT])
		{
			if (FlxG.keys.anyJustPressed([key]))
				FlxG.game.getChildAt(i).visible = FlxG.game.getChildAt(i).visible;
		}
	}
}

class BorderShader extends FlxShader
{
	
	@:glFragmentSource("
		#pragma header
		
		const float pixelSize = 4.0;
		
		vec2 pxFloor(vec2 coord, float size)
		{
			return coord - mod(coord, size / openfl_TextureSize);
		}
		
		vec2 px(vec2 coord, float size, vec2 offset)
		{
			return pxFloor(coord, size) + (size * offset / openfl_TextureSize);
		}
		
		vec2 px(vec2 coord, float size, bool center)
		{
			return px(coord, size, vec2(float(center) * 0.5));
		}
		
		vec2 px(vec2 coord, float size)
		{
			return px(coord, size, vec2(0.5));
		}
		
		void main()
		{
			vec2 uv = px(openfl_TextureCoordv, pixelSize);
			vec3 col = texture2D(bitmap, uv).rgb;
			
			if ((uv.x > 0.0 && uv.x < 0.2) || (uv.x < 1.0 && uv.x > 0.8) || (uv.y > 0.0 && uv.y < 0.2) || (uv.y < 1.0 && uv.y > 0.8)) {
				gl_FragColor = vec4(1., col.gb, 1.);
				return;
			}
			gl_FragColor = vec4(col, 1.);
		}
	")
	
	public function new() 
	{
		super();
	}
}
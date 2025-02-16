package states;

class ShaderColorTestState extends flixel.FlxState
{
	override public function create()
	{
		super.create();
		
		final sprite = new flixel.FlxSprite().makeGraphic(100, 100);
		sprite.shader = new flixel.system.FlxAssets.FlxShader();
		sprite.color = 0xFFff00ff;
		add(sprite);
	}
}

class SimpleShader extends flixel.system.FlxAssets.FlxShader
{
	@:glFragmentSource('
		#pragma header
		
		void main()
		{
			gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
		}
	')
	public function new()
	{
		super();
	}
}

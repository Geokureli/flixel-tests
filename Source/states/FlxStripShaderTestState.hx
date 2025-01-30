package states;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.tweens.FlxTween;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxStrip;
import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxShader;
import flixel.util.FlxColor;
import flixel.addons.effects.FlxClothSprite;

#if spinehaxe
import flixel.addons.editors.spine.FlxSpine;
import spinehaxe.SkeletonData;
#end

class FlxStripShaderTestState extends FlxState
{
	inline static var SCALE = 2;
	inline static var SIZE = 75 * SCALE;
	inline static var GAP = 5 * SCALE;
	inline static var SPACING = SIZE + GAP;
	
	var colored = new FlxTypedGroup<FlxSprite>();
	var shaded = new FlxTypedGroup<FlxSprite>();
	
	override public function create()
	{
		super.create();

		createSet(0, SPACING * 0, createSprite);
		createSet(0, SPACING * 1, createStrip);
		createSet(0, SPACING * 2, createTile);
		createSet(0, SPACING * 3, createFlag);
		createSet(0, SPACING * 4, createSkew);
		
		#if spinehaxe
		final skeleton = FlxSpine.readSkeletonData("spineboy", "spineboy", "assets/spine/", 0.6);
		add(new SpineBoyTest(skeleton, 0, SPACING * 4));
		#end
	}
	
	function createSet(x = 0.0, y = 0.0, func:(Float, Float, ?Int)->FlxSprite)
	{
		var sprite:FlxSprite;
		add(sprite = func(x, y));
		x += SPACING;
		
		add(sprite = func(x, y));
		colored.add(sprite);
		sprite.color = 0xFFff0080;
		x += SPACING;
		
		add(sprite = func(x, y));
		shaded.add(sprite);
		sprite.shader = new GreenShader();
		x += SPACING;
		
		add(sprite = func(x, y));
		sprite.setColorTransform(1.0, 0.5, 0.0, 1.0, 0x40, 0x40, 0x40, 0);
		x += SPACING;
		
		add(sprite = func(x, y));
		sprite.scale.scale(0.5, 0.5);
		x += SPACING;
	}
	
	function createFlag(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		final flag = new FlxClothSprite(x, y, "assets/images/haxe.png");
		flag.pinnedSide = NONE;
		flag.meshScale.set(1.5, 1);
		flag.setMesh(15, 10, 0, 0, [0, 14]);
		flag.iterations = 8;
		flag.maxVelocity.set(200, 200);
		flag.meshVelocity.y = 40;
		return flag;
	}
	
	function createSprite(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		final sprite = new FlxSprite(x, y, "assets/images/haxe.png");
		sprite.scale.set(SIZE / sprite.frameWidth, SIZE / sprite.frameHeight);
		sprite.updateHitbox();
		return sprite;
	}
	
	function createStrip(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		var strip:FlxStrip;
		strip = new FlxStrip(x, y, "assets/images/haxe.png");
		// strip.makeGraphic(SIZE, SIZE, color);
		strip.vertices = DrawData.ofArray([0.0, 0.0, SIZE, 0.0, SIZE / 2, SIZE]);
		strip.indices = DrawData.ofArray([0, 1, 2]);
		strip.uvtData = DrawData.ofArray([0, 0, 0, 1, 1, 1.0]);
		return strip;
	}
	
	function createSkew(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		var sprite:FlxSkewedSprite;
		sprite = new FlxSkewedSprite(x, y, "assets/images/haxe.png");
		sprite.skew.set(50, 0);
		return sprite;
	}
	
	function createTile(x = 0.0, y = 0.0, color = 0xFFffffff)
	{
		final tile = new FlxTiledSprite("assets/images/haxe.png", SIZE, SIZE);
		tile.x = x;
		tile.y = y;
		return tile;
	}
	
	static final colors = [0xFFff0000, 0xFFffff00, 0xFF00ff00, 0xFF00ffff, 0xFF0000ff, 0xFFff00ff];
	var timer = 0.0;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		timer += elapsed;
		
		final cycleTime = 3.0;
		final loopTime = ((timer / cycleTime) % 1.0) * colors.length;
		final color1 = Math.floor(loopTime);
		final color2 = (color1 + 1) % colors.length;
		final factor = loopTime - color1;
		
		for (sprite in colored)
			sprite.color = FlxColor.interpolate(colors[color1], colors[color2], factor);
	}
}

class GreenShader extends FlxShader
{
	@glFragmentSource('
	#pragma header

	void main()
	{
		vec4 color = texture2D(bitmap, openfl_TextureCoordv);
		gl_FragColor = vec4(color.r / 2.0, 1.0, color.b / 2.0, color.a);
	}
	')
	public function new()
	{
		super();
	}
}

#if spinehaxe
/**
 * @author Kris
 */
class SpineBoyTest extends FlxSpine
{
	public function new(skeletonData:SkeletonData, x:Float = 0, y:Float = 0)
	{
		super(skeletonData, x + 80, y + 400);
		antialiasing = true;

		stateData.setMixByName("walk", "jump", 0.2);
		stateData.setMixByName("jump", "walk", 0.4);
		stateData.setMixByName("jump", "jump", 0.2);

		state.setAnimationByName(0, "walk", true);
	}

	override public function update(elapsed:Float):Void
	{
		var anim = state.getCurrent(0);

		if (anim.animation.name == "walk")
		{
			// After one second, change the current animation. Mixing is done by AnimationState for you.
			if (anim.getAnimationTime() > 2)
				state.setAnimationByName(0, "jump", false);
		}
		else
		{
			if (anim.getAnimationTime() > 1)
				state.setAnimationByName(0, "walk", true);
		}

		// if (FlxG.mouse.justPressed)
		// {
		// 	state.setAnimationByName(0, "jump", false);
		// 	state.addAnimationByName(0, "walk", true, 0.5);
		// }

		super.update(elapsed);
	}
}
#end
package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class ColorTransformTestState3413 extends flixel.FlxState
{
	var sprite:FlxSprite;
	var alphaText:FlxText;
	var alphaOffsetText:FlxText;

	var alpha = 1.0;
	var alphaOffset = 0.0;

	override public function create()
	{
		super.create();

		// FlxG.camera.bgColor = 0xFF999999;

		sprite = new FlxSprite(60, 60).makeGraphic(200, 200);
		add(sprite);

		alphaText = new FlxText(60, 280, 0, "", 16);
		add(alphaText);

		alphaOffsetText = new FlxText(60, 320, 0, "", 16);
		add(alphaOffsetText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		final mult = FlxG.keys.pressed.SHIFT ? 10 : 1;

		if (FlxG.keys.pressed.Q)
			setAlpha(alpha - (.1 * elapsed * mult));
		if (FlxG.keys.pressed.E)
			setAlpha(alpha + (.1 * elapsed * mult));
		if (FlxG.keys.justPressed.W)
			setAlpha(1);

		if (FlxG.keys.pressed.A)
			setAlphaOffset(alphaOffset - (0x10 * elapsed * mult));
		if (FlxG.keys.pressed.D)
			setAlphaOffset(alphaOffset + (0x10 * elapsed * mult));
		if (FlxG.keys.justPressed.S)
			setAlphaOffset(0);

		sprite.setColorTransform(
			sprite.colorTransform.redMultiplier, sprite.colorTransform.greenMultiplier, sprite.colorTransform.blueMultiplier, alpha,
			sprite.colorTransform.redOffset,     sprite.colorTransform.greenOffset,     sprite.colorTransform.blueOffset,     alphaOffset
		);

		alphaText.text = "alpha: " + FlxMath.roundDecimal(alpha, 3);
		alphaOffsetText.text = "alphaOffset: " + FlxMath.roundDecimal(alphaOffset, 3);
	}
	
	override function draw()
	{
		super.draw();
	}

	function setAlpha(value:Float)
		alpha = FlxMath.bound(value, 0, 1);

	function setAlphaOffset(value:Float)
		alphaOffset = FlxMath.bound(value, -255, 255);
}
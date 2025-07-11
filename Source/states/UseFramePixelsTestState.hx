package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxNestedSprite;
import flixel.text.FlxText;
import openfl.geom.Rectangle;
import sprites.AnimSprite;

class UseFramePixelsTestState extends flixel.FlxState
{
	var colors = [0xAA0000, 0x00AA00, 0x0000AA, 0xAAAA00, 0x00AAAA];
	var curColor = 0;

	var bugged:FlxSprite;
	var expected:FlxSprite;

	override public function create()
	{
		super.create();

		FlxG.camera.bgColor = 0xFF999999;

		add(new FlxText(20, 20, 0, "Bugged", 16));

		bugged = makeCube(10, 60);
		add(bugged);
		bugged.useFramePixels = true;

		add(new FlxText(150, 20, 0, "Expected", 16));

		expected = makeCube(130, 60);
		add(expected);

		add(new FlxText(290, 20, 0, "Graphic", 16));

		final graphic = makeCube(250, 60);
		add(graphic);

		switchColor();
		new flixel.util.FlxTimer().start(3, switchColor, 0);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Q)
			changeAlpha(-1);
		if (FlxG.keys.justPressed.E)
			changeAlpha(1);
	}

	function makeCube(x:Float, y:Float):FlxSprite
	{
		// can be just solid color sliced into frames
		final cube = new FlxSprite(x, y).makeGraphic(70, 70, 0xFF000000);
        cube.graphic.bitmap.fillRect(new Rectangle(10, 10, 50, 50), 0xFFffffff);
		cube.setGraphicSize(120, 120);
		cube.updateHitbox();
		// cube.animation.add("anim", [0, 1, 2], 8);
		// cube.animation.play("anim");
		return cube;
		// return new AnimSprite(x, y);
	}

	function switchColor(?_)
	{
		final color = colors[curColor];
		bugged.color = color;
		expected.color = color;
		curColor = ++curColor % colors.length;
	}

	function changeAlpha(mult:Int)
	{
		expected.alpha = bugged.alpha += 0.1 * mult;
	}
}

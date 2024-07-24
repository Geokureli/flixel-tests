package states;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;

class LastBlendTestState2 extends FlxState
{
	static final blendModes:Array<BlendMode> = [
		NORMAL, ADD, ALPHA, DARKEN, DIFFERENCE, ERASE, HARDLIGHT, INVERT, LAYER, LIGHTEN, MULTIPLY, OVERLAY, SCREEN, SHADER, SUBTRACT
	];
	var sprite2:FlxSprite;
	var text:FlxText;
	
	override public function create():Void
	{
		super.create();
		
		text = new FlxText(0, 0, 0, "Invert", 32);
		text.color = 0xFF000000;
		text.screenCenter(X);
		add(text);
		
		FlxG.camera.bgColor = FlxColor.WHITE;
		
		final sprite1 = new FlxSprite().makeGraphic(200, 200, FlxColor.PINK);
		sprite1.screenCenter();
		sprite1.x -= 50;
		add(sprite1);
		
		sprite2 = new FlxSprite().makeGraphic(200, 200, FlxColor.GREEN);
		sprite2.blend = ADD;
		sprite2.screenCenter();
		sprite2.x += 50;
		add(sprite2);
		
		text.text = Std.string(sprite2.blend);
		text.y = sprite2.y + sprite2.height + 10;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		final k = FlxG.keys.justPressed;
		final diff = (k.RIGHT ? 1 : 0) - (k.LEFT ? 1 : 0);
		if (diff != 0)
		{
			final len = blendModes.length;
			final i = blendModes.indexOf(sprite2.blend) + diff;
			sprite2.blend = blendModes[(i + len) % len];
			text.text = Std.string(sprite2.blend);
		}
		
		if (k.SPACE)
		{
			FlxG.camera.fade(0xff008000);
		}
	}
}
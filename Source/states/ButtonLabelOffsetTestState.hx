package states;

import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class ButtonLabelOffsetTestState extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		final button1 = new Button(20, 10, "Button", ()->trace("clicked button1."));
		
		button1.onOver.callback = ()->trace("clicked button1");
		button1.scale.set(2, 2);
		button1.updateHitbox();
		button1.blend = SCREEN;
		button1.antialiasing = false;
		button1.label.antialiasing = false;
		button1.label.letterSpacing = -3;
		button1.label.fieldWidth = button1.width;
		button1.label.fieldHeight = button1.height;
		button1.label.setFormat('Helvetica', 16, 0xFFFFFFFF);
		button1.label.text = "_" + button1.label.text + "_";
		button1.labelAlphas = [0.7, 1.0, 0.8, 0.8];
		button1.labelOffsets[0].x += 10;
		button1.labelOffsets[1].x += 15;
		button1.labelOffsets[2].x += 20;
		button1.alpha = 0;
		add(button1);
		button1.moves = false;
		FlxTween.tween(button1, {alpha: 1, x: 10}, 1);
		
		final y = button1.y + button1.height + 10;
		final button2 = new Button(10, y, "Button", ()->trace("clicked button2."));
		button2.onOver.callback = ()->trace("clicked button2");
		button2.scale.set(2, 2);
		button2.updateHitbox();
		button2.blend = SCREEN;
		button2.antialiasing = false;
		button2.label.antialiasing = false;
		button2.label.letterSpacing = -3;
		button2.label.fieldWidth = button2.width;
		button2.label.fieldHeight = button2.height;
		button2.label.setFormat('Helvetica', 16, 0xFFFFFFFF);
		button2.label.text = "_" + button2.label.text + "_";
		button2.labelAlphas = [0.7, 1.0, 0.8, 0.8];
		button2.labelOffsets[0].x += 10;
		button2.labelOffsets[1].x += 15;
		button2.labelOffsets[2].x += 20;
		add(button2);
		// button2.moves = false;
	}
}

class Button extends flixel.ui.FlxButton
{
	override function updateMotion(elapsed:Float)
	{
		super.updateMotion(elapsed);
	}
}

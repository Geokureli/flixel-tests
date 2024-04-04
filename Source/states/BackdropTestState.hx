package states;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxAxes;
import flixel.addons.util.FlxScene;

import flixel.addons.display.FlxBackdrop;

class BackdropTestState extends flixel.FlxState
{
	var backdrop:FlxBackdrop;
	
	override function create()
	{
		FlxG.scaleMode = new flixel.system.scaleModes.StageSizeScaleMode();
		// FlxG.camera.zoom = 0.5;
		
		// backdrop = new FlxBackdrop("assets/images/haxe.png", 1, 1, true, true, 100, 50); // old
		backdrop = new FlxBackdrop("assets/images/haxe-anim.png");
		backdrop.loadGraphic("assets/images/haxe-anim.png", true);
		backdrop.animation.add("loop", [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1], 16);
		backdrop.animation.play("loop");
		backdrop.screenCenter();
		add(backdrop);
		
		FlxG.watch.add(backdrop, "spacing", "spacing");
		FlxG.watch.add(backdrop, "angle", "angle");
		FlxG.watch.add(backdrop, "scale", "scale");
		FlxG.watch.add(backdrop, "offset", "offset");
		FlxG.watch.add(backdrop, "origin", "origin");
		FlxG.watch.add(backdrop, "_blitOffset");
		FlxG.watch.add(backdrop, "_point", "_point");
		FlxG.watch.add(camera, "zoom");
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.D) backdrop.velocity.x++;
		if (FlxG.keys.pressed.A) backdrop.velocity.x--;
		if (FlxG.keys.pressed.S) backdrop.velocity.y++;
		if (FlxG.keys.pressed.W) backdrop.velocity.y--;
		
		final L = FlxG.keys.pressed.L;
		final J = FlxG.keys.pressed.J;
		final K = FlxG.keys.pressed.K;
		final I = FlxG.keys.pressed.I;
		
		final shift = FlxG.keys.pressed.SHIFT;
		if (shift)
		{
			if (L) backdrop.offset.x += 1;
			if (J) backdrop.offset.x -= 1;
			if (K) backdrop.offset.y += 1;
			if (I) backdrop.offset.y -= 1;
		}
		else if (FlxG.keys.pressed.ALT)
		{
			if (L) backdrop.origin.x += 1;
			if (J) backdrop.origin.x -= 1;
			if (K) backdrop.origin.y += 1;
			if (I) backdrop.origin.y -= 1;
		}
		else
		{
			if (L) backdrop.scale.x += 0.01;
			if (J) backdrop.scale.x -= 0.01;
			if (K) backdrop.scale.y += 0.01;
			if (I) backdrop.scale.y -= 0.01;
		}
		
		if (FlxG.keys.pressed.RIGHT)
			backdrop.spacing.x++;
		
		if (FlxG.keys.pressed.LEFT && backdrop.spacing.x > 0)
			backdrop.spacing.x--;
		
		if (FlxG.keys.pressed.DOWN)
			backdrop.spacing.y++;
		
		if (FlxG.keys.pressed.UP && backdrop.spacing.y > 0)
			backdrop.spacing.y--;
		
		if (FlxG.keys.pressed.Q && camera.zoom > 0.1) camera.zoom -= 0.01;
		if (FlxG.keys.pressed.E && camera.zoom < 2.0) camera.zoom += 0.01;
		
		if (FlxG.keys.pressed.PERIOD) backdrop.angle++;
		if (FlxG.keys.pressed.COMMA ) backdrop.angle--;
		
		var axes = backdrop.repeatAxes;
		if (FlxG.keys.justPressed.X) axes = FlxAxes.fromBools(axes.x == false, axes.y         );
		if (FlxG.keys.justPressed.Y) axes = FlxAxes.fromBools(axes.x         , axes.y == false);
		backdrop.repeatAxes = axes;
		
		if (FlxG.keys.justPressed.SPACE)
			backdrop.drawBlit = !backdrop.drawBlit;
		
		if (FlxG.keys.justPressed.ZERO ) backdrop.blitMode = AUTO;
		if (FlxG.keys.justPressed.ONE  ) backdrop.blitMode = shift ? MAX_TILES(1) : SPLIT(1);
		if (FlxG.keys.justPressed.TWO  ) backdrop.blitMode = shift ? MAX_TILES(2) : SPLIT(2);
		if (FlxG.keys.justPressed.THREE) backdrop.blitMode = shift ? MAX_TILES(3) : SPLIT(3);
		if (FlxG.keys.justPressed.FOUR ) backdrop.blitMode = shift ? MAX_TILES(4) : SPLIT(4);
		if (FlxG.keys.justPressed.FIVE ) backdrop.blitMode = shift ? MAX_TILES(5) : SPLIT(5);
		if (FlxG.keys.justPressed.SIX  ) backdrop.blitMode = shift ? MAX_TILES(6) : SPLIT(6);
		if (FlxG.keys.justPressed.SEVEN) backdrop.blitMode = shift ? MAX_TILES(7) : SPLIT(7);
		if (FlxG.keys.justPressed.EIGHT) backdrop.blitMode = shift ? MAX_TILES(8) : SPLIT(8);
		if (FlxG.keys.justPressed.NINE ) backdrop.blitMode = shift ? MAX_TILES(9) : SPLIT(9);
		
		FlxScene;
	}
	
	function fromBools(x:Bool, y:Bool):FlxAxes
	{
		return cast (x ? (cast X:Int) : 0) | (y ? (cast Y:Int) : 0);
	}
}
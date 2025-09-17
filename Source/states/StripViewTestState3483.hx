package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.util.FlxColor;

class StripViewTestState3483 extends flixel.FlxState
{
	var strip:Strip;
	var stripBounds:FlxSprite;

	override function create()
	{
		super.create();

		// uncomment this line to use smaller camera
		// FlxG.cameras.reset(new flixel.FlxCamera(FlxG.width / 4, FlxG.height / 4, FlxG.width, FlxG.height, 0.5));
		FlxG.camera.zoom = 0.5;
		FlxG.camera.bgColor = FlxColor.GRAY;

		final camBounds = new FlxSprite().makeGraphic(FlxG.camera.width, FlxG.camera.height, FlxColor.RED);
		camBounds.alpha = 0.5;
		add(camBounds);

		stripBounds = new FlxSprite().makeGraphic(120, 120, FlxColor.BLUE);
		stripBounds.alpha = 0.5;
		add(stripBounds);
		// remove this line to see strip bounds when it's outside of initial camera bounds
		// stripBounds.visible = false;
		
		strip = new Strip();
		add(strip);
		strip.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		final mult = elapsed * (FlxG.keys.pressed.SHIFT ? 5 : 1);

		if (FlxG.keys.pressed.Q)
			FlxG.camera.zoom = Math.max(FlxG.camera.zoom - 0.5 * mult, FlxG.camera.initialZoom / 2);
		if (FlxG.keys.pressed.E)
			FlxG.camera.zoom = Math.min(FlxG.camera.zoom + 0.5 * mult, FlxG.camera.initialZoom);

		if (FlxG.keys.pressed.A)
			strip.x -= 200 * mult;
		if (FlxG.keys.pressed.D)
			strip.x += 200 * mult;
		if (FlxG.keys.pressed.W)
			strip.y -= 200 * mult;
		if (FlxG.keys.pressed.S)
			strip.y += 200 * mult;

		stripBounds.setPosition(strip.x - 10, strip.y - 10);
		
	}
}

@:forward
abstract Strip(FlxStrip) to FlxSprite
{
	public function new (x = 0.0, y = 0.0)
	{
		this = new FlxStrip(x, y);
		this.makeGraphic(100, 100);

		this.vertices.push(0);
		this.vertices.push(0);
		this.vertices.push(this.width);
		this.vertices.push(0);
		this.vertices.push(this.width);
		this.vertices.push(this.height);
		this.vertices.push(0);
		this.vertices.push(this.height);

		this.uvtData.push(0);
		this.uvtData.push(0);
		this.uvtData.push(1);
		this.uvtData.push(0);
		this.uvtData.push(1);
		this.uvtData.push(1);
		this.uvtData.push(0);
		this.uvtData.push(1);

		this.indices.push(0);
		this.indices.push(1);
		this.indices.push(2);
		this.indices.push(0);
		this.indices.push(3);
		this.indices.push(2);
	}
}
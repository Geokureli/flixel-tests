package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import openfl.display.DisplayObjectContainer;

class InitialSetupTestState extends flixel.FlxState
{
	static public function setup(main:DisplayObjectContainer)
	{
		// @:bypassAccessor
		// flixel.FlxG.scaleMode = new MobileScaleMode();
		// FlxG.scaleMode = new TestScaleMode();
		// main.addChild(new Main.TestGame(TestStateA, 1, 900, 720));
		main.addChild(new Main.TestGame(()->new InitialSetupTestState(true), 1, main.stage.stageWidth >> 1, main.stage.stageHeight));
		flixel.FlxG.scaleMode = new MobileScaleMode(); //place it here not on top
	}
	
	var sprite1:FlxSprite;
	var text:FlxText;
	final firstLoad:Bool;
	
	public function new(firstLoad = true)
	{
		this.firstLoad = firstLoad;
		super();
	}

	override function create()
	{
		FlxG.camera.bgColor = firstLoad ? 0xFFFF0000 : 0xFF0000FF;
		
		add(text = new FlxText("R to reload\nSPACE to add a centered sprite"));
		text.screenCenter();

		super.create();
	}

	override function update(elapsed:Float):Void
	{
		//sprite that added after create will be positioned according to new screen coordinates we obtained in scale mode
		if (sprite1 == null && FlxG.keys.justPressed.SPACE)
		{
			add(sprite1 = new FlxSprite(0, 200).makeGraphic(50, 50, 0xFFFF00FF));
			sprite1.screenCenter(X); //to see the difference
		}
		
		if (FlxG.keys.justPressed.R)
			FlxG.switchState(()->new InitialSetupTestState(false));

		super.update(elapsed);
	}
}

class MobileScaleMode extends flixel.system.scaleModes.BaseScaleMode
{
	var logicalSize:FlxPoint;
	var maxAspectRatio:FlxPoint;
	var maxRatioAxis:FlxAxes = X;
	var ratioAxis:FlxAxes = X;

	public function new():Void {
		super();
		logicalSize = FlxPoint.get();
		maxAspectRatio = FlxPoint.get(20, 9);
	}

	override function onMeasure(w:Int, h:Int):Void {
		@:privateAccess FlxG.width = FlxG.initialWidth; //untyped to apply new screen size
		@:privateAccess FlxG.height = FlxG.initialHeight;
		
		for (camera in FlxG.cameras.list)
		{
			camera.width = w;
			camera.height = w;
		}

		updateGameSize(w, h);
		updateDeviceSize(w, h);

		updateScaleOffset();
		updateGamePosition();

		if (ratioAxis == Y) {
			var gameHeight:Float = gameSize.y / scale.y;

			if (gameHeight / FlxG.width > maxAspectRatio.y / maxAspectRatio.x && maxRatioAxis.y) {
				gameHeight = ((gameSize.x / scale.x) / maxAspectRatio.x) * maxAspectRatio.y;
				gameSize.y = gameHeight * scale.y;
				updateGamePosition();
			}

			@:privateAccess FlxG.height = Math.ceil(gameHeight);
		} else {
			var gameWidth:Float = gameSize.x / scale.x;

			if (gameWidth / FlxG.height > maxAspectRatio.x / maxAspectRatio.y && maxRatioAxis.x) {
				gameWidth = ((gameSize.y / scale.y) / maxAspectRatio.y) * maxAspectRatio.x;
				gameSize.x = gameWidth * scale.x;
				updateGamePosition();
			}

			@:privateAccess FlxG.width = Math.ceil(gameWidth);
		}
	}

	override function updateGameSize(w:Int, h:Int):Void {
		final gameRatio:Float = FlxG.width / FlxG.height;
		ratioAxis = w / h < gameRatio ? Y : X;

		logicalSize.set(w, h);

		if (ratioAxis == Y) {
			gameSize.x = w;
			logicalSize.y = Math.ceil(gameSize.x / gameRatio);
			gameSize.y = logicalSize.y;
		} else {
			gameSize.y = h;
			logicalSize.x = Math.ceil(gameSize.y * gameRatio);
			gameSize.x = w;
		}
	}

	override function updateScaleOffset():Void {
		scale.set(ratioAxis == X ? logicalSize.x / FlxG.width : deviceSize.x / FlxG.width, ratioAxis == Y ? logicalSize.y / FlxG.height : deviceSize.y / FlxG.height);
		updateOffsetX();
		updateOffsetY();
	}
}

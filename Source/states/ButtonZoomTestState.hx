package states;

import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.*;
import flixel.ui.FlxButton;

class ButtonZoomTestState extends flixel.FlxState
{
	var uiCam:FlxCamera;
	var text:FlxText;
	
	override function create():Void
	{
		final bg = new FlxSprite("assets/images/haxe.png");
		bg.screenCenter();
		add(bg);
		
		text = new FlxText(0, 0, 0, "UI Zoom:1.0");
		text.screenCenter(X);
		text.y = bg.y - text.height;
		add(text);
		
		uiCam = new FlxCamera().copyFrom(FlxG.camera);
		uiCam.bgColor = 0x0;
		FlxG.cameras.add(uiCam, false);
		
		final uiGrp = new FlxSpriteGroup();
		uiGrp.camera = uiCam;
		add(uiGrp);
		
		final buttonGrp = new FlxButton("grouped");
		buttonGrp.screenCenter();
		buttonGrp.x -= buttonGrp.width / 2;
		uiGrp.add(buttonGrp);
		
		final uiCnt = new FlxSpriteContainer();
		uiCnt.camera = uiCam;
		add(uiCnt);
		
		final buttonCnt = new FlxButton("contained");
		buttonCnt.screenCenter();
		buttonCnt.x += buttonCnt.width / 2;
		uiCnt.add(buttonCnt);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		final cam = uiCam;
		
		if (FlxG.keys.pressed.UP)
			cam.zoom += 0.1;
		else if (FlxG.keys.pressed.DOWN)
			cam.zoom -= 0.1;
		
		if (cam.zoom > 2)
			cam.zoom = 2;
		else if (cam.zoom < 0.5)
			cam.zoom = 0.5;
		
		text.text = 'UI Zoom: ${cam.zoom}';
	}
}
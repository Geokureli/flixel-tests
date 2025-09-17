package states;

import flixel.FlxG;
import flixel.FlxStrip;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class UVRectTestState3471 extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		FlxG.camera.bgColor = flixel.util.FlxColor.GRAY;
		
		final bitmap = new BitmapData(450, 250, true);
		bitmap.fillRect(bitmap.rect, FlxColor.RED);
		bitmap.fillRect(new Rectangle(200, 100, 50, 50), FlxColor.BLACK);
		bitmap.fillRect(new Rectangle(205, 105, 40, 40), FlxColor.WHITE);
		bitmap.fillRect(new Rectangle(220, 120, 10, 10), FlxColor.GREEN);
		
		final strip = new FlxStrip();
		add(strip);
		
		strip.frames = flixel.graphics.frames.FlxAtlasFrames.fromSparrow(bitmap, xmlData);
		final frame = strip.frames.getByName("big-frame");
		frame.clip(FlxRect.get(20, 10, 50, 50));
		strip.frame = frame;
		
		// Add Indices
		strip.indices.push(0); // A
		strip.indices.push(1); // B
		strip.indices.push(2); // C

		strip.indices.push(0); // A
		strip.indices.push(3); // D
		strip.indices.push(2); // C
		
		// Add Vertices
		
		// top left (A)
		strip.vertices.push(0);
		strip.vertices.push(0);
		// top right (B)
		strip.vertices.push(frame.frame.width);
		strip.vertices.push(0);
		// bottom right (C)
		strip.vertices.push(frame.frame.width);
		strip.vertices.push(frame.frame.height);
		// bottom left (D)
		strip.vertices.push(0);
		strip.vertices.push(frame.frame.height);
		
		// Add UV
		
		// top left (A)
		strip.uvtData.push(frame.uv.left);
		strip.uvtData.push(frame.uv.top);
		// top right (B)
		strip.uvtData.push(frame.uv.right);
		strip.uvtData.push(frame.uv.top);
		// bottom right (C)
		strip.uvtData.push(frame.uv.right);
		strip.uvtData.push(frame.uv.bottom);
		// bottom left (D)
		strip.uvtData.push(frame.uv.left);
		strip.uvtData.push(frame.uv.bottom);
		
		strip.screenCenter();
	}
}

private final xmlData = 
'<TextureAtlas imagePath="bold.png">
	<SubTexture name="frame" x="200" y="100" width="50" height="50" />
	<SubTexture name="big-frame" x="180" y="90" width="90" height="70" />
</TextureAtlas>';
package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.FlxAtlas;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import openfl.display.BitmapData;

class HtmlFlickerTestState3354 extends flixel.FlxState
{
	override function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.GRAY;
		
		final asset = new GraphicAuto();
		asset.onLoad = ()->addSprites(asset);
	}
	
	function addSprites(tileBitmap:BitmapData)
	{
		final atlas = new Atlas("atlas");
		
		final tiles = new FlxTilemap();
		final size = 8;
		final rows = 9;
		final cols = 3;
		final data = [for (i in 0...rows * cols) FlxG.random.bool(80) ? 1 : 0];
		final tileFrames = atlas.addAndGetTileFrames(tileBitmap, "tiles", size, size);
		tiles.loadMapFromArray(data, cols, rows, tileFrames, size, size, AUTO);
		// tiles.alpha = 0.5;
		add(tiles);
		
		final flixelFrame = atlas.addAndGetFrame("flixel/images/logo/default.png");
		
		for (i in 0...16)
		{
			final sprite = new FlxSprite(0, 0);
			sprite.frames = flixelFrame;
			sprite.screenCenter();
			sprite.x += i * 20;
			// sprite.alpha = (i % 4 == 0) ? 0.5 : 1.0;
			sprite.color = (i % 4 == 0) ? FlxColor.RED : FlxColor.WHITE;
			add(sprite);
		}
		
		final atlasSprite = new FlxSprite(atlas.graphic);
		atlasSprite.y = FlxG.height - atlas.height;
		add(atlasSprite);
	}
}

@:forward
@:forward.new
abstract Atlas(FlxAtlas)
{
	public function addAndGetTileFrames(asset:FlxGraphicAsset, ?key:String, frameWidth:Int, frameHeight:Int)
	{
		final graphic = FlxG.bitmap.add(asset, false, key);
		final node = this.addNode(graphic, key);
		final frames = node.getTileFrames(FlxPoint.weak(frameWidth, frameHeight));
		FlxG.bitmap.remove(graphic);
		return frames;
	}
	
	public function addAndGetFrame(asset:FlxGraphicAsset, ?key:String)
	{
		final graphic = FlxG.bitmap.add(asset, false, key);
		final node = this.addNode(graphic, key);
		final frame = node.getImageFrame();
		FlxG.bitmap.remove(graphic);
		return frame;
	}
}
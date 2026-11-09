package states;

import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;


private function drawBG(sprite:FlxSprite)
{
	final graphic = FlxG.bitmap.get("mainBG");
	if (graphic != null)
	{
		sprite.loadGraphic(graphic);
	}
	else
	{
		final graphic = FlxG.bitmap.create(100, 100, FlxColor.WHITE, false, "mainBG");
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(20, 20,  60,  60), FlxColor.BLUE);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(40, 40,  20,  20), FlxColor.WHITE);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(19,  0,   1, 100), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle( 0, 19, 100,   1), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(80,  0,   1, 100), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle( 0, 80, 100,   1), FlxColor.RED);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(25,  7,  50,   6), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(25, 87,  50,   6), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle( 7, 25,   6,  50), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(87, 25,   6,  50), FlxColor.LIME);
		graphic.bitmap.fillRect(new openfl.geom.Rectangle(40, 40,  20,  20), FlxColor.LIME);
		sprite.loadGraphic(graphic);
	}
}

class PixelPerfectMouseEventTestState extends flixel.FlxState
{
    var sourceBg:FlxSprite;
    var source:FlxSprite;
    var clipRect = FlxRect.get();
    var mousePixel:FlxSprite;
    
    override function create()
    {
        super.create();
        
        clipRect = FlxRect.get(10, 10, 80, 80);
        
        sourceBg = new FlxSprite(10, 10);
        sourceBg.alpha = 0.5;
        drawBG(sourceBg);
        add(sourceBg);
        
        source = new FlxSprite(10, 10);
        drawBG(source);
        add(source);
        source.clipRect = clipRect;
        
        mousePixel = new FlxSprite().makeGraphic(10, 10);
        add(mousePixel);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final deltaScale = elapsed * 0.5 * ((FlxG.keys.pressed.E ? 1 : 0) - (FlxG.keys.pressed.Q ? 1 : 0));
        if (deltaScale != 0)
        {
            sourceBg.scale.x = sourceBg.scale.y += deltaScale;
            source.scale.copyFrom(sourceBg.scale);
        }
        
        clipRect.x += (FlxG.keys.pressed.D ? 1.0 : 0.0) - (FlxG.keys.pressed.A ? 1.0 : 0.0);
        clipRect.y += (FlxG.keys.pressed.S ? 1.0 : 0.0) - (FlxG.keys.pressed.W ? 1.0 : 0.0);
        
        clipRect.width += (FlxG.keys.pressed.RIGHT ? 1.0 : 0.0) - (FlxG.keys.pressed.LEFT ? 1.0 : 0.0);
        clipRect.height += (FlxG.keys.pressed.DOWN ? 1.0 : 0.0) - (FlxG.keys.pressed.UP ? 1.0 : 0.0);
        
        final mouse = FlxPoint.get();
        final pixelColor = source.getPixelAt(FlxG.mouse.getWorldPosition(mouse));
        mousePixel.visible = pixelColor != null;
        mousePixel.color = pixelColor != null ? pixelColor.rgb : FlxColor.WHITE;
        mouse.put();
    }
}
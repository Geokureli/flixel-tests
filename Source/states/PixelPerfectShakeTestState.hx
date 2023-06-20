package states;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTilemap;
import flixel.text.FlxBitmapText;

class PixelPerfectShakeTestState extends flixel.FlxState
{
    var text:FlxBitmapText;
    
    override function create()
    {
        super.create();
        FlxG.camera.pixelPerfectRender = true;
        
        FlxG.camera.bgColor = 0xFFffffff;
        
        final TILE_SIZE = 8;
        final cols = Math.floor(FlxG.width / TILE_SIZE);
        final rows = Math.floor(FlxG.height / TILE_SIZE);
        final tiles = [for (i in 0...rows * cols) FlxG.random.int(0, 1)];
        final graphic = FlxGraphic.fromClass(GraphicAuto);
        final map = new FlxTilemap();
        map.loadMapFromArray(tiles, cols, rows, graphic, TILE_SIZE, TILE_SIZE, AUTO);
        add(map);
        
        add(text = new FlxBitmapText(""));
        text.setBorderStyle(OUTLINE, 0xFF000000, 1);
        updateText();
        text.screenCenter(X);
        text.y = FlxG.height - text.height;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        @:privateAccess
        final isShaking = FlxG.camera._fxShakeDuration > 0; //TODO add camera feature
        
        if (FlxG.keys.justPressed.SPACE)
        {
            FlxG.camera.shake(0.05, 2.0);
            if (FlxG.keys.pressed.SHIFT)
                FlxG.vcr.pause();
        }
        
        if (FlxG.keys.justPressed.P)
        {
            FlxG.camera.pixelPerfectRender = !FlxG.camera.pixelPerfectRender;
            updateText();
        }
    }
    
    function updateText()
    {
        final value = FlxG.camera.pixelPerfectRender ? "ON" : "OFF";
        text.text = '[SPACE]: SHAKE\n[P]: PP SHAKE $value';
    }
}

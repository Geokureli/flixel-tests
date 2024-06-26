package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class GameSizeTestState extends flixel.FlxState
{
    final size:FlxPoint = FlxPoint.get(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
    override function create()
    {
        super.create();
        
        createMess(64, 1.0);
    }
    
    function createMess(size = 32, density = 0.5)
    {
        final area = FlxRect.get(0, 0, FlxG.width * 2, FlxG.height * 2);
        final count = Std.int(area.width * area.height / (size * size) * density);
        for (i in 0...count)
        {
            final x = FlxG.random.float(area.left, area.right - size);
            final y = FlxG.random.float(area.top, area.bottom - size);
            final sprite = new FlxSprite(x, y);
            sprite.makeGraphic(size, size, 0x0);
            FlxSpriteUtil.drawCircle(sprite, size / 2, size / 2, size / 2 - 1);
            sprite.color = FlxColor.fromHSB(FlxG.random.float(0, 360), 1, 1);
            add(sprite);
        }
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final scale = switch (FlxG.keys.firstJustPressed():FlxKey)
        {
            case ONE: 1;
            case TWO: 2;
            case THREE: 3;
            case FOUR: 4;
            default:0;
        }
        
        if (scale != 0)
        {
            if (FlxG.keys.pressed.SHIFT)
                FlxG.resizeWindow(Std.int(size.x / scale), Std.int(size.y / scale));
            else
                FlxG.resizeGame(Std.int(size.x / scale), Std.int(size.y / scale));
        }
    }
}

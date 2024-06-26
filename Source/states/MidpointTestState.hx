package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class MidpointTestState extends FlxState
{
    
    var sprite:FixedSprite;
    var wrong:FlxSprite;
    var correct:FlxSprite;
    
    override function create()
    {
        super.create();
        
        sprite = new FixedSprite();
        sprite.makeGraphic(50, 50, 0xFFFFFFFF);
        sprite.screenCenter();
        add(sprite);
        
        wrong = new FlxSprite().makeGraphic(1, 1, 0xFFFF0000);
        wrong.offset.set(0.5, 0.5);
        add(wrong);
        
        // correct = new FlxSprite().makeGraphic(1, 1, 0xFF00FFFF);
        // correct.offset.set(0.5, 0.5);
        // add(correct);
        
        final size = 10;
        final halfSize = 5;
        
        final circle = new FlxSprite();
        circle.setPosition(100, 100);
        circle.makeGraphic(size, size, FlxColor.TRANSPARENT);
        circle.drawCircle(-1, -1, halfSize, FlxColor.WHITE);
        FlxG.log.add(0xffffff == sprite.pixels.getPixel(halfSize, halfSize));
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final x = elapsed * ((FlxG.keys.pressed.RIGHT ? 1 : 0) - (FlxG.keys.pressed.LEFT ? 1 : 0));
        final y = elapsed * ((FlxG.keys.pressed.DOWN ? 1 : 0) - (FlxG.keys.pressed.UP ? 1 : 0));
        final angle = elapsed * ((FlxG.keys.pressed.PERIOD ? 1 : 0) - (FlxG.keys.pressed.COMMA ? 1 : 0));
        
        if (FlxG.keys.pressed.SHIFT)
        {
            sprite.scale.x += x * 1;
            sprite.scale.y += y * 1;
        }
        else if (FlxG.keys.pressed.ALT)
        {
            sprite.origin.x += x * 10;
            sprite.origin.y += y * 10;
        }
        else
        {
            sprite.offset.x += x * 10;
            sprite.offset.y += y * 10;
        }
        
        sprite.angle += angle * 90;
        
        var p = FlxPoint.get();
        sprite.getGraphicMidpoint(p);
        wrong.setPosition(p.x, p.y);
        // sprite.getGraphicMidpointFixed(p);
        // correct.setPosition(p.x, p.y);
        p.put();
    }
}

class FixedSprite extends FlxSprite
{
    public function getGraphicMidpointFixed(?point:FlxPoint):FlxPoint
    {
        if (point == null)
            point = FlxPoint.get();
        
        _scaledOrigin.set(origin.x * scale.x, origin.y * scale.y);
        point.x = x - offset.x + origin.x - _scaledOrigin.x + frameWidth * 0.5 * scale.x;
        point.y = y - offset.y + origin.y - _scaledOrigin.y + frameHeight * 0.5 * scale.y;
        
        return point;
    }
}
package states;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class BounceEaseTestState2788 extends flixel.FlxState
{
    var oldInSprite:FlxSprite;
    var newInSprite:FlxSprite;
    
    var oldOutSprite:FlxSprite;
    var newOutSprite:FlxSprite;
    
    var oldInOutSprite:FlxSprite;
    var newInOutSprite:FlxSprite;
    
    override function create()
    {
        super.create();
        
        oldInSprite = createSprite(0xFF000080, true);
        newInSprite = createSprite(0xFF0000ff, false);
        
        oldOutSprite = createSprite(0xFF008000, true);
        newOutSprite = createSprite(0xFF00ff00, false);
        
        oldInOutSprite = createSprite(0xFF800000, true);
        newInOutSprite = createSprite(0xFFff0000, false);
    }
    
    function createSprite(color:FlxColor, top:Bool)
    {
        final sprite = new FlxSprite().makeGraphic(10, 10);
        if (top)
            sprite.offset.y = 10;
        sprite.color = color;
        add(sprite);
        return sprite;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        oldInSprite.x = newInSprite.x
            = oldOutSprite.x = newOutSprite.x
            = oldInOutSprite.x = newInOutSprite.x
            = FlxG.mouse.x;
        
        final t = oldInSprite.x / FlxG.width;
        
        oldInSprite.y = FlxG.height * oldBounceIn(t);
        newInSprite.y = FlxG.height * newBounceIn(t);
        oldOutSprite.y = FlxG.height * bounceOut(t);
        newOutSprite.y = FlxG.height * bounceOut(t);
        oldInOutSprite.y = FlxG.height * oldBounceInOut(t);
        newInOutSprite.y = FlxG.height * newBounceInOut(t);
    }
    
    inline static var B1:Float = 1 / 2.75;
    inline static var B2:Float = 2 / 2.75;
    inline static var B3:Float = 1.5 / 2.75;
    inline static var B4:Float = 2.5 / 2.75;
    inline static var B5:Float = 2.25 / 2.75;
    inline static var B6:Float = 2.625 / 2.75;
    
    static function bounceOut(t:Float):Float
    {
        if (t < B1)
            return 7.5625 * t * t;
        if (t < B2)
            return 7.5625 * (t - B3) * (t - B3) + .75;
        if (t < B4)
            return 7.5625 * (t - B5) * (t - B5) + .9375;
        return 7.5625 * (t - B6) * (t - B6) + .984375;
    }

    static function oldBounceIn(t:Float)
    {
        t = 1 - t;
        if (t < B1)
            return 1 - 7.5625 * t * t;
        if (t < B2)
            return 1 - (7.5625 * (t - B3) * (t - B3) + .75);
        if (t < B4)
            return 1 - (7.5625 * (t - B5) * (t - B5) + .9375);
        return 1 - (7.5625 * (t - B6) * (t - B6) + .984375);
    }
    
    static function newBounceIn(t:Float)
    {
        return 1 - bounceOut(1 - t);
    }
    
    
    static function oldBounceInOut(t:Float):Float
    {
        if (t < .5)
        {
            t = 1 - t * 2;
            if (t < B1)
                return (1 - 7.5625 * t * t) / 2;
            if (t < B2)
                return (1 - (7.5625 * (t - B3) * (t - B3) + .75)) / 2;
            if (t < B4)
                return (1 - (7.5625 * (t - B5) * (t - B5) + .9375)) / 2;
            return (1 - (7.5625 * (t - B6) * (t - B6) + .984375)) / 2;
        }
        t = t * 2 - 1;
        if (t < B1)
            return (7.5625 * t * t) / 2 + .5;
        if (t < B2)
            return (7.5625 * (t - B3) * (t - B3) + .75) / 2 + .5;
        if (t < B4)
            return (7.5625 * (t - B5) * (t - B5) + .9375) / 2 + .5;
        return (7.5625 * (t - B6) * (t - B6) + .984375) / 2 + .5;
    }
    
    static function newBounceInOut(t:Float):Float
    {
        return t < 0.5
            ? (1 - bounceOut(1 - 2 * t)) / 2
            : (1 + bounceOut(2 * t - 1)) / 2;
    }
}
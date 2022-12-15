package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class PivotTestState extends flixel.FlxState
{
    var sprite:FlxSprite;
    var pivot:FlxPoint;
    var p:FlxPoint;
    
    override function create()
    {
        super.create();
        
        p = FlxPoint.get(0, 50);
        pivot = FlxPoint.get(50, 50);
        
        trace('$p @ ${(p - pivot).degrees)}');
        for (i in 0...8)
        {
            p.pivotDegrees(pivot, 45);
            trace('$p @ ${(p - pivot).degrees)}');
        }
        /* output (beautified):
         * (x:   0.000 | y:  50.000 ) @  180
         * (x:  85.355 | y:  85.355 ) @ -135
         * (x:  50.000 | y:   0.000 ) @  -90
         * (x:  14.645 | y:  85.355 ) @  -45
         * (x: 100.000 | y:  50.000 ) @    0
         * (x:  14.645 | y:  14.645 ) @   45
         * (x:  50.000 | y: 100.000 ) @   90
         * (x:  85.355 | y:  14.645 ) @  135
         * (x:   0.000 | y:  50.000 ) @  180
        **/
        
        pivot.set(FlxG.width / 2, FlxG.height / 2);
        var pivotSprite = new FlxSprite().makeGraphic(6, 6, 0xFF0000ff);
        pivotSprite.x = pivot.x - pivotSprite.origin.x;
        pivotSprite.y = pivot.y - pivotSprite.origin.y;
        add(pivotSprite);
        
        p.set(pivot.x + 100, pivot.y);
        sprite = new FlxSprite().makeGraphic(50, 50, 0xFFff0000);
        sprite.x = p.x - sprite.origin.x;
        sprite.y = p.y - sprite.origin.y;
        add(sprite);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        p.pivotDegrees(pivot, 360 * elapsed);
        sprite.x = p.x - sprite.origin.x;
        sprite.y = p.y - sprite.origin.y;
    }
}
package sprites;

import flixel.math.FlxPoint;

class LineSprite extends flixel.FlxSprite
{
    public final end = FlxPoint.get();
    
    public function new (x = 0.0, y = 0.0, thickness = 5, scaleY = true)
    {
        super(x, y);
        
        if (scaleY)
        {
            makeGraphic(1, 1);
            scale.y = thickness;
            origin.x = 0;
            origin.y = 0.5;
        }
        else
        {
            makeGraphic(1, thickness);
            origin.x = 0;
            origin.y = thickness / 2;
        }
        offset.y = origin.y;
    }
    
    override function draw()
    {
        orient();
        super.draw();
    }
    
    function orient()
    {
        inline function rnd(n:Float) return pixelPerfectPosition ? Math.round(n) : n;
        final dis = FlxPoint.get(rnd(end.x) - rnd(x), rnd(end.y) - rnd(y));
        scale.x = dis.length;
        angle = dis.degrees;
        dis.put();
    }
}
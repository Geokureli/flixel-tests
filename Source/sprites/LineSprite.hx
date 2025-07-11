package sprites;

import flixel.math.FlxPoint;

class LineSprite extends flixel.FlxSprite
{
    public final end = FlxPoint.get();
    
    public function new (x = 0.0, y = 0.0, thickness = 5)
    {
        super(x, y);
        
        makeGraphic(1, thickness);
        origin.x = 0;
        origin.y = thickness / 2;
    }
    
    override function draw()
    {
        orient();
        super.draw();
    }
    
    function orient()
    {
        final dis = FlxPoint.get(end.x - x, end.y - y);
        scale.x = dis.length;
        angle = dis.degrees;
    }
}
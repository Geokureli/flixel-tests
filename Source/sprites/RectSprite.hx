package sprites;

abstract RectSprite(flixel.FlxSprite) to flixel.FlxSprite
{
    inline public function new (x = 0.0, y = 0.0, color = flixel.util.FlxColor.WHITE)
    {
        this = new flixel.FlxSprite(x, y).makeGraphic(1, 1, color);
    }
    
    inline public function orient(x:Float, y:Float, width = 0.0, height = 0.0)
    {
        this.x = x;
        this.y = y;
        final w = Std.int(width);
        final h = Std.int(height);
        
        this.visible = w * h > 0;
        if (this.visible == false)
            return;
        
        this.makeGraphic(w, h, 0xFF0000ff);
        if (w > 2 && h > 2)
            this.graphic.bitmap.fillRect(new openfl.geom.Rectangle(1, 1, w - 2, h - 2), 0x0);
    }
}
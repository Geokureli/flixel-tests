package sprites;

class RectSprite extends flixel.FlxSprite
{
    public var hollow:Bool;
    
    public function new (x = 0.0, y = 0.0, color = 0xFFffffff, hollow = true)
    {
        this.hollow = hollow;
        super(x, y);
        
        this.color = color;
    }
    
    function autoMakeGraphic()
    {
        visible = width * height > 0;
        scale.set(1, 1);
        
        if (visible)
        {
            if (hollow)
                makeGraphic(Std.int(width), Std.int(height), 0xFFffffff, false, 'hollow-${width}x${height}');
            else
            {
                final w = width;
                final h = height;
                makeGraphic(1, 1, 0xFFffffff);
                width = w;
                height = h;
                setGraphicSize(width, height);
            }
            
            centerOrigin();
            centerOffsets();
        }
    }
    
    inline public function orientBounds(left:Float, top:Float, right:Float, bottom:Float)
    {
        return orient(left, top, right - left, bottom - top);
    }
    
    public function orient(x:Float, y:Float, width = 0.0, height = 0.0)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        
        autoMakeGraphic();
        
        return this;
    }
}
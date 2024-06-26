package states;

import flixel.FlxG;

@:bitmap("assets/images/haxe.png")
class CustomCursorData extends openfl.display.BitmapData {}

class CustomCursor extends openfl.display.Bitmap {
    
    public function new ()
    {
        super(new CustomCursorData(0, 0));
    }
}

class CustomCursorTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        // FlxG.mouse.load(new CustomCursorData(0, 0));
        // FlxG.mouse.load(CustomCursorData);
        FlxG.mouse.load(CustomCursor);
        // FlxG.mouse.load(new CustomCursor().bitmapData);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

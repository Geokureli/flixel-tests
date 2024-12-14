package states;

import flixel.FlxG;
import flixel.FlxSprite;

class ViewCenterTestState extends flixel.FlxState
{
    var sprite:FlxSprite;
    override function create()
    {
        super.create();
        
        sprite = new FlxSprite(0, 0, "assets/images/haxe.png");
        add(sprite);
        shuffle([0,1,2,3,4]);
        final featureID = "tasc[i]".split('[').shift().toLowerCase();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        // if (FlxG.keys.pressed.SPACE)
            // sprite.viewCenter();
        
        if (FlxG.keys.anyPressed([D, RIGHT]))
            camera.scroll.x += (FlxG.width / 2) * elapsed;
        
        if (FlxG.keys.anyPressed([A, LEFT]))
            camera.scroll.x -= (FlxG.width / 2) * elapsed;
        
        if (FlxG.keys.anyPressed([W, UP]))
            camera.scroll.y -= (FlxG.height / 2) * elapsed;
        
        if (FlxG.keys.anyPressed([S, DOWN]))
            camera.scroll.y += (FlxG.height / 2) * elapsed;
        
        
        var deltaZoom = 0.0;
        if (FlxG.mouse.wheel != 0)
            deltaZoom = FlxG.mouse.wheel / 1000;
        else if (FlxG.keys.pressed.COMMA)
            deltaZoom = 0.1;
        else if (FlxG.keys.pressed.PERIOD)
            deltaZoom = -0.1;
        
        FlxG.camera.zoom = Math.min(2.0, Math.max(0.2, FlxG.camera.zoom - deltaZoom));
    }
    
    @:generic
    static  function shuffle<T>(array:Array<T>):Void
	{
		var maxValidIndex = array.length - 1;
		for (i in 0...maxValidIndex)
		{
			var j = randomInt(i, maxValidIndex);
			var tmp = array[i];
			array[i] = array[j];
			array[j] = tmp;
		}
	}
    
    static function randomInt(min:Int, max:Int)
    {
        return min + Std.int(Math.random() * (max-min));
    }
}

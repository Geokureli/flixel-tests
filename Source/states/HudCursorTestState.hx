package states;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxCoordUtil;

class HudCursorTestState extends flixel.FlxState
{
    var player:FlxSprite;
    var crosshairWorld:FlxSprite;
    var crosshair:FlxSprite;
    
    override function create()
    {
        super.create();
        
        player = new FlxSprite("assets/images/haxe.png");
        player.screenCenter();
        add(player);
        
        final world = FlxWorldPoint.get();
        final window = FlxWindowPoint.get();
        FlxG.watch.addFunction("p.window", function (){
            player.getMidpoint(world);
            return world.toWindow(window);
        });
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

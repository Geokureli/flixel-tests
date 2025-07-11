package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxCollision;
import sprites.LineSprite;

class PixelPerfectOverlapTestState extends flixel.FlxState
{
    var beam:LineSprite;
    var target:FlxSprite;
    
    override function create()
    {
        super.create();
        
        beam = new LineSprite(0, 0, 5);
        beam.screenCenter();
        add(beam);
        
        target = new FlxSprite();
        target.loadGraphic("assets/images/anim-sprite.png", true);
        target.screenCenter();
        add(target);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.mouse.pressed)
        {
            beam.x = FlxG.mouse.x;
            beam.y = FlxG.mouse.y;
        }
        else
        {
            beam.end.x = FlxG.mouse.x;
            beam.end.y = FlxG.mouse.y;
        }
        
        final hit = FlxCollision.pixelPerfectCheck(target, beam);
        beam.color = hit ? 0xFFff0000 : 0xFFffffff;
    }
}

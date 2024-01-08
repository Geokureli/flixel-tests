package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxCollision;

/** https://github.com/HaxeFlixel/flixel/pull/2820 */
class PPPCTestState2820 extends flixel.FlxState
{
    var sprite:FlxSprite;
    
    override function create()
    {
        super.create();
        
        add(sprite = new FlxSprite());
        sprite.loadGraphic("assets/images/haxe-anim.png", true);
        sprite.animation.add("off", [8]);
        sprite.animation.play("off");
        sprite.screenCenter();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        // final overlap = FlxCollision.pixelPerfectPointCheck(FlxG.mouse.x, FlxG.mouse.y, sprite);
        final overlap = sprite.pixelsOverlapPoint(FlxG.mouse.getPosition(FlxPoint.weak()));
        sprite.color = overlap ? 0xFF00ff00 : 0xFFffffff;
        
        if (FlxG.keys.pressed.D) sprite.x++;
        if (FlxG.keys.pressed.A) sprite.x--;
        if (FlxG.keys.pressed.S) sprite.y++;
        if (FlxG.keys.pressed.W) sprite.y--;
        
        final R1 = FlxG.keys.pressed.RIGHT;
        final L1 = FlxG.keys.pressed.LEFT;
        final D1 = FlxG.keys.pressed.DOWN;
        final U1 = FlxG.keys.pressed.UP;
        
        final R2 = FlxG.keys.pressed.L;
        final L2 = FlxG.keys.pressed.J;
        final D2 = FlxG.keys.pressed.K;
        final U2 = FlxG.keys.pressed.I;
        
        final shift = FlxG.keys.pressed.SHIFT;
        if (shift)
        {
            if (R1) sprite.scale.x += 0.01;
            if (L1) sprite.scale.x -= 0.01;
            if (D1) sprite.scale.y += 0.01;
            if (U1) sprite.scale.y -= 0.01;
            
            if (R2) sprite.origin.x += 1;
            if (L2) sprite.origin.x -= 1;
            if (D2) sprite.origin.y += 1;
            if (U2) sprite.origin.y -= 1;
        }
        else
        {
            if (R1) sprite.offset.x += 1;
            if (L1) sprite.offset.x -= 1;
            if (D1) sprite.offset.y += 1;
            if (U1) sprite.offset.y -= 1;
            
            if (R2) sprite.angle++;
            if (L2) sprite.angle--;
        }
        
    }
}

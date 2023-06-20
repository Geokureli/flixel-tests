package states;

import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxAngle.angleBetween as angleBetween_new;
import flixel.math.FlxAngle.TO_DEG;

class AngleBetweenTestState extends flixel.FlxState
{
    var spriteA:FlxSprite;
    var spriteB:FlxSprite;
    var field:FlxText;
    
    override function create()
    {
        super.create();
        
        add(spriteA = new FlxSprite("assets/images/haxe.png"));
        spriteA.screenCenter();
        
        add(spriteB = new FlxSprite("assets/images/haxe.png"));
        
        add(field = new FlxText(""));
    }
    
    override function update(elapsed:Float)
    {
        spriteB.x = FlxG.mouse.x - spriteB.origin.x;
        spriteB.y = FlxG.mouse.y - spriteB.origin.y;
        
        final oldResult = angleBetween_old(spriteA, spriteB, true);
        final newResult = angleBetween_new(spriteA, spriteB, true);
        
        field.text = 'old: $oldResult\nnew: $newResult';
    }
    
    public static function angleBetween_old(SpriteA:FlxSprite, SpriteB:FlxSprite, AsDegrees:Bool = false):Float
    {
        var dx:Float = (SpriteB.x + SpriteB.origin.x) - (SpriteA.x + SpriteA.origin.x);
        var dy:Float = (SpriteB.y + SpriteB.origin.y) - (SpriteA.y + SpriteA.origin.y);
        
        if (AsDegrees)
            return Math.atan2(dy, dx) * TO_DEG;
        else
            return Math.atan2(dy, dx);
    }
}
package states;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxCamera;

class OfffsetRotateTestState extends flixel.FlxState
{
    inline static var ROT_SPEED = 200;
    inline static var ROT_STAGGER = -30;
    
    var sprites = new FlxTypedGroup<FlxSprite>();
    
    override function create():Void
    {
        var sprite:FlxSprite;
        
        sprite = new FlxSprite("assets/images/haxe.png");
        sprite.screenCenter();
        sprites.add(sprite);
        sprite.offset.set(80, 20);
        
        sprite = new FlxSprite("assets/images/haxe.png");
        sprite.screenCenter();
        sprites.add(sprite);
        sprite.offset.set(140, 80);
        
        sprite = new FlxSprite("assets/images/haxe.png");
        sprite.screenCenter();
        sprites.add(sprite);
        sprite.offset.set(160, 160);
        
        add(sprites);
    }
    
    override function update(elapsed:Float):Void
    {
        for (sprite in sprites)
        {
            sprite.offset.degrees += ROT_SPEED * elapsed;
        }
    }
}
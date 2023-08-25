package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxAsepriteUtil;
import flixel.system.FlxAssets;

using flixel.graphics.FlxAsepriteUtil;

class AseAtlasTestState extends flixel.FlxState
{
    var sprite:AseAtlasSprite;
    
    override function create()
    {
        super.create();
        
        sprite = new AseAtlasSprite("adventurerAssets/adventurer.png", "adventurerAssets/adventurer.json");
        sprite.animation.play("idle");
        add(sprite);
        
        final a = new flixel.FlxObject();
        final b = new flixel.FlxObject();
        
        FlxG.collide(a, b, function (a:flixel.FlxObject, b:flixel.FlxObject) { });
        FlxG.watch
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.pressed.RIGHT)
        {
            sprite.flipX = false;
            sprite.animation.play("run");
        }
        else if (FlxG.keys.pressed.LEFT)
        {
            sprite.flipX = true;
            sprite.animation.play("run");
        }
        else if (FlxG.keys.pressed.DOWN)
            sprite.animation.play("crouch");
        else
            sprite.animation.play("idle");
    }
}

@:forward
abstract AseAtlasSprite(FlxSprite) to FlxSprite
{
    public function new(x = 0, y = 0, graphic, data:FlxAsepriteJsonAsset)
    {
        this = new FlxSprite(x, y);
        this.loadAseAtlasAndTagsByPrefix(graphic, data);
    }
}
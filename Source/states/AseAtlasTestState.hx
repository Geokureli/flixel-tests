package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets;

class AseAtlasTestState extends flixel.FlxState
{
    var sprite:AseAtlasSprite;
    
    override function create()
    {
        super.create();
        
        sprite = new AseAtlasSprite("adventurerAssets/adventurer.png", "adventurerAssets/adventurer.json");
        sprite.animation.play("idle");
        add(sprite);
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
        
        final aseData:AsepriteAtlasObject = cast data.getData();
        this.frames = FlxAtlasFrames.fromAseprite(graphic, data);
        
        for (frameTag in aseData.meta.frameTags)
            this.animation.addByPrefix(frameTag.name, frameTag.name + " ");
    }
}


typedef AsepriteAtlasObject = TexturePackerObject &
{
	var frames:Dynamic;
	var meta:AsepriteAtlasMetaObject;
}

typedef AsepriteAtlasMetaObject =
{
	var app:String;
	var version:String;
	var image:String;
	var format:String;
	var size:{ w:Int, h:Int };
	var scale:String;
	var frameTags: Array<{ name: String, from:Int, to:Int, direction:String }>;
}
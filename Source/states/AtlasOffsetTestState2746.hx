package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxBitmapText;
import flixel.util.FlxColor;

import openfl.Assets;

class AtlasOffsetTestState2746 extends flixel.FlxState
{
    var sprite1:BF;
    var sprite2:BF;
    
    override function create()
    {
        super.create();
        
        // FlxG.camera.bgColor = FlxColor.WHITE;
        
        sprite1 = new BF(false);
        sprite1.screenCenter();
        sprite1.x -= sprite1.width / 2;
        add(sprite1);
        
        final text1 = new Text("Original");
        text1.centerBelow(sprite1);
        add(text1);
        
        sprite2 = new BF(true);
        sprite2.screenCenter();
        sprite2.x += sprite2.width / 2;
        add(sprite2);
        
        final text2 = new Text("Fixed");
        text2.centerBelow(sprite2);
        add(text2);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final anim
            =    if (FlxG.keys.pressed.RIGHT) "right";
            else if (FlxG.keys.pressed.LEFT ) "left";
            else if (FlxG.keys.pressed.UP   ) "up";
            else if (FlxG.keys.pressed.DOWN ) "down";
            else if (FlxG.keys.pressed.SPACE) "hey";
            else "idle";
        
        sprite1.animation.play(anim);
        sprite2.animation.play(anim);
    }
}

abstract Text(FlxBitmapText) to FlxBitmapText
{
    public function new (x = 0.0, y = 0.0, text, ?font)
    {
        this = new FlxBitmapText(font);
        this.text = text;
        
        this.scale.set(4, 4);
        this.updateHitbox();
    }
    
    public function centerBelow(sprite:FlxSprite)
    {
        this.x = sprite.x + (sprite.width - this.width) / 2;
        this.y = sprite.y + sprite.height;
    }
}

@:forward
abstract BF(FlxSprite) to FlxSprite
{
    public function new (x = 0.0, y = 0.0, offsetAnims:Bool)
    {
        this = new FlxSprite(x, y);
        // ensure unique graphic for offset and non-offset
        final graphic = FlxG.bitmap.add("assets/images/bf/bf.png", 'bf:${offsetAnims ? "offset" : "original"}');
        final atlas = FlxAtlasFrames.fromSparrow(graphic, "assets/images/bf/bf.xml");
        this.frames = atlas;
        
        if (offsetAnims)
        {
            atlas.addFramesOffsetByPrefix("BF idle dance" , -5 , -0 );
            atlas.addFramesOffsetByPrefix("BF HEY!!"      , -7 , -5 );
            atlas.addFramesOffsetByPrefix("BF NOTE LEFT0" , -4 ,  7 );
            atlas.addFramesOffsetByPrefix("BF NOTE DOWN0" ,  22,  51);
            atlas.addFramesOffsetByPrefix("BF NOTE UP0"   ,  47, -28);
            atlas.addFramesOffsetByPrefix("BF NOTE RIGHT0",  48,  5 );
        }
        
        this.antialiasing = false;
        
        this.animation.addByPrefix("idle" , "BF idle dance" , 24, false);
        this.animation.addByPrefix("hey"  , "BF HEY!!"      , 24, false);
        this.animation.addByPrefix("left" , "BF NOTE LEFT0" , 24, false);
        this.animation.addByPrefix("down" , "BF NOTE DOWN0" , 24, false);
        this.animation.addByPrefix("up"   , "BF NOTE UP0"   , 24, false);
        this.animation.addByPrefix("right", "BF NOTE RIGHT0", 24, false);
    }
}

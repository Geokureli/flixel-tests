package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class RotateFrameTestState3433 extends flixel.FlxState
{
    override function create()
    {
        final graphic = FlxG.bitmap.create(150, 150, 0xFFffffff);
        graphic.bitmap.fillRect(new openfl.geom.Rectangle(10, 120, 130, 20), 0xFF0000ff);
        
        final sprite1 = new FlxSprite(10, 10);
        sprite1.frames = FlxAtlasFrames.fromSparrow(graphic, xml);
        sprite1.animation.addByPrefix("static", "TestAnimation0001", 2);
        sprite1.animation.play("static");
        add(sprite1);
        
        final sprite2 = new FlxSprite(170, 10);
        sprite2.frames = FlxAtlasFrames.fromSparrow(graphic, xml);
        sprite2.animation.addByPrefix("static", "TestAnimation0002", 2);
        sprite2.animation.play("static");
        add(sprite2);
        
        final sprite3 = new FlxSprite(330, 10);
        sprite3.frames = FlxAtlasFrames.fromSparrow(graphic, xml);
        sprite3.animation.addByPrefix("static", "TestAnimation", 2);
        sprite3.animation.play("static");
        add(sprite3);
    }
    
    override function draw()
    {
        super.draw();
    }
}

private final xml = 
'<?xml version="1.0" encoding="UTF-8"?>
<TextureAtlas imagePath="TestImage.png">
    <SubTexture name="TestAnimation0001" x="0" y="0" width="150" height="150" rotated="false"/>
    <SubTexture name="TestAnimation0002" x="0" y="0" width="150" height="150" rotated="true"/>
</TextureAtlas>';
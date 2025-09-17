package states;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class AseAtlasTestState3473 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final sprite = new FlxSprite();
        sprite.frames = FlxAtlasFrames.fromAseprite("adventurerAssets/adventurer.png", "adventurerAssets/adventurer.json");
        add(sprite);
    }
}

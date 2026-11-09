package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;

class AtlasLeakTestState extends FlxState
{
	override function create():Void {
		final bf = new BF();
		bf.animation.play("idle");
		add(bf);

		super.create();
	}

    override function update(elapsed:Float):Void {
        if (FlxG.keys.justPressed.ENTER)
			FlxG.switchState(AtlasLeakTestState.new);

		super.update(elapsed);
	}

	override function destroy():Void {
		// FlxG.bitmap.clearCache();
		super.destroy();
	}
}

@:forward
abstract BF(FlxSprite) to FlxSprite
{
    public function new (x = 0.0, y = 0.0)
    {
        this = new FlxSprite(x, y);
        final atlas = FlxAtlasFrames.fromSparrow("assets/images/bf/bf.png", "assets/images/bf/bf.xml");
        this.frames = atlas;
        
        atlas.addFramesOffsetByPrefix("BF idle dance" , -5 , -0 );
        atlas.addFramesOffsetByPrefix("BF HEY!!"      , -7 , -5 );
        atlas.addFramesOffsetByPrefix("BF NOTE LEFT0" , -4 ,  7 );
        atlas.addFramesOffsetByPrefix("BF NOTE DOWN0" ,  22,  51);
        atlas.addFramesOffsetByPrefix("BF NOTE UP0"   ,  47, -28);
        atlas.addFramesOffsetByPrefix("BF NOTE RIGHT0",  48,  5 );
        
        this.antialiasing = false;
        
        this.animation.addByPrefix("idle" , "BF idle dance" , 24, false);
        this.animation.addByPrefix("hey"  , "BF HEY!!"      , 24, false);
        this.animation.addByPrefix("left" , "BF NOTE LEFT0" , 24, false);
        this.animation.addByPrefix("down" , "BF NOTE DOWN0" , 24, false);
        this.animation.addByPrefix("up"   , "BF NOTE UP0"   , 24, false);
        this.animation.addByPrefix("right", "BF NOTE RIGHT0", 24, false);
    }
}

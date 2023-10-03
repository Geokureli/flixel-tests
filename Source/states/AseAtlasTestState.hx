package states;

import flixel.graphics.atlas.AseAtlas;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxAsepriteUtil;
import flixel.system.FlxAssets;

using flixel.graphics.FlxAsepriteUtil;

class AseAtlasTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        add(new AdventurerSprite(  0, 50, 0.75));
        add(new AdventurerSprite( 50, 50, 1.00));
        add(new AdventurerSprite(100, 50, 1.25));
        add(new AdventurerSprite(150, 50, 1.50));
    }
}

class AdventurerSprite extends AseAtlasSprite
{
    static inline var ATTACK = "attack2";
    
    public var attackTimeScale:Float;
    
    public function new(x = 0, y = 0, attackTimeScale = 1.0)
    {
        this.attackTimeScale = attackTimeScale;
        super(x, y, "adventurerAssets/adventurer.png", "adventurerAssets/adventurer.json");
        animation.play("idle");
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (animation.curAnim.name == ATTACK && animation.finished)
        {
            animation.play("idle");
            animation.timeScale = 1.0;
        }
        
        if (animation.curAnim.name != ATTACK)
        {
            if (FlxG.keys.pressed.RIGHT)
            {
                flipX = false;
                animation.play("run");
            }
            else if (FlxG.keys.pressed.LEFT)
            {
               flipX = true;
               animation.play("run");
            }
            else if (FlxG.keys.pressed.DOWN)
                animation.play("crouch");
            else
            {
                if (FlxG.keys.pressed.SPACE)
                {
                    animation.play(ATTACK);
                    animation.timeScale = attackTimeScale;
                }
                else if (animation.curAnim.name != "idle")
                    animation.play("idle");
            }
        }
    }
}

class AseAtlasSprite extends FlxSprite
{
    public function new(x = 0, y = 0, graphic, data:FlxAsepriteJsonAsset)
    {
        super(x, y);
        
        FlxAsepriteUtil.loadAseAtlasAndTagsByPrefix(this, graphic, data);
    }
}
package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

/**
 * Made for https://github.com/HaxeFlixel/flixel/pull/2811
 */
class ReverseAnimTestState2811 extends flixel.FlxState
{
    var sprite:FlxSprite;
    var animText:FlxText;
    var stateText:FlxText;
    
    override function create()
    {
        super.create();
        
        add(sprite = new FlxSprite(50, 50));
        sprite.loadGraphic("assets/images/haxe-anim.png", true);
        sprite.animation.add("idle", [0]);
        final numFrames = sprite.animation.numFrames;
        sprite.animation.add("anim", [for (i in 0...numFrames) i], numFrames, false);
        sprite.animation.play("idle");
        
        add(animText = new FlxText(sprite.x, sprite.y + sprite.height, "idle", 24));
        add(stateText = new FlxText(animText.x, animText.y + animText.height, "initial", 24));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final anim = sprite.animation;
        
        if (FlxG.keys.justPressed.PERIOD)
        {
            stateText.text = "forward";
            anim.play("anim", true);
            anim.finishCallback = function (animName)
            {
                stateText.text = "fired";
                anim.play("idle");
                anim.finishCallback = null;
            };
        }
        
        if (FlxG.keys.justPressed.COMMA)
        {
            stateText.text = "reverse";
            anim.play("anim", true, true);
            anim.finishCallback = function (animName)
            {
                stateText.text = "fired";
                anim.play("idle");
                anim.finishCallback = null;
            };
        }
        
        animText.text = '${anim.name}:${anim.frameIndex}';
    }
}

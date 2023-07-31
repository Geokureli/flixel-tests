package states;

import flixel.FlxSprite;
import flixel.FlxG;
import tools.FlxColorEffectList;
import openfl.geom.ColorTransform;

class ColorEffectListTestState2869 extends flixel.FlxState
{
    var sprite:FlxSprite;
    
    override function create()
    {
        sprite = new FlxSprite("assets/images/haxe-anim.png");
        sprite.loadGraphic("assets/images/haxe-anim.png", true);
        sprite.animation.add("loop", [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1], 10);
        sprite.animation.play("loop");
        sprite.screenCenter();
        add(sprite);
        
        final list = new FlxColorEffectList(sprite);
        list.add(new FlxBrightnessTransform(0.5));
        list.add(new FlxTintTransform(0xFF00FF, 0.5));
        add(list);
    }
}

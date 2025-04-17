package sprites;

import flixel.util.FlxAxes;

class AnimSprite extends flixel.FlxSprite
{
    public var curAnim(default, null):Anim;
    
    public function new (x = 0.0, y = 0.0, fps = 8.0)
    {
        super(x, y);
        loadGraphic("assets/images/haxe-anim.png", true);
        animation.add("once", [for (i in 0...9) i], fps, false);
        animation.add("loop", [for (i in 0...9) i], fps);
        animation.add("yoyo", [0,1,2,3,4,5,6,7,8,7,6,5,4,3,2,1], 8);
        animation.add("flipX", [for (i in 0...9) i], fps, true, true);
        animation.add("flipY", [for (i in 0...9) i], fps, true, false, true);
        animation.add("flipXY", [for (i in 0...9) i], fps, true, true, true);
        animation.play("yoyo");
    }
    
    public function playAnim(anim:Anim)
    {
        curAnim = anim;
        animation.play(switch anim
        {
            case ONCE: "once";
            case LOOP: "loop";
            case YOYO: "yoyo";
            case FLIP(X): "flipX";
            case FLIP(Y): "flipY";
            case FLIP(XY): "flipXY";
            case FLIP(NONE): throw "invalid FLIP(XY)";
        });
    }
}

enum Anim
{
    ONCE;
    LOOP;
    YOYO;
    FLIP(axes:FlxAxes);
}
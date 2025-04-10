package states;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.geom.Rectangle;

class ClipRectPortalTestState extends flixel.FlxState
{
    var portal:FlxSprite;
    var hand:FlxSprite;
    
    override function create():Void
    {
        add(portal = new FlxSprite(0, 50).makeGraphic(100, 20, 0xFF0000ff));
        portal.screenCenter(X);
        add(hand = new FlxSprite().makeGraphic(80, 200, 0xFFff8f32));
        hand.graphic.bitmap.fillRect(new Rectangle(0, 0, 15, 150), 0x0);
        hand.graphic.bitmap.fillRect(new Rectangle(65, 0, 15, 150), 0x0);
        hand.screenCenter(X);
        
        final frameHeight = hand.frameHeight;
        final portal_y = portal.y + portal.height;
        hand.y = portal_y - frameHeight;
        hand.clipRect = new FlxRect(0, frameHeight, hand.frameWidth, frameHeight);

        function onComplete (_)
        {
            trace("complete");
            hand.clipRect = null;
        }

        FlxTween.num(frameHeight, 0, 0.5, { ease: (t)->FlxEase.smootherStepIn(FlxEase.quintOut(t)), onComplete: onComplete },
        // FlxTween.num(frameHeight, 0, 0.5, { ease: FlxEase.smoothStepIn, onComplete: onComplete },
            function (num)
            {
                // FlxG.watch.addQuick("num", num);
                // FlxG.watch.addQuick("clipRect.height", hand.clipRect.height);
                hand.y = portal_y - num;
                hand.clipRect.y = num;
                hand.clipRect = hand.clipRect;
            }
        );
        trace("start");
    }
}



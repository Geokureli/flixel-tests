package states;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxState;

class MidpointTestState extends FlxState
{

    override function create()
    {
        var sizes:Array<Array<Float>> = [[1, 1], [0.9, 0.9], [0.6, 1.3], [0.7, 0.8], [1.4, 1.2]];

        for(i in 0...sizes.length){
            var box = new FlxSprite((i+1) * (FlxG.width/(sizes.length + 2)), 0).makeGraphic(72, 72, 0xFFFFFFFF);
            box.screenCenter(Y);
            box.setGraphicSize(box.width * sizes[i][0], box.height * sizes[i][1]);
            box.updateHitbox();
            add(box);

            var wrong = new FlxSprite(box.getGraphicMidpoint().x, box.getGraphicMidpoint().y).makeGraphic(9, 9, 0xFFFF0000);
            wrong.offset.set(4, 4);
            add(wrong);

            var correct = new FlxSprite(getGraphicMidpointFix(box).x, getGraphicMidpointFix(box).y).makeGraphic(9, 9, 0xFF00FFFF);
            correct.offset.set(4, 4);
            add(correct);
        }

        super.create();
    }

    function getGraphicMidpointFix(sprite:FlxSprite, ?point:FlxPoint):FlxPoint
    {
        if (point == null)
        {
            point = FlxPoint.get();
        }
        return point.set(sprite.x + sprite.frameWidth * 0.5 * sprite.scale.x, sprite.y + sprite.frameHeight * 0.5 * sprite.scale.y);
    }

}
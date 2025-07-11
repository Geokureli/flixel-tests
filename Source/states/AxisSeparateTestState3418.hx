package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import sprites.RectSprite;
import tools.SpriteDragger;

class AxisSeparateTestState3418 extends flixel.FlxState
{
    var mover:RectSprite;
    var target:RectSprite;
    var wall:RectSprite;
    var resultA:RectSprite;
    var resultB:RectSprite;
    var resultC:RectSprite;
    
    override function create()
    {
        FlxG.cameras.bgColor = FlxColor.GRAY;
        
        add(mover = new RectSprite(0, 0, FlxColor.WHITE, false).orient(0, 0, 100, 100));
        add(wall = new RectSprite(0, 0, FlxColor.BLACK, false).orient(0, 0, 200, 200));
        add(target = new RectSprite(0, 0, FlxColor.GREEN, false).orient(0, 0, 100, 100));
        add(resultA = new RectSprite(0, 0, FlxColor.RED, false).orient(0, 0, 100, 100));
        add(resultB = new RectSprite(0, 0, FlxColor.BLUE, false).orient(0, 0, 100, 100));
        add(resultC = new RectSprite(0, 0, FlxColor.YELLOW, false).orient(0, 0, 100, 100));
        target.alpha = 0.75;
        resultA.alpha = 0.75;
        resultB.alpha = 0.75;
        resultC.alpha = 0.75;
        
        wall.screenCenter();
        wall.immovable = true;
        mover.x = wall.x + wall.width + 100;
        mover.y = wall.y + wall.height - 100;
        target.x = wall.x + wall.width - 10;
        target.y = wall.y + wall.height + 10;
        final moverDragger = new SpriteDragger(mover);
        final targetDragger = new SpriteDragger(target);
        add(moverDragger);
        add(targetDragger);
        
        FlxG.collision.maxOverlap = Math.POSITIVE_INFINITY;
        
        FlxG.watch.addFunction("mover.state", ()->moverDragger.state);
        FlxG.watch.addFunction("target.state", ()->targetDragger.state);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        resultA.x = resultB.x = target.x;
        resultA.y = resultB.y = target.y;
        resultA.last.set(mover.x, mover.y);
        resultB.last.set(mover.x, mover.y);
        resultC.last.set(mover.x, mover.y);
        
        FlxG.collision.separate(resultA, wall);
        FlxObject.separate(resultB, wall);
        // FlxColliderUtil.
    }
}
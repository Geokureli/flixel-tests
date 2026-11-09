package states;

import flixel.FlxG;
import flixel.effects.FlxMatrixSprite;

class MatrixSpriteTestState extends flixel.FlxState
{
    public var sprite:FlxMatrixSprite;
    
    override function create()
    {
        super.create();
        
        add(sprite = new FlxMatrixSprite());
        sprite.loadGraphic("assets/images/haxe-anim.png", true);
        sprite.animation.add("loop", [for (i in 0...9) i], 16);
        sprite.animation.play("loop");
        sprite.screenCenter();
        // sprite.renderMatrix.skewDegrees(45, 45);
        
        FlxG.watch.addFunction("matrix", ()->sprite.renderMatrix);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        sprite.renderMatrix.a += elapsed * ((FlxG.keys.pressed.D ? 1 : 0) - (FlxG.keys.pressed.A ? 1 : 0));
        sprite.renderMatrix.d += elapsed * ((FlxG.keys.pressed.W ? 1 : 0) - (FlxG.keys.pressed.S ? 1 : 0));
        sprite.renderMatrix.c += elapsed * ((FlxG.keys.pressed.RIGHT ? 1 : 0) - (FlxG.keys.pressed.LEFT ? 1 : 0));
        sprite.renderMatrix.b += elapsed * ((FlxG.keys.pressed.UP ? 1 : 0) - (FlxG.keys.pressed.DOWN ? 1 : 0));
    }
}

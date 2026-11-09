package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxArrayUtil;

class JumpTestState extends flixel.FlxState
{
    var sprite:FlxSprite;
    var box:FlxSprite;
    var pad:FlxVirtualPad;
    
    override function create()
    {
        super.create();
        
        sprite = new Jumper();
        sprite.x = FlxG.width / 2 - sprite.width / 2;
        add(sprite);
        
        box = new FlxSprite();
        box.makeGraphic(40, 40);
        box.x = FlxG.width / 2 - box.width / 2;
        box.y = FlxG.height * 0.75 - box.height / 2;
        box.immovable = true;
        add(box);
        
        pad = new FlxVirtualPad(FlxDPadMode.NONE, FlxActionMode.A);
        add(pad);
    }
    
    override function update(elapsed:Float)
    {
        // call super.update first, as it sets touching flags to NONE
        super.update(elapsed);
        
        FlxG.watch.addQuick("sprite.pre-vy", sprite.velocity.y);
        
        // If sprite is resting on box it will set its touching to DOWN
        FlxG.collide(box, sprite);
        // if (FlxG.collide(box, sprite) && Math.abs(sprite.velocity.y) < 10)
        //     sprite.velocity.y = 0;
        
        final a = pad.getButton(A);
        
        // jump if touching the box, and jump is pressed
        if (a.justPressed && sprite.isTouching(DOWN))
            sprite.velocity.y = -300;
        
        FlxG.watch.addQuick("isTouching(floor)", sprite.isTouching(FLOOR));
        FlxG.watch.addQuick("isTouching(down)", sprite.isTouching(DOWN));
        FlxG.watch.addQuick("is/wasTouching(down)", sprite.isTouching(DOWN) || sprite.justTouched(DOWN));
        FlxG.watch.addQuick("a.press", a.pressed);
        FlxG.watch.addQuick("a.justPress", a.justPressed);
        FlxG.watch.addQuick("sprite.post-vy", sprite.velocity.y);
    }
}


class Jumper extends FlxSprite
{
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        makeGraphic(24, 24);
        acceleration.y = 900;
        maxVelocity.y = 300;
        elasticity = 0.5;
        drag.y = 300;
    }
    
    override function updateMotion(elapsed)
    {
        super.updateMotion(elapsed);
    }
}
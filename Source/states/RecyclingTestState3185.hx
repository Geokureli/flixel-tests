package states;

import flixel.group.FlxGroup;

class RecyclingTestState3185 extends flixel.FlxState
{
    var bullets:FlxTypedGroup<Bullet>;
    
    override function create()
    {
        super.create();
        
        bullets = new FlxTypedGroup();
        
        var bullet = new Bullet();
        bullets.add(bullet);
        bullet.kill();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        var bullet = bullets.recycle(Bullet);
        if (bullets.length > 1)
            throw "Bullet wasn't recycled";
        
        if (bullet.graphic == null || bullet.graphic.isDestroyed)
            throw "Bullet was destroyed";
        
        bullet.kill();
    }
}


class Bullet extends flixel.FlxSprite
{
    public function new()
    {
        super();
        makeGraphic(30, 30);
    }

    override function kill()
    {
        super.kill();
    }

    override function revive()
    {
        super.revive();
    }
}
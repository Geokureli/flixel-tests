package states;

import flixel.FlxObject;
import flixel.FlxG;

class HealthTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final obj = new #if FLX_HEALTH FlxObject #else ObjectHealth #end();
        obj.health = 10;
        obj.hurt(1);
    }
}

#if FLX_NO_HEALTH
class ObjectHealth extends FlxObject
{
    public var health:Int = 0;
    
    public function hurt(damage:Int)
    {
        health = health - damage;
        if (health <= 0)
            kill();
    }
}
#end
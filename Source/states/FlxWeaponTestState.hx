package states;

import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.helpers.FlxBounds;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;

class FlxWeaponTestState extends flixel.FlxState
{
    var weapon:FlxWeapon;
    var gun:FlxSprite;
    
    override function create()
    {
        super.create();
        
        add(gun = new FlxSprite(100, 100, "assets/images/haxe.png"));
        weapon = new FlxWeapon
            ("test", (w)->new FlxBullet()
            , PARENT
                ( gun
                , new FlxBounds(FlxPoint.get(0, 0), FlxPoint.get(gun.frameWidth, gun.frameHeight))
                , true
                , 50
                )
            , SPEED(new FlxBounds(100.0, 200.0))
            );
        
        add(weapon.group);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        gun.angle = FlxAngle.degreesBetweenMouse(gun);
        weapon.fireFromParentAngle(new FlxBounds(-20.0, 20.0));
    }
}

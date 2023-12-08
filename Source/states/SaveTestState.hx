package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class SaveTestState extends flixel.FlxState
{
    var playerPos:FlxPoint;
    var player:Player;
    
    public function new(?playerPos:FlxPoint)
    {
        this.playerPos = playerPos;
        super();
    }
    
    override function create()
    {
        super.create();
        
        player = new Player();
        add(player);
        
        if (playerPos != null)
            player.setPosition(playerPos.x, playerPos.y);
        else
            player.screenCenter();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.pressed.SPACE)
            FlxG.switchState(new SaveTestState(FlxPoint.get(player.x, player.y)));
    }
}


class Player extends FlxSprite
{
    static inline var SPEED = 200;
    static inline var SPEED_UP_TIME = 0.25;
    static inline var ACCEL = SPEED / SPEED_UP_TIME;
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        makeGraphic(100, 100, FlxColor.fromHSB(FlxG.random.int(0, 360), 1.0, 1.0));
        maxVelocity.set(SPEED, SPEED);
        drag.set(ACCEL, ACCEL);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final l = FlxG.keys.pressed.LEFT;
        final r = FlxG.keys.pressed.RIGHT;
        final u = FlxG.keys.pressed.UP;
        final d = FlxG.keys.pressed.DOWN;
        
        acceleration.set(0, 0);
        acceleration.x = (r ? ACCEL : 0) - (l ? ACCEL : 0);
        acceleration.y = (d ? ACCEL : 0) - (u ? ACCEL : 0);
    }
}
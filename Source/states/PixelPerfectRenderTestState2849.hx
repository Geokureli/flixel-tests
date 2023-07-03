package states;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;

class PixelPerfectRenderTestState2849 extends flixel.FlxState
{
    var bar:Bar;
    var walls:FlxGroup;
    override function create()
    {
        super.create();
        
        FlxG.camera.pixelPerfectRender = true;
        bar = new Bar(0, 100);
        bar.velocity.set(100, 100);
        bar.elasticity = 1;
        add(bar);
        
        walls = FlxCollision.createCameraWall(FlxG.camera, 10);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        FlxG.collide(bar, walls);
        
        if (FlxG.keys.justPressed.P)
            openSubState(new PauseSubState());
        
        bar.angularVelocity = 180 * ((FlxG.keys.pressed.RIGHT ? 1 : 0) - (FlxG.keys.pressed.LEFT ? 1 : 0));
    }
}

class PauseSubState extends flixel.FlxSubState
{
    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.Q)
            close();
    }
}

@:forward
abstract Bar(FlxBar) to FlxBar
{
    public function new(min = 0, max = 100):Void
    {
        this = new FlxBar(0, 0, LEFT_TO_RIGHT, 20, 5, null, "", min, max, true);
        this.createFilledBar(0xff510000, 0xfff40000, true);
        
        this.value = (max - min) / 2;
    }
}
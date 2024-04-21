package states;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxContainer;
import flixel.util.FlxColor;

class ContainerCameraTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        FlxG.camera.scroll.set(10, 10);
        
        final uiCam = new FlxCamera().copyFrom(FlxG.camera);
        uiCam.scroll.set(-10, -10);
        uiCam.bgColor = 0x0;
        FlxG.cameras.add(uiCam, false);
        
        final uiGroup = new FlxContainer();
        add(uiGroup);
        
        final healthBars = new FlxTypedContainer<Health>();
        uiGroup.add(healthBars);
        
        // final healthBar = uiGroup;
        
        final outerBar = new Health(50, 50, 100, 20, FlxColor.GREEN);
        healthBars.add(outerBar);
        
        final innerBar = new Health(52, 52, 96, 16, FlxColor.BLUE);
        healthBars.add(innerBar);
        
        uiGroup.cameras = [uiCam];
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final uiCam = FlxG.cameras.list[1];
        final uiGroup = members[0];
        // if (FlxG.mouse.justPressed)
        //     uiCam.bgColor = (uiCam.bgColor == 0x0 ? FlxColor.RED : 0x0);
        
        if (FlxG.keys.justPressed.SPACE)
            uiGroup.camera = (uiGroup.camera == FlxG.camera ? uiCam : FlxG.camera);
        
        final cam = FlxG.keys.pressed.SHIFT ? uiCam : FlxG.camera;
        
        final xMove = 100 * ((FlxG.keys.pressed.RIGHT ? 1 : 0) - (FlxG.keys.pressed.LEFT ? 1 : 0));
        final yMove = 100 * ((FlxG.keys.pressed.DOWN ? 1 : 0) - (FlxG.keys.pressed.UP ? 1 : 0));
        FlxG.watch.addQuick("move", '(x: $xMove, y: $yMove)');
        cam.scroll.add(xMove * elapsed, yMove * elapsed);
    }
}

class Health extends FlxContainer
{
    public function new(x, y, width, height, color:FlxColor):Void
    {
        super();

        final healthBar = new FlxSprite(x, y);
        healthBar.makeGraphic(width, height, color);
        add(healthBar);
    }
    
    override function draw()
    {
        super.draw();
        
        function getCam(obj:FlxBasic)
        {
            final cams = obj.getCameras();
            return cams != null && cams.length > 0
                ? Std.string(cams[0] == FlxG.camera ? "main" : "ui")
                : "null"
                ;
        }
        
        FlxG.watch.addQuick('$ID', getCam(this));
        if (members.length > 0)
            FlxG.watch.addQuick('$ID-bar', getCam(members[0]));
    }
}

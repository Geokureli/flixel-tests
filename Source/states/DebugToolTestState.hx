package states;


import flixel.addons.display.FlxBackdrop;
import flash.display.BitmapData;
import flash.ui.Keyboard;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.debug.console.ConsoleUtil;
import flixel.system.debug.interaction.Interaction;

enum TestEnum { A; B; C; }

class DebugToolTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        add(new FlxBackdrop("assets/images/haxe.png"));
        #if debug
        
        FlxG.game.debugger.interaction.addTool(new DebugTool(AGraphic, "a"));
        
        addDebugTools();
        
        FlxG.game.debugger.interaction.addTool(new DebugTool(BGraphic, "b"));
        FlxG.game.debugger.interaction.addTool(new DebugTool(CGraphic, "c"));
        #else
        final text = new FlxText("this test is only available\nwith debug features enabled", 24);
        text.setBorderStyle(OUTLINE, 0xFF000000, 2);
        text.screenCenter();
        add(text);
        #end
    }
    
    #if debug
    var camTool:DebugTool;
    
    public function addDebugTools()
    {
        camTool = new DebugTool(CameraGraphic, "camera");
        FlxG.game.debugger.interaction.addTool(camTool);
        
        FlxG.console.registerObject("cam", FlxG.camera);
        FlxG.console.registerEnum(TestEnum);
    }
    
    public function removeDebugTools()
    {
        FlxG.game.debugger.interaction.removeTool(camTool);
        camTool.destroy();
        camTool = null;
        
        FlxG.console.removeByAlias("cam");
        FlxG.console.removeEnum(TestEnum);
    }
    #end
    
    override function update(elapsed)
    {
        super.update(elapsed);
        #if debug
        if (FlxG.keys.justPressed.SPACE)
        {
            if (camTool == null)
                addDebugTools();
            else
                removeDebugTools();
        }
        #end
    }
}

@:bitmap("assets/images/a.png")
private class AGraphic extends BitmapData {}
@:bitmap("assets/images/b.png")
private class BGraphic extends BitmapData {}
@:bitmap("assets/images/c.png")
private class CGraphic extends BitmapData {}

@:bitmap("assets/images/cameramover.png")
private class CameraGraphic extends BitmapData {}


class DebugTool extends flixel.system.debug.interaction.tools.Tool
{
    var graphicClass:Class<BitmapData>;
    
    public function new (graphicClass, name)
    {
        this.graphicClass = graphicClass;
        super();
        
        _name = name;
    }
    
    override function init(brain:Interaction)
    {
        super.init(brain);
        
        setButton(graphicClass);
        
        return this;
    }
}
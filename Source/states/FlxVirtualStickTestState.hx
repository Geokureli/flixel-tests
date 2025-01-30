package states;

import flixel.FlxG;
import flixel.ui.FlxAnalog;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualStick;

class FlxVirtualStickTestState extends flixel.FlxState
{
    var stick1:FlxVirtualStick;
    var stick2:FlxVirtualStick;
    var analog1:FlxAnalog;
    var analog2:FlxAnalog;
    var button1:FlxButton;
    var button2:FlxButton;
    
    override function create()
    {
        add(stick1 = new FlxVirtualStick());
        stick1.x = 50;
        stick1.y = FlxG.height - stick1.height - 50;
        
        add(stick2 = new FlxVirtualStick());
        stick2.x = 50 + stick1.width / 2;
        stick2.y = FlxG.height - stick2.height - 50;
        @:privateAccess
        FlxG.watch.addFunction("stick2.input", ()->'${stick2.button.currentInput}');
        @:privateAccess
        FlxG.watch.addFunction("stick2.pressed", ()->'${stick2.button.pressed}');
        
        stick1.onMoveStart.add(()->trace("start"));
        stick1.onMoveEnd.add(()->trace("end"));
        stick1.onMove.add(()->trace("move"));
        
        add(analog1 = new FlxAnalog());
        analog1.x = FlxG.width - analog1.width - 50;
        analog1.y = FlxG.height - analog1.height - 50;
        
        add(analog2 = new FlxAnalog());
        analog2.x = FlxG.width - analog2.width - analog1.width / 2 - 50;
        analog2.y = FlxG.height - analog2.height - 50;
    }
}
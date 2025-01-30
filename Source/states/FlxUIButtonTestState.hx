package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUIButton;

class 
FlxUIButtonTestState extends flixel.FlxState
{
    var button:FlxUIButton;
    
    override function create()
    {
        super.create();
        
        add(button = new FlxUIButton(10, 10, "button", ()->trace("click")));
        button.has_toggle = true;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUITypedButton;

class UiBUttonTestState296 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        final button = new FlxUITypedButton(0, 0, ()->trace("Click"));
        add(button);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

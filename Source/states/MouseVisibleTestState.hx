package states;

import flixel.FlxG;

class MouseVisibleTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
		FlxG.mouse.visible = false;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

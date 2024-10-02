package states;

import flixel.addons.display.FlxStarField;
import flixel.FlxG;

// https://github.com/HaxeFlixel/flixel-ui/pull/283
class StarFieldTestState extends flixel.FlxState
{
    
    override function create()
    {
        super.create();
        
        add(new FlxStarField2D(0, 0, FlxG.width, FlxG.height));
    }
}

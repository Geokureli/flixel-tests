package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUIRadioGroup;

/**
 * https://github.com/HaxeFlixel/flixel-ui/pull/254
 */
class UiListTestState254 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final labels = ["Option 1", "Option 2", "Option 3"];
        final radioGroup = new FlxUIRadioGroup(0, 0, labels, labels);
        radioGroup.destroy(); // radio group was destroyed, but list buttons weren't. Their graphics are still present in the cache
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

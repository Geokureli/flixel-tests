package states;

import flixel.FlxG;
import flixel.addons.ui.FlxInputText;

/**
 * https://github.com/HaxeFlixel/flixel-ui/pull/253
 */
class UiInputTextState253 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var text = new FlxInputText(50, 50, "Input Text");
        add(text);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

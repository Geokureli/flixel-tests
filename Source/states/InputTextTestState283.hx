package states;

import flixel.util.FlxColor;
import flixel.FlxG;

// https://github.com/HaxeFlixel/flixel-ui/pull/283
class InputTextTestState283 extends flixel.FlxState
{
    
    override function create()
    {
        super.create();
        
        bgColor = 0xFF808080;
        
        // createNew(10, 10);
        createOld(10, 60);
    }
    
    function createOld(x = 0, y = 0)
    {
        final defaultText = "Enter Username... (Max 40 Characters)";
        final name = new flixel.addons.ui.FlxInputText(x, y, FlxG.width - 20, defaultText, 32);
        name.font = "Arial";
        name.maxLength = 40;
        name.focusGained = function()
        {
            if (name.text == defaultText)
                name.text = "";
        };
        add(name);
    }
    
    function createNew(x = 0, y = 0)
    {
        // final defaultText = "Enter Username... (Max 40 Characters)";
        // final name = new flixel.text.FlxInputText(x, y, FlxG.width - 20, defaultText, 32);
        final name = new flixel.text.FlxInputText(x, y, FlxG.width - 20, "hello", 32);
        // name.font = "Arial";
        // name.maxChars = 40;
        // name.onFocusChange.add(function (focused)
        // {
        //     if (focused && name.text == defaultText)
        //         name.text = "";
        // });
        add(name);
    }
}

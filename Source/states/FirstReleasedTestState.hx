package states;

import flixel.util.FlxColor;
import flixel.FlxG;

class FirstReleasedTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        final input = new flixel.addons.ui.FlxInputText(FlxColor.WHITE);
        add(input);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        FlxG.watch.addQuick("SPACE", "");
        if (FlxG.keys.justReleased.SPACE)
            FlxG.watch.addQuick("SPACE", "JUST RELEASED");
        
        FlxG.watch.addQuick('firstPressed',FlxG.keys.firstPressed());
        FlxG.watch.addQuick('firstJustPressed', FlxG.keys.firstJustPressed());
        FlxG.watch.addQuick('firstJustReleased', FlxG.keys.firstJustReleased());
        // FlxG.watch.addQuick('firstReleased', FlxG.keys.firstReleased());
    }
}

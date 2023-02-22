package states;

import flixel.FlxG;
import flixel.util.FlxSave;

class MergeSaveTestState2735 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var save_1 = new FlxSave();
        save_1.bind('save_1', 'BendyGaming0');
        save_1.data.score = 10000;

        var save_2 = new FlxSave();
        save_2.bind('save_2', 'BendyGaming0');
        save_2.data.score = 5000;

        save_2.mergeDataFrom('save_1', 'BendyGaming0', true, false);
        FlxG.log.add('Score : ${save_2.data.score}');
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

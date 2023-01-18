package states;

import flixel.FlxG;

class FlxTilemapExpTextState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        add(new flixel.addons.tile.FlxTilemapExt());
        
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

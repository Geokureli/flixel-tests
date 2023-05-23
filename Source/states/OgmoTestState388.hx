package states;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;

class OgmoTestState388 extends flixel.FlxState
{
    var map:FlxOgmo3Loader;
    var walls:FlxTilemap;
    
    override function create()
    {
        super.create();
        map = new FlxOgmo3Loader("assets388/data/levelProject.ogmo", "assets388/data/lev1.json");
        walls = map.loadTilemap("assets388/images/tilemap_1.png", 'walls');
        walls.follow();
        walls.setTileProperties(1, NONE);
        walls.setTileProperties(2, ANY);
        add(walls);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTileblock;

class DefaultMovesTestState2980 extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        assertMoves(new FlxObject());
        assertMoves(new FlxSprite());
        assertNotMoves(new FlxText());
        assertNotMoves(new FlxTilemap());
        assertNotMoves(new FlxTileblock(0, 0, 1, 1));
        
        FlxObject.defaultMoves = false;
        assertNotMoves(new FlxObject());
        assertNotMoves(new FlxSprite());
        assertNotMoves(new FlxText());
        assertNotMoves(new FlxTilemap());
        assertNotMoves(new FlxTileblock(0, 0, 1, 1));
        
        FlxObject.defaultMoves = true;
        assertMoves(new FlxObject());
        assertMoves(new FlxSprite());
        assertNotMoves(new FlxText());
        assertNotMoves(new FlxTilemap());
        assertNotMoves(new FlxTileblock(0, 0, 1, 1));
    }
    
    function assertMoves(obj:FlxObject)
    {
        if (obj.moves == false)
            throw 'Expected obj: $obj, moves:FALSE, got TRUE';
    }
    
    function assertNotMoves(obj:FlxObject)
    {
        if (obj.moves)
            throw 'Expected obj: $obj, moves:FALSE, got TRUE';
    }
}

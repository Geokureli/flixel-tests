package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;

import openfl.display.BitmapData;

class TilemapUnitTestState extends flixel.FlxState
{
    override function create()
    {
        final basic:Basic = new Tilemap();
        (cast basic:BaseTilemap<Dynamic>).doSomething();
        
        trace(FlxG.renderBlit);
        trace(FlxG.renderTile);
        
        var object1 = new FlxSprite(8, 4, new BitmapData(8, 12, false, 0xFFff0000));
        var level = new FlxTilemap();
        level.loadMapFromCSV("0,0,1\n0,0,1\n1,1,1", new BitmapData(16, 8));
        
        FlxG.state.add(object1);
        FlxG.state.add(level);
        object1.velocity.set(100, 100);
        
        FlxG.signals.postUpdate.addOnce(function()
        {
            trace(FlxG.collide(object1, level));
            trace(FlxMath.equal(16.0, object1.y + object1.height, 0.0002));
        });
    }
}
private class Basic {}
private class Object extends Basic
{
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;
    
    public function new (x, y, width, height)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}

private abstract class BaseTilemap<T:Object> extends Basic
{
    public var data:Array<T>;
    
    public function new ()
    {
        init();
    }
    
    abstract public function init():Void;
    
    abstract public function doSomething():Void;
}

private class Tile extends Object
{
    public var data:Int;
    
    public function new (x, y, data:Int)
    {
        this.data = data;
        super(x, y, 1, 1);
    }
}

private abstract class TypedTilemap<T:Tile> extends BaseTilemap<T>
{
    public function doSomething()
    {
        trace('something: $data');
    }
}

private class Tilemap extends TypedTilemap<Tile>
{
    public function init()
    {
        data = [for (x in 0...3){ for (y in 0...3) new Tile(x, y, y * 3 + x); }];
    }
}
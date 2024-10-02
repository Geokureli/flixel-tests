package states;

import flixel.FlxG;
import haxe.ds.Vector;
import openfl.utils.ByteArray;
import openfl.display.BitmapData;

class ByteArrayTestState extends flixel.FlxState
{
    inline static var duration = 5.0;
    
    final bmList:Vector<BitmapData>;
    final btList:Vector<ByteArray>;
    final loneBm:BitmapData;
    final updateFunc:()->Void;
    
    public function new(test:TestType)
    {
        this.test = test;
        switch test
        {
            case BITMAP_DATA:
                bmList = new Vector(Math.ceil(duration * 5.0));
                updateFunc = updateBm;
            case BYTE_ARRAY:
                btList = new Vector(Math.ceil(duration * 5.0));
                loneBm = new Image();
                updateFunc = updateBt;
        }
        super();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        updateFunc();
        
        FlxG.keys.checkStatus(key, PRESSED);
    }
    
    function updateBm()
    {
        final bm = new Image();
    }
    
    function updateBt()
    {
        loneBm.reset();
    }
}

@:forward
abstract Image(BitmapData) to BitmapData
{
    inline public function new()
    {
        this = new BitmapData(FlxG.width, FlxG.height, false);
        reset();
    }
    
    inline public function reset()
    {
        this.noise(FlxG.random.int());
    }
}

enum TestType
{
    BITMAP_DATA;
    BYTE_ARRAY;
}
package ;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxState;

class Main extends openfl.display.Sprite
{
    public function new()
    {
        super();
        
        final p1 = FlxPoint.get(1, 2);
        trace(p1);// (x: 1 | y: 2)
        p1.put();
        final p2 = FlxPoint.get(3, 4);
        trace(p1);// (x: 3 | y: 4)
        trace(p2);// (x: 3 | y: 4)
        trace(p1 == p2); // true
        
        // addChild(new flixel.FlxGame(0, 0, states.ClipRectTestState));
        // addChild(new flixel.FlxGame(0, 0, states.ScaleOffsetTestState));
        // addChild(new flixel.FlxGame(0, 0, states.TestState2305));
        // addChild(new flixel.FlxGame(0, 0, states.BackdropTestState));
        // addChild(new flixel.FlxGame(0, 0, states.JumpTestState));
        // addChild(new flixel.FlxGame(0, 0, states.BlueTestState));
        // addChild(new flixel.FlxGame(0, 0, states.ModMinMaxTestState));
        // addChild(new flixel.FlxGame(0, 0, states.AustinPixelTestState));
        // addChild(new flixel.FlxGame(0, 0, states.ButtonUpTestState));
        // addChild(new flixel.FlxGame(0, 0, states.FlxTextTestState2656));
        // addChild(new flixel.FlxGame(0, 0, states.AssetPathsTestState));
        // addChild(new flixel.FlxGame(0, 0, states.DebugSelectionTestState));
        // addChild(new flixel.FlxGame(0, 0, states.ButtonZoomTestState));
        // addChild(new flixel.FlxGame(0, 0, states.NoAnimTestState));
        // addChild(new flixel.FlxGame(0, 0, states.ArraySwapTestState));
        // addChild(new flixel.FlxGame(0, 0, states.FlxStripShaderTestState));
        // addChild(new flixel.FlxGame(0, 0, states.PivotTestState));
        // addChild(new flixel.FlxGame(0, 0, states.DestroyedSpriteTestState));
        // addChild(new flixel.FlxGame(0, 0, states.ErrorSoundTestState));
        // addChild(new flixel.FlxGame(0, 0, states.CameraAngleTestState));
        // addChild(new flixel.FlxGame(0, 0, states.FlxTilemapExpTextState));
        // addChild(new flixel.FlxGame(0, 0, states.VscDebuggerTestState));
        // addChild(new flixel.FlxGame(0, 0, states.FlxBitmapTextTestState2530));
        // addChild(new flixel.FlxGame(0, 0, states.FlxBitmapTextTestState2710));
        // addChild(new flixel.FlxGame(0, 0, states.OfffsetRotateTestState));
        // addChild(new flixel.FlxGame(0, 0, states.FlxTextWidthTestState2729));
        // addChild(new flixel.FlxGame(0, 0, states.MergeSaveTestState2735));
        // addChild(new flixel.FlxGame(0, 0, states.AtlasOffsetTestState2746));
        addChild(new flixel.FlxGame(0, 0, states.InvalidFrameSizeTestState));
    }
}

class BootState extends FlxState
{
    public static var initialState:Class<FlxState>;
    
    override function create()
    {
        super.create();
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        FlxG.switchState(Type.createInstance(initialState, []));
    }
}
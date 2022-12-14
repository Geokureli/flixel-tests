package ;

import flixel.FlxG;
import flixel.FlxState;

class Main extends openfl.display.Sprite
{
    public function new()
    {
        super();
        
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
        addChild(new flixel.FlxGame(0, 0, states.FlxStripShaderTestState));
        // addChild(new flixel.FlxGame(0, 0, states.PivotTestState));
        // addChild(new flixel.FlxGame(0, 0, states.DestroyedSpriteTestState));
        // addChild(new flixel.FlxGame(0, 0, states.ErrorSoundTestState));
        // addChild(new flixel.FlxGame(0, 0, states.CameraAngleTestState));
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
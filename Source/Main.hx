package ;

import flixel.FlxG;

class Main extends openfl.display.Sprite
{
    public function new()
    {
        super();
        
        // addChild(new TestGame(states.TemplateTestState));
        // addChild(new TestGame(states.ClipRectTestState));
        // addChild(new TestGame(states.ScaleOffsetTestState));
        // addChild(new TestGame(states.TestState2305));
        // addChild(new TestGame(states.BackdropTestState));
        // addChild(new TestGame(states.JumpTestState));
        // addChild(new TestGame(states.BlueTestState));
        // addChild(new TestGame(states.ModMinMaxTestState));
        // addChild(new TestGame(states.AustinPixelTestState));
        // addChild(new TestGame(states.ButtonUpTestState));
        // addChild(new TestGame(states.FlxTextTestState2656));
        // addChild(new TestGame(states.AssetPathsTestState));
        // addChild(new TestGame(states.DebugSelectionTestState));
        // addChild(new TestGame(states.ButtonZoomTestState));
        // addChild(new TestGame(states.NoAnimTestState));
        // addChild(new TestGame(states.ArraySwapTestState));
        // addChild(new TestGame(states.FlxStripShaderTestState));
        // addChild(new TestGame(states.PivotTestState));
        // addChild(new TestGame(states.DestroyedSpriteTestState));
        // addChild(new TestGame(states.ErrorSoundTestState));
        // addChild(new TestGame(states.CameraAngleTestState));
        // addChild(new TestGame(states.FlxTilemapExpTextState));
        // addChild(new TestGame(states.VscDebuggerTestState));
        // addChild(new TestGame(states.FlxBitmapTextTestState2530));
        // addChild(new TestGame(states.FlxBitmapTextTestState2710));
        // addChild(new TestGame(states.OfffsetRotateTestState));
        // addChild(new TestGame(states.FlxTextWidthTestState2729));
        // addChild(new TestGame(states.MergeSaveTestState2735));
        // addChild(new TestGame(states.AtlasOffsetTestState2746));
        // addChild(new TestGame(states.InvalidFrameSizeTestState));
        // addChild(new TestGame(states.StateOutroTestState));
        // addChild(new TestGame(states.TransitionTestState));
        // addChild(new TestGame(states.AnimCallbackTestState2782));
        // addChild(new TestGame(states.ResizeGameTestState2744));
        // addChild(new TestGame(states.DebugToolTestState));
        // addChild(new TestGame(states.TryCatchTestState));
        // addChild(new TestGame(states.EaseGraphState));
        // addChild(new TestGame(states.TweenChainTestState));
        // addChild(new TestGame(states.FlxWeaponTestState));
        // addChild(new TestGame(states.OgmoTestState388));
        // addChild(new TestGame(states.ReverseAnimTestState2811));
        // addChild(new TestGame(states.PPPCTestState2820));
        // addChild(new TestGame(states.TextHeightTestState2789));
        // addChild(new TestGame(states.PixelPerfectShakeTestState, 10));
        // addChild(new TestGame(states.TilemapUnitTestState, 10));
        // addChild(new TestGame(states.AngleBetweenTestState));
        // addChild(new TestGame(states.EmptyTextTestState));
        // addChild(new TestGame(states.GroupTestState));
        // addChild(new TestGame(states.TypeTextTestState, 4));
        // addChild(new TestGame(states.VolumeTestState));
        // addChild(new TestGame(states.AnimationFrameTestState2847));
        // addChild(new TestGame(states.PixelPerfectRenderTestState2849, 10));
        // addChild(new TestGame(states.SoundPanTestState2852));
        // addChild(new TestGame(states.SoundFLPanTestState2852));
        addChild(new TestGame(states.AseAtlasTestState, 4));
        // addChild(new TestGame(states.CircleWipeShaderTestState));
        // addChild(new TestGame(states.ExceptionTestState11265));
        // addChild(new TestGame(states.JustifyTextTestState));
        // addChild(new TestGame(states.TintTestState));
        // addChild(new TestGame(states.InputTextTestState2846));
        // addChild(new TestGame(states.VignetteShaderTestState2847));
        // addChild(new TestGame(states.ColorEffectListTestState2869));
        // addChild(new TestGame(states.TilemapSizeTestState2882));
        // addChild(new TestGame(states.RuntimeShaderTestState399));
        // addChild(new TestGame(states.MacKeysTestState));
        
        // addChild(new tests.KeyEventTest());
    }
}

abstract TestGame(flixel.FlxGame) to flixel.FlxGame
{
    inline public function new (state, zoom = 1)
    {
        if (zoom == 1)
        {
            // set game size to window size
            this = new flixel.FlxGame(0, 0, state);
        }
        else
        {
            // set game sizse from zoom
            final stage = openfl.Lib.current.stage;
            final gameWidth = Std.int(stage.stageWidth / zoom);
            final gameHeight = Std.int(stage.stageWidth / zoom);
            this = new flixel.FlxGame(gameWidth, gameHeight, state);
        }
    }
}

class BootState extends flixel.FlxState
{
    public static var initialState:Class<flixel.FlxState>;
    
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
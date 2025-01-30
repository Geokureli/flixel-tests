package;

import flixel.FlxG;
import flixel.FlxGame;
#if (flixel >= "5.6.0")
import flixel.util.typeLimit.NextState;
#end

class Main extends openfl.display.Sprite
{
    #if (html5 && munit)
    static var isFirst = true;
    #end
    
    public function new()
    {
        super();
        
        // munit makes this happen twice for some reason
        #if (html5 && munit)
        if (!isFirst)
            createTest();
            
        isFirst = false;
        #else
        createTest();
        #end
        
    }
    
    function createTest()
    {
        // addChild(new TestGame(states.ClipRectTestState));
        // addChild(new TestGame(states.ScaleOffsetTestState));
        // addChild(new TestGame(states.TestState2305));
        // addChild(new TestGame(states.JumpTestState));
        // addChild(new TestGame(states.BlueTestState));
        // addChild(new TestGame(states.ModMinMaxTestState));
        // addChild(new TestGame(states.AustinPixelTestState));
        // addChild(new TestGame(states.ButtonUpTestState));
        // addChild(new TestGame(states.FlxTextTestState2656));
        // addChild(new TestGame(states.ButtonZoomTestState, 2));
        // addChild(new TestGame(states.NoAnimTestState));
        // addChild(new TestGame(states.ArraySwapTestState));
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
        // addChild(new TestGame(states.InvalidFrameSizeTestState));
        // addChild(new TestGame(states.StateOutroTestState));
        // addChild(new TestGame(states.TransitionTestState));
        // addChild(new TestGame(states.AnimCallbackTestState2782));
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
        // addChild(new TestGame(states.AnimationFrameTestState2847));
        // addChild(new TestGame(states.PixelPerfectRenderTestState2849, 10));
        // addChild(new TestGame(states.SoundFLPanTestState2852));
        // addChild(new TestGame(states.CircleWipeShaderTestState));
        // addChild(new TestGame(states.ExceptionTestState11265));
        // addChild(new TestGame(states.JustifyTextTestState));
        // addChild(new TestGame(states.TintTestState));
        // addChild(new TestGame(states.VignetteShaderTestState2847));
        // addChild(new TestGame(states.ColorEffectListTestState2869));
        // addChild(new TestGame(states.TilemapSizeTestState2882));
        // addChild(new TestGame(states.RuntimeShaderTestState399));
        // addChild(new TestGame(states.MacKeysTestState));
        // addChild(new TestGame(states.BlackDebugSliceSpriteTestState, 4));
        // addChild(new TestGame(states.FlxExtendedSpriteTestState));
        // addChild(new TestGame(states.SoundTrayTestState));
        // addChild(new TestGame(states.StackingSoundTestState2926));
        // addChild(new TestGame(states.TelemetryTestState));
        // addChild(new TestGame(states.UiInputTextState253));
        // addChild(new TestGame(states.UiListTestState254));
        // addChild(new TestGame(states.TextAutoSizeTestState, 2));
        // addChild(new TestGame(states.FlxBarTestState2938));
        // addChild(new TestGame(states.PluginTestState));
        // addChild(new TestGame(states.TransitionCameraTestState));
        // addChild(new TestGame(states.TilemapPerfTestState));
        // addChild(new TestGame(states.HudCursorTestState));
        // addChild(new TestGame(states.SaveTestState));
        // addChild(new TestGame(states.HistogramTestState));
        // addChild(new TestGame(states.BMFontTestState, 2));
        // addChild(new TestGame(states.BMFontTestState3024, 2));
        // addChild(new TestGame(states.OriginTestState2981));
        // addChild(new TestGame(states.CameraBlackLineTestState));
        // addChild(new TestGame(states.DefaultMovesTestState2980));
        // addChild(new TestGame(states.CompileFlagTestState));
        // addChild(new TestGame(states.CursorTestState, 3));
        // addChild(new TestGame(states.NestingTestState, 2));
        // addChild(new TestGame(states.DebugStuffTestState, 2));
        // addChild(new TestGame(states.TextFormatTestState, 4));
        // addChild(new TestGame(states.AsyncAssetTestState, 2));
        // addChild(new TestGame(states.BarTestState, 2));
        // addChild(new TestGame(states.HealthTestState, 2));
        // addChild(new TestGame(states.FlickerTweenTestState, 2));
        // addChild(new TestGame(states.MidpointTestState, 9));
        // addChild(new TestGame(states.SparrowVTestState, 1));
        // addChild(new TestGame(states.SpriteGroupCameraTestState, 2));
        // addChild(new TestGame(states.ContainerCameraTestState, 2));
        // addChild(new TestGame(states.SoundRecycleTestState, 2));
        // addChild(new TestGame(states.NoneKeyTestState, 2));
        // addChild(new TestGame(states.CmdKeyTestState, 2));
        // addChild(new TestGame(states.FlxColorTestState, 2));
        // addChild(new TestGame(states.CustomCursorTestState, 2));
        // addChild(new TestGame(states.ResetStateTestState));
        // addChild(new TestGame(states.AutoTileTestState));
        // addChild(new TestGame(states.DropDownTestState274));
        // addChild(new TestGame(states.FeeshyColorTestState));
        // addChild(new TestGame(states.BGSpriteTestState));
        // addChild(new TestGame(states.TiledSpriteTestState));
        // addChild(new TestGame(states.TypeTextTestState, 4));
        // addChild(new TestGame(states.RecyclingTestState3185, 4));
        // addChild(new TestGame(states.ColorTestState));
        // addChild(new TestGame(states.BufferTestState));
        // addChild(new TestGame(states.GameSizeTestState));
        // addChild(new TestGame(states.TilemapSetIndexTestState));
        // addChild(new TestGame(states.HLArithTestState));
        // addChild(new TestGame(states.AtlasOffsetTestState2746));
        // addChild(new TestGame(states.AlphaTweenTestState3198));
        // addChild(new TestGame(states.MouseScreenTestState3200, 2, 800-80, 800));
        // addChild(new TestGame(states.BigMoverPathfinderTestState));
        // addChild(new TestGame(states.AnimFinishedTestState));
        // addChild(new TestGame(states.FlxStripBlendModeTestState));
        // addChild(new TestGame(states.FlxTextMultilineTest));
        // addChild(new TestGame(states.LastBlendTestState));
        // addChild(new TestGame(states.LastBlendTestState2));
        // addChild(new TestGame(states.SpriteGroupScaleTestState));
        // addChild(new TestGame(states.ResizeGameTestState));
        // addChild(new TestGame(states.SliderTestState));
        // addChild(new TestGame(states.PolymodTestState));
        // addChild(new TestGame(states.FlxStripColorTestState));
        // addChild(new TestGame(states.ButtonLabelOffsetTestState, 2));
        // addChild(new TestGame(states.TextShadowTestState, 4));
        // addChild(new TestGame(states.ShaderColorTestState));
        // addChild(new TestGame(states.FlxBarBorderTestState));
        // addChild(new TestGame(states.SpriteMatrixTestState));
        // addChild(new TestGame(states.VolumeTestState));
        // addChild(new TestGame(states.WatchFunctionTestState));
        // addChild(new TestGame(states.ByteArrayTestState));
        // addChild(new TestGame(states.InputTextTestState2846));
        // addChild(new TestGame(states.InputTextTestState283));
        // addChild(new TestGame(states.FlxInputTextTest, 2));
        // addChild(new TestGame(states.FlxInputTextBannerTest, 4));
        // addChild(new TestGame(states.StarFieldTestState));
        // addChild(new TestGame(states.AssetFrontEndTestState));
        // addChild(new TestGame(states.SaveCrashTestState3270));
        // addChild(new TestGame(states.SoundPanTestState2852));
        // addChild(new TestGame(states.SoundFocusTestState3271));
        // addChild(new TestGame(states.BackdropTestState));
        // addChild(new TestGame(states.AssetPathsTestState));
        // addChild(new TestGame(states.ViewCenterTestState));
        // addChild(new TestGame(states.PixelModeTestState, 4));
        // addChild(new TestGame(states.AseAtlasTestState, 4));
        // addChild(new TestGame(states.CameraColorTest3207));
        // addChild(new TestGame(states.FlxStripShaderTestState));
        // addChild(new TestGame(states.LayerTestState));
        // addChild(new TestGame(states.NGioTestState));
        // addChild(new TestGame(states.SliceSprite));
        // addChild(new TestGame(states.RayTestState, 2));
        // addChild(new TestGame(states.CollisionTestState, 2));
        // addChild(new TestGame(states.FlxVirtualStickTestState, 2));
        addChild(new TestGame(states.FlxUIButtonTestState, 2));
        // addChild(new TestGame(states.DebugSelectionTestState, 4));
        // addChild(new TestGame(states.MultiLockTestState, 2));
        
        flixel.tile.FlxBaseTilemap;
        
        // addChild(new TestGame()); 
        // FlxG.camera.bgColor = 0x0;
        
        // addChild(new tests.ShapeColorTest());
        // addChild(new tests.KeyEventTest());
        // addChild(new tests.HardwareTest());
        // addChild(new tests.Bare());
    }
}

abstract TestGame(FlxGame) to FlxGame
{
    inline public function new (?state, zoom = 1, width = 0, height = 0)
    {
        if (FlxG.game != null)
            throw "Already created a FlxGame";
        
        if (zoom == 1)
        {
            this = new FlxGame(width, height, state);
        }
        else
        {
            // set game size from zoom
            final stage = openfl.Lib.current.stage;
            final gameWidth = Std.int((width == 0 ? stage.stageWidth : width) / zoom);
            final gameHeight = Std.int((height == 0 ? stage.stageHeight : height) / zoom);
            this = new FlxGame(gameWidth, gameHeight, state);
        }
    }
}

#if (flixel >= "5.6.0")
class BootState extends flixel.FlxState
{
    var nextState:NextState;
    
    public function new (nextState:NextState)
    {
        this.nextState = nextState;
        super();
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        FlxG.switchState(nextState);
    }
}
#end
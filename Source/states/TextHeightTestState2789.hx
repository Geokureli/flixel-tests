package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.text.TextField;

/**
 * The problem: 
 *     FlxText does not support fixed height
 * 
 * Current implementation details:
 * - FlxText does not even have prop to set fixed height
 * - FlxText uses `textHeight` property to redraw itslef. 
 *     This prop reads the real height of the text instead of 
 *     the height of text field.
 * 
 * Solution:
 * - FlxText must have prop to set height, e.g. `fieldHeight`
 * - Need to figure out all relevant combinations of width,
 *     height, autosize, to test inconsistencies with openfl
 * 
 * Some random notes:
 *     if autoSize is set then openfl TextField does not react
 *     on setting its height.
 *     
 *     Default FlxText with fixed width:
 *         - width is SET
 *         - word wrap is TRUE
 *         - autosize is FALSE
 *     Similar TextField is:
 *         - width is SET
 *         - height is SET (but actually got determined automatically)
 *         - word wrap is true
 *         - autosize is SET
 * @see https://github.com/HaxeFlixel/flixel/pull/2789
 */
class TextHeightTestState2789 extends flixel.FlxState
{
    var openflGroup = new Sprite();
    var flixelGroup = new FlxTypedGroup<OptionedFlxText>();

    override public function create()
    {
        super.create();

        add(flixelGroup);
        flixelGroup.visible = true;

        Lib.current.stage.addChild(openflGroup);
        openflGroup.visible = false;

        // Demo info:
        //
        // OpenFl textfield building options are different from Flixel,
        // Flixel does the same in its setters, but for OpenFl
        // this should be done excplicitly.
        //
        // Press O to switch between Flixel and OpenFl
        // Press P to reposition text
        // Press 1 or 2 to add text for Flixel (these updates accumulate!)

        // 1. default FlxText has auto width and auto height
        final MARGIN = 15;
        final WIDTH = FlxG.width * 0.6;
        
        inline function createText(opts:TextOptions)
        {
            flixelGroup.add(new OptionedFlxText(opts));
            openflGroup.addChild(new OptionedTextField(opts));
        }
        
        createText({
            text: 'Default FlxText',
            autosize: true,
            wordwrap: false
        });

        // 2. FlxText with fixed width still has auto height
        createText({
            text: 'FlxText with fixed width and words to show auto height',
            width: WIDTH,
            autosize: true,
            wordwrap: true
        });

        // 3. FlxText with both width and height fixed
        createText({
            text: 'FlxText with both width and height fixed',
            width: WIDTH,
            height: 100,
            autosize: false,
            wordwrap: true
        });

        // 4. Nonnsence FlxText with auto width and fixed height.
        // It works the same as fully autosize field.
        createText({
            text: 'FlxText with fixed height and free width bla bla',
            width: 0,
            height: 65,
            autosize: true,
            wordwrap: false
        });

        repositionText();
    }
    
    override function destroy()
    {
        super.destroy();
        Lib.current.stage.removeChild(openflGroup);
        openflGroup = null;
    }
    
    function repositionText()
    {
        final MARGIN = 15;
        var y = 10.0;
        for (text in flixelGroup)
        {
            text.y = y;
            y += text.height + MARGIN;
        }
        
        y = 10.0;
        for (i in 0...openflGroup.numChildren)
        {
            final text:TextField = cast openflGroup.getChildAt(i);
            text.y = y;
            y += text.textHeight + MARGIN;
        }
    }
    
    function appendTextToAll(string:String)
    {
        for (text in flixelGroup.members)
            text.text += string;
        
        for (i in 0...openflGroup.numChildren)
            cast(openflGroup.getChildAt(i), TextField).text += string;
        
        repositionText();
    }
    
    override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.O)
        {
            openflGroup.visible = !openflGroup.visible;
            flixelGroup.visible = !flixelGroup.visible;
        }
        
        if (FlxG.keys.justPressed.ONE)
            appendTextToAll('. Bizz bazz!');
        
        if (FlxG.keys.justPressed.TWO)
            appendTextToAll('\nLorem ipsum!');
        
        if (FlxG.keys.justPressed.P)
            repositionText();
        
        if (FlxG.keys.justPressed.R)
            FlxG.resetState();
        
        super.update(elapsed);
    }
}

typedef TextOptions =
{
	?text:String,
	?x:Float,
	?y:Float,
	?width:Float,
	?height:Float,
	?autosize:Bool,
	?wordwrap:Bool,
	?autoHeight:Bool,
	?size:Int,
}

@:forward
abstract OptionedFlxText(FlxText) to FlxText
{
    inline public function new (opts:TextOptions)
    {
        this = new FlxText
            ( opts.x ?? 10.0
            , opts.y ?? 0.0
            , opts.width ?? 0.0
            , opts.text ?? ''
            , opts.size ?? 16
            );

        this.bold = false;
        this.color = 0x111111;
        this.textField.background = true;
        this.textField.backgroundColor = 0xEEEEEE;
        this.textField.backgroundColor = 0xFF6666;
        this.alignment = LEFT;

        // trace(textfield.fieldWidth, textfield.fieldHeight);
        if (opts.width != null)
            this.fieldWidth = opts.width;
        // tracing it before setting autosize fixed hashlink target
        // some time ago, now it shouldn't be relevant
        // trace(this.textField.width, this.textField.height);
        if (opts.height != null)
            this.fieldHeight = opts.height;
        if (opts.autosize != null)
            this.autoSize = opts.autosize;
        if (opts.wordwrap != null)
            this.wordWrap = opts.wordwrap;
    }
}

@:forward
abstract OptionedTextField(TextField) to TextField
{
    inline public function new (opts:TextOptions)
    {
        this = new TextField();
        // make it match to flixel defaults
        this.autoSize = LEFT;
        this.selectable = false;
        this.multiline = true;
        this.wordWrap = true;
        this.height = 10;
        // ---

        var format = this.defaultTextFormat;
        format.font = FlxAssets.FONT_DEFAULT;
        format.size = 16;
        this.embedFonts = true;
        // format.font = 'Arial';
        // format.size = 20;
        // field.embedFonts = false;
        format.bold = false;
        format.color = 0x111111;
        format.align = LEFT;
        this.defaultTextFormat = format;
        // field.border = true;
        // field.borderColor = 0xFF0000;

        this.height = 16;
        this.background = true;
        this.backgroundColor = 0xEEEEEE;

        this.x = opts.x ?? 10.0;
        this.y = opts.y ?? 10.0;
        this.text = opts.text ?? '';
        this.width = opts.width ?? 0.0;
        this.wordWrap = opts.wordwrap ?? (opts.width == null || opts.width == 0);

        if (opts.height != null)
            this.height = opts.height;

        if (opts.autosize != null)
            this.autoSize = opts.autosize ? LEFT : NONE;

    }
}
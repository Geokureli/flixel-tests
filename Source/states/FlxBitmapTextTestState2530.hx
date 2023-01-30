package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;

import openfl.utils.Assets;

class FlxBitmapTextTestState2530 extends flixel.FlxState
{
    var texts = new FlxTypedGroup<FlxBitmapText>();
    var headers = new FlxTypedGroup<FlxBitmapText>();
    
    override function create()
    {
        super.create();
        
        FlxG.cameras.bgColor = 0xFFf0f0f0;
        FlxG.stage.color = 0xFF000000;
        FlxG.debugger.drawDebug = true;
        
        add(texts);
        add(headers);
        
        var monospaceLetters:String = " !\"#$%&'()*+,-.\\0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}~";
        var charSize = FlxPoint.get(7, 10);
        var fontMonospace = FlxBitmapFont.fromMonospace("assets/fonts/RetroMedievalV3.png", monospaceLetters, charSize);
        
        function createHeader(msg:String)
        {
            var text:FlxBitmapText = new FlxBitmapText(fontMonospace);
            text.scale.set(3, 3);
            text.letterSpacing = -1;
            text.text = msg;
            text.updateHitbox();
            // text.screenCenter(X);
            headers.add(text);
            return text;
        }
        
        function createText(msg:String, wrap)
        {
            var text:FlxBitmapText = new FlxBitmapText(fontMonospace);
            text.scale.set(2, 2);
            text.autoSize = false;
            text.fieldWidth = 100;
            text.letterSpacing = -1;
            text.multiLine = true;
            text.wrap = wrap;
            text.text = msg;
            text.updateHitbox();
            texts.add(text);
            return text;
        }
        
        final msg1 = "The quick brown fox jumps over the lazy dog, supercala-phragalist-icexpiala-docious";
        final msg2 = "The quick brown fox jumps over the lazy dog, supercala-phragalist\nicexpiala-docious";
        final msg3 = "The quick brown fox jumps over the lazy dog, supercalaphragalisticexpialadocious";
        
        var header = createHeader("NONE");
        createText(msg1, NONE);
        createText(msg2, NONE);
        createText(msg3, NONE);
        
        var header = createHeader("CHAR");
        createText(msg1, CHAR);
        createText(msg2, CHAR);
        createText(msg3, CHAR);
        
        var header = createHeader("WORD(NEVER)");
        createText(msg1, WORD(NEVER));
        createText(msg2, WORD(NEVER));
        createText(msg3, WORD(NEVER));
        
        var header = createHeader("WORD(FIELD_WIDTH)");
        createText(msg1, WORD(FIELD_WIDTH));
        createText(msg2, WORD(FIELD_WIDTH));
        createText(msg3, WORD(FIELD_WIDTH));
        
        reposition();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final inc = FlxG.keys.pressed.RIGHT;
        final dec = FlxG.keys.pressed.LEFT;
        
        if (!inc == !dec)
            return;
            
        final delta = inc ? 1 : -1;
        
        for (text in texts)
        {
            text.fieldWidth += delta;
            text.updateHitbox();
        }
        
        reposition();
    }
    
    function reposition()
    {
        final GAP = 50;
        
        function max3(a:Float, b:Float, c:Float)
        {
            return Math.max(a, Math.max(b, c)); 
        }
        
        function bottom3(a:FlxObject, b:FlxObject, c:FlxObject)
        {
            return max3(a.y + a.height, b.y + b.height, c.y + c.height); 
        }
        
        var header:FlxBitmapText;
        var left:FlxBitmapText;
        var middle:FlxBitmapText;
        var right:FlxBitmapText;
        
        header = headers.members[0];
        for (i in 0...headers.length)
        {
            left   = texts.members[i * 3 + 0];
            middle = texts.members[i * 3 + 1];
            right  = texts.members[i * 3 + 2];
            
            left.y = header.y + header.height;
            middle.y = header.y + header.height;
            right.y = header.y + header.height;
            
            middle.x = left.x + left.width + GAP;
            right.x = middle.x + middle.width + GAP;
            
            if (i + 1 < headers.length)
            {
                header = headers.members[i + 1];
                header.y = bottom3(left, middle, right);
            }
        }
    }
}

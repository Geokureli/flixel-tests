package states;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxBitmapText;
import flixel.util.FlxColor;

class OklabTestState extends flixel.FlxState
{
    final text:FlxBitmapText;
    
    var lightness = 1.0;
    var redGreen = 0.0;
    var blueYellow = 0.0;
    
    public function new()
    {
        super();
        final color = FlxColor.fromOKLab(lightness, redGreen, blueYellow);
        bgColor = color;
        
        text = new FlxBitmapText(10, 10, "");
        text.setBorderStyle(OUTLINE, 0xFF000000);
        add(text);
        updateText();
    }
    
    function updateText()
    {
        final hex = bgColor.toHexString();
        final c = bgColor;
        
        inline function rndf(n:Float) return '${Math.round(n * 1000) / 1000}';
        text.text = '#$hex\nrgb(${c.red}, ${c.green}, ${c.blue})\n'
            + 'okLab(${Math.round(lightness * 1000) / 10}%, ${rndf(redGreen)}, ${rndf(blueYellow)})';
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        inline function pressedF(key) return (FlxG.keys.checkStatus(key, PRESSED) ? 1.0 : 0.0);
        inline function getDelta(inc, dec) return (pressedF(inc) - pressedF(dec)) * elapsed;
        
        final deltaLG = getDelta(Q, A);
        final deltaRG = getDelta(W, S);
        final deltaBY = getDelta(E, D);
        
        if (deltaLG == 0 && deltaRG == 0 && deltaBY == 0)
            return;
        
        function clamp(n:Float, min:Float, max:Float)
        {
            return Math.max(min, Math.min(max, n));
        }
        
        lightness = clamp(lightness + deltaLG, 0.0, 1.0);
        redGreen = clamp(redGreen + deltaRG, -0.4, 0.4);
        blueYellow = clamp(blueYellow + deltaBY, -0.4, 0.4);
        
        bgColor = FlxColor.fromOKLab(lightness, redGreen, blueYellow);
        updateText();
    }
}

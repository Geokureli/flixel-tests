package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.display.Sprite;
import openfl.display.Shape;

class CameraColorTest3207 extends flixel.FlxState
{
    var camColorFloats = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0];
    var sprColorFloats = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0];
    var sprAlpha = [1.0];
    var camAlpha = [1.0];
    
    var sprites:FlxTypedGroup<FlxSprite>;
    
    override function create()
    {
        super.create();
        
        FlxG.camera.color = 0xFFffffff;
        
        final cols = 8;
        final rows = 8;
        final width = Std.int(FlxG.width / cols);
        final height = Std.int(FlxG.height / rows);
        final total = cols * rows;
        sprites = new FlxTypedGroup<FlxSprite>();
        for (i in 0...total)
        {
            final x = (i % cols) * width;
            final y = Std.int(i / cols) * height;
            // final color = 0xFFffffff;
            final color = FlxColor.fromHSB(i * 360 / total, 1, 1);
            final sprite = new FlxSprite(x, y).makeGraphic(width, height, color);
            sprite.setColorTransform(color.redFloat, color.greenFloat, color.blueFloat, 1.0, 0, 0, 0.0);
            // sprite.setColorTransform(0, 0, 0, 1, color.red, color.green, color.blue);
            sprites.add(sprite);
        }
        add(sprites);
        
        FlxG.watch.addFunction("cam", ()->camColorFloats.map((f)->Std.int(f*0xFF)));
        FlxG.watch.addFunction("spr", ()->sprColorFloats.map((f)->Std.int(f*0xFF)));
        FlxG.watch.addFunction("spr.alpha", ()->Std.int(sprAlpha[0] * 100));
        FlxG.watch.addFunction("cam.alpha", ()->Std.int(camAlpha[0] * 100));
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final q = FlxG.keys.pressed.Q;
        final a = FlxG.keys.pressed.A;
        final w = FlxG.keys.pressed.W;
        final s = FlxG.keys.pressed.S;
        final e = FlxG.keys.pressed.E;
        final d = FlxG.keys.pressed.D;
        final r = FlxG.keys.pressed.R;
        final f = FlxG.keys.pressed.F;
        final up = FlxG.keys.pressed.UP;
        final dn = FlxG.keys.pressed.DOWN;
        final shift = FlxG.keys.pressed.SHIFT;
        final ctrl = FlxG.keys.pressed.ALT;
        
        function adjust(f:Float, up:Bool, down:Bool, min = 0.0)
        {
            f += (up ? 0.025 : 0) - (down ? 0.025 : 0);
            
            if (f > 1.0)
                f = 1.0;
            
            if (f < min)
                f = min;
            
            return f;
        }
        
        if (FlxG.keys.justPressed.SPACE)
        {
            camColorFloats = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0];
            sprColorFloats = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0];
        }
        else
        {
            final arr = ctrl ? camColorFloats : sprColorFloats;
            final alpha = ctrl ? camAlpha : sprAlpha;
            alpha[0] = adjust(alpha[0], up, dn, -1.0);
            if (shift)
            {
                arr[4] = adjust(arr[4], q, a, -1.0);
                arr[5] = adjust(arr[5], w, s, -1.0);
                arr[6] = adjust(arr[6], e, d, -1.0);
                arr[7] = adjust(arr[7], r, f, -1.0);
            }
            else
            {
                arr[0] = adjust(arr[0], q, a);
                arr[1] = adjust(arr[1], w, s);
                arr[2] = adjust(arr[2], e, d);
                arr[3] = adjust(arr[3], r, f);
            }
        }
        
        final f = camColorFloats;
        FlxG.camera.color = FlxColor.fromRGBFloat(f[0], f[1], f[2]);
        FlxG.camera.alpha = camAlpha[0];
        final f = sprColorFloats;
        for (sprite in sprites)
        {
            sprite.setColorTransform(f[0], f[1], f[2], f[3], f[4] * 0xFF, f[5] * 0xFF, f[6] * 0xFF, f[7] * 0xFF);
            sprite.alpha = sprAlpha[0];
        }
    }
}
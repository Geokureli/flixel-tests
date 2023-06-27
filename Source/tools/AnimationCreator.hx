package tools;

import flixel.text.FlxBitmapText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxAnimationController;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.BitmapData;
import openfl.display.BitmapData;

typedef AnimationTextParams =
{
    final color:FlxColor;
    final maxSize:Float;
}

class AnimationCreator
{
    static public function create(width:Int, height:Int, frames:Int, transparent = false, color = 0xFF808080, textColor = 0xffffff)
    {
        final bmd = new BitmapData(width * frames, height, transparent, color);
        
        final field = new TextField();
        field.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 128, textColor);
        
        final mat = new openfl.geom.Matrix();
        for (frame in 0...frames)
        {
            field.text = Std.string(frame);
            field.width = field.textWidth + 4;
            field.height = field.textHeight + 4;
            mat.identity();
            
            final scale = Math.min(1.0, Math.min(width / field.textWidth, height / field.textHeight));
            mat.scale(scale, scale);
            
            mat.translate(width * frame, 0);
            bmd.draw(field, mat);
        }
        
        return bmd;
    }
}
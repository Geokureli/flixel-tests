package tests;

import flixel.system.FlxAssets;
import openfl.display.BitmapData;
import openfl.display.GraphicsShader;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

class ShapeColorTest extends openfl.display.Sprite
{
    public function new ()
    {
        super();
        
        addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }
    
    function addedToStage(_)
    {
        final shape = new Sprite();
        
        final color = shape.transform.colorTransform;
        color.blueMultiplier = 0.0;
        color.redMultiplier = 1.0;
        color.greenMultiplier = 1.0;
        
        shape.transform.colorTransform = color;
        addChild(shape);
        
        final bitmap = new BitmapData(100, 100, false, 0xFFffffff);
        bitmap.fillRect(new openfl.geom.Rectangle(25, 25, 50, 50), 0xFF000000);
        
        final shaderRaw = new GraphicsShader();
        shaderRaw.bitmap.input = bitmap;
        shaderRaw.bitmap.filter = LINEAR;
        
        final shaderFlx = new FlxShader();
        shaderFlx.bitmap.input = bitmap;
        shaderFlx.bitmap.filter = LINEAR;
        shaderFlx.alpha.value = [1.0];
        shaderFlx.colorMultiplier.value = [1.0, 0.5, 1.0, 1.0];
        shaderFlx.colorOffset.value = [0.0, 0.0, 255.0, 0.0];
        shaderFlx.hasColorTransform.value = [true];
        shaderFlx.hasTransform.value = [true];
        final rects = openfl.Vector.ofArray([0.0, 0.0, bitmap.width, bitmap.height]);
        var drawMode = Circle;
        stage.addEventListener(MouseEvent.CLICK, (e)->drawMode = switch drawMode
        {
            case Circle: Rect;
            case Rect: Bitmap;
            case Bitmap: ShaderFlx; // skip
            // case Bitmap: ShaderRaw;
            case ShaderRaw: ShaderFlx;
            case ShaderFlx: Circle;
        });
        stage.addEventListener(Event.ENTER_FRAME, function (_)
        {
            shape.graphics.clear();
            switch drawMode
            {
                case Circle:
                    shape.graphics.beginFill(0xFFffffff);
                    shape.graphics.drawCircle(stage.mouseX - 50, stage.mouseY - 50, 50);
                    shape.graphics.endFill();
                case Rect:
                    shape.graphics.beginFill(0xFFffffff);
                    shape.graphics.drawRect(stage.mouseX - 100, stage.mouseY, 100, 100);
                    shape.graphics.endFill();
                case Bitmap:
                    shape.graphics.beginBitmapFill(bitmap);
                    shape.graphics.drawRect(stage.mouseX, stage.mouseY - 100, bitmap.width, bitmap.height);
                    shape.graphics.endFill();
                case ShaderRaw:
                    final transforms = openfl.Vector.ofArray([1.0, 0.0, 0.0, 1.0, stage.mouseX, stage.mouseY]);
                    shape.graphics.beginShaderFill(shaderRaw);
                    shape.graphics.drawQuads(rects, null, transforms);
                    shape.graphics.endFill();
                case ShaderFlx:
                    final transforms = openfl.Vector.ofArray([1.0, 0.0, 0.0, 1.0, stage.mouseX, stage.mouseY]);
                    shape.graphics.beginShaderFill(shaderFlx);
                    shape.graphics.drawQuads(rects, null, transforms);
                    shape.graphics.endFill();
            }
        });
    }
}

enum DrawMode
{
    Rect;
    Circle;
    Bitmap;
    ShaderRaw;
    ShaderFlx;
}

class Shader extends GraphicsShader
{
    @:glVertexHeader("
        attribute float alpha;
        attribute vec4 colorMultiplier;
        attribute vec4 colorOffset;
        uniform bool hasColorTransform;
    ")
    @:glVertexBody("
        openfl_Alphav = openfl_Alpha * alpha;
        
        if (hasColorTransform)
        {
            openfl_ColorOffsetv = (openfl_ColorOffsetv * colorMultiplier) + (colorOffset / 255.0);
            openfl_ColorMultiplierv *= colorMultiplier;
        }
    ")
    @:glFragmentHeader("
        uniform bool hasTransform;
        uniform bool hasColorTransform;
        vec4 flixel_texture2D(sampler2D bitmap, vec2 coord)
        {
            vec4 color = texture2D(bitmap, coord);
            if (!hasTransform)
                return color;
            
            if (color.a == 0.0)
                return vec4(0.0, 0.0, 0.0, 0.0);
            
            if (openfl_HasColorTransform || hasColorTransform)
            {
                color = vec4 (color.rgb / color.a, color.a);
                vec4 mult = vec4 (openfl_ColorMultiplierv.rgb, 1.0);
                color = clamp (openfl_ColorOffsetv + (color * mult), 0.0, 1.0);
                
                if (color.a == 0.0)
                    return vec4 (0.0, 0.0, 0.0, 0.0);
                
                return vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
            }
            
            return color * openfl_Alphav;
        }
    ")
    @:glFragmentBody("
        gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv);
        // gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
    ")
    public function new()
    {
        super();
    }
}

package vfx;

import flixel.util.FlxColor;

class DoubleOutline extends flixel.system.FlxAssets.FlxShader
{
    public var enabled(get, set):Bool;
    inline function get_enabled()
    {
        return _enabled.value[0];
    }
    inline function set_enabled(value:Bool)
    {
        _enabled.value = [value];
        return value;
    }
    
    @:glFragmentSource('
        #pragma header

        uniform bool _enabled;
        uniform float inSize;
        uniform float outSize;
        uniform vec4 inColor;
        uniform vec4 outColor;

        bool outline(vec2 coord, float size)
        {
            float w = size / openfl_TextureSize.x;
            float h = size / openfl_TextureSize.y;
            
            return size > 0.0
            &&  ( flixel_texture2D(bitmap, vec2(coord.x + w, coord.y)).a != 0.0
                || flixel_texture2D(bitmap, vec2(coord.x - w, coord.y)).a != 0.0
                || flixel_texture2D(bitmap, vec2(coord.x, coord.y + h)).a != 0.0
                || flixel_texture2D(bitmap, vec2(coord.x, coord.y - h)).a != 0.0
                );
        }
        
        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            if (color.a == 0.0 && _enabled)
            {
                if (outline(openfl_TextureCoordv, inSize))
                    color = inColor;
                else if (outline(openfl_TextureCoordv, outSize))
                    color = outColor;
            }
            gl_FragColor = color;
        }')
    public function new(inColor:FlxColor = 0xFFFFFFFF, outColor:FlxColor = 0xFF000000, inSize = 1, outSize = 1)
    {
        super();
        this.inColor.value = [inColor.red, inColor.blue, inColor.green, inColor.alpha];
        this.outColor.value = [outColor.red, outColor.blue, outColor.green, outColor.alpha];
        this._enabled.value = [true];
        this.inSize.value = [inSize];
        this.outSize.value = [inSize + outSize];
    }
}

class TestShader extends flixel.system.FlxAssets.FlxShader
{
    @:glFragmentSource('
#pragma header

void main()
{
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    
    // 0 should be 0.0
    if (color.a > 0)
    {
        // brg should be vec4
        color = color.brg;
    }
    // color_ should be color
    gl_FragColor = color_;
// } <-- missing
    ')
    public function new()
    {
        super();
    }
}
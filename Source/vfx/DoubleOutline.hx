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
    
    public var inColor(get, set):FlxColor;
    inline function get_inColor()
    {
        return FlxColor.fromRGBFloat(_inColor.value[0], _inColor.value[1], _inColor.value[2], _inColor.value[3]);
    }
    inline function set_inColor(value:FlxColor)
    {
        _inColor.value = [value.red, value.blue, value.green, value.alpha];
        return value;
    }
    
    public var outColor(get, set):FlxColor;
    inline function get_outColor()    {
        return FlxColor.fromRGBFloat(_outColor.value[0], _outColor.value[1], _outColor.value[2], _outColor.value[3]);
    }
    inline function set_outColor(value:FlxColor)
    {
        _outColor.value = [value.red, value.blue, value.green, value.alpha];
        return value;
    }

    @:glFragmentSource('
        #pragma header

        uniform bool _enabled;
        uniform float _inSize;
        uniform float _outSize;
        uniform vec4 _inColor;
        uniform vec4 _outColor;

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
                if (outline(openfl_TextureCoordv, _inSize))
                    color = _inColor;
                else if (outline(openfl_TextureCoordv, _outSize))
                    color = _outColor;
            }
            gl_FragColor = color;
        }')
    public function new(inColor:FlxColor = 0xFFFFFFFF, outColor:FlxColor = 0xFF000000, inSize = 1, outSize = 1)
    {
        super();
        this._inColor.value = [inColor.red, inColor.blue, inColor.green, inColor.alpha];
        this._outColor.value = [outColor.red, outColor.blue, outColor.green, outColor.alpha];
        this._enabled.value = [true];
        this._inSize.value = [inSize];
        this._outSize.value = [inSize + outSize];
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
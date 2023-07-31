package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

// https://github.com/HaxeFlixel/flixel/issues/2874
class VignetteShaderTestState2874 extends flixel.FlxState
{
    var shader:VignetteShader;
    
    override function create()
    {
        super.create();
        
        final rdm = FlxG.random;
        
        // create random squares so we know the shader is working
        for (i in 0...50)
        {
            final sprite = new FlxSprite();
            sprite.x = rdm.int(0, FlxG.width);
            sprite.y = rdm.int(0, FlxG.height);
            sprite.makeGraphic(rdm.int(30, 100), rdm.int(30, 100), FlxColor.fromHSB(rdm.float(0, 360), 1, 1));
            add(sprite);
        }
        
        shader = new VignetteShader();
        FlxG.camera.setFilters([new openfl.filters.ShaderFilter(shader)]);
        FlxG.camera.bgColor = FlxColor.GRAY;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.pressed.RIGHT)
            shader.reach += 0.1;
        if (FlxG.keys.pressed.LEFT)
            shader.reach -= 0.1;
        
        if (FlxG.keys.pressed.UP)
            shader.strength += 5;
        if (FlxG.keys.pressed.DOWN)
            shader.strength -= 5;
    }
}

/**
 * Stolen from https://www.shadertoy.com/view/lsKSWR
 */
class VignetteShader extends flixel.system.FlxAssets.FlxShader
{
    public var strength(get, set):Float;
    public var reach(get, set):Float;
    
    @:glFragmentSource('
        #pragma header
        
        uniform float uStrength;
        uniform float uReach;
        
        void main(){
            vec2 uv = openfl_TextureCoordv;
            
            uv *= 1.0 - uv.yx;// uv *= vec2(1.0, 1.0) - uv.yx;
            
            float vignette = uv.x*uv.y * uStrength;
            vignette = pow(vignette, uReach);
            
            vec4 color = texture2D(bitmap, openfl_TextureCoordv);
            color.rgb *= vignette;
            
            gl_FragColor = color;
        }
    ')
    
    public function new(strength = 15.0, reach = 0.25)
    {
        super();
        
        this.strength = strength;
        this.reach = reach;
    }
    
    inline function get_strength()
        return this.uStrength.value[0];
    
    inline function set_strength(value:Float)
    {
        this.uStrength.value = [value];
        FlxG.watch.addQuick("strength", value);
        return value;
    }
    
    inline function get_reach()
        return this.uReach.value[0];
    
    inline function set_reach(value:Float)
    {
        this.uReach.value = [value];
        FlxG.watch.addQuick("reach", value);
        return value;
    }
}
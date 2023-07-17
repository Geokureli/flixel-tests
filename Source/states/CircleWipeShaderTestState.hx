package states;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class CircleWipeShaderTestState extends flixel.FlxState
{
    var shader:ShaderToyShader;
    
    
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
        shader = new ShaderToyShader();
        FlxG.camera.setFilters([new openfl.filters.ShaderFilter(shader)]);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        shader.update(elapsed);
    }
}

class ShaderToyShader extends flixel.system.FlxAssets.FlxShader
{
    var totalElapsed = 0.0;
    
    @:glFragmentSource('
        #pragma header
        
        uniform float iTime;
        
        void main()
        {
            // sampler2d iChannel0 = bitmap;
            vec2 iResolution = openfl_TextureSize;
            vec2 uv = openfl_TextureCoordv;
            vec2 fragCoord = uv * iResolution;
            
            vec4 col = texture2D(bitmap, openfl_TextureCoordv);
            
            if (uv.x > (sin(iTime * 3.14) + 1.0) / 2.0)
                col = vec4(1.0 - col.rgb, 1.0);
            
            gl_FragColor = col;
        }
    ')
    
    public function new() { super(); }
    
    public function update(elapsed:Float)
    {
        totalElapsed += elapsed;
        this.iTime.value = [totalElapsed];
    }
}
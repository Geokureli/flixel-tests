package states;

import flixel.FlxG;

class BatchFilterTestState3675 extends flixel.FlxState
{
    override function create() 
    {
        for (i in 0...10)
        {
            var flixel = new flixel.FlxSprite(0, 0, "flixel/images/logo/default.png");
            flixel.scale.set(3, 3);
            flixel.updateHitbox();
            flixel.x = i * flixel.width;
            flixel.y = 10;
            flixel.alpha = 1 - (i / 10);
            add(flixel);
        }
        
        camera.filters = [new openfl.filters.ShaderFilter(new GreenTint())];
        camera.filtersEnabled = false;
    }

    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        if (flixel.FlxG.keys.justPressed.SPACE) 
            camera.filtersEnabled = !camera.filtersEnabled;
    }
}

class GreenTint extends flixel.graphics.tile.FlxGraphicsShader 
{
    @:glFragmentSource("#pragma header
    void main()
    {
        gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv) * vec4(0.0, 1.0, 0.0, 1.0);
    }
    ")
    public function new()
    {
        super();
    }
}
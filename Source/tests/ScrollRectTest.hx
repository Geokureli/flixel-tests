package tests;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.filters.ShaderFilter;
import openfl.geom.Rectangle;

class ScrollRectTest extends openfl.display.Sprite
{
    final bm:Bitmap;
    
    public function new ()
    {
        super();
        
        final container = new Sprite();
        bm = new Bitmap(new BitmapData(400, 400, false, 0xFF0000ff));
        bm.bitmapData.fillRect(new Rectangle(110, 110, 180, 180), 0xFF000000);
        bm.x = bm.y = 300;
        bm.filters = [new ShaderFilter(new BorderShader())];
        addChild(bm);
        function log(?_) trace('{ w: ${bm.width} | h: ${bm.height} } - ${bm.getBounds(this)}');
        log();
        
        bm.scrollRect = new Rectangle(100, 100, 200, 200);
        log();
        addEventListener(Event.ENTER_FRAME, log);
    }
}

class BorderShader extends openfl.display.GraphicsShader
{
    @:glFragmentSource("
        #pragma header
        
        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec3 col = texture2D(bitmap, uv).rgb;
            
            if (uv.x < 0.1 || uv.x > 0.9 || uv.y < 0.1 || uv.y > 0.9) {
                gl_FragColor = vec4(1., col.gb, 1.);
                return;
            }
            gl_FragColor = vec4(col, 1.);
        }
    ")
    
    public function new() 
    {
        super();
    }
}
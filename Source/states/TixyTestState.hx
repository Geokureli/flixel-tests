package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxGraphicsShader;
import flixel.group.FlxSpriteContainer;
import flixel.math.FlxMath;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class TixyTestState extends flixel.FlxState
{
    inline static var W = 16;
    inline static var H = 16;
    
    final interpreter = new Interpreter();
    
    final elements = new FlxTypedSpriteContainer<Element>();
    final header:FlxText;
    final input:FlxInputText;
    final title:FlxText;
    final nextBtn:FlxButton;
    final prevBtn:FlxButton;
    
    var t = 0.0;
    var currentDemo = 0;
    var lastSuccessful:Null<String> = null;
    
    public function new()
    {
        super();
        
        FlxG.drawFramerate = 15;
        FlxG.updateFramerate = 15;
        
        add(elements);
        for (i in 0...W * H)
        {
            final x = (i % W) * (Element.RADIUS + 1);
            final y = Math.floor(i / W) * (Element.RADIUS + 1);
            final element = new Element(x, y);
            elements.add(element);
        }
        
        elements.screenCenter();
        
        header = new FlxText(0, elements.y + elements.height + 10, elements.width, "(t,i,x,y)=>", 16);
        add(header);
        
        input = new FlxInputText(0, header.y + header.height, FlxG.width, "sin(y/8+t)", 16);
        input.multiline = true;
        input.wordWrap = true;
        input.onTextChange.add(onTextChange);
        onTextChange(input.text);
        add(input);
        
        title = new FlxText(0, 20, FlxG.width, "");
        title.alignment = CENTER;
        add(title);
        
        nextBtn = new FlxButton(0, title.y + title.height, "Next Demo", onNextClick);
        nextBtn.x = FlxG.width / 2 + 2;
        add(nextBtn);
        
        prevBtn = new FlxButton(0, title.y + title.height, "Prev Demo", onPrevClick);
        prevBtn.x = FlxG.width / 2 - prevBtn.width + 2;
        add(prevBtn);
    }
    
    function onTextChange(text:String, ?_)
    {
        try
        {
            interpreter.variables.set("t", t);
            interpreter.variables.set("x", 0);
            interpreter.variables.set("y", 0);
            interpreter.variables.set("i", 0);
            final result:Any = interpreter.interpret(text);
            if (result is Float)
                lastSuccessful = text;
            header.color = FlxColor.WHITE;
        }
        catch(e)
        {
            header.color = FlxColor.RED;
            trace(e);
        }
    }
    
    function onNextClick()
    {
        currentDemo++;
        if (currentDemo >= Gallery.list.length)
            currentDemo = 0;
        
        onDemoChange();
    }
    
    function onPrevClick()
    {
        currentDemo--;
        if (currentDemo < 0)
            currentDemo = Gallery.list.length - 1;
        
        onDemoChange();
    }
    
    function onDemoChange()
    {
        final demo = Gallery.list[currentDemo];
        title.text = demo.name;
        input.text = demo.cmd;
        t = 0;
        onTextChange(demo.cmd);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        t += elapsed;
        
        if (lastSuccessful == null)
            return;
        
        interpreter.variables.set("t", t);
        for (i=>element in elements.members)
        {
            interpreter.variables.set("x", i % W);
            interpreter.variables.set("y", Math.floor(i / W));
            interpreter.variables.set("i", i);
            final result = interpreter.interpret(lastSuccessful);
            element.value = FlxMath.bound(result, -1.0, 1.0);
        }
    }
}

class Element extends FlxSprite
{
    static public inline var RADIUS = 16;
    
    public var value:Float = 1.0;
    
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y);
        
        shader = new ElementShader();
        
        makeGraphic(RADIUS, RADIUS, FlxColor.WHITE);
    }
    
    override function update(elapsed:Float)
    {
        // (cast shader:ElementShader).value.value[0] = value;
        super.update(elapsed);
    }
    
    override function draw()
    {
        (cast shader:ElementShader).value.value[0] = value;
        super.draw();
    }
}

class ElementShader extends FlxGraphicsShader
{
    @:glFragmentSource('
        #pragma header
        
        uniform float value;
        
        const vec2 MID = vec2(0.5);
        const float SMOOTHING = 0.1;
        const float SQRT2 = 1.41421356237;
        
        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec3 color = value > 0.0 ? vec3(1.0) : vec3(1.0, 0.0, 0.0);
            float dist = length(abs(uv - MID));
            float absValue = abs(value) / 2.0;
            float alpha = 1.0 - smoothstep(absValue - SMOOTHING, absValue, dist);
            gl_FragColor = vec4(color * alpha, alpha);
        }
    ', true)
    public function new ()
    {
        super();
        value.value = [1.0];
    }
}

typedef GalleryItem = {name:String, cmd:String, ?author:String, ?url:String};

class Gallery
{
    static var OG = "Martin Kleppe";
    static var ME = "George Kurelic";
    public static var list = 
        [ {name: "", cmd: "sin(y/8+t)"}
        , {name: "scrolling TIXY", cmd: "[5463,2194,2386][y+t*9&7]&1<<x-1", author: OG, url:"https://x.com/aemkei/status/1324495985196847107"}
        , {name: "checker board", cmd: "(((x-8)/y+t*5)&1^1/y*8&1)*y/5", author: OG, url:"https://x.com/aemkei/status/1324612940335599618" }
        , {name: "matrix rain", cmd: "1-((x*x-y+t*(1+x*x%5)*3)%16)/16", author: OG, url:"https://x.com/aemkei/status/1324501989464723456" }
        , {name: "fun with the & operator", cmd: "(x+(t*10)/16)&y+(t*10)", author: OG, url:"https://x.com/aemkei/status/1324637850491650049" }
        // , {name: "3d starfield", cmd: "d=y*y%5.9+1,!((x+t*50/d)&15)/d", author: OG, url:"https://x.com/aemkei/status/1324842485202493440" }
        , {name: "space invader", cmd: "'p}¶¼<¼¶}p'.charCodeAt(x)&pow(2,y)", author: "keithclarkcouk and zozuar", url:"https://x.com/aemkei/status/1325184311851589632" }
        , {name: "hungry pac man", cmd: "hypot(x-=t*5,y-=8)<6&(x<y|y<-x)", author: "p_malin and aemkei", url:"https://x.com/aemkei/status/1325184311851589632" }
        ];
}

class Interpreter extends hscript.Interp
{
    final parser = new hscript.Parser();
    public function new ()
    {
        super();
        parser.allowTypes = true;
        this.variables.set("Math", Math);
        this.variables.set("sin", Math.sin);
        this.variables.set("cos", Math.cos);
        this.variables.set("tan", Math.tan);
        this.variables.set("acos", Math.acos);
        this.variables.set("asin", Math.asin);
        this.variables.set("atan", Math.atan);
        this.variables.set("atan2", Math.atan2);
        this.variables.set("abs", Math.abs);
        this.variables.set("sqrt", Math.sqrt);
        this.variables.set("pow", Math.pow);
        this.variables.set("ceil", Math.ceil);
        this.variables.set("floor", Math.floor);
        this.variables.set("round", Math.round);
        this.variables.set("exp", Math.exp);
        this.variables.set("log", Math.log);
        this.variables.set("min", Math.min);
        this.variables.set("max", Math.max);
        this.variables.set("PI", Math.PI);
        this.variables.set("random", Math.random);
        this.variables.set("NaN", Math.NaN);
        this.variables.set("isNaN", Math.isNaN);
        this.variables.set("NEGATIVE_INFINITY", Math.NEGATIVE_INFINITY);
        this.variables.set("POSITIVE_INFINITY", Math.POSITIVE_INFINITY);
        this.variables.set("isFinite", Math.isFinite);
        final length = (x:Float, y:Float)->Math.sqrt(x * x + y * y);
        this.variables.set("length", length);
        this.variables.set("hypot", length);
    }
    
    public function interpret(command)
    {
        return this.expr(parser.parseString(command));
    }
}
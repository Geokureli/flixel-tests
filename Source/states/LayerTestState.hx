package states;

import flixel.group.FlxContainer;
import flixel.text.FlxText;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

class LayerTestState extends flixel.FlxState
{
    final layers = new Layers();
    var ui:FlxText;
    override function create()
    {
        super.create();
        add(layers);
        
        layers.bg[2].add(new FlxSprite(5, 5)).makeGraphic(FlxG.width - 10, FlxG.height - 10, 0xFFff8080);
        layers.bg[1].add(new FlxSprite(150, 150)).makeGraphic(100, 100, 0xFFffffff);
        layers.fg[0].add(new FlxSprite(350, 150)).makeGraphic(100, 100, 0xFFffffff);
        layers.fg[3].add(new FlxSprite(350, 350)).makeGraphic(100, 100, 0xFFffffff);
        layers.ui[0].add(ui = new FlxText(0, 100, 0, "UI here")).screenCenter(X);
        ui.velocity.set(100, 100);
        
        layers.mg.add(new FlxSprite(200, 200)).makeGraphic(200, 200, 0xFFaaaaaa);
        
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (ui.x + ui.width > FlxG.width)
        {
            ui.x = FlxG.width - ui.width;
            ui.velocity.x = -100;
        }
        
        if (ui.y + ui.height > FlxG.height)
        {
            ui.y = FlxG.height - ui.height;
            ui.velocity.y = -100;
        }
        
        if (ui.x < 0)
        {
            ui.x = 0;
            ui.velocity.x = 100;
        }
        
        if (ui.y < 0)
        {
            ui.y = 0;
            ui.velocity.y = 100;
        }
    }
}

class Layers extends FlxGroup
{
    public final bg = new MultiLayer(true);
    public final mg = new Layer();
    public final fg = new MultiLayer(false);
    public final ui = new MultiLayer(false);
    
    public function new ()
    {
        super();
        
        add(bg);
        add(mg);
        add(fg);
        add(ui);
    }
}

class MultiLayerRaw extends FlxTypedContainer<Layer>
{
    public final reverse:Bool;
    public function new (reverse = false)
    {
        this.reverse = reverse;
        super();
    }
    
    public function get(index:Int)
    {
        while (index >= this.length)
        {
            if (reverse)
                this.insert(0, new Layer());
            else
                this.add(new Layer());
        }
        
        return this.members[reverse ? length - index - 1 : index];
    }
}

@:forward.new
abstract MultiLayer(MultiLayerRaw) to FlxBasic
{
    @:arrayAccess
    inline public function get(index:Int)
    {
        return this.get(index);
    }
    
    //TODO: Override find methods to search all
}


@:forward.new
abstract Layer(FlxContainer) to FlxBasic
{
    public function add<T:FlxBasic>(member:T):T
    {
        this.add(member);
        return member;
    }
}


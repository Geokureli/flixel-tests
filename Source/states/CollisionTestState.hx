package states;

import flixel.input.mouse.FlxMouseEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDirection;
import flixel.util.FlxDirectionFlags;

class CollisionTestState extends flixel.FlxState
{
    final start:DragSprite;
    final end:DragSprite;
    final collider:BoxSprite;
    final wall:DirSprite;
    
    public function new ()
    {
        super();
        
        start = new DragSprite(50, 50, 50, 50, 0xFFff0000);
        end = new DragSprite(350, 350, start.width, start.height, start.color);
        collider = new BoxSprite(350, 350, start.width, start.height, 0xFFff8888);
        
        wall = new DirSprite(200, 200, 100, 100, 0xFF0000ff, 0xFF8888ff);
        wall.immovable = true;
        
        add(wall);
        add(start);
        add(end);
        add(collider);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        collider.last.x = start.x;
        collider.last.y = start.y;
        
        collider.x = end.x;
        collider.y = end.y;
        
        FlxG.collide(collider, wall);
    }
}

class DirSprite extends BoxSprite
{
    inline static var BORDER = 5;
    
    final u:BoxSprite;
    final d:BoxSprite;
    final l:BoxSprite;
    final r:BoxSprite;
    
    public function new (x = 0.0, y = 0.0, width = 100.0, height = 100.0, color = FlxColor.WHITE, borderColor = FlxColor.RED)
    {
        super(x, y, width, height, color);
        u = new BoxSprite(x, y, width, BORDER, borderColor);
        d = new BoxSprite(x, y + height - BORDER, width, BORDER, borderColor);
        l = new BoxSprite(x, y, BORDER, height, borderColor);
        r = new BoxSprite(x + width - BORDER, y, BORDER, height, borderColor);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        function toggle(dir:FlxDirection)
        {
            if (allowCollisions.has(dir))
                allowCollisions = allowCollisions.without(dir)
            else
                allowCollisions = allowCollisions.with(dir);
        }
        
        if (FlxG.keys.justPressed.LEFT ) toggle(LEFT );
        if (FlxG.keys.justPressed.RIGHT) toggle(RIGHT);
        if (FlxG.keys.justPressed.UP   ) toggle(UP   );
        if (FlxG.keys.justPressed.DOWN ) toggle(DOWN );
    }
    
    override function draw()
    {
        super.draw();
        
        if (allowCollisions.left ) l.draw();
        if (allowCollisions.right) r.draw();
        if (allowCollisions.up   ) u.draw();
        if (allowCollisions.down ) d.draw();
    }
}

class DragSprite extends BoxSprite
{
    var state:DragState = Idle;
    var enabled = true;
    
    public function new (x = 0.0, y = 0.0, width = 100.0, height = 100.0, color = FlxColor.WHITE)
    {
        super(x, y, width, height, color);
        
        FlxMouseEvent.add(this, (_)->if (enabled) state = Dragging(FlxG.mouse.x - this.x, FlxG.mouse.y - this.y));
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        switch state
        {
            case Idle:
            case Dragging(offsetX, offsetY):
                x = FlxG.mouse.x - offsetX;
                y = FlxG.mouse.y - offsetY;
                
                if (FlxG.mouse.justReleased)
                    state = Idle;
        }
    }
}

class BoxSprite extends FlxSprite
{
    public function new (x = 0.0, y = 0.0, width = 100.0, height = 100.0, color = FlxColor.WHITE)
    {
        super(x, y, FlxG.bitmap.whitePixel.parent);
        setGraphicSize(width, height);
        this.width = width;
        this.height = height;
        origin.set(0, 0);
        this.color = color;
    }
}

enum DragState
{
    Idle;
    Dragging(offsetX:Float, offsetY:Float);
}
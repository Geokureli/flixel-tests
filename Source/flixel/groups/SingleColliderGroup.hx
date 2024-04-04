package flixel.groups;


import flixel.FlxSprite;
import flixel.groups.FlxGroup;

class SingleColliderGroup<T:FlxBasic> extends FlxObject
{
    public var group:FlxTypedGroup<T>;
    
    public function new (x = 0.0, y = 0.0, width = 0.0, height = 0.0)
    {
        group = new FlxTypedGroup();
        super(x, y, width, height);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        group.update(elapsed);
    }
    
    override function draw()
    {
        super.draw();
        
        for (member in group)
        {
            member.x += x;
            member.y += y;
        }
        
        group.draw();
        
        for (member in group)
        {
            member.x -= x;
            member.y -= y;
        }
    }
}
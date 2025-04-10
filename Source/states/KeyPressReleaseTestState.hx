package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class KeyPressReleaseTestState extends flixel.FlxState
{
    var sprite1:FlxSprite;
    var sprite2:FlxSprite;
    final halfWidth:Int = Std.int(FlxG.width / 2);
    final halfHeight:Int = Std.int(FlxG.height / 2);
    
    override function create()
    {
        FlxG.drawFramerate = 4;
        FlxG.updateFramerate = FlxG.drawFramerate;
        
        add(sprite1 = new FlxSprite(0, 5).makeGraphic(halfWidth, halfHeight - 10));
        add(sprite2 = new FlxSprite(0, halfHeight + 5).makeGraphic(halfWidth, halfHeight - 10));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed); // <-- inputs updated here
        
        sprite1.x = (sprite1.x == 0 ? halfWidth : 0);
        sprite2.x = sprite1.x;
        
        sprite1.color = FlxG.keys.justPressed.SPACE ? FlxColor.BLUE : FlxColor.WHITE;
        sprite2.color = FlxG.keys.justReleased.SPACE ? FlxColor.RED : FlxColor.WHITE;
    }
}

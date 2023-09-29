package states;

import flixel.addons.plugin.FlxMouseControl;
import flixel.FlxG;
import flixel.addons.display.FlxExtendedMouseSprite;

class FlxExtendedSpriteTestState extends flixel.FlxState
{
    var sprite:FlxExtendedMouseSprite;
    
    override function create()
    {
        super.create();
        
        // FlxG.plugins.add(new FlxMouseControl());
        
        sprite = new FlxExtendedMouseSprite(50, 50);
        sprite.loadGraphic("assets/images/haxe-anim.png", true, 100, 100);
        sprite.animation.frameIndex = 8;
        // sprite.enableMouseClicks(true, true);
        // sprite.mousePressedCallback = (s, x, y)->trace('press ( x: $x | y: $y )');
        // sprite.mouseReleasedCallback = (s, x, y)->trace('released ( x: $x | y: $y )');
        // sprite.enableMouseDrag(false, true);
        // sprite.enableMouseThrow(50, 50);
        // sprite.enableMouseSnap(100, 100, false, true);
        sprite.enableMouseSpring(true, true);
        // sprite.enableMouseSpring(false, false);
        
        add(sprite);
        
        FlxG.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, (e)->trace(e.keyCode));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

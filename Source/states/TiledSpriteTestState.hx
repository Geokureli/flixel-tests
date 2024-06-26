package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.display.FlxTiledSprite;
import flixel.math.FlxRect;
import flixel.text.FlxText;

class TiledSpriteTestState extends flixel.FlxState
{
    var sprite:FlxTiledSprite;
    var object:FlxObject;
    var text:FlxText;
    var instructions:FlxText;
    
    override function create()
    {
        super.create();
        FlxG.debugger.drawDebug = true;
        
        sprite = new FlxTiledSprite("assets/images/haxe.png", 200, 100);
        sprite.screenCenter();
        add(sprite);
        
        object = new FlxObject();
        object.solid = false;
        add(object);
        
        text = new FlxText(0, 0, 0, "null");
        text.ignoreDrawDebug = true;
        updateText();
        add(text);
        
        instructions = new FlxText(0, 0, 0
            , "ARROWS/WASD: SCROLL\n"
            + "X,Y: TOGGLE REPEAT AXES\n"
            + "CLICK+DRAG: SET CLIPRECT\n"
            + "RIGHT-CLICK: CLEAR CLIPRECT\n"
            );
        instructions.ignoreDrawDebug = true;
        add(instructions);
    }
    
    function updateText()
    {
        final show = sprite.clipRect != null;
        text.visible = show;
        object.ignoreDrawDebug = !show;
        if (show)
        {
            object.x = sprite.clipRect.x + sprite.x;
            object.y = sprite.clipRect.y + sprite.y;
            object.width = sprite.clipRect.width;
            object.height = sprite.clipRect.height;
            text.text = sprite.clipRect.toString();
            text.screenCenter();
            text.y += 100;
        }
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        final R = FlxG.keys.anyPressed([RIGHT, D]);
        final L = FlxG.keys.anyPressed([LEFT, A]);
        final U = FlxG.keys.anyPressed([UP, W]);
        final D = FlxG.keys.anyPressed([DOWN, S]);
        
        if (FlxG.keys.pressed.ONE)
            sprite.repeatX = sprite.repeatX;
        
        if (FlxG.keys.pressed.TWO)
            sprite.repeatY = sprite.repeatY;
        
        sprite.scrollX += 100 * elapsed * ((R ? 1 : 0) - (L ? 1 : 0));
        sprite.scrollY += 100 * elapsed * ((D ? 1 : 0) - (U ? 1 : 0));
        
        if (FlxG.mouse.justPressed)
        {
            final rect = sprite.clipRect ?? FlxRect.get();
            final x = FlxG.mouse.x - sprite.x;
            final y = FlxG.mouse.y - sprite.y;
            rect.set(x, y, 1, 1);
            sprite.clipRect = rect;
            updateText();
        }
        else if (FlxG.mouse.pressed)
        {
            final rect = sprite.clipRect;
            final x = FlxG.mouse.x - sprite.x;
            final y = FlxG.mouse.y - sprite.y;
            rect.right = x;
            rect.bottom = y;
            
            if (rect.right <= rect.left)
                rect.width = 0;
            
            if (rect.bottom <= rect.top)
                rect.height = 0;
            
            sprite.clipRect = rect;
            updateText();
        }
        else if (FlxG.mouse.justPressedRight)
        {
            sprite.clipRect.put();
            sprite.clipRect = null;
            updateText();
        }
    }
}

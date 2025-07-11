package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxBitmapDataUtil;
import flixel.util.FlxColor;
import sprites.AnimSprite;
import tools.SpriteMover;

class ColorOffsetTestState extends flixel.FlxState
{
    var sprite:FlxSprite;
    
    override function create()
    {
        // add(sprite = new AnimSprite(10, 10));
        
        add(sprite = new FlxText(10, 10, "Hello, world!"));
        
        add(new SpriteMover(sprite));
        FlxG.watch.addFunction("alpha", ()->sprite.alpha);
        FlxG.watch.addFunction("color", ()->sprite.color);
        final ct = sprite.colorTransform;
        FlxG.watch.addFunction("ct.mult", ()->'r:${ct.redMultiplier}, g:${ct.greenMultiplier}, b:${ct.blueMultiplier}, a:${ct.alphaMultiplier}');
        FlxG.watch.addFunction("ct.offset", ()->'r:${ct.redOffset}, g:${ct.greenOffset}, b:${ct.blueOffset}, a:${ct.alphaOffset}');
        
        if (sprite is FlxText)
        {
            @:privateAccess
            FlxG.watch.addFunction("format.color", ()->((cast sprite:FlxText)._defaultFormat.color:FlxColor).toHexString());
        }
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.SPACE)
        {
            sprite.alpha = 0.99;
            // sprite.setColorTransform(0.0, 1, 1, 0.0, 0.5, 0, 0, 0.5);
            // sprite.setColorTransform(1, 1, 1, 1, 0, 0, 0xFF, 0);
            sprite.setColorTransform(0, 0.5, 1, sprite.alpha, 0, 0, 0, 0xFF);
            // sprite.setColorTransform(0, 0.5, 1, sprite.alpha);
        }
        else if (FlxG.keys.justReleased.SPACE)
        {
            sprite.color = FlxColor.WHITE;
            // sprite.setColorTransform();
        }
    }
}

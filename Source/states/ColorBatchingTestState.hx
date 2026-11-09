package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;


private final SPRITE_SIZE = 16;
private final SPRITE_SCALE = 1;
private final SPACING = SPRITE_SIZE * SPRITE_SCALE;

class ColorBatchingTestState extends flixel.FlxState
{
    final grp:FlxSpriteGroup;
    
    var colorMode = ColorMode.BOTH;
    
    final spritesPerRow:Int;
    final spritesPerCol:Int;
    
    public function new()
    {
        grp = new FlxSpriteGroup();
        
        super();
        
        spritesPerRow = Math.floor(FlxG.width / SPACING);
        spritesPerCol = Math.floor(FlxG.height / SPACING);
        
        createSprites();
        add(grp);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.SPACE)
        {
            colorMode = (colorMode + 1) % 4;
            recolorSprites();
        }
    }
    
    function createSprites()
    {
        final totalSprites = spritesPerRow * spritesPerCol;
        
        for (i in 0...totalSprites)
        {
            final row = Math.floor(i / spritesPerRow);
            final col = i % spritesPerRow;
            
            final spr = grp.recycle(() -> new FlxSprite());
            spr.x = col * SPACING;
            spr.y = row * SPACING;
            spr.width = spr.height = SPACING;
            spr.scale.set(SPRITE_SCALE, SPRITE_SCALE);
        }
        
        grp.screenCenter();
        recolorSprites();
    }
    
    function recolorSprites()
    {
        final totalSprites = spritesPerRow * spritesPerCol;
        
        for (i in 0...totalSprites)
        {
            final spr = grp.members[i];
            spr.setColorTransform();
            spr.color = FlxColor.WHITE;
            
            if (i % spritesPerRow == 2 && colorMode.offsets)
            {
                spr.setColorTransform(1, 1, 1, 1, 255, 255, 0, 0);
            }
            
            if (i % spritesPerRow >= spritesPerRow / 2 && colorMode.mults)
            {
                spr.color = FlxColor.fromHSB(i / totalSprites * 360, 1, 1);
                spr.alpha = (i % 10) / 10;
            }
        }
    }
}

enum abstract ColorMode(Int) to Int from Int
{
    var OFF = 0;
    var MULTS_ONLY = 1;
    var OFFSETS_ONLY = 2;
    var BOTH = 3;
    
    public var mults(get, never):Bool;
    inline function get_mults() return this & MULTS_ONLY > 0;
    
    public var offsets(get, never):Bool;
    inline function get_offsets() return this & OFFSETS_ONLY > 0;
}
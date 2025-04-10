package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxBitmapText;

class AssetCacheTestState extends flixel.FlxState
{
    static var counter = 0;
    
    var sprites:FlxTypedGroup<FlxSprite>;
    var text:FlxBitmapText;
    final autoLoad:Bool;
    
    public function new (autoLoad = false)
    {
        this.autoLoad = autoLoad;
        super();
    }
    
    override function create()
    {
        super.create();
        
        add(text = new FlxBitmapText(""));
        text.alignment = CENTER;
        text.setBorderStyle(OUTLINE, 1);
        setText('State ${counter++} - autoLoad:$autoLoad');
        
        if (autoLoad)
            loadSprites();
    }
    
    function setText(msg:String)
    {
        text.text = msg;
        text.screenCenter();
    }
    
    function appendText(msg:String)
    {
        text.text += text.text != "" ? '\n$msg' : msg;
        text.screenCenter();
    }
    
    function loadSprites()
    {
        clearSprites();
        insert(0, sprites = new FlxTypedGroup<FlxSprite>());
        
        appendText("checking chache");
        
        final key1 = "custom-graphic";
        final key2 = "assets/images/haxe-anim.png";
        sprites.add(createSpriteFromCache(key1) ?? new FlxSprite().makeGraphic(100, 100, key1));
        sprites.add(createSpriteFromCache(key2) ?? new FlxSprite().loadGraphic(key2, true, 100, 100));
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justReleased.SPACE)
            loadSprites();
        
        if (FlxG.keys.justReleased.ENTER)
        {
            final autoLoad = FlxG.keys.pressed.SHIFT;
            FlxG.switchState(()->new AssetCacheTestState(autoLoad));
        }
    }
    
    function createSpriteFromCache(key)
    {
        if (FlxG.bitmap.checkCache(key))
        {
            appendText('found: "$key"');
            return new FlxSprite(FlxG.bitmap.get(key));
        }
        
        appendText('missing: "$key"');
        return null;
    }
    
    function clearSprites()
    {
        if (sprites != null)
        {
            setText("cleared");
            remove(sprites);
            sprites.destroy();
            sprites = null;
        }
    }
}

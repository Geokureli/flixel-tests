package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.frontEnds.AssetFrontEnd;

class AssetFrontEndTestState extends flixel.FlxState
{
    
    override function create()
    {
        super.create();
        
        // Edit the simplified id before passing it to the old method
        function path(id:String, type:FlxAssetType)
        {
            // for flixel assets, just pass them to the old method
            if (StringTools.startsWith(id, "flixel/") || StringTools.contains(id, ':'))
                return id;
                
            return switch type
            {
                case BINARY: 'assets/data/$id';// expects extension already
                case TEXT  : 'assets/data/$id.json';
                case IMAGE : 'assets/images/$id.png';
                case SOUND : 'assets/sounds/$id.ogg';
                case FONT  : 'assets/font/$id.ttf';
            };
        }
        
        final assets = FlxG.assets;
        
        // Save the old methods, call them with the full path
        final oldExists = assets.exists;
        assets.exists = (id, ?type)->oldExists(path(id, type ?? BINARY), type);
        
        final oldIsLocal = assets.isLocal;
        assets.isLocal = (id, ?type, cache = true)->oldIsLocal(path(id, type ?? BINARY), type, cache);
        
        final oldGet = assets.getAssetUnsafe;
        assets.getAssetUnsafe = (id, type, cache = true)->oldGet(path(id, type), type, cache);
        
        final sprite = new FlxSprite(100, 100);
        sprite.loadGraphic("haxe-anim", true);
        sprite.animation.add("loop", [for (i in 0...sprite.animation.numFrames) i], 8);
        sprite.animation.play("loop");
        add(sprite);
        
        trace(FlxG.assets.list().join("\n"));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
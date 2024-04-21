package states;

import flixel.text.FlxText;
import flixel.FlxSprite;

import openfl.Assets;

class AsyncAssetTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        final imgPath = "async:async-assets/images/haxe.png";
        try
        {
            final bmd = Assets.getBitmapData(imgPath);
            final sprite = new FlxSprite(10, 10, bmd);
            add(sprite);
        }
        catch(e){ trace(e.message); }
        
        Assets.loadBitmapData(imgPath).onComplete(
            function drawSprites(bmd)
            {
                final sprite = new FlxSprite(10, 120, bmd);
                add(sprite);
            }
        );
        
        final txtPath = "async:async-assets/data/test.json";
        try
        {
            final data = Assets.getText(txtPath);
            final text = new FlxText(120, 10, 0, data);
            add(text);
        } catch(e){ trace(e.message); }
        
        Assets.loadText(txtPath).onComplete(
            function drawSprites(data)
            {
                final text = new FlxText(120, 120, 0, data);
                add(text);
            }
        );
        
        
    }
}

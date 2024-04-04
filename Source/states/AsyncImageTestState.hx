package states;

import flixel.FlxSprite;

class AsyncImageTestState extends flixel.FlxState
{
    inline static var PATH = "async-assets/images/haxe.png";
    
    override function create()
    {
        super.create();
        
        openfl.Assets.loadBitmapData(PATH, true).onComplete(
            function drawSprites(_)
            {
                for (i in 0...3)
                {
                    final sprite = new FlxSprite(10 + 110 * i, 10);
                    sprite.loadGraphic(PATH, false, 0, 0, i > 1);
                    add(sprite);
                }
                // edit the first sprite, see if all change
                final bitmap = (cast members[0]:FlxSprite).graphic.bitmap;
                bitmap.fillRect(bitmap.rect, 0xFFff0000);
            }
        );
    }
}

package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

class SpriteGroupScaleTestState extends flixel.FlxState
{
    var sprites:FlxSpriteGroup;
    
    override function create() {
        var demoCard = new CreditsCard('');
        add(demoCard);
        demoCard.updateFramePixels();
        demoCard.screenCenter();
        demoCard.updateHitbox();
        demoCard.offset.x = 0;
        demoCard.offset.y = 0;
        
        super.create();
        
        trace(demoCard.scale);
        trace(demoCard.char.scale);
        trace(demoCard.backing.scale);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

class CreditsCard extends flixel.group.FlxSpriteContainer {
    public var char:FlxSprite;
    public var backing:FlxSprite;
    public function new(?person:String = 'Farsy') {
        super();
        backing=new FlxSprite().makeGraphic(304, 184, 0xFFFFFFFF);
        char = new FlxSprite().makeGraphic(482, 548, 0xFFFF0000);
        char.scale.set(char.width / Math.min(char.height/150, char.width/150), char.height / Math.min(char.height/150, char.width/150));
        char.updateHitbox();
        char.updateFramePixels();
        char.x = backing.width - (char.width+4);
        char.y = backing.height - (char.height+4);
        add(backing);
        add(char);
        this.scale.set(3,3);
    }
}
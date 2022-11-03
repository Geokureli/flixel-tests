package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class TestState2305 extends flixel.FlxState
{
	var parentGroup:FlxSpriteGroup;
	var text:FlxText;
	
	override public function create()
	{
		parentGroup = new FlxSpriteGroup();
		parentGroup.setPosition(FlxG.width / 2, FlxG.height / 2);
		add(parentGroup);
		
		var group = new FlxSpriteGroup();
		var thing = new FlxSprite(-10, -10);
		thing.makeGraphic(10, 10, FlxColor.RED, true);
		group.add(thing);
		
		var thing2 = new FlxSprite(0, 0);
		thing2.makeGraphic(10, 10, FlxColor.BLUE, true);
		group.add(thing2);
		parentGroup.add(group);
		
		text = new FlxText();
		add(text);
		updateText();
	}
	
	inline function updateText()
	{
		text.text = '${parentGroup.width} x ${parentGroup.height}';
	}
	
	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			var sprite = new FlxSprite(-10, 10);
			sprite.makeGraphic(10, 10, FlxColor.GREEN, true);
			parentGroup.add(sprite);
			
			updateText();
		}
		super.update(elapsed);
	}
}
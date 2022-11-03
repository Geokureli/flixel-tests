package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class ClipRectTestState extends flixel.FlxState
{
	var _groupA:ClipRectTestGroup;
	var _groupB:ClipRectTestGroup;
	
	override function create():Void
	{
		add(_groupA = new ClipRectTestGroup(150, 100, "NEW WAY", true));
		add(_groupB = new ClipRectTestGroup(550, 100, "OLD WAY", false));
		
		final instructions = new FlxText();
		instructions.size = 24;
		instructions.text
			= "Arrows Keys: Move sprite\n"
			+ "< >: grow/shrink sprite\n"
			+ "IJKL: move sprite origin\n"
			+ "SHIFT: apply above commands to the group\n"
			+ "Z: apply above commands to the text!\n"
			+ "\n"
			+ "WASD: move clip rect\n"
			+ "SHIFT + WASD: grow/shrink clipRect\n"
			;
		instructions.x = 4;
		instructions.y = FlxG.height - instructions.height - 4;
		add(instructions);
	}
}

class ClipRectTestGroup extends FlxSpriteGroup
{
	var _sprite:FlxSprite;
	var _text:FlxText;
	var _subGroup:FlxSpriteGroup;
	var _groupRect = new FlxRect(0, 0, 100, 100);
	
	public function new (x = 0.0, y = 0.0, text:String, newMethod:Bool)
	{
		super(x, y);
		
		add(_sprite = new FlxSprite("Assets/images/haxe.png"));
		
		add(_subGroup = new FlxSpriteGroup());
		_subGroup.add(_text = new FlxText(text, 16));
		_text.color = 0xFFFF0000;
		
		clipRectIgnoreScale
			= _subGroup.clipRectIgnoreScale
			= _sprite.clipRectIgnoreScale
			= _text.clipRectIgnoreScale
			= !newMethod;
		
		clipRect = _groupRect;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		final shift = FlxG.keys.pressed.SHIFT;
		final ctrl = FlxG.keys.pressed.Z;
		
		if (shift)
		{
			if (FlxG.keys.pressed.D) _groupRect.width++;
			if (FlxG.keys.pressed.A) _groupRect.width--;
			if (FlxG.keys.pressed.S) _groupRect.height++;
			if (FlxG.keys.pressed.W) _groupRect.height--;
		}
		else
		{
			if (FlxG.keys.pressed.D) _groupRect.x++;
			if (FlxG.keys.pressed.A) _groupRect.x--;
			if (FlxG.keys.pressed.S) _groupRect.y++;
			if (FlxG.keys.pressed.W) _groupRect.y--;
		}
		
		var sprite = shift
			? this
			: (ctrl ? _text : _sprite);
		
		if (FlxG.keys.pressed.D) sprite.width++;
		if (FlxG.keys.pressed.A) sprite.width--;
		if (FlxG.keys.pressed.S) sprite.height++;
		if (FlxG.keys.pressed.W) sprite.height--;
		
		if (FlxG.keys.pressed.RIGHT) sprite.x++;
		if (FlxG.keys.pressed.LEFT ) sprite.x--;
		if (FlxG.keys.pressed.DOWN ) sprite.y++;
		if (FlxG.keys.pressed.UP   ) sprite.y--;
		
		if (FlxG.keys.pressed.L) sprite.origin.x++;
		if (FlxG.keys.pressed.J) sprite.origin.x--;
		if (FlxG.keys.pressed.K) sprite.origin.y++;
		if (FlxG.keys.pressed.I) sprite.origin.y--;
		
		if (FlxG.keys.justPressed.C)
			sprite.origin.set(0, 0);
		
		if (FlxG.keys.justPressed.X)
			sprite.updateHitbox();
		
		var width = Math.round(sprite.frameWidth * sprite.scale.x);
		if (FlxG.keys.pressed.PERIOD)
			sprite.setGraphicSize(width + 1);
		if (FlxG.keys.pressed.COMMA && width > 1)
			sprite.setGraphicSize(width - 1);
		
		if (FlxG.keys.pressed.QUOTE)
			sprite.offset.x++;
		if (FlxG.keys.pressed.SEMICOLON)
			sprite.offset.x--;
		
		clipRect = _groupRect;
	}
	
	override function draw()
	{
		alpha = 0.25;
		clipRect = null;
		super.draw();
		
		alpha = 1.00;
		clipRect = _groupRect;
		super.draw();
	}
}
package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;

class ScaleOffsetTestState extends flixel.FlxState
{
	var _groupA:ScaleOffsetTestGroup;
	var _groupB:ScaleOffsetTestGroup;
	
	override function create():Void
	{
		add(_groupA = new ScaleOffsetTestGroup(150, 100, true));
		add(_groupB = new ScaleOffsetTestGroup(550, 100, false));
		
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

class ScaleOffsetTestGroup extends FlxSpriteGroup
{
	var _sprite:FlxSprite;
	var _text:FlxText;
	var _origin:FlxSprite;
	
	public function new (x = 0.0, y = 0.0, newMethod:Bool)
	{
		super(x, y);
		
		FlxG.debugger.drawDebug = true;
		ignoreDrawDebug = true;
		
		add(_sprite = new FlxSprite("Assets/images/haxe.png"));
		
		add(_text = new FlxText(newMethod ? "NEW WAY" : "OLD WAY", 16));
		_text.color = 0xFFFF0000;
		_text.ignoreDrawDebug = true;
		
		_origin = new FlxSprite("Assets/images/origin.png");
		_origin.ignoreDrawDebug = true;
		
		if (newMethod)
		{
			FlxG.watch.add(_sprite, "origin");
			FlxG.watch.add(_sprite, "offset");
			FlxG.watch.add(_sprite, "scale");
		}
		
		scaleOffset
			= _sprite.scaleOffset
			= _text.scaleOffset
			= newMethod;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		final shift = FlxG.keys.pressed.SHIFT;
		final ctrl = FlxG.keys.pressed.Z;
		
		var sprite = _sprite;
		
		if (FlxG.keys.pressed.D)
		{
			sprite.width++;
			sprite.height++;
		}
		
		if (FlxG.keys.pressed.A)
		{
			sprite.width--;
			sprite.height--;
		}
		
		var width = Math.round(sprite.frameWidth * sprite.scale.x);
		if (FlxG.keys.pressed.W)
			sprite.setGraphicSize(width + 1);
		if (FlxG.keys.pressed.S && width > 1)
			sprite.setGraphicSize(width - 1);
		
		
		var right = FlxG.keys.pressed.RIGHT;
		var left  = FlxG.keys.pressed.LEFT ;
		var down  = FlxG.keys.pressed.DOWN ;
		var up    = FlxG.keys.pressed.UP   ;
		
		if (right && left) sprite.origin.x = sprite.frameWidth / 2;
		else if (left ) sprite.origin.x = 0;
		else if (right) sprite.origin.x = sprite.frameWidth;
		
		if (up && down) sprite.origin.y = sprite.frameHeight / 2;
		else if (up  ) sprite.origin.y = 0;
		else if (down) sprite.origin.y = sprite.frameHeight;
		
		if (FlxG.keys.pressed.L) sprite.origin.add(1, 1);
		if (FlxG.keys.pressed.J) sprite.origin.subtract(1, 1);
		if (FlxG.keys.pressed.I) sprite.offset.add(1, 1);
		if (FlxG.keys.pressed.K) sprite.offset.subtract(1, 1);
		
		if (FlxG.keys.pressed.COMMA) sprite.angle--;
		if (FlxG.keys.pressed.PERIOD) sprite.angle++;
		
		if (FlxG.keys.pressed.C)
			sprite.centerOffsets(shift);
		
		if (FlxG.keys.pressed.X)
			sprite.updateHitbox();
	}
	
	@:privateAccess
	override function draw()
	{
		super.draw();
		
		_origin.x = _sprite.x + _sprite.origin.x - _sprite.offset.x - 3;
		_origin.y = _sprite.y + _sprite.origin.y - _sprite.offset.y - 3;
		_origin.draw();
		
		var gfx = _sprite.beginDrawDebug(camera);
		_sprite.drawDebugBoundingBoxColor(gfx, _sprite.getScreenBounds());
		_sprite.endDrawDebug(camera);
		
		var pos = _sprite.getScreenPosition();
		_origin.x = pos.x - 3;
		_origin.y = pos.y - 3;
		_origin.draw();
	}
}
package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class ClipRectSlameronTestState extends FlxState
{
	var texts:FlxTypedGroup<FlxText>;

	var topBound:Float = 213;
	var bottomBound:Float = 560;
	var defY = 213;
	var spacing = 70;
	var scrollSelected:Int = 0;
	var scrollAmount:Int = 0;

	override public function create()
	{
		super.create();

		texts = new FlxTypedGroup();
		add(texts);

		for (i in 0...6)
		{
			var text = new FlxText(0, defY + (i * spacing), FlxG.width, 'test $i', 32);
			text.ID = i;
			text.alignment = CENTER;
			texts.add(text);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([S, DOWN]))
			scroll(1);
		if (FlxG.keys.anyJustPressed([W, UP]))
			scroll(-1);
		
		for (i=>text in texts)
		{
			text.color = text.ID == scrollSelected ? FlxColor.YELLOW : FlxColor.WHITE;
			var targetY = defY + (spacing * text.ID) - (spacing * scrollAmount);
			text.y = FlxMath.lerp(text.y, targetY, 0.2);
			if (text.clipRect != null)
			{
				text.clipRect.put();
				text.clipRect = null;
			}
			
			if (text.y < topBound)
			{
				var yDiff = topBound - text.y;
				text.clipRect = FlxRect.get(0, yDiff, text.width, text.height - yDiff);
			}
			else if (text.y + text.height > bottomBound)
			{
				var yDiff = text.y + text.height - bottomBound;
				text.clipRect = FlxRect.get(0, 0, text.width, text.height - yDiff);
			}
			FlxG.watch.addQuick('text-$i', text.clipRect);
		}
	}

	function scroll(amount:Int, boundOffs:Int = 0)
	{
		var bound = FlxPoint.get(0,
			texts.members.length > (spacing > 70 ? 3 + boundOffs : 4 + boundOffs) ? (spacing > 70 ? 3 + boundOffs : 4 + boundOffs) : texts.members.length - 1);
		scrollSelected += amount;
		if (scrollSelected < bound.x + 1 || scrollSelected > bound.y - 1)
			scrollAmount = Std.int(FlxMath.bound(scrollAmount + amount, 0, texts.members.length - scrollSelected));
		scrollSelected = Std.int(FlxMath.bound(scrollSelected, bound.x, bound.y));
		bound.put();
	}
}

class ScrollContainer
{
	// public var scrollX(default, set):Float;
	// public var maxScrollX(get, never):Float;
}
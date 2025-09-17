package states;

class FlxTextTestState extends flixel.FlxState
{
	override public function create():Void
	{
		super.create();
		bgColor = 0xFF808080;
		
		final text = new flixel.text.FlxText("Hello World!");
		text.screenCenter();
		add(text);
	}
}
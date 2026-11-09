package states;

import flixel.FlxG;

class LoggingTestState extends flixel.FlxState
{
	override public function create()
	{
		super.create();

		trace(FlxG.log.styles.error.throwException);
		
		FlxG.log.styles.normal.format.underlined = true;
		FlxG.log.styles.notice.format.bold = true;
		FlxG.log.styles.warning.format.italic = true;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ONE)
			FlxG.log.add("test");
		
		if (FlxG.keys.justPressed.TWO)
			FlxG.log.notice("test");
		
		if (FlxG.keys.justPressed.THREE)
			FlxG.log.warn("test");
		
		if (FlxG.keys.justPressed.FOUR)
			FlxG.log.error("test");
	}
}

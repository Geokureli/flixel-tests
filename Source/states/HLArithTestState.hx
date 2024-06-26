package states;

class HLArithTestState extends flixel.FlxState
{
	override function create()
	{
		// only true in nightly HL
		trace(checkDownStatic(false, true, true, false));
		
		// no issues
		trace(checkDownInstance(false, true, true, false));
		
		// only true in nightly HL
		trace(checkDownStatic(false, true, true, true));
		
		// no issues
		trace(checkDownInstance(false, true, true, true));
	}
	
	public static function checkDownStatic(left:Bool, right:Bool, up:Bool, down:Bool)
	{
		return down;
	}
	
	public function checkDownInstance(left:Bool, right:Bool, up:Bool, down:Bool)
	{
		return down;
	}
}
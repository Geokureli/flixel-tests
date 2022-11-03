package states;

class ModMinMaxTestState extends flixel.FlxState
{
	override function create()
	{
		for (i in 100...200)
		{
			trace('$i % 100 - min:${modMin(i, 100, 100)}(${modMinWhile(i, 100, 100))}) max:${modMax(i, 100, 100)}(${modMaxWhile(i, 100, 100)})');
		}
	}
	
	function modMin(value:Float, step:Float, min:Float)
	{
		return value - Math.floor((value - min) / step) * step;
	}
	
	function modMax(value:Float, step:Float, max:Float)
	{
		return value - Math.ceil((value - max) / step) * step;
	}
	
	function modMinWhile(value:Float, step:Float, min:Float)
	{
		while (Math.round((value - step) * 100) >= min * 100)
			value -= step;
		
		while (Math.round(value * 100) < min * 100)
			value += step;
		
		return Math.round(value * 100) / 100;
	}
	
	function modMaxWhile(value:Float, step:Float, max:Float)
	{
		while (Math.round((value + step) * 100) <= max * 100)
			value += step;
		
		while (Math.round(value * 100) > max * 100)
			value -= step;
		
		return Math.round(value * 100) / 100;
	}
}
package states;

import flixel.system.FlxBuffer;

class BufferTestState extends flixel.FlxState
{
	override function create()
	{
		final bufferStr = new FlxBuffer<{ x:String, y:String }>();
		for (i in 0...100)
			bufferStr.push({ x: Std.string(i % 10), y: Std.string(Std.int(i / 10)) });
		
		bufferStr.shift();
		bufferStr.pop();
		
		for (i=>item in bufferStr)
		{
			trace('$i: $item');
		}
		
		final bufferTD = new FlxBuffer<{ x:Float, y:Float }>();
		final bufferTD2 = new FlxBuffer<XY>();
		final buffer = new FlxBuffer<XYAbs>();
		for (i in 0...100)
			buffer.push({ x: i % 10, y: Std.int(i / 10) });
		
		buffer.set(0, { x: 1000, y: 1000 });
		trace('sum(0): ${buffer.getSum(0)} == ${buffer.get(0).sum}');
		buffer.insert(1, { x: 500, y: 500 });
		trace('sum(1): ${buffer.getSum(1)} == ${buffer.get(1).sum}');
		
		trace('x(15): ${buffer.getX(15)} == ${buffer.get(15).x}');
		trace('y(15): ${buffer.getY(15)} == ${buffer.get(15).y}');
		trace('sum(15): ${buffer.getSum(15)} == ${buffer.get(15).sum}');
		
		for (i=>item in buffer)
		{
			trace('$i: $item');
		}
		
		trace(buffer.shift().sum);
		trace(buffer.pop().sum);
		
		// $type(buffer.iterator()); // Iterable<XYAbs>
		final foldtotal
			= Lambda.fold((buffer:Iterable<XYAbs>), (item, result)->result + item.x + item.y, 0.0);
	}
}

typedef XY = { x:Float, y:Float }
@:forward
abstract XYAbs(XY) from XY
{
	public var sum(get, never):Float;
	inline function get_sum() { return this.x + this.y; }
	
	public function toString() { return '( ${this.x} | ${this.y} )'; }
}
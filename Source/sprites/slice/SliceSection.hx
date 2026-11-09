package sprites.slice;

import sprites.slice.FlxBits;

enum abstract SliceSection(Int)
{
	static final names = ["TL", "TC", "TR", "CL", "CC", "CR", "BL", "BC", "BR"];
	static public final all = [TL, TC, TR, CL, CC, CR, BL, BC, BR];
	inline static public function iterator() return all.iterator();
	
	var TL = 0x001; var TC = 0x002; var TR = 0x004;
	var CL = 0x008; var CC = 0x010; var CR = 0x020;
	var BL = 0x040; var BC = 0x080; var BR = 0x100;
	
	static final LOG2 = Math.log(2);
	static inline var COLUMNS = 3;
	static inline var ROWS = 3;
	
	var index(get, never):Int;
	inline function get_index() return Std.int(Math.log(this) / LOG2);
	
	public var row(get, never):Int;
	inline function get_row() return Std.int(index / 3);
	
	public var column(get, never):Int;
	inline function get_column() return index % 3;
	
	public function toString()
	{
		return names[all.indexOf((cast this: SliceSection))];
	}
}

@:access(sprites.slice.SliceSection)
@:forward(length)
@:forward.variance
abstract SliceSectionList<T>(Array<T>) from Array<T>
{
	public function new(defaultValue:()->T)
	{
		this = [for (i in SliceSection) defaultValue()];
	}
	
	@:arrayAccess
	public inline function get(section:SliceSection)
	{
		return this[intFromBit(section)];
	}
	
	@:arrayAccess
	public inline function set(section:SliceSection, value:T)
	{
		return this[intFromBit(section)] = value;
	}
	
	public inline function iterator()
	{
		return this.iterator();
	}
	
	public inline function keys()
	{
		return SliceSection.iterator();
	}
	
	public inline function keyValueIterator()
	{
		return new SectionListKeyValueIterator(this);
	}
	
	static inline function intFromBit(bit:SliceSection)
	{
		return bit.index;
	}
}

class SectionListKeyValueIterator<T>
{
	final list:SliceSectionList<T>;
	var iter = SliceSection.iterator();

	public inline function new(list)
	{
		this.list = list;
	}

	public inline function hasNext():Bool
	{
		return iter.hasNext();
	}

	public inline function next()
	{
		final key:SliceSection = iter.next();
		final value = list[key];
		return { value: value, key: key };
	}
}
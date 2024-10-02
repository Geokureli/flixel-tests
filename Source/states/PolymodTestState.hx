package states;

import flixel.FlxBasic;

class PolymodTestState extends flixel.FlxState {
	
	override function create()
	{
		
	}
}

// Uses Group
@:keep
@:hscriptClass
class PolymodStateGroup extends GroupState {}

// Uses Container with NO override for add
// @:keep
// @:hscriptClass
// class PolymodStateCont extends ContState implements polymod.hscript.HScriptedClass {}

// Uses Container with override for add
@:keep
@:hscriptClass
class PolymodStateContOv extends ContStateOv implements polymod.hscript.HScriptedClass {}

class GroupState extends Group{}
class ContState extends Container{}
class ContStateOv extends ContainerOv{}

typedef Container = TypedContainer<FlxBasic>;
class TypedContainer<T:FlxBasic> extends TypedGroup<T>{}

typedef ContainerOv = TypedContainerOv<FlxBasic>;
class TypedContainerOv<T:FlxBasic> extends TypedGroup<T>
{
	override function add(item:T):T { return super.add(item); }
}

typedef Group = TypedGroup<FlxBasic>;
class TypedGroup<T:FlxBasic>
{
	public function add(item:T):T { return item; }
	
	public function toString():String { return ""; }
}
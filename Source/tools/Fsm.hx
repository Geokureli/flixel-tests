package tools;

import haxe.macro.Type;

class Fsm<State:EnumType>
{
    public var current(default, never):State;
    
    final links:Map<State, Array<Link>> = [];
    final controls:Map<State, FsmController<State>> = [];
    
    public function new (start:State)
    {
        
    }
}

class FsmController<State:EnumType>
{
    public function onEnter(from:Null<State>) {}
    
    public function onExit(to:State) {}
    
    public function update(elapsed:Float) {}
}
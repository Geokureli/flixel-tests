package states;

import flixel.FlxG;
import flixel.system.debug.console.EmptyConsoleHandler;
import flixel.system.debug.console.IFlxConsoleHandler;
import haxe.DynamicAccess;
#if hscript
import flixel.system.debug.console.ConsoleUtil;
#end

class ConsoleTestState extends flixel.FlxState
{
    final obj:DynamicAccess<Dynamic> = {};
    override function create()
    {
        super.create();
        
        G.thing.doThing();
        
        #if FLX_DEBUG
        FlxG.console.registerClass(G);
        FlxG.console.registerObject("Flags", obj);
        obj["a"] = 0;
        obj["b"] = 1;
        obj["2"] = "2";
        
        FlxG.console.registerObject("Null", null);
        
        FlxG.watch.addExpression("Flags.a");
        #end
        trace("hello, world!");
        trace(Reflect.field(FlxG.console, "handler"));
        trace(Reflect.field(FlxG.game, "debugger"));
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.mouse.justPressed)
            obj["new"] = true;
        
        #if FLX_DEBUG
        if (FlxG.keys.justPressed.ONE)
        {
            FlxG.console.setHandler(new ConsoleHandler());
        }
        
        if (FlxG.keys.justPressed.TWO)
        {
            FlxG.console.setHandler(new EmptyConsoleHandler());
        }
        
        #if hscript
        if (FlxG.keys.justPressed.THREE)
        {
            FlxG.console.setHandler(@:privateAccess ConsoleUtil.handler);
        }
        #end
        #end
    }
}

class ConsoleHandler implements IFlxConsoleHandler
{
    public function new() {}
	
	public function evaluate(input:String):Any
	{
		return 'Evaluated "$input"';
	}
	
	public function register(alias:String, value:Any):Void {}
	
	public function remove(alias:String):Void {}
	
	public function getFields(object:Any):Array<String>
	{
		return [];
	}
	
	public function getGlobals():Array<String>
	{
		return [];
	}
	
	public function findAlias(obj:Any):Null<String>
	{
		return null;
	}
}

class G
{
	static public final thing = Thing;
	static public var otherthing(get, never):Class<Thing>;
	static inline function get_otherthing() return thing;
}

class Thing {
  
  static public function doThing(){ trace("Haxe is great!"); }
}
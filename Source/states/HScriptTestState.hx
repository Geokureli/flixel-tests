package states;

import flixel.FlxG;
import flixel.FlxSprite;
import haxe.Json;
import hscript.Interp;
import hscript.Parser;

using flixel.util.FlxColorTransformUtil;

class HScriptTestState extends flixel.FlxState
{
    override function create()
    {
        // super.create();
        
        // final parse = Json.parse;
        // // trace((cast parse('{ "x": 10, "y": 20 }'):{x:Int, y:Int}).x);
        // trace((cast { x: 10, y: 20 }:{x:Int, y:Int}).x);
        // final parser = new Parser();
		// parser.allowJSON = true;
		// parser.allowTypes = true;
        // final interp = new Interp();
        // interp.expr(parser.parseString("trace({ x: 10, y: 20 }.z)"));
        // interp.variables.set("TestEnum", TestEnum);
        // interp.variables.set("parse", parse);
        // // interp.expr(parser.parseString('trace((cast parse(\'{ "x": 10, "y": 20 }\'):{x:Int, y:Int}).x)'));
        // // interp.expr(parser.parseString("trace((cast { x: 10, y: 20 }:{x:Int, y:Int}).x)"));
        // interp.expr(parser.parseString("trace(TestEnum.A)"));
        
        // #if FLX_DEBUG
        // FlxG.console.registerEnum(TestEnum);
        // interp.expr(parser.parseString("trace(TestEnum.A)"));
        // #end
        test();
    }
    
    function test()
    {
        final parser = new hscript.Parser();
        parser.allowTypes = true;
        final interp = new hscript.Interp();
        interp.variables.set("TestEnum", TestEnum);
        trace(interp.expr(parser.parseString("TestEnum"))); // $TestEnum
        trace(interp.expr(parser.parseString("TestEnum.A"))); // null
    }
    
    function tryRunConsole(cmd:String)
    {
        try
        {
            trace('SUCCESS: ${flixel.system.debug.console.ConsoleUtil.runCommand(cmd)}');
        }
        catch (e)
        {
            trace('FAIL: ${e.message}');
        }
    }
}

enum TestEnum { A; B; C; }
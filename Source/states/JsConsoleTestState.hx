package states;

import flixel.FlxG;

class JsConsoleTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        #if js
        js.Browser.console.trace({test: "foo", bar: [0,1,2,3,4,5,6,7,8,9]});
        // js.Browser.console.log({test: "foo", bar: [0,1,2,3,4,5,6,7,8,9]});
        // js.Browser.console.
        // final console = js.Browser.document.getElementById("consoleContainer");
        // trace(console);
        // js.Browser.console.info({test: "foo", bar: [0,1,2,3,4,5,6,7,8,9]});
        // js.Browser.console.warn({test: "foo", bar: [0,1,2,3,4,5,6,7,8,9]});
        // js.Browser.console.error({test: "foo", bar: [0,1,2,3,4,5,6,7,8,9]});
        // js.Browser.console.
        // #elseif hl
        // #elseif cpp
        // sys.io.
        #else
        haxe.Log.trace({test: "foo", bar: [0,1,2,3,4,5,6,7,8,9]});
        #end
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

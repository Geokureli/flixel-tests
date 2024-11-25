package states;

import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.Exception;
import haxe.Json;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.net.SharedObject;

#if generateData
enum Values { A; B; }
#end

class SaveCrashTestState3270 extends flixel.FlxState
{
    inline static var INVALID_DATA = "oy8:someDatafy5:valuewy13:states.Valuesy1:B:0y9:otherDatay6:stringg";
    
    
    var save:FlxSave;
    
    override function create()
    {
        super.create();
        
        #if generateData
        // Used to get `INVALID_DATA`
        final data = { someData:false, value: Values.B, otherData:"string" };
        trace('serializing data${Json.stringify(data)}');
        final serialized = Serializer.run(data);
        trace('serialized data: ${serialized}');
        trace(Serializer.run({ someData:false, otherData:"string" }));
        #else
        runTest();
        #end
    }
    
    function runTest()
    {
        trace('Saving invalid data: "$INVALID_DATA"');
        saveRawData("test-save", INVALID_DATA);
        trace('loading "test-save"');
        save = new FlxSave();
        save.bind("test-save", resolveParsingError);
        switch save.status
        {
            case BOUND(_,_):
                trace('Bind successful: ${Json.stringify(save.data)}');
                trace('Erasing save');
                save.erase();
            case found:
                trace('Bind failed: $found');
        }
    }
    
    function resolveParsingError(rawData:String, e:Exception)
    {
        trace('Parsing failed, data:"$rawData", error:"$e"');
        
        trace("patching data");
        final reg = ~/y5:valuewy13:states.Valuesy.:.+:0/;
        final patchedData = reg.split(rawData).join("");
        
        trace('Resolving patched data: "$patchedData"');
        final unserializer = new Unserializer(patchedData);
        final resolver = { resolveEnum: Type.resolveEnum, resolveClass: FlxSave.resolveFlixelClasses };
        unserializer.setResolver(cast resolver);
        final parsedData = unserializer.unserialize();
        trace('resolving data: ${Json.stringify(parsedData)}');
        return parsedData;
    }
    
    @:access(openfl.net.SharedObject)
    @:access(flixel.util.FlxSave)
    function saveRawData(name:String, encodedData:String)
    {
        final meta = openfl.Lib.current.stage.application.meta;
        var path = meta["company"];
        if (path == null || path == "")
            path = "HaxeFlixel";
        else
            path = FlxSave.validate(path);
        
        final obj = SharedObject.getLocal(name, path);
        
        // put outdated data in save
        // copied from SharedObject.hx flush
        #if (js && html5)
            var storage = js.Browser.getLocalStorage();
            
            if (storage != null)
            {
                storage.removeItem(obj.__localPath + ":" + obj.__name);
                storage.setItem(obj.__localPath + ":" + obj.__name, encodedData);
            }
        #else
            var path = SharedObject.__getPath(obj.__localPath, obj.__name);
            var directory = haxe.io.Path.directory(path);
            
            if (!sys.FileSystem.exists(directory))
            {
                SharedObject.__mkdir(directory);
            }
            
            var output = sys.io.File.write(path, false);
            output.writeString(encodedData);
            output.close();
        #end
    }
}
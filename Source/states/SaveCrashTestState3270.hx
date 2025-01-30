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
class MyType
{
    public var x:Int;
    public function new (x) { this.x = x; }
}
#end

class SaveCrashTestState3270 extends flixel.FlxState
{
    // inline static var INVALID_DATA = "oy8:someDatafy5:valuewy13:states.Valuesy1:B:0y9:otherDatay6:stringg";
    inline static var INVALID_DATA = "oy5:aTypeAy13:states.MyTypey6:anEnumwy13:states.Valuesy1:B:0y6:anInstcR1y1:xi5gy8:someDatafy7:versiony5:5.0.0g";
    
    var save:FlxSave;
    
    override function create()
    {
        super.create();
        
        #if generateData
        // Used to get `INVALID_DATA`
        final data = 
            { someData:false
            , anEnum: Values.B
            , anInst: new MyType(5)
            , aType: MyType
            , version:"5.0.0"
            };
        trace('serializing data${Json.stringify(data)}');
        final serialized = Serializer.run(data);
        trace('serialized data: ${serialized}');
        trace(Serializer.run({ someData:false, otherData:"streeng" }));
        #else
        // runSaveTest();
        runUnserializerTest();
        #end
    }
    
    function runSaveTest()
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
    
    function runUnserializerTest()
    {
        trace('Unserializing invalid data: "$INVALID_DATA"');
        final unserializer = new haxe.Unserializer(INVALID_DATA);
        final resolver = { resolveEnum: Type.resolveEnum, resolveClass: FlxSave.resolveFlixelClasses };
        unserializer.setResolver(cast resolver);
        try
        {
			final data = unserializer.unserialize();
            trace('Parse successful: ${Json.stringify(data)}');
        }
        catch (e)
        {
            trace('Parse unsuccessful, resolving: ${e.message}');
            final data:Dynamic = resolveParsingError(INVALID_DATA, e);
            trace(data.anEnum);
            trace(data.anInst);
            trace(data.aType);
            trace('Resolved to: ${Json.stringify(data)}');
        }
    }
    
    function resolveParsingError(rawData:String, e:Exception):Any
    {
        trace('Parsing failed, data:"$rawData", error:"$e"');
        
        // trace("patching data");
        // final reg = ~/y5:valuewy13:states.Valuesy.:.+:0/;
        final patchedData = rawData;//reg.split(rawData).join("");
        // final patchedData = reg.split(rawData).join("");
        // trace('Resolving patched data: "$patchedData"');
        
        final unserializer = new NoFailUnserializer(patchedData);
        // final unserializer = new Unserializer(patchedData);
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

enum MissingData
{
    CLASS(name:String, fields:Any);
    CLASS_T(name:String);
    ENUM(name:String, tag:MissingEnumTag, args:Array<Any>);
    ENUM_T(name:String);
}

enum MissingEnumTag
{
    INDEX(i:Int);
    NAME(n:String);
}

class NoFailUnserializer extends haxe.Unserializer
{
    static public function parseSave(rawData:String):Any
    {
        final unserializer = new haxe.Unserializer(rawData);
        unserializer.setResolver({resolveEnum: Type.resolveEnum, resolveClass: FlxSave.resolveFlixelClasses});
        return unserializer.unserialize();
    }
    
    override function unserialize():Dynamic
    {
        @:keep final startPos = pos;
        switch get(pos++)
        {
            case "c".code:
                var name = unserialize();
                var cl = resolver.resolveClass(name);
                if (cl == null)
                {
                    final proxy = {};
                    unserializeObject(proxy);
                    final o = MissingData.CLASS(name, proxy);
                    cache.push(o);
                    return o;
                }
                
                var o = Type.createEmptyInstance(cl);
                cache.push(o);
                unserializeObject(o);
                return o;
            case "w".code:
                var name = unserialize();
                var edecl = resolver.resolveEnum(name);
                if (edecl == null)
                {
                    final tag = MissingEnumTag.NAME(unserialize());
                    final e = unserializeNullEnum(name, tag);
                    cache.push(e);
                    return e;
                }
                var e = unserializeEnum(edecl, unserialize());
                cache.push(e);
                return e;
            case "j".code:
                var name = unserialize();
                var edecl = resolver.resolveEnum(name);
                if (edecl == null)
                {
                    pos++; /* skip ':' */
                    final tag = MissingEnumTag.INDEX(readDigits());
                    final e = unserializeNullEnum(name, tag);
                    cache.push(e);
                    return e;
                }
                pos++; /* skip ':' */
                var index = readDigits();
                var tag = Type.getEnumConstructs(edecl)[index];
                if (tag == null)
                    throw "Unknown enum index " + name + "@" + index;
                var e = unserializeEnum(edecl, tag);
                cache.push(e);
                return e;
            case "C".code:
                var name = unserialize();
                var cl = resolver.resolveClass(name);
                if (cl == null)
                {
                    final o = MissingData.CLASS(name, null);
                    cache.push(o);
                    if (get(pos++) != "g".code)
                        throw "Invalid custom data";
                    return null;
                }
                var o:Dynamic = Type.createEmptyInstance(cl);
                cache.push(o);
                o.hxUnserialize(this);
                if (get(pos++) != "g".code)
                    throw "Invalid custom data";
                return o;
            case "A".code:
                var name = unserialize();
                var cl = resolver.resolveClass(name);
                if (cl == null)
                    return MissingData.CLASS_T(name);
                return cl;
            case "B".code:
                var name = unserialize();
                var e = resolver.resolveEnum(name);
                if (e == null)
                    return MissingData.ENUM_T(name);
                return e;
            case unhandled:
                @:keep final char = String.fromCharCode(unhandled);
                pos--;
                return super.unserialize();
        }
    }
    
    override function unserializeEnum<T>(edecl:Enum<T>, tag:String)
    {
        if (edecl == null)
            throw "null enum";
        
        return super.unserializeEnum(edecl, tag);
    }
    
    function unserializeNullEnum<T>(name:String, tag:MissingEnumTag)
    {
        if (get(pos++) != ":".code)
            throw "Invalid enum format";
        
        var nargs = readDigits();
        final args = new Array();
        while (nargs-- > 0)
            args.push(unserialize());
        
        return MissingData.ENUM(name, tag, args);
    }
}

package states;

import flixel.FlxState;
import haxe.ValueException;
import haxe.Unserializer;

/**
 * https://github.com/HaxeFoundation/haxe/issues/11265
 */
class ExceptionTestState11265 extends FlxState
{
    override function  create()
    {
        try
        {
            trace((null:flixel.math.FlxPoint).clone());
        }
        catch (e:ValueException)
        {
            trace("caught ValueException");
        }
        catch (e)
        {
            trace("did not catch");
            trace(Type.getClassName(Type.getClass(e)));
        }
    }
}
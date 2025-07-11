package states;

class FlxSignalDestroyTestState extends flixel.FlxState
{
    final mySignal = new flixel.util.FlxSignal();
    
    override function create()
    {
        super.create();
        
        mySignal.add(dispatchOne);
        mySignal.add(()->trace("2"));
        mySignal.dispatch();
    }
    
    function dispatchOne():Void
    {
        // uncommenting causes crash
        mySignal.destroy();
        trace("1");
    }
}

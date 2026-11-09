package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.debug.FlxDebugger;

class DebuggerLayoutTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        @:privateAccess
        FlxG.watch.addQuick("layout", FlxG.game.debugger._layout);
        
        bgColor = 0xFF808080;
        final GUTTER = FlxDebugger.GUTTER;
        final inside = new FlxSprite(GUTTER, GUTTER);
        inside.makeGraphic(FlxG.width - GUTTER * 2, FlxG.height - GUTTER * 2, 0xFFffffff);
        add(inside);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.SPACE)
        {
            @:privateAccess
            final next = switch (FlxG.game.debugger._layout)
            {
                case STANDARD: RIGHT   ;
                case MICRO   : STANDARD;
                case BIG     : MICRO   ;
                case TOP     : BIG     ;
                case LEFT    : TOP     ; 
                case RIGHT   : LEFT    ; 
            }
            FlxG.debugger.setLayout(next);
            FlxG.watch.addQuick("layout", next);
        }
    }
}

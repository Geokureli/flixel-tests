package states;

import flixel.FlxG;
import flixel.input.FlxAnalogInput;
import flixel.input.FlxInput;
import flixel.ui.FlxAnalog;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import openfl.events.MouseEvent;

class FlxInputTestState extends flixel.FlxState
{
    final button = new Button(50, 50, 'Click Me');
    final analog:FlxAnalogInput<FlxAxes, Int>;
    
    public function new()
    {
        super();
        FlxG.drawFramerate = 4;
        FlxG.updateFramerate = 4;
        
        add(button);
        
        final input = new FlxInput(0);
        
        input.press();
        trace('${input.current} | ${input.last}'); // 1J| R
        input.press();
        trace('${input.current} | ${input.last}'); // P | PJ
        input.update();
        trace('${input.current} | ${input.last}'); // P | P
        input.update();
        trace('${input.current} | ${input.last}'); // P | P
        input.update();
        trace('${input.current} | ${input.last}'); // P | P
        input.release();
        trace('${input.current} | ${input.last}'); // RJ| P
        input.update();
        trace('${input.current} | ${input.last}'); // RJ| RJ
        input.update();
        trace('${input.current} | ${input.last}'); // R | R
        input.press();
        trace('${input.current} | ${input.last}'); // PJ| R
        input.release();
        trace('${input.current} | ${input.last}'); // RJ| PJ
        input.press();
        trace('${input.current} | ${input.last}'); // PJ| RJ
        
        
        analog = new FlxAnalogInput(FlxAxes.X, FlxG.mouse.x);
        analog.move(10);
        trace('${analog.current} | ${analog.last}'); // MJ| S
        analog.move(20);
        trace('${analog.current} | ${analog.last}'); // M | MJ
        analog.update();
        trace('${analog.current} | ${analog.last}'); // M | M
        analog.update();
        trace('${analog.current} | ${analog.last}'); // SJ| M
        analog.update();
        trace('${analog.current} | ${analog.last}'); // SJ| SJ
        analog.move(20);
        trace('${analog.current} | ${analog.last}'); // S | SJ
        analog.update();
        trace('${analog.current} | ${analog.last}'); // S | S
        analog.update();
        trace('${analog.current} | ${analog.last}'); // S | S
        analog.update();
        trace('${analog.current} | ${analog.last}'); // S | S
        analog.move(10);
        trace('${analog.current} | ${analog.last}'); // MJ| S
        analog.move(10);
        trace('${analog.current} | ${analog.last}'); // M | MJ
        analog.move(20);
        trace('${analog.current} | ${analog.last}'); // SJ| M
        
        FlxG.stage.addEventListener(MouseEvent.MOUSE_MOVE, function (e)
        {
            final preCurrent = analog.current;
            final preLast = analog.last;
            final preValue = analog.value;
            final preLastValue = analog.lastValue;
            
            analog.move(Std.int(e.stageX)); 
            if (preCurrent != analog.current || preLast != analog.last)
                trace('move: $preValue:$preCurrent|$preLastValue:$preLast -> ${analog.value}:${analog.current}|${analog.lastValue}:${analog.last}');
        });
    }
    
    @:haxe.warning("-WDeprecated")
    override function update(elapsed)
    {
        super.update(elapsed);
        
        
        final preCurrent = analog.current;
        final preLast = analog.last;
        
        analog.update();
        if (preCurrent != analog.current || preLast != analog.last)
            trace('update: ${preCurrent}|${preLast} -> ${analog.current}|${analog.last}');
        
        // @:privateAccess analog.move(FlxG.mouse._rawX);
        
        if (FlxG.mouse.moved != FlxG.mouse.justMoved)
            trace('Mismatch moved: ${FlxG.mouse.moved} justMoved: ${FlxG.mouse.justMoved}');
    }
}


class Button extends FlxButton
{
    public function new (x = 0, y = 0, text = "", ?onClick)
    {
        super(x, y, text, onClick);
    }
    
    override function update(elapsed:Float)
    {
        final preCurrent = input.current;
        final preLast = input.last;
        
        super.update(elapsed);
        
        if (preCurrent != input.current || preLast != input.last)
            trace('update: ${preCurrent}|${preLast} -> ${input.current}|${input.last}');
    }
    
    override function onDownHandler()
    {
        final preCurrent = input.current;
        final preLast = input.last;
        
        super.onDownHandler();
        
        if (preCurrent != input.current || preLast != input.last)
            trace('down: ${preCurrent}|${preLast} -> ${input.current}|${input.last}');
    }
    
    override function onUpHandler()
    {
        final preCurrent = input.current;
        final preLast = input.last;
        
        super.onUpHandler();
        
        if (preCurrent != input.current || preLast != input.last)
            trace('up: ${preCurrent}|${preLast} -> ${input.current}|${input.last}');
    }
}
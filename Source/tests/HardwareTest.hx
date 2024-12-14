package tests;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.events.*;
import openfl.text.TextField;
import openfl.system.System;

class HardwareTest extends openfl.display.Sprite
{
    var shape:Shape;
    
    public function new ()
    {
        super();
        
        addEventListener(Event.ADDED_TO_STAGE, function addedToStage(?_)
        {
            stage.color = 0x808080;
            
            final text  = new TextField();
            text.text = "Memory: 0";
            text.width = 400;
            addChild(text);
            
            final bitmap = new BitmapData(2048, 2048, true, 0xFFFF0000);
            final shape = new Shape();
            addChild(shape);
            
            var spacePressed = false;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, (e) -> if (e.keyCode == " ".code) spacePressed = true);
            stage.addEventListener(KeyboardEvent.KEY_UP, (e) -> if (e.keyCode == " ".code) spacePressed = false);
            
            stage.addEventListener(Event.ENTER_FRAME, function (_)
            {
                
                final mem = toPrecision(System.totalMemory / 1000 / 1000, 2);
                text.text = 'Memory: ${mem} Mb';
                if (spacePressed)
                {
                    shape.graphics.clear();
                    shape.graphics.beginBitmapFill(bitmap);
                    shape.graphics.drawRect(50, 50, 100, 100);
                    // shape.graphics.drawRect(stage.mouseX, stage.mouseY, 100, 100);
                    shape.graphics.endFill();
                }
            });
        });
    }
    
    function toPrecision(num:Float, dec = 2):String
    {
        final scale = Math.pow(10, dec);
        final str = Std.string(Math.floor(num * scale));
        return str.substr(0, str.length - dec) + "." + str.substr(-dec, dec);
    }
}
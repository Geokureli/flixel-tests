package tests;

import flixel.input.keyboard.FlxKey;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;

class KeyEventTest extends openfl.display.Sprite
{
    public function new ()
    {
        super();
        
        var field = new TextField();
        field.text = "Nothing happening";
        field.textColor = 0xFFffffff;
        field.x = 100;
        field.y = 100;
        addChild(field);
        
        addEventListener(Event.ADDED_TO_STAGE,
            function addedToStage(?_)
            {
                var lastPressed:Int = -1;
                stage.addEventListener(KeyboardEvent.KEY_UP,
                    function (e)
                    {
                        if (e.keyCode == lastPressed)
                            field.text = 'Cmd + ${String.fromCharCode(e.charCode)} released';
                    }
                );
                
                stage.addEventListener(KeyboardEvent.KEY_DOWN,
                    function (e)
                    {
                        if (e.ctrlKey)
                        {
                            lastPressed = e.keyCode;
                            field.text = 'Cmd + ${String.fromCharCode(e.charCode)} pressed';
                            e.preventDefault();
                        }
                    }
                );
            }
        );
    }
}
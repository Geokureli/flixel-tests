package tests;

import openfl.events.Event;

class Bare extends openfl.display.Sprite
{
    public function new ()
    {
        super();
        
        addEventListener(Event.ADDED_TO_STAGE, function addedToStage(?_)
        {
            trace("initted");
            stage.addEventListener(Event.ENTER_FRAME, function (_)
            {
                // trace("update");
            });
        });
    }
}
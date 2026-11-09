package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxBitmapText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FinishTimerTestState extends flixel.FlxState
{
    var timer:FlxTimer;
    var barBg:FlxSprite;
    var barFg:FlxSprite;
    var text:FlxBitmapText;
    var finishBtn:FlxButton;
    var finishAllBtn:FlxButton;
    var startBtn:FlxButton;
    var loopBtn:FlxButton;
    
    override function create()
    {
        super.create();
        FlxG.camera.bgColor = FlxColor.WHITE;

        
        final ui = new FlxSpriteGroup();
        add(ui);
        
        final WIDTH = FlxG.width - 20;
        final BORDER = 4;
        ui.add(barBg = new FlxSprite()).makeGraphic(WIDTH, 30, FlxColor.BLACK);
        ui.add(barFg = new FlxSprite(BORDER, BORDER)).makeGraphic(barBg.frameWidth - BORDER * 2, barBg.frameHeight - BORDER * 2, FlxColor.GRAY);
        barFg.origin.x = 0;
        
        ui.add(text = new FlxBitmapText(barFg.x, "Unstarted"));
        final SCALE = 2;
        text.scale.scale(SCALE);
        text.updateHitbox();
        text.fieldWidth = Std.int(barFg.frameWidth / SCALE);
        text.autoSize = false;
        text.alignment = CENTER;
        text.y = barFg.y + (barFg.height - text.height) / 2;
        
        final btns = new FlxTypedSpriteGroup<FlxButton>();
        ui.add(btns);
        btns.add(startBtn = new FlxButton(0, 0, "Start 10s", ()->timer = FlxTimer.wait(10, onComplete)));
        btns.add(loopBtn = new FlxButton(startBtn.width, 0, "Start 10 Loops", ()->timer = new FlxTimer().start(10, onLoopComplete, 10)));
        btns.add(finishBtn = new FlxButton(loopBtn.x + loopBtn.width, 0, "Finish", ()->timer.complete()));
        btns.add(finishAllBtn = new FlxButton(finishBtn.x + finishBtn.width, 0, "FinishAll", ()->timer.completeLoops()));
        btns.y = barBg.height;
        ui.screenCenter();
        btns.screenCenter(X);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        if (timer != null && timer.finished == false)
        {
            barFg.setGraphicSize(barFg.frameWidth * (timer.elapsedTime / timer.time), barFg.frameHeight);
            final time = StringTools.rpad(Std.string(Std.int((timer.elapsedTime) * 10) / 10), ".0", 2);
            if (timer.loops > 1)
                text.text = '$time / ${timer.time} loops ${timer.elapsedLoops} / ${timer.loops}';
            else
                text.text = '$time / ${timer.time}';
        }
    }
    
    function onComplete()
    {
        FlxG.log.add("complete");
        text.text = "Completed";
        barFg.scale.x = 1.0;
    }
    
    function onLoopComplete(timer:FlxTimer)
    {
        FlxG.log.add('${timer.elapsedLoops}/${timer.loops} loops');
        if (timer.loopsLeft == 0)
            onComplete();
    }
}

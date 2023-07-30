package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;

using flixel.util.FlxSpriteUtil;

class TintTestState extends flixel.FlxState
{
    var ui:TintUI;
    var backdrop:FlxSprite;
    
    override function create()
    {
        super.create();
        
        backdrop = new FlxBackdrop("assets/images/haxe-anim.png");
        backdrop.loadGraphic("assets/images/haxe-anim.png", true);
        backdrop.animation.add("loop", [0, 1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1], 10);
        backdrop.animation.play("loop");
        backdrop.screenCenter();
        add(backdrop);
        
        haxe.ui.Toolkit.init();
        haxe.ui.Toolkit.autoScale = false;
        
        add(ui = new TintUI());
        ui.flash.onClick = (_)->backdrop.flashTint(getTint(), ui.flashDuration.pos);
        
        // final oldOnChange = ui.tintMode.onChange;
        ui.tintMode.onChange = function (_)
        {
            if (ui.tintMode.selectedItem.text == "Flash")
                backdrop.setColorTransform();
            
            // if (oldOnChange != null)
            //     oldOnChange();
        }
    }
    
    function getTint():FlxColor
    {
        var tint = FlxColor.fromString(ui.hex.text).rgb;
        tint.alphaFloat = ui.strength.pos / 100;
        return tint;
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        switch (ui.effect.selectedItem.text)
        {
            case "Tint":
                final tint = getTint();
                // FlxG.watch.addQuick("hex", ui.hex.text);
                // FlxG.watch.addQuick("color", tint.rgb);
                // FlxG.watch.addQuick("stength", tint.alphaFloat);
                switch (ui.tintMode.selectedItem.text)
                {
                    case "Constant":
                        backdrop.setTint(tint);
                    case "Flash":
                }
            case "Brightness":
                final amount = ui.brightness.pos / 100;
                backdrop.setBrightness(amount);
            case "None":
                backdrop.setColorTransform();
        }
        
        
        FlxG.watch.addQuick("redM", backdrop.colorTransform.redMultiplier);
        FlxG.watch.addQuick("greenM", backdrop.colorTransform.greenMultiplier);
        FlxG.watch.addQuick("blueM", backdrop.colorTransform.blueMultiplier);
        
        FlxG.watch.addQuick("redO", backdrop.colorTransform.redOffset);
        FlxG.watch.addQuick("greenO", backdrop.colorTransform.greenOffset);
        FlxG.watch.addQuick("blueO", backdrop.colorTransform.blueOffset);
    }
}

@:build(haxe.ui.ComponentBuilder.build("assets/data/ui/tint_test.xml"))
class TintUI extends haxe.ui.containers.Box
{
    override function onReady()
    {
        super.onReady();
    }
}

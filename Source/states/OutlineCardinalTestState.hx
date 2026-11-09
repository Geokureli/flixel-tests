package states;

import flixel.FlxG;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import tools.SpriteMover;

class OutlineCardinalTestState extends flixel.FlxState
{
    public final text:FlxText;
    public final bText:FlxBitmapText;
    
    public function new()
    {
        bText = new FlxBitmapText(0, 0, message);
        bText.fieldWidth = FlxG.width;
        bText.multiLine = true;
        bText.autoSize = false;
        bText.setBorderStyle(OUTLINE_CARDINAL, FlxColor.BLACK);
        
        text = new FlxText(0, bText.y + bText.height, message);
        text.fieldWidth = FlxG.width;
        text.wordWrap = true;
        text.autoSize = false;
        text.setBorderStyle(OUTLINE_CARDINAL, FlxColor.BLACK);
        
        super();
        
        bgColor = 0xFF808080;
        
        add(new SpriteMover(bText));
        add(new SpriteMover(text));
        add(text);
        add(bText);
        
        FlxTween.tween(camera, { zoom: 0.5 }, 1.0, { ease: FlxEase.cubeInOut, type: PINGPONG });
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

final message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum";
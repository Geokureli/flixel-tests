package states;

import flixel.FlxG;
import flixel.text.FlxText;

class TextFormatTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
        var text1 = new FlxText(0, 0, 0, "Hello World", 16);
        text1.font = "fonts/DTM-Mono.ttf";
        text1.screenCenter();
        text1.y -= text1.height / 2;
        add(text1);
        
        // var text2 = new FlxText(0, 0, 0, "Hello World");
        // text2.letterSpacing = 10;
        // text2.screenCenter();
        // text2.y += text2.height / 2;
        // // text2.text = "Hello, world!";
        // add(text2);
        
        var text3 = new FlxText(0, 0, 0, "Hello World", 16);
        text3.font = "fonts/DTM-Mono.ttf";
        @:privateAccess
        text3._defaultFormat.letterSpacing = 10;
        @:privateAccess
        text3.updateDefaultFormat();
        text3.screenCenter();
        text3.y += text3.height * 1.5;
        text3.text = "Hello, world!";
        add(text3);
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
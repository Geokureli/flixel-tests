package tools;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

@:using(tools.KeyControls.KeyControlTools)
enum KeyControls
{
    WASD;
    ARROWS;
    IJKL;
}

class KeyControlTools
{
    
    static public function left(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyPressed(A) && !keyPressed(D);
            case ARROWS: keyPressed(LEFT) && !keyPressed(RIGHT);
            case IJKL: keyPressed(J) && !keyPressed(L);
        }
    }
    
    static public function right(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyPressed(D) && !keyPressed(A);
            case ARROWS: keyPressed(RIGHT) && !keyPressed(LEFT);
            case IJKL: keyPressed(L) && !keyPressed(J);
        }
    }
    
    static public function up(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyPressed(W) && !keyPressed(S);
            case ARROWS: keyPressed(UP) && !keyPressed(DOWN);
            case IJKL: keyPressed(I) && !keyPressed(K);
        }
    }
    
    static public function down(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyPressed(S) && !keyPressed(W);
            case ARROWS: keyPressed(DOWN) && !keyPressed(UP);
            case IJKL: keyPressed(K) && !keyPressed(I);
        }
    }
    
    static public function leftJust(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyJustPressed(A) && !keyJustPressed(D);
            case ARROWS: keyJustPressed(LEFT) && !keyJustPressed(RIGHT);
            case IJKL: keyJustPressed(J) && !keyJustPressed(L);
        }
    }
    
    static public function rightJust(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyJustPressed(D) && !keyJustPressed(A);
            case ARROWS: keyJustPressed(RIGHT) && !keyJustPressed(LEFT);
            case IJKL: keyJustPressed(L) && !keyJustPressed(J);
        }
    }
    
    static public function upJust(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyJustPressed(W) && !keyJustPressed(S);
            case ARROWS: keyJustPressed(UP) && !keyJustPressed(DOWN);
            case IJKL: keyJustPressed(I) && !keyJustPressed(K);
        }
    }
    
    static public function downJust(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: false;
            case WASD: keyJustPressed(S) && !keyJustPressed(W);
            case ARROWS: keyJustPressed(DOWN) && !keyJustPressed(UP);
            case IJKL: keyJustPressed(K) && !keyJustPressed(I);
        }
    }
    
    inline static public function x(keys:Null<KeyControls>)
    {
        return pressedX(keys);
    }
    
    inline static public function y(keys:Null<KeyControls>)
    {
        return pressedY(keys);
    }
    
    inline static public function xJust(keys:Null<KeyControls>)
    {
        return justPressedX(keys);
    }
    
    inline static public function yJust(keys:Null<KeyControls>)
    {
        return justPressedY(keys);
    }
    
    static public function pressedX(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: 0;
            case WASD: dirPressed(A, D);
            case ARROWS: dirPressed(LEFT, RIGHT);
            case IJKL: dirPressed(J, L);
        }
    }

    static public function pressedY(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: 0;
            case WASD: dirPressed(S, W);
            case ARROWS: dirPressed(UP, DOWN);
            case IJKL: dirPressed(I, K);
        }
    }
    
    static public function justPressedX(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: 0;
            case WASD: dirJustPressed(A, D);
            case ARROWS: dirJustPressed(LEFT, RIGHT);
            case IJKL: dirJustPressed(J, L);
        }
    }

    static public function justPressedY(keys:Null<KeyControls>)
    {
        return switch (keys)
        {
            case null: 0;
            case WASD: dirJustPressed(S, W);
            case ARROWS: dirJustPressed(UP, DOWN);
            case IJKL: dirJustPressed(I, K);
        }
    }
    
    inline static function keyPressed(k) return FlxG.keys.checkStatus(k, PRESSED);
    inline static function keyJustPressed(k) return FlxG.keys.checkStatus(k, JUST_PRESSED);
    
    inline static function dirPressed (dec:FlxKey, inc:FlxKey)
    {
        return (keyPressed(inc) ? 0 : 1) - (keyPressed(dec) ? 0 : 1);
    }
    
    inline static function dirJustPressed (dec:FlxKey, inc:FlxKey)
    {
        return (keyJustPressed(inc) ? 0 : 1) - (keyJustPressed(dec) ? 0 : 1);
    }
}

enum KeyModes
{
    NONE;
    SHIFT;
    ALT;
}
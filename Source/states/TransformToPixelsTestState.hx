package states;

import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxFrame;
import tools.SpriteMover;
import sprites.RectSprite;
import sprites.AnimSprite;

class TransformToPixelsTestState extends flixel.FlxState
{
    final start = FlxPoint.get();
    final rect = FlxRect.get();
    var rectSprite:RectSprite;
    var hidden:Sprite;
    var source:Sprite;
    var color:FlxSprite;
    var mover:SpriteMover;
    
    override function create()
    {
        super.create();
        
        FlxG.camera.bgColor = 0xFF808080;
        
        add(rectSprite = new RectSprite());
        add(hidden = new Sprite());
        add(source = new Sprite());
        source.screenCenter();
        source.clipRect = new FlxRect(0, 0, source.frameWidth, source.frameHeight);
        hidden.x = source.x;
        hidden.y = source.y;
        hidden.alpha = 0.5;
        
        add(color = new FlxSprite().makeGraphic(20, 20, 0xFF000000));
        color.graphic.bitmap.fillRect(new openfl.geom.Rectangle(1, 1, 18, 18), 0xFFffffff);
        rect.set(source.x, source.y, source.width, source.height);
        rectSprite.orient(rect.x, rect.y, rect.width, rect.height);
        
        add(mover = new SpriteMover(source));
        
        FlxG.watch.addFunction("rect", ()->rect);
        FlxG.watch.addFunction("clipRect", ()->source.clipRect);
        final viewPos = FlxPoint.get();
        FlxG.watch.addFunction("viewPos", ()->camera.worldToViewPosition(source.x, source.y, 0, 0, viewPos));
    }
    
    static final mouse = FlxPoint.get();
    static final viewMouse = FlxPoint.get();
    static final viewToWorld = FlxPoint.get();
    override function update(elapsed)
    {
        super.update(elapsed);
        hidden.x = source.x;
        hidden.y = source.y;
        hidden.angle = source.angle;
        hidden.flipX = source.flipX;
        hidden.flipY = source.flipY;
        hidden.scale.copyFrom(source.scale);
        hidden.offset.copyFrom(source.offset);
        hidden.origin.copyFrom(source.origin);
        
        final cam = FlxG.camera;
        FlxG.mouse.getWorldPosition(cam, mouse);
        FlxG.mouse.getViewPosition(cam, viewMouse);
        FlxG.camera.viewToWorldPosition(viewMouse, null, viewToWorld);
        FlxG.watch.addQuick('view == world', '$viewToWorld == $mouse');
        
        if (color != null)
        {
            final pixelColor = source.getPixelAt(mouse, cam);
            color.color = pixelColor != null ? pixelColor.rgb : 0xFF000000;
            color.alpha = pixelColor != null ? pixelColor.alphaFloat : 0;
            color.x = mouse.x;
            color.y = mouse.y;
        }
        
        if (FlxG.mouse.justPressed)
        {
            start.x = viewMouse.x;
            start.y = viewMouse.y;
            rectSprite.orient(0, 0);
        }
        
        if (FlxG.mouse.pressed)
            rect.setBoundsAbs(start.x, start.y, viewMouse.x, viewMouse.y);
        
        final worldX = camera.viewToWorldX(rect.x);
        final worldY = camera.viewToWorldY(rect.y);
        final worldRight = camera.viewToWorldX(rect.right);
        final worldBottom = camera.viewToWorldY(rect.bottom);
        rectSprite.orient(worldX, worldY, worldRight - worldX, worldBottom - worldY);
        
        source.clipToViewRect(rect);
    }
}

class Sprite extends sprites.AnimSprite
{
    public function new (x = 0.0, y = 0.0)
    {
        super(x, y, 8);
        
        function flipToString(flipX:Bool, flipY:Bool)
        {
            return switch[flipX,flipY]
            {
                case [true, true]: "XY";
                case [true, false]: "X";
                case [false, true]: "Y";
                case [false, false]: "NONE";
            }
        }
        FlxG.watch.addFunction("flip", ()->flipToString(flipX, flipY));
        FlxG.watch.addFunction("anim.flip", ()->flipToString(animation.curAnim.flipX, animation.curAnim.flipY));
        FlxG.watch.addFunction("frames.flip", ()->flipToString(frame.flipX, frame.flipY));
        FlxG.watch.addFunction("frames.angle", ()->frame.angle);
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.SPACE)
            playAnim(curAnim == LOOP ? FLIP(X) : LOOP);
        
        final L = FlxG.keys.justPressed.L;
        final J = FlxG.keys.justPressed.J;
        final K = FlxG.keys.justPressed.K;
        final I = FlxG.keys.justPressed.I;
        
        function forEachFrames(func:(FlxFrame)->Void)
        {
            for (frame in this.frames.frames)
                func(frame);
        }
        
        if (FlxG.keys.pressed.SHIFT)
        {
            if (L) forEachFrames((f)->f.flipX = true);
            if (J) forEachFrames((f)->f.flipX = false);
            if (K) forEachFrames((f)->f.flipY = true);
            if (I) forEachFrames((f)->f.flipY = false);
        }
        else if (FlxG.keys.pressed.ALT)
        {
            if (I) forEachFrames((f)->f.angle = ANGLE_0);
            if (L) forEachFrames((f)->f.angle = ANGLE_90);
            if (K) forEachFrames((f)->f.angle = ANGLE_NEG_90);
            if (J) forEachFrames((f)->f.angle = ANGLE_270);
        }
    }
}
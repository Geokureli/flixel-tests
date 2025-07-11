package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import sprites.AnimSprite;
import sprites.RectSprite;
import tools.SpriteMover;

class TransformToPixelsTestState extends flixel.FlxState
{
    final start = FlxPoint.get();
    final rect = FlxRect.get();
    var rectSprite:RectSprite;
    var hidden:Sprite;
    var source:Sprite;
    var color:FlxSprite;
    var mover:SpriteMover;
    
    @:haxe.warning("-WDeprecated")
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
        source.alpha = 0.5;
        source.color = 0xFFff8800;
        hidden.alpha = source.alpha * 0.5;
        hidden.color = source.color;
        // source.setColorTransform(0.0, 0.5, 0.25, 1.0, 0x0, 0x40, 0x80);
        // hidden.setColorTransform(0.0, 0.5, 0.25, 1.0, 0x0, 0x40, 0x80);
        
        add(color = new FlxSprite().makeGraphic(20, 20, 0xFF000000));
        color.graphic.bitmap.fillRect(new openfl.geom.Rectangle(1, 1, 18, 18), 0xFFffffff);
        rect.set(source.x, source.y, source.width, source.height);
        rectSprite.orient(rect.x, rect.y, rect.width, rect.height);
        
        add(mover = new SpriteMover(source));
        
        // FlxG.watch.addFunction("rect", ()->rect);
        FlxG.watch.addFunction("clipRect", ()->source.clipRect);
        final p = FlxPoint.get();
        final r = FlxRect.get();
        // FlxG.watch.addFunction("source.p", ()->camera.worldToViewPosition(source.x, source.y, 0, 0, p));
        FlxG.watch.addFunction("cam.scroll", ()->camera.scroll);
        FlxG.watch.addFunction('cam.view', ()->r.set(camera.viewX, camera.viewY, camera.viewWidth, camera.viewHeight));
        FlxG.watch.addFunction('mGame', ()->FlxG.mouse.getGamePosition(p));
        FlxG.watch.addFunction('mWorld', ()->FlxG.mouse.getWorldPosition(camera, p));
        FlxG.watch.addFunction('mScreen', ()->FlxG.mouse.getScreenPosition(camera, p));
        FlxG.watch.addFunction('mView', ()->FlxG.mouse.getViewPosition(camera, p));
    }
    
    static final mouse = FlxPoint.get();
    static final viewMouse = FlxPoint.get();
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
        cam.worldToViewPosition(mouse.x, mouse.y, 1, 1, viewMouse);
        FlxG.watch.addQuick("toView(mouse)", viewMouse);
        final p = FlxPoint.get();
        FlxG.watch.addQuick("toWorld(viewMouse)", cam.viewToWorldPosition(viewMouse, 1, 1, p));
        p.put();
        
        if (color != null)
        {
            final pixelColor = source.getPixelAt(mouse, cam);
            color.color = pixelColor != null ? pixelColor.rgb : 0xFF000000;
            color.alpha = pixelColor != null ? pixelColor.alphaFloat : 0;
            color.x = mouse.x;
            color.y = mouse.y;
            FlxG.watch.addQuick("color", pixelColor.toHexString());
        }
        
        if (FlxG.mouse.justPressed)
        {
            // start.x = viewMouse.x;
            // start.y = viewMouse.y;
            start.x = mouse.x;
            start.y = mouse.y;
        }
        
        if (FlxG.mouse.pressed)
            // rect.setBoundsAbs(start.x, start.y, viewMouse.x, viewMouse.y);
            rect.setBoundsAbs(start.x, start.y, mouse.x, mouse.y);
        
        // final toX = camera.viewToWorldX;
        // final toY = camera.viewToWorldY;
        // rectSprite.orientBounds(toX(rect.x), toY(rect.y), toX(rect.right), toY(rect.bottom));
        // source.clipToViewRect(rect);
        
        rectSprite.orientBounds(rect.x, rect.y, rect.right, rect.bottom);
        // source.clipToWorldRectSimple(rect);
        source.clipToWorldRect(rect);
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
        // FlxG.watch.addFunction("flip", ()->flipToString(flipX, flipY));
        // FlxG.watch.addFunction("anim.flip", ()->flipToString(animation.curAnim.flipX, animation.curAnim.flipY));
        // FlxG.watch.addFunction("frames.flip", ()->flipToString(frame.flipX, frame.flipY));
        // FlxG.watch.addFunction("frames.angle", ()->frame.angle);
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
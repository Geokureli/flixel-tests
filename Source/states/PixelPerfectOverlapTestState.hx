package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxBitmapDataPool;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import sprites.LineSprite;

class PixelPerfectOverlapTestState extends flixel.FlxState
{
    var beam:LineSprite;
    var target:FlxSprite;
    var overlapSprite:FlxSprite;
    var mouseColor1:FlxSprite;
    var mouseColor2:FlxSprite;
    var info:FlxText;
    
    var useOld = true;
    
    override function create()
    {
        super.create();
        FlxG.camera.bgColor = 0xFF4B96ff;
        
        target = new FlxSprite();
        target.loadGraphic("assets/images/anim-sprite.png", true);
        target.screenCenter();
        add(target);
        
        beam = new LineSprite(0, 0, 5, false);
        beam.screenCenter();
        add(beam);
        
        overlapSprite = new FlxSprite();
        overlapSprite.exists = false;
        add(overlapSprite);
        
        mouseColor1 = new FlxSprite().makeGraphic(25, 25);
        mouseColor1.x = FlxG.width - mouseColor1.width;
        mouseColor1.exists = false;
        add(mouseColor1);
        
        mouseColor2 = new FlxSprite().makeGraphic(25, 25);
        mouseColor2.x = mouseColor1.x - mouseColor2.width;
        mouseColor2.exists = false;
        add(mouseColor2);
        
        info = new FlxText("Old");
        info.y = FlxG.height - info.height;
        add(info);
        
        FlxG.watch.addFunction('mouse.col[1]', ()->mouseColor1.exists ? mouseColor1.color.toHexString() : "null");
        FlxG.watch.addFunction('mouse.col[2]', ()->mouseColor2.exists ? mouseColor2.color.toHexString() : "null");
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
        
        mouseColor1.exists = false;
        mouseColor2.exists = false;
        if (FlxG.keys.released.SPACE)
        {
            if (FlxG.mouse.pressed)
            {
                beam.x = FlxG.mouse.x;
                beam.y = FlxG.mouse.y;
            }
            else
            {
                beam.end.x = FlxG.mouse.x;
                beam.end.y = FlxG.mouse.y;
            }
        }
        else
        {
            final color = beam.getPixelAtScreen(FlxG.mouse.getViewPosition(FlxPoint.weak()));
            if (color != null)
            {
                mouseColor1.exists = true;
                mouseColor1.color = color.rgb;
                mouseColor1.alpha = color.alphaFloat;
            }
            
            final color = target.getPixelAtScreen(FlxG.mouse.getViewPosition(FlxPoint.weak()));
            if (color != null)
            {
                mouseColor2.exists = true;
                mouseColor2.color = color.rgb;
                mouseColor2.alpha = color.alphaFloat;
            }
        }
        
        if (FlxG.keys.justPressed.ENTER)
        {
            useOld = !useOld;
            info.text = useOld ? "Old" : "New";
        }
        
        // final hitOld = FlxCollision.pixelPerfectCheck(target, beam);
        // final hitNew = pixelPerfectCheckOld(target, beam);
        final num = 100;
        if(useOld)
        {
            for (i in 0...num)
                FlxCollision.pixelPerfectCheck(target, beam);
        }
        else
        {
            for (i in 0...num)
                pixelPerfectCheckNew(target, beam);
        }
        final hitNew = pixelPerfectCheckNew(target, beam);
        beam.color = hitNew ? 0xFFff0000 : 0xFFffffff;
        overlapSprite.exists = false;
        // if (hitOld)
        // {
            final pos = FlxPoint.get();
            final debugBitmap = FlxCollision.drawPixelPerfectCheck(target, beam, 1, null, pos);
            if (debugBitmap != null && debugBitmap.width * debugBitmap.height > 0)
            {
                overlapSprite.exists = true;
                overlapSprite.loadGraphic(debugBitmap);
                overlapSprite.x = pos.x - target.x;
                overlapSprite.y = pos.y - target.y;
            }
            pos.put();
        // }
    }
    
    public function pixelPerfectCheckOld(contact:FlxSprite, target:FlxSprite, alphaTolerance:Int = 1, ?camera:FlxCamera):Bool
    {
        // if either of the angles are non-zero, consider the angles of the sprites in the pixel check
        final advanced = contact.angle != 0 || target.angle != 0
            || contact.scale.x != 1 || contact.scale.y != 1
            || target.scale.x != 1 || target.scale.y != 1;
        
        final boundsA = contact.getScreenBounds(camera);
        final boundsB = target.getScreenBounds(camera);
        final intersect = boundsA.intersection(boundsB);
        boundsA.put();
        boundsB.put();
        
        if (intersect.isEmpty || intersect.width < 1 || intersect.height < 1)
        {
            intersect.put();
            
            return false;
        }
        
        contact.drawFrame();
        target.drawFrame();
        
        var bmpA = contact.framePixels;
        var bmpB = target.framePixels;
        
        final overlapWidth = Std.int(intersect.width);
        final overlapHeight = Std.int(intersect.height);
        
        // More complicated case, if either of the sprites is rotated
        if (advanced)
        {
            final testMatrix = new FlxMatrix();
            
            contact.prepareDrawMatrix(testMatrix, camera);
            testMatrix.translate(-intersect.x, -intersect.y);
            final testA2 = FlxBitmapDataPool.get(overlapWidth, overlapHeight, true, 0x0, true);
            testA2.draw(bmpA, testMatrix, null, null, null, false);
            bmpA = testA2;
            
            target.prepareDrawMatrix(testMatrix, camera);
            testMatrix.translate(-intersect.x, -intersect.y);
            final testB2 = FlxBitmapDataPool.get(overlapWidth, overlapHeight, true, 0x0, true);
            testB2.draw(bmpB, testMatrix, null, null, null, false);
            bmpB = testB2;
        }
        intersect.put();
        
        final flashRect = new Rectangle(0, 0, overlapWidth, overlapHeight);
        final pixelsA = bmpA.getPixels(flashRect);
        final pixelsB = bmpB.getPixels(flashRect);
        
        if (advanced)
        {
            FlxBitmapDataPool.put(bmpA);
            FlxBitmapDataPool.put(bmpB);
        }
        
        // check every pixel's alpha against the tolerance
        final pixels = overlapWidth * overlapHeight;
        // check every 4 pixels first, then the ones in between
        final numPasses = 4;
        final bytesPer = 4;
        for (pass in 0...numPasses)
        {
            final passLength = Math.ceil((pixels - pass) / numPasses);
			for (i in 0...passLength)
            {
                final alphaIdx = (i * bytesPer * numPasses) + pass * bytesPer;
                pixelsA.position = pixelsB.position = alphaIdx;
                final alphaA = pixelsA.readUnsignedByte();
                final alphaB = pixelsB.readUnsignedByte();
                
                if (alphaA >= alphaTolerance && alphaB >= alphaTolerance)
                    return true;
            }
        }
        
        return false;
    }
    
    public function pixelPerfectCheckDisplay(contact:FlxSprite, target:FlxSprite, alphaTolerance = 1, ?camera:FlxCamera):Null<BitmapData>
    {
        // if either of the angles are non-zero, consider the angles of the sprites in the pixel check
        final advanced = contact.angle != 0 || target.angle != 0
            || contact.scale.x != 1 || contact.scale.y != 1
            || target.scale.x != 1 || target.scale.y != 1;
        
        final boundsA = contact.getScreenBounds(camera);
        final boundsB = target.getScreenBounds(camera);
        final intersect = boundsA.intersection(boundsB);
        boundsA.put();
        boundsB.put();
        
        if (intersect.isEmpty || intersect.width < 1 || intersect.height < 1)
        {
            intersect.put();
            
            return null;
        }
        
        contact.drawFrame();
        target.drawFrame();
        
        var bmpA = contact.framePixels;
        var bmpB = target.framePixels;
        
        final overlapWidth = Std.int(intersect.width);
        final overlapHeight = Std.int(intersect.height);
        
        // More complicated case, if either of the sprites is rotated
        if (advanced)
        {
            final testMatrix = new FlxMatrix();
            
            contact.prepareDrawMatrix(testMatrix, camera);
            testMatrix.translate(-intersect.x, -intersect.y);
            final testA2 = FlxBitmapDataPool.get(overlapWidth, overlapHeight, true, 0x0, true);
            testA2.draw(bmpA, testMatrix, null, null, null, false);
            bmpA = testA2;
            
            target.prepareDrawMatrix(testMatrix, camera);
            testMatrix.translate(-intersect.x, -intersect.y);
            final testB2 = FlxBitmapDataPool.get(overlapWidth, overlapHeight, true, 0x0, true);
            testB2.draw(bmpB, testMatrix, null, null, null, false);
            bmpB = testB2;
        }
        intersect.put();
        
        final result = new BitmapData(overlapWidth, overlapHeight, false, 0x0);
        final flashRect = new Rectangle(0, 0, overlapWidth, overlapHeight);
        final point = new Point();
        final temp = FlxBitmapDataPool.get(overlapWidth, overlapHeight, true, 0x0, true);
        temp.threshold(bmpA, flashRect, point, ">", alphaTolerance << 24, 0xFFff0000, 0xFF000000);
        result.copyChannel(temp, flashRect, point, RED, RED);
        temp.threshold(bmpB, flashRect, point, ">", alphaTolerance << 24, 0xFF0000ff, 0xFF000000);
        result.copyChannel(bmpB, flashRect, point, BLUE, BLUE);
        result.threshold(result, flashRect, point, "==", 0xFFff00ff, 0xFFffffff, 0xFFff00ff);
        FlxBitmapDataPool.put(temp);
        
        if (advanced)
        {
            FlxBitmapDataPool.put(bmpA);
            FlxBitmapDataPool.put(bmpB);
        }
        
        return result;
    }
    
    public function pixelPerfectCheckNew(contact:FlxSprite, target:FlxSprite, alphaTolerance:Int = 1, ?camera:FlxCamera):Bool
    {
        // if either of the angles are non-zero, consider the angles of the sprites in the pixel check
        final advanced = contact.angle != 0 || target.angle != 0
            || contact.scale.x != 1 || contact.scale.y != 1
            || target.scale.x != 1 || target.scale.y != 1;
        
        final boundsA = contact.getScreenBounds(camera);
        final boundsB = target.getScreenBounds(camera);
        final intersect = boundsA.intersection(boundsB);
        boundsA.put();
        boundsB.put();
        
        if (intersect.isEmpty || intersect.width < 1 || intersect.height < 1)
        {
            intersect.put();
            
            return false;
        }
        
        final l = Math.floor(intersect.left);
        final r = Math.ceil(intersect.right);
        final t = Math.floor(intersect.top);
        final b = Math.ceil(intersect.bottom);
        final w = r - l;
        final h = b - t;
        intersect.put();
        
        final pxCacheA = new Map<Int, FlxColor>();
        final pxCacheB = new Map<Int, FlxColor>();
        final p = FlxPoint.get();
        return forInterlaced(w * h, 4, function (i)
        {
            p.x = l + i % w;
            p.y = t + Math.floor(i / w);
            
            final pxA = contact.getPixelAtScreen(p, camera);
            if (pxA == null || pxA.alpha < alphaTolerance)
                return false;
            
            final pxB = target.getPixelAtScreen(p, camera);
            return !(pxB == null && pxB.alpha < alphaTolerance);
        });
    }
    
    function forInterlaced(total:Int, passes:Int, func:(Int)->Bool)
    {
        for (pass in 0...passes)
        {
            final passLength = Math.ceil((total - pass) / passes);
			for (i in 0...passLength)
            {
                if (func((i * passes) + pass))
                    return true;
            }
        }
        return false;
    }
}

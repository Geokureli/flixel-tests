package states;

import flixel.math.FlxAngle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxMatrix;
import flixel.text.FlxText;

class SpriteMatrixTestState extends flixel.FlxState
{
    final sprite = new MatrixSprite("assets/images/haxe.png");
    final skewedSprite = new flixel.addons.effects.FlxSkewedSprite("assets/images/haxe.png");
    var scaleX = 1.0;
    var scaleY = 1.0;
    var skewX = 0.0;
    var skewY = 0.0;
    var tX = 0.0;
    var tY = 0.0;
    
    public function new()
    {
        super();
        
        sprite.screenCenter();
        sprite.x -= sprite.width;
        add(sprite);
        
        skewedSprite.screenCenter();
        skewedSprite.x += sprite.width;
        add(skewedSprite);
        
        final text = new FlxText("MatrixSprite", 16);
        text.x = sprite.x;
        text.y = sprite.y + sprite.height * 1.5;
        add(text);
        
        final text = new FlxText("FlxSkewedSprite", 16);
        text.x = skewedSprite.x;
        text.y = skewedSprite.y + skewedSprite.height * 1.5;
        add(text);
        
        FlxG.watch.addFunction("scale", ()->'( x: $scaleX | y: $scaleY )');
        FlxG.watch.addFunction("scew", ()->'( x: $skewX | y: $skewY )');
        FlxG.watch.addFunction("t", ()->'( x: $tX | y: $tY )');
        
        FlxG.log.notice
            ( "ARROWS: Translate\n"
            + "ARROWS + SHIFT: Scale\n"
            + "ARROWS + ALT: Skew"
            );
        FlxG.debugger.visible = true;
    }
    
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        final L = FlxG.keys.pressed.LEFT;
        final R = FlxG.keys.pressed.RIGHT;
        final U = FlxG.keys.pressed.UP;
        final D = FlxG.keys.pressed.DOWN;
        
        if (FlxG.keys.pressed.SHIFT)
        {
            if (L) scaleX -= 0.01;
            if (R) scaleX += 0.01;
            if (U) scaleY += 0.01;
            if (D) scaleY -= 0.01;
        }
        else if (FlxG.keys.pressed.ALT)
        {
            if (L) skewX -= 0.01;
            if (R) skewX += 0.01;
            if (U) skewY -= 0.01;
            if (D) skewY += 0.01;
        }
        else
        {
            if (L) tX -= 1;
            if (R) tX += 1;
            if (U) tY -= 1;
            if (D) tY += 1;
        }
        
        sprite.transform.identity();
        sprite.transform.skewRadians(skewX * Math.PI / 2, skewY * Math.PI / 2);
        sprite.transform.scale(scaleX, scaleY);
        sprite.transform.translate(tX, tY);
        
        skewedSprite.skew.set(skewX * 90, skewY * 90);
    }
}

class SkewMatrix extends FlxMatrix
{
	public inline function isIdentity()
	{
		return equals(openfl.geom.Matrix.__identity);
	}
	
	public function skewRadians(skewX:Float, skewY:Float)
	{
		b = Math.tan(skewY);
		c = Math.tan(skewX);
	}
	
	public inline function skewDegrees(skewX:Float, skewY:Float)
	{
		skewRadians(skewY * FlxAngle.TO_RAD, skewX * FlxAngle.TO_RAD);
	}
}

class MatrixSprite extends flixel.FlxSprite
{
    public var transform:SkewMatrix = new SkewMatrix();
    
    override function isSimpleRenderBlit(?camera:FlxCamera):Bool
    {
        return transform.isIdentity() || super.isSimpleRenderBlit(camera);
    }
    
    override function drawComplex(camera:FlxCamera)
    {
        _frame.prepareMatrix(_matrix, ANGLE_0, checkFlipX(), checkFlipY());
        _matrix.translate(-origin.x, -origin.y);
        _matrix.scale(scale.x, scale.y);
        
        if (bakedRotationAngle <= 0)
        {
            updateTrig();
        
            if (angle != 0)
                _matrix.rotateWithTrig(_cosAngle, _sinAngle);
        }
        
        _matrix.concat(transform);
        getScreenPosition(_point, camera).subtractPoint(offset);
        _point.add(origin.x, origin.y);
        _matrix.translate(_point.x, _point.y);
        
        if (isPixelPerfectRender(camera))
        {
            _matrix.tx = Math.floor(_matrix.tx);
            _matrix.ty = Math.floor(_matrix.ty);
        }
        
        camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing, shader);
    }
}
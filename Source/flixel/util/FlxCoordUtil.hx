package flixel.util;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxPoint;

/**
 * A `FlxPoint` representing a position in the world, functionally identical to `FlxPoint`
 * but with helpers to convert to `FlxCameraPoint` and `FlxWindowPoint`
 */
@:forward
@:forwardStatics
abstract FlxWorldPoint(FlxPoint) from FlxPoint to FlxPoint
{
	public static inline function get(x = 0.0, y = 0.0):FlxWorldPoint
	{
		return FlxPoint.get(x, y);
	}
	
	inline public function new(x = 0.0, y = 0.0)
	{
		this = FlxPoint.get(x, y);
	}
	
	inline public function toCamera(?camera:FlxCamera, ?result:FlxCameraPoint)
	{
		return FlxCoordUtil.worldToCamera(this, camera, result);
	}
	
	inline public function toWindow(?camera:FlxCamera, ?result:FlxWindowPoint)
	{
		return FlxCoordUtil.worldToWindow(this, camera, result);
	}
	
	@:op(A + B) static function plus(a:FlxWorldPoint, b:FlxWorldPoint):Bool;
}

/**
 * A `FlxPoint` representing a position in a camera's view, does not have a reference to the
 * specific camera. Functionally identical to `FlxPoint` but with helpers to convert to 
 * `FlxWorldPoint` and `FlxWindowPoint`
 */
@:forward
@:forwardStatics
abstract FlxCameraPoint(FlxPoint) from FlxPoint to FlxPoint
{
	public static inline function get(x = 0.0, y = 0.0):FlxCameraPoint
	{
		return FlxPoint.get(x, y);
	}
	
	inline public function new(x = 0.0, y = 0.0)
	{
		this = FlxPoint.get(x, y);
	}
	
	inline public function toWorld(?camera:FlxCamera, ?result:FlxWorldPoint)
	{
		return FlxCoordUtil.cameraToWorld(this, camera, result);
	}
	
	inline public function toCamera(fromCam:FlxCamera, toCam:FlxCamera, ?result:FlxCameraPoint)
	{
		return FlxCoordUtil.cameraToCamera(this, fromCam, toCam, result);
	}
	
	inline public function toWindow(?camera:FlxCamera, ?result:FlxWindowPoint)
	{
		return FlxCoordUtil.cameraToWindow(this, camera, result);
	}
	
	@:op(A + B) static function plus(a:FlxCameraPoint, b:FlxCameraPoint):Bool;
}

/**
 * A `FlxPoint` representing a position in the game's screen, functionally identical to `FlxPoint`
 * but with helpers to convert to `FlxCameraPoint` and `FlxWorldPoint`
 */
@:forward
@:forwardStatics
abstract FlxWindowPoint(FlxPoint) from FlxPoint to FlxPoint
{
	public static inline function get(x = 0.0, y = 0.0):FlxWindowPoint
	{
		return FlxPoint.get(x, y);
	}
	
	inline public function new(x = 0.0, y = 0.0)
	{
		this = FlxPoint.get(x, y);
	}
	
	inline public function toWorld(?camera:FlxCamera, ?result:FlxWorldPoint)
	{
		return FlxCoordUtil.windowToWorld(this, camera, result);
	}
	
	inline public function toCamera(?camera:FlxCamera, ?result:FlxCameraPoint)
	{
		return FlxCoordUtil.windowToCamera(this, camera, result);
	}
	
	@:op(A + B) static function plus(a:FlxWindowPoint, b:FlxWindowPoint):Bool;
}



// TODO: rename?
/**
 * Helper to Convert between coordinate spaces
**/
class FlxCoordUtil
{
	// --- --- --- WINDOW-TO-WORLD --- --- --- //
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * Note: This changes the point passed in
	 * @param windowPos  The position in the game's window.
	 * @param camera     The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function convertWindowToWorld(windowPos:FlxWindowPoint, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return windowPos.set(windowToWorldXUnsafe(windowPos.x, camera), windowToWorldYUnsafe(windowPos.y, camera));
	}
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in the world space,
	 * via the supplied camera.
	 * @param windowPos  The position in the game's window.
	 * @param camera     The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	 * @param result     Optional point used for the returned result. If null, one is created.
	**/
	static public function windowToWorld(windowPos:FlxWindowPoint, ?camera:FlxCamera, ?result:FlxWorldPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(windowToWorldXUnsafe(windowPos.x, camera), windowToWorldYUnsafe(windowPos.y, camera));
	}
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * @param windowX  The position in the game's window.
	 * @param windowY  The position in the game's window.
	 * @param camera   The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function windowToWorldXY(windowX:Float, windowY:Float, ?camera:FlxCamera, ?result:FlxWorldPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(windowToWorldXUnsafe(windowX, camera), windowToWorldYUnsafe(windowY, camera));
	}
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * @param windowX  The position in the game's window.
	 * @param camera   The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function windowToWorldX(windowX:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return windowToWorldXUnsafe(windowX, camera);
	}
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * @param windowY  The position in the game's window.
	 * @param camera   The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function windowToWorldY(windowY:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return windowToWorldYUnsafe(windowY, camera);
	}
	
	inline static function windowToWorldXUnsafe(windowX:Float, camera:FlxCamera)
	{
		return cameraToWorldXUnsafe(windowToCameraXUnsafe(windowX, camera), camera);
	}
	
	inline static function windowToWorldYUnsafe(windowY:Float, camera:FlxCamera)
	{
		return cameraToWorldYUnsafe(windowToCameraYUnsafe(windowY, camera), camera);
	}
	
	// --- --- --- CAMERA-TO-WORLD --- --- --- //
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * @param cameraPos  The position in the camera's space.
	 * @param camera     The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	 * @param result     Optional point used for the returned result. If null, one is created.
	**/
	static public function cameraToWorld(cameraPos:FlxCameraPoint, ?camera:FlxCamera, ?result:FlxWorldPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(cameraToWorldXUnsafe(cameraPos.x, camera), cameraToWorldYUnsafe(cameraPos.y, camera));
	}
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * @param cameraX  The position in the camera's space.
	 * @param cameraY  The position in the camera's space.
	 * @param camera   The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function cameraToWorldXY(cameraX:Float, cameraY:Float, ?camera:FlxCamera, ?result:FlxWorldPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(cameraToWorldXUnsafe(cameraX, camera), cameraToWorldYUnsafe(cameraY, camera));
	}
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * @param cameraX  The position in the camera's space.
	 * @param camera   The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function cameraToWorldX(cameraX:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return cameraToWorldXUnsafe(cameraX, camera);
	}
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * @param cameraY  The position in the camera's space.
	 * @param camera   The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function cameraToWorldY(cameraY:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return cameraToWorldYUnsafe(cameraY, camera);
	}
	
	inline static function cameraToWorldXUnsafe(cameraX:Float, camera:FlxCamera)
	{
		// return cameraX / camera.zoom + camera.viewX;
		@:privateAccess
		return cameraX / camera.zoom + camera.scroll.x + camera.viewMarginX;
	}
	
	inline static function cameraToWorldYUnsafe(cameraY:Float, camera:FlxCamera)
	{
		// return cameraY / camera.zoom + camera.viewY;
		@:privateAccess
		return cameraY / camera.zoom + camera.scroll.y + camera.viewMarginY;
	}
	
	// --- --- --- WORLD-TO-WINDOW --- --- --- //
	
	/**
	 * Takes a position on the game's window and gives a corresponding position in world space, via the supplied camera.
	 * Note: This changes the point passed in
	 * @param worldPos  The position in the game's window.
	 * @param camera    The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function convertWorldToWindow(worldPos:FlxWorldPoint, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return worldPos.set(worldToWindowXUnsafe(worldPos.x, camera), worldToWindowYUnsafe(worldPos.y, camera));
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the game's window, via the supplied camera.
	 * @param worldPos  The position in world space.
	 * @param camera    The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	 * @param result    Optional point used for the returned result. If null, one is created.
	**/
	static public function worldToWindow(worldPos:FlxWorldPoint, ?camera:FlxCamera, ?result:FlxWindowPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(worldToWindowXUnsafe(worldPos.x, camera), worldToWindowYUnsafe(worldPos.y, camera));
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the game's window, via the supplied camera.
	 * @param worldX  The position in world space.
	 * @param worldY  The position in world space.
	 * @param camera  The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function worldToWindowXY(worldX:Float, worldY:Float, ?camera:FlxCamera, ?result:FlxWindowPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(worldToWindowXUnsafe(worldX, camera), worldToWindowYUnsafe(worldY, camera));
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the game's window, via the supplied camera.
	 * @param worldX  The position in world space.
	 * @param camera  The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function worldToWindowX(worldX:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return worldToWindowXUnsafe(worldX, camera);
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the game's window, via the supplied camera.
	 * @param worldY  The position in world space.
	 * @param camera  The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function worldToWindowY(worldY:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return worldToWindowYUnsafe(worldY, camera);
	}
	
	inline static function worldToWindowXUnsafe(worldX:Float, ?camera:FlxCamera)
	{
		return cameraToWindowXUnsafe(worldToCameraXUnsafe(worldX, camera), camera);
	}
	
	inline static function worldToWindowYUnsafe(worldY:Float, ?camera:FlxCamera)
	{
		return cameraToWindowYUnsafe(worldToCameraYUnsafe(worldY, camera), camera);
	}
	
	// --- --- --- WORLD-TO-CAMERA --- --- --- //
	
	/**
	 * Takes a position in world space and gives a corresponding position in the supplied camera.
	 * @param worldPos  The position in world space.
	 * @param camera    The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	 * @param result    Optional point used for the returned result. If null, one is created.
	**/
	static public function worldToCamera(worldPos:FlxWorldPoint, ?camera:FlxCamera, ?result:FlxCameraPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(worldToCameraXUnsafe(worldPos.x, camera), worldToCameraYUnsafe(worldPos.y, camera));
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the supplied camera.
	 * @param worldX  The position in world space.
	 * @param worldY  The position in world space.
	 * @param camera  The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function worldToCameraXY(worldX:Float, worldY:Float, ?camera:FlxCamera, ?result:FlxCameraPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(worldToCameraXUnsafe(worldX, camera), worldToCameraYUnsafe(worldY, camera));
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the supplied camera.
	 * @param worldX  The position in world space.
	 * @param camera  The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function worldToCameraX(worldX:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return worldToCameraXUnsafe(worldX, camera);
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the supplied camera.
	 * @param worldY  The position in world space.
	 * @param camera  The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function worldToCameraY(worldY:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return worldToCameraYUnsafe(worldY, camera);
	}
	
	inline static function worldToCameraXUnsafe(worldX:Float, camera:FlxCamera)
	{
		@:privateAccess
		return (worldX - camera.scroll.x - camera.viewMarginX) * camera.zoom;
	}
	
	inline static function worldToCameraYUnsafe(worldY:Float, camera:FlxCamera)
	{
		@:privateAccess
		return (worldY - camera.scroll.y - camera.viewMarginY) * camera.zoom;
	}
	
	// --- --- --- WINDOW-TO-CAMERA --- --- --- //
	
	/**
	 * Takes a position in window space and gives a corresponding position in the supplied camera.
	 * @param windowPos  The position in window space.
	 * @param camera     The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	 * @param result     Optional point used for the returned result. If null, one is created.
	**/
	static public function windowToCamera(windowPos:FlxWindowPoint, ?camera:FlxCamera, ?result:FlxCameraPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(windowToCameraXUnsafe(windowPos.x, camera), windowToCameraYUnsafe(windowPos.y, camera));
	}
	
	/**
	 * Takes a position in window space and gives a corresponding position in the supplied camera.
	 * @param windowX  The position in window space.
	 * @param windowY  The position in window space.
	 * @param camera   The camera from which to transform window coordinates. If null, `FlxG.camera` is used.
	**/
	static public function windowToCameraXY(windowX:Float, windowY:Float, ?camera:FlxCamera, ?result:FlxCameraPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(windowToCameraXUnsafe(windowX, camera), windowToCameraYUnsafe(windowY, camera));
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the supplied camera.
	 * @param worldX  The world x position.
	 * @param camera  The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function windowToCameraX(worldX:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return windowToCameraXUnsafe(worldX, camera);
	}
	
	/**
	 * Takes a position in world space and gives a corresponding position in the supplied camera.
	 * @param worldY  The world y position.
	 * @param camera   The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function windowToCameraY(windowY:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return windowToCameraYUnsafe(windowY, camera);
	}
	
	inline static function windowToCameraXUnsafe(windowX:Float, camera:FlxCamera)
	{
		return windowX - camera.x - FlxG.game.x;
	}
	
	inline static function windowToCameraYUnsafe(windowY:Float, camera:FlxCamera)
	{
		return windowY - camera.y - FlxG.game.y;
	}
	
	// --- --- --- CAMERA-TO-WINDOW --- --- --- //
	
	/**
	 * Takes a position in the supplied camera and gives a corresponding position in the game's window.
	 * @param cameraPos  The position in the game's window.
	 * @param camera     The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	 * @param result     Optional point used for the returned result. If null, one is created.
	**/
	static public function cameraToWindow(cameraPos:FlxCameraPoint, ?camera:FlxCamera, ?result:FlxWindowPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(cameraToWindowXUnsafe(cameraPos.x, camera), cameraToWindowYUnsafe(cameraPos.y, camera));
	}
	
	
	/**
	 * Takes a position in the supplied camera and gives a corresponding position in the game's window.
	 * @param cameraX  The position in the game's window.
	 * @param cameraY  The position in the game's window.
	 * @param camera   The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function cameraToWindowXY(cameraX:Float, cameraY:Float, ?camera:FlxCamera, ?result:FlxWindowPoint)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(cameraToWindowXUnsafe(cameraX, camera), cameraToWindowYUnsafe(cameraY, camera));
	}
	
	/**
	 * Takes a position in the supplied camera and gives a corresponding position in the game's window.
	 * @param cameraX  The world x position.
	 * @param camera   The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function cameraToWindowX(cameraX:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return cameraToWindowXUnsafe(cameraX, camera);
	}
	
	/**
	 * Takes a position in the supplied camera and gives a corresponding position in the game's window.
	 * @param cameraY  The world y position.
	 * @param camera   The camera from which to transform world's coordinates. If null, `FlxG.camera` is used.
	**/
	static public function cameraToWindowY(cameraY:Float, ?camera:FlxCamera)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return cameraToWindowYUnsafe(cameraY, camera);
	}
	
	inline static function cameraToWindowXUnsafe(cameraX:Float, camera:FlxCamera)
	{
		return cameraX + camera.x + FlxG.game.x;
	}
	
	inline static function cameraToWindowYUnsafe(cameraY:Float, camera:FlxCamera)
	{
		return cameraY + camera.y + FlxG.game.y;
	}
	
	// --- --- --- CAMERA_TO_CAMERA --- --- --- //
	
	/**
	 * TODO: description
	 * @param worldPos  The position in world space.
	 * @param fromCam   The camera from which to transform world's coordinates.
	 * @param toCam     The camera to which to transform world's coordinates.
	 * @param result    Optional point used for the returned result. If null, one is created.
	**/
	static public function cameraToCamera(worldPos:FlxCameraPoint, fromCam:FlxCamera, toCam:FlxCamera, ?result:FlxCameraPoint)
	{
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(cameraToCameraX(worldPos.x, fromCam, toCam), cameraToCameraY(worldPos.y, fromCam, toCam));
	}
	
	/**
	 * TODO: description
	 * @param worldX   The position in world space.
	 * @param worldY   The position in world space.
	 * @param fromCam  The camera from which to transform world's coordinates.
	 * @param toCam    The camera to which to transform world's coordinates.
	**/
	static public function cameraToCameraXY(worldX:Float, worldY:Float, fromCam:FlxCamera, toCam:FlxCamera, ?result:FlxCameraPoint)
	{
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(cameraToCameraX(worldX, fromCam, toCam), cameraToCameraY(worldY, fromCam, toCam));
	}
	
	/**
	 * TODO: description
	 * @param worldX   The world x position.
	 * @param fromCam  The camera from which to transform world's coordinates.
	 * @param toCam    The camera to which to transform world's coordinates.
	**/
	static public function cameraToCameraX(worldX:Float, fromCam:FlxCamera, toCam:FlxCamera)
	{
		return windowToWorldX(worldToWindowX(worldX, fromCam), toCam);
	}
	
	/**
	 * TODO: description
	 * @param worldY   The world y position.
	 * @param fromCam  The camera from which to transform world's coordinates.
	 * @param toCam    The camera to which to transform world's coordinates.
	**/
	static public function cameraToCameraY(worldY:Float, fromCam:FlxCamera, toCam:FlxCamera)
	{
		return windowToWorldY(worldToWindowY(worldY, fromCam), toCam);
	}
	
	// --- --- --- HELPERS --- --- --- //
	
	// TODO: use macro to generate converters
	inline static function convertTo(pos:FlxPoint, ?camera:FlxCamera, funcX:ToFunc, funcY:ToFunc)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		return pos.set(funcX(pos.x, camera), funcY(pos.y, camera));
	}
	
	// TODO: use macro to generate converters
	inline static function to(pos:FlxPoint, ?camera:FlxCamera, ?result:FlxPoint, funcX:ToFunc, funcY:ToFunc)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(funcX(pos.x, camera), funcY(pos.y, camera));
	}
	
	// TODO: use macro to generate converters
	inline static function toXY(x:Float, y:Float, ?camera:FlxCamera, ?result:FlxPoint, funcX:ToFunc, funcY:ToFunc)
	{
		if (camera == null)
			camera = FlxG.camera;
		
		if(result == null)
			result = FlxPoint.get();
		
		return result.set(funcX(x, camera), funcY(y, camera));
	}
}

private typedef ToFunc = (x:Float, camera:FlxCamera)->Float;
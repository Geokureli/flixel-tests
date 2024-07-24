package states;

import flixel.FlxStrip;
import flixel.graphics.FlxGraphic;

import openfl.display.BlendMode;
import openfl.Vector;

class FlxStripBlendModeTestState extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		createMeshes(100, 100, MULTIPLY);
		createMeshes(100, 250, NORMAL);
	}
	
	inline static final SIZE = 100;
	function createMeshes(x:Float, y:Float, blend:BlendMode)
	{
		var mesh:FlxStrip = new FlxStrip(x, y, FlxGraphic.fromRectangle(SIZE, SIZE, 0xFFff40ff));
		mesh.indices = Vector.ofArray([0, 1, 2, 0, 2, 3]);
		mesh.vertices = Vector.ofArray(([0, 0, SIZE, 0, SIZE, SIZE, 0, SIZE]:Array<Float>));
		mesh.uvtData = Vector.ofArray(([0, 0, 1, 0, 1, 1, 0, 1]:Array<Float>));
		mesh.colors = Vector.ofArray([0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF]);
		add(mesh);
		
		var mesh2:FlxStrip = new FlxStrip(x + SIZE/2, y, FlxGraphic.fromRectangle(SIZE, SIZE, 0xFF80ffff));
		mesh2.indices = Vector.ofArray([0, 1, 2, 0, 2, 3]);
		mesh2.vertices = Vector.ofArray(([0, 0, SIZE, 0, SIZE, SIZE, 0, SIZE]:Array<Float>));
		mesh2.uvtData = Vector.ofArray(([0, 0, 1, 0, 1, 1, 0, 1]:Array<Float>));
		mesh2.colors = Vector.ofArray([0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF]);
		mesh2.blend = blend;
		add(mesh2);
	}
}
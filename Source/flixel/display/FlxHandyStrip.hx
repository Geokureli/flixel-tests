package flixel.display;

import flixel.util.FlxDestroyUtil;

class FlxTriangles implements IFlxDestroyable
{
	/**
	* A `Vector` of floats where each pair of numbers is treated as a coordinate location (an x, y pair).
	*/
	public var vertices:DrawData<Float>;
	
	/**
	* A `Vector` of integers or indexes, where every three indexes define a triangle.
	*/
	public var indices:DrawData<Int>;
	
	/**
	* A `Vector` of normalized coordinates used to apply texture mapping.
	*/
	public var uvtData:DrawData<Float>;
	
	public var colors:DrawData<Int>;
	
	public function destroy()
	{
		vertices = null;
		indices = null;
		uvData = null;
		colors = null;
	}
}

class FlxHandyStrip extends FlxSprite
{
	public var repeat:Bool = false;
	public var triangles:FlxTriangles;
	
	override public function destroy():Void
	{
		triangles = FlxDestroyUtil.destroy(triangles);
		
		super.destroy();
	}
	
	// TODO: check this for cases when zoom is less than initial zoom...
	override public function draw():Void
	{
		if (alpha == 0 || graphic == null || triangles.length == null)
			return;
		
		for (camera in cameras)
		{
			if (!camera.visible || !camera.exists)
				continue;
			
			getScreenPosition(_point, camera).subtractPoint(offset);
			#if !flash
			camera.drawTriangles(graphic, data.vertices, data.indices, data.uvData, data.colors, _point, blend, repeat, antialiasing, colorTransform, shader);
			#else
			camera.drawTriangles(graphic, data.vertices, data.indices, data.uvData, data.colors, _point, blend, repeat, antialiasing);
			#end
		}
	}
}

class Vertex
{
	public var x(default, set):Float;
	inline function set_x(value:Float)
	{
		dirty = dirty || this.x != value;
		return this.x = value;
	}
	
	public var y(default, set):Float;
	inline function set_y(value:Float)
	{
		dirty = dirty || this.y != value;
		return this.y = value;
	}
	
	public var u(default, set):Float;
	inline function set_u(value:Float)
	{
		dirty = dirty || this.u != value;
		return this.u = value;
	}
	
	public var v(default, set):Float;
	inline function set_v(value:Float)
	{
		dirty = dirty || this.v != value;
		return this.v = value;
	}
	
	var dirty = true;
	
	inline public function new(x:Float, y:Float, u:Float, v:Float)
	{
		this.x = x;
		this.y = y;
		this.u = u;
		this.v = v;
	}
}

class Triangle
{
	public var a(default, set):Vertex;
	inline function set_a(value:Vertex)
	{
		dirty = dirty || this.a != value;
		return this.a = value;
	}
	
	public var b(default, set):Vertex;
	inline function set_b(value:Vertex)
	{
		dirty = dirty || this.b != value;
		return this.b = value;
	}
	
	public var c(default, set):Vertex;
	inline function set_c(value:Vertex)
	{
		dirty = dirty || this.c != value;
		return this.c = value;
	}
	
	var dirty = true;
	
	inline public function new(a:Vertex, b:Vertex, c:Vertex)
	{
		@:bypassAccessor this.a = a;
		@:bypassAccessor this.b = b;
		@:bypassAccessor this.c = c;
	}
	
	@:privateAccess
	function checkDirtyAndReset()
	{
		final isDirty = dirty || a.dirty || b.dirty || c.dirty;
		dirty = a.dirty = b.dirty = c.dirty = false;
		return isDirty;
	}
}

class TriangleArray
{
	var list = new Array<Triangle>();
	var dirty = true;
	
	inline public function new(triangles:Array<Triangle>)
	{
		list = triangles;
	}
	
	public function updateData()
	{
		if (checkDirtyAndReset())
			createData();
	}
	
	function checkDirtyAndReset()
	{
		for (triangle in list)
		{
			@:privateAccess
			if (triangle.checkDirtyAndReset())
				dirty = true;
		}
		
		final isDirty = dirty;
		dirty = false;
		return isDirty;
	}
	
	function toDrawData(triangles:FlxTriangles)
	{
		final uniqueVertices = [];
		function addIfUnique(v:Vertex)
		{
			if (uniqueVertices.contains(v) == false)
				uniqueVertices.push(v);
		}
		
		for (triangle in list)
		{
			addIfUnique(triangle.a);
			addIfUnique(triangle.b);
			addIfUnique(triangle.c);
		}
		
		final verticesArray:Array<Float> = [];
		final uvArray:Array<Float> = [];
		final indicesArray:Array<Int> = [];
		
		for (vertex in uniqueVertices)
		{
			verticesArray.push(vertex.x);
			verticesArray.push(vertex.y);
			
			uvArray.push(vertex.u);
			uvArray.push(vertex.v);
		}
		
		for (triangle in list)
		{
			indicesArray.push(uniqueVertices.indexOf(triangle.a));
			indicesArray.push(uniqueVertices.indexOf(triangle.b));
			indicesArray.push(uniqueVertices.indexOf(triangle.c));
		}
		
		triangles.vertices = DrawData.fromArray(verticesArray);
		triangles.uvtData = DrawData.fromArray(uvArray);
		triangles.indices = DrawData.fromArray(indicesArray);
		triangles.color = DrawData.fromArray([]);
	}
	
	inline public function get(index:Int):Triangle
	{
		return list[index];
	}
	
	inline public function set(index:Int, triangle:Triangle):Triangle
	{
		dirty = true;
		return list[index] = triangle;
	}
	
	inline public function push(triangle:Triangle)
	{
		dirty = true;
		list.push(triangle);
	}
	
	inline public function pushVertices(a, b, c)
	{
		push(new Triangle(a, b, c));
	}
	
	inline public function pushQuad(a, b, c, d)
	{
		push(new Triangle(a, b, c));
		push(new Triangle(a, c, d));
	}
	
	inline function remove(triangle:Triangle)
	{
		dirty = true;
		list.remove(triangle);
	}
	
	inline function slice(pos:Int, ?end:Int)
	{
		dirty = true;
		list.slice(pos, end);
	}
	
	inline function splice(pos:Int, len:Int)
	{
		dirty = true;
		list.splice(pos, len);
	}
}
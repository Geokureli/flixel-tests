package states;

import flixel.FlxG;
import flixel.FlxStrip;
import flixel.group.FlxGroup;
import flixel.graphics.FlxGraphic;
import openfl.Vector;

class FlxStripColorTestState extends flixel.FlxState
{
	final meshes = new FlxTypedGroup<Mesh>();
	
	override public function create()
	{
		super.create();
		
		for (i in 0...3)
			meshes.add(new Mesh(10, 10 + i * 110));
		
		add(meshes);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed)
		{
			final mouse = FlxG.mouse.getWorldPosition();
			for (mesh in meshes)
			{
				if (mesh.overlapsPoint(mouse))
					mesh.toggleColor();
			}
			mouse.put();
		}
	}
}

@:forward
abstract Mesh(FlxStrip) to FlxStrip
{
	static inline var ON_COLOR = 0xFFffff00;
	static inline var OFF_COLOR = 0xFFffffff;
	
	inline public function new (x = 0.0, y = 0.0)
	{
		this = new FlxStrip(x, y);
		this.makeGraphic(50, 50, 0xFFff80ff);
		this.width = 100;
		this.height = 100;
		this.indices = Vector.ofArray([0, 1, 2, 0, 2, 3]);
		this.vertices = Vector.ofArray([0., 0., this.width, 0., this.width, this.height, 0., this.height]);
		this.uvtData = Vector.ofArray([0., 0., 1., 0., 1., 1., 0., 1.]);
		this.color = OFF_COLOR;
	}
	
	public function toggleColor()
	{
		this.color = (this.color == OFF_COLOR ? ON_COLOR : OFF_COLOR);
	}
}
package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class JumpTweenTestState extends flixel.FlxState
{
	override function create()
	{
		super.create();
		
		final WIDTH = 50;
		final HEIGHT = 50;
		final DURATION = 1.5;
		
		final top = 0;
		final bottom = FlxG.height - HEIGHT;
		final center = FlxG.height / 2;
		
		function make(startY:Float, apex:Float, endY:Float, color:FlxColor)
		{
			final obj = new FlxSprite().makeGraphic(WIDTH, HEIGHT, color);
			add(obj);
			obj.y = startY;
			return JumpTween.to(obj, FlxG.width - WIDTH, apex, endY, DURATION,
				{ type: PINGPONG, loopDelay: 0.25, startDelay: this.members.length * 0.15 }
				// { type: LOOPING, startDelay: this.members.length * 0.15 }
			);
		}
		
		make(bottom, top, bottom, 0xFFff0000);
		make(bottom, top, center, 0xFFffff00);
		make(center, top, bottom, 0xFF808000);
		make(bottom, top, top, 0xFFff00ff);
		make(top, top, bottom, 0xFF800080);
		make(center, center, center, 0xFF00ff00);
		make(top, bottom, top, 0xFF0000ff);
		make(top, bottom, center, 0xFF00ffff);
		make(center, bottom, top, 0xFF008080);
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
	}
}

class JumpTween extends flixel.tweens.FlxTween
{
	public final object:FlxObject;
	public final velocityX:Float;
	public final velocityY:Float;
	public final gravity:Float;
	public final startX:Float;
	public final startY:Float;
	
	public function new (target:FlxObject, velocityX:Float, velocityY:Float, gravity:Float, duration:Float, ?options:TweenOptions, ?manager)
	{
		object = target;
		this.velocityX = velocityX;
		this.velocityY = velocityY;
		this.gravity = gravity;
		this.startX = target.x;
		this.startY = target.y;
		
		super(options, manager);
		this.duration = duration;
		
		this.manager.add(this);
		start();
	}
	
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.watch.addQuick("scale", scale);
		FlxG.watch.addQuick("s", _secondsSinceStart);
		FlxG.watch.addQuick("%", percent);
		FlxG.watch.addQuick("duration", duration);
		FlxG.watch.addQuick("backward", backward);
		FlxG.watch.addQuick("delay", _delayToUse);
		
		final t = duration * scale;
		object.x = startX + velocityX * t;
		object.y = startY + velocityY * t + .5 * gravity * t * t;
	}
	
	override function isTweenOf(object:Dynamic, ?field:String):Bool
	{
		return this.object == object
			&& (field == null || field == "x" || field == "y");
	}
	
	/**
	 * Makes an object "jump" from their current position with the specified velocity and gravity
	 * 
	 * @param target     The jumping object
	 * @param velocityX  The initial velocity of the object
	 * @param velocityY  The initial velocity of the object
	 * @param gravity    How fast the object accelerates downward px/s/s
	 * @param duration   How long it takes to jump
	 * @param options    Tween options
	 * @since 6.3.0
	 */
	static public function tween(target:FlxObject, velocityX:Float, velocityY:Float, gravity:Float, duration:Float, ?options:TweenOptions, ?manager):JumpTween
	{
		if (manager == null)
			manager = FlxTween.globalManager;
		
		return new JumpTween(target, velocityX, velocityY, gravity, duration, options, manager);
	}
	
	/**
	 * Makes an object "jump" from their current position to some apex and,
	 * eventually, the target position as if affected by some constant gravity
	 * 
	 * @param target    The jumping object
	 * @param endX      The end X position
	 * @param apexY     The objects highest position during the jump
	 * @param endY      The end Y position
	 * @param duration  How long it takes to jump
	 * @param options   Tween options
	 * @since 6.3.0
	 */
	overload static public inline extern function to(target:FlxObject, endX:Float, apexY:Float, endY:Float, duration:Float, ?options:TweenOptions, ?manager):JumpTween
	{
		if (manager == null)
			manager = FlxTween.globalManager;
		
		return toHelper(target, endX, apexY, endY, duration, options, manager);
	}
	
	/**
	 * Makes an object "jump" from their current position to the target
	 * position as if affected by some constant, downward gravity
	 * 
	 * @param target    The jumping object
	 * @param endX      The end X position
	 * @param endY      The end Y position
	 * @param duration  How long it takes to jump
	 * @param options   Tween options
	 * @since 6.3.0
	 */
	overload static public inline extern function to(target:FlxObject, endX:Float, endY:Float, duration:Float, ?options:TweenOptions, ?manager):JumpTween
	{
		return toHelper(target, endX, Math.min(target.y, endY), endY, duration, options, manager);
	}
	
	static function toHelper(target:FlxObject, endX:Float, apexY:Float, endY:Float, duration:Float, options:TweenOptions, manager:Null<FlxTweenManager>):JumpTween
	{
		if (manager == null)
			manager = FlxTween.globalManager;
		
		final vx = getLinearV(target.x, endX, duration);
		
		if (target.y == apexY && endY == apexY)
		{
			final vy = getLinearV(target.y, endY, duration);
			return new JumpTween(target, vx, vy, 0, duration, options, manager);
		}
		
		if (target.y == apexY && endY != apexY)
			return fallToHelper(target, vx, endY, duration, options, manager);
		
		if (target.y != apexY && endY == apexY)
			return toComplexHelper(target, vx, apexY, endY, duration, options, manager);
		
		if ((target.y < apexY) != (endY < apexY))
		{
			FlxG.log.warn("The jump apex cannot be between the start and end y");
			final vy = getLinearV(target.y, endY, duration);
			return new JumpTween(target, vx, vy, 0, duration, options, manager);
		}
		
		return toComplexHelper(target, vx, apexY, endY, duration, options, manager);
	}
	
	static function toComplexHelper(target:FlxObject, vx:Float, apexY:Float, endY:Float, duration:Float, options:TweenOptions, manager):JumpTween
	{
		final jumpHeight = apexY - target.y;
		final fallHeight = endY - apexY;
		final t1 = getTimeToApex(jumpHeight, fallHeight, duration);
		// d = (vi + vf) / 2 * t1 | vf = 0 at apex
		// d = vi / 2 * t1
		final vy = getInitialV(jumpHeight, t1);
		// vf = vi + a * t1 | vf = 0 at apex
		// a = -vi / t1
		final a = -vy / t1;
		
		return new JumpTween(target, vx, vy, a, duration, options, manager);
	}
	
	/**
	 * Used when jumping to a lower position, when the start is also the apex
	 */
	static function fallToHelper(target:FlxObject, vx:Float, endY:Float, duration:Float, options:TweenOptions, manager):JumpTween
	{
		final fallHeight = endY - target.y;
		final t2 = getTimeToApex(fallHeight, 0, duration);
		final a = getInitialV(fallHeight, t2) / t2;
		
		return tween(target, vx, 0, a, duration, options, manager);
	}
	
	/**
	 * Calculates the time it will take to get to the apex given the heights and duration
	 * @param jumpHeight  Starting height - apex height
	 * @param fallHeight  Apex height - ending height
	 * @param duration    The time it takes to do the entire jump
	 */
	@:pure static function getTimeToApex(jumpHeight:Float, fallHeight:Float, duration:Float):Float
	{
		// Assume up takes 1 second, calc fall time and use that ratio with the actual duration
		final t1Guess = 1.0; // arbitrary
		// d = (vi + vf)/2 * t1| vf = 0 at apex
		// d/t1 = vi/2 * t1/t1
		final vi = 2 * jumpHeight / t1Guess;
		// vf = vi + a*t | vf = 0 at apex
		// -a*t = vi
		final a = -vi / t1Guess;
		// d = vi * t + 1/2 * a * t^2 | vi = 0 at apex
		// d = 1/2 * a * t^2
		// 2 * d / a = t^2
		final t2Guess = Math.sqrt(2 * fallHeight / a);
		return t1Guess / (t1Guess + t2Guess) * duration;
	}
	
	/**
	 * Calculates the initial verlocity that will bring an obnject to the desired height in the given time
	 */
	@:pure static function getInitialV(apexHeight:Float, duration:Float):Float
	{
		// d = (vi + vf) / 2 * t1 | vf = 0 at apex
		// d = vi / 2 * t1
		// d * 2 = vi * t1
		return apexHeight * 2 / duration;
	}
	
	/**
	 * Calculates the initial verlocity that will bring an obnject to the desired height in the given time
	 */
	@:pure static function getLinearV(start:Float, end:Float, duration:Float)
	{
		return (end - start) / duration;
	}
}
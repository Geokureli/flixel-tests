package flixel.addons.text;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSignal;

class FlxTextTyper extends FlxBasic
{
	/**
	 * The current state of the typer.
	 */
	public var state(default, null):FlxTyperState = EMPTY;
	
	/**
	 * The delay between each character, in seconds.
	 */
	public var delay:FlxTypeDelay = CONST(0.05);
	
	/**
	 * The delay between each character erasure, in seconds.
	 */
	public var eraseDelay:FlxTypeDelay = CONST(0.02);
	
	/**
	 * Set to true to show a blinking cursor at the end of the text.
	 */
	public var showCursor:Bool = false;
	
	/**
	 * The character to blink at the end of the text.
	 */
	public var cursorCharacter:String = "|";
	
	/**
	 * The speed at which the cursor should blink, if shown at all.
	 */
	public var cursorBlinkRate:Float = 0.5;
	
	/**
	 * Text to add at the beginning, without animating.
	 */
	public var prefix:String = "";
	
	/**
	 * An array of keys (e.g. `[SPACE, L]`) that will advance the text.
	 */
	public var skipKeys:Array<FlxKey>;
	
	/**
	 * Dispatched when the message is done typing.
	 */
	public var onTypingComplete(default, null):FlxSignal = new FlxSignal();
	
	/**
	 * Dispatched when the message is done erasing.
	 */
	public var onErasingComplete(default, null):FlxSignal = new FlxSignal();
	
	/**
	 * Dispatched whenever the text changes.
	 */
	public var onChange(default, null):FlxSignal = new FlxSignal();
	
	/**
	 * Dispatched when a new portion of the text is typed. Helpful for playing sounds.
	 */
	public var onCharsType(default, null):FlxSignal = new FlxSignal();
	
	/**
	 * Dispatched when a portion of the text is erased. Helpful for playing sounds.
	 */
	public var onCharsErase(default, null):FlxSignal = new FlxSignal();
	
	/**
	 * The text that will ultimately be displayed.
	 */
	public var finalText(default, null):String;
	
	/**
	 * The full text to display.
	 */
	public var text(default, null):String;
	
	/**
	 * The text that was typed.
	 */
	var typedText:String = "";
	
	/**
	 * Used to delay character typing and erasing.
	 */
	var timer:Float = 0.0;
	
	/**
	 * Internal tracker for cursor blink time.
	 */
	var cursorTimer:Float = 0.0;
	
	/**
	 * Internal tracker for cursor blink time.
	 */
	var wasCursorShowing:Bool = false;
	
	public function new (prefix = "")
	{
		if (prefix == null)
			prefix = "";
		
		super();
		this.prefix = prefix;
		text = prefix;
	}
	
	/**
	 * Clears all typed text
	 */
	public function clear()
	{
		state = EMPTY;
		typedText = "";
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// check prefix before typedText changes
		final prefixChanged = text.indexOf(prefix + typedText) != 0;
		
		// update typed text
		var changed = switch(state)
		{
			case EMPTY: false;
			case TYPING: updateTyping(elapsed);
			case FINISHED: false;
			case ERASING: updateErasing(elapsed);
		}
		
		if (prefixChanged)
			changed = true;
		
		// update cursor
		cursorTimer += elapsed;
		final cursorShowing = isCursorShowing();
		if (wasCursorShowing != cursorShowing)
		{
			changed = true;
			wasCursorShowing = cursorShowing;
		}
		
		// apply new changes and dispatch change events
		if (changed)
		{
			text = (prefix == null ? "" : prefix) + typedText;
			if (cursorShowing)
				text += cursorCharacter;
			
			onChange.dispatch();
		}
	}
	
	/**
	 * Begins the typing effect.
	 * 
	 * @param text   The text to type. Do not include the prefix
	 * @param clear  If true, all typed text is removed, otherwise, if some of the desired
	 *               message is already typed, it will continue where it left off.
	 */
	public function startTyping(text:String, clear = true)
	{
		finalText = text;
		
		// if partial message is already there, and clear is false, continue where we left off
		if (clear || (typedText != "" && finalText.indexOf(typedText) != 0))
			typedText = "";
		else if (typedText == finalText)
		{
			typingCompleted();
			return;
		}
		
		timer = delay.random();
		state = TYPING;
	}
	
	/**
	 * Begins the typing effect while preserving any text that is already typed.
	 * 
	 * @param text         The text to type. Do not include the prefix
	 * @param skipCurrent  If the type is currently typing or erasing, it will finish
	 *                     first before appending the desired text.
	 */
	public function startAppending(text:String, skipCurrent = true)
	{
		prefix += typedText;
		finalText = text;
		
		if (skipCurrent && state.match(TYPING, ERASING))
			skip();
		
		timer = delay.random();
		state = TYPING;
	}
	
	public function startErasing(?textOverride:String)
	{
		if (textOverride != null)
			typedText = textOverride;
		
		if (typedText == "")
		{
			erasingCompleted();
			return;
		}
		
		timer = eraseDelay.random();
		state = ERASING;
	}
	
	public function skip()
	{
		switch(state)
		{
			case TYPING:
				typedText = finalText;
				typingCompleted();
			case ERASING:
				typedText = "";
				erasingCompleted();
			case EMPTY | FINISHED:
				// nothing
		}
	}
	
	function updateTyping(elapsed:Float):Bool
	{
		var changed = false;
		
		if (skipPressed())
		{
			skip();
			return true;
		}
		
		timer -= elapsed;
		while (timer < 0)
		{
			typedText += finalText.charAt(typedText.length);
			timer += delay.random();
			changed = true;
			
			if (typedText == finalText)
			{
				typingCompleted();
				break;
			}
		}
		
		if (changed)
			onCharsType.dispatch();
		
		return changed;
	}
	
	public function typingCompleted()
	{
		state = FINISHED;
		onTypingComplete.dispatch();
	}
	
	function updateErasing(elapsed:Float):Bool
	{
		var changed = false;
		
		if (skipPressed())
		{
			skip();
			return true;
		}
		
		timer -= elapsed;
		while (timer < 0)
		{
			// remove last typed character
			typedText = typedText.substr(0, typedText.length - 1);
			timer += eraseDelay.random();
			changed = true;
			
			if (typedText == "")
			{
				erasingCompleted();
				break;
			}
		}
		
		if (changed)
			onCharsErase.dispatch();
		
		return changed;
	}
	
	public function erasingCompleted()
	{
		state = EMPTY;
		onErasingComplete.dispatch();
	}
	
	function skipPressed()
	{
		return skipKeys != null && FlxG.keys.anyJustPressed(skipKeys);
	}
	
	function isCursorShowing()
	{
		return showCursor && (cursorTimer % cursorBlinkRate) / cursorBlinkRate > 0.5;
	}
}

@:using(flixel.addons.text.FlxTextTyper.FlxTypeDelayTools)
enum FlxTypeDelay
{
	CONST(delay:Float);
	VARIED(delay:Float, variance:Float);
	RANGE(min:Float, max:Float);
	NORMAL(mean:Float, deviation:Float);
}

class FlxTypeDelayTools
{
	public static function random(delay:FlxTypeDelay)
	{
		return switch(delay)
		{
			case CONST(amount):
				amount;
			case RANGE(min, max):
				FlxG.random.float(min, max);
			case VARIED(base, variance):
				base * (1 + FlxG.random.float(-variance, variance));
			case NORMAL(mean, deviation):
				FlxG.random.floatNormal(mean, deviation);
		}
	}
}

enum FlxTyperState
{
	/**
	 * Text either has not started yet, or has been fully erased.
	 * Note: if `prefix` is non-null the text will never be empty.
	 */
	EMPTY;
	
	/** The typer is currently typing */
	TYPING;
	
	/** The typer has completed typing, if erasing is enabled it is waiting to erase */
	FINISHED;
	
	/** The typer is currently erasing */
	ERASING;
}
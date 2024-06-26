package flixel.addons.text;

package;

#if openfl
import texter.openfl.TextFieldRTL;
import texter.openfl.DynamicTextField;
import openfl.text.TextField;
import openfl.events.FocusEvent;
import openfl.events.Event;
import lime.system.Clipboard;
import openfl.events.TextEvent;
import lime.ui.KeyModifier;
import lime.ui.KeyCode;
#end
import texter.general.CharTools;
import texter.general.bidi.Bidi;

/**
	This class provides useful tools to add support for Right-to-Left Texts.

	to use it, I recommand adding the following line to the top of your file:

		using BidiTools;

**/
#if openfl
@:access(openfl.text.TextField)
@:access(openfl.text._internal.TextEngine)
#end
class FlxTypeTools
{
	public static function __attachOpenFL(textfield:TextField):Void
	{
		function getBidified(text:String):String
		{
			var processed = text;
			return Bidi.process(processed);
		}

		var unbidified:String = textfield.text;
		var nText = new TextField();
		function displayChanges(e:Event)
		{
			nText.defaultTextFormat = textfield.defaultTextFormat;
			nText.width = textfield.width;
			nText.x = textfield.x;
			nText.y = textfield.y + textfield.height;
			nText.height = textfield.height;
			nText.text = getBidified(textfield.text);
		}

		function displayBidifiedBelow(e)
		{
			var tf = textfield.defaultTextFormat;
			tf.align = if (CharTools.isRTL(textfield.text.charAt(0)) && tf.align != "center") "right" else tf.align;
			textfield.text = unbidified;
			nText.defaultTextFormat = textfield.defaultTextFormat;
			nText.width = textfield.width;
			nText.x = textfield.x;
			nText.y = textfield.y + textfield.height;
			nText.height = textfield.height;
			nText.multiline = textfield.multiline;
			nText.wordWrap = textfield.wordWrap;
			nText.text = getBidified(textfield.text);
			textfield.parent.addChild(nText);
			textfield.addEventListener(Event.CHANGE, displayChanges);
		}

		function applyBidified(e)
		{
			unbidified = textfield.text;
			textfield.text = nText.text;
			textfield.parent.removeChild(nText);
		}

		function invoke(fromEvent = false, e:Event)
		{
			if (fromEvent)
				textfield.removeEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
			textfield.addEventListener(FocusEvent.FOCUS_IN, displayBidifiedBelow);
			textfield.addEventListener(FocusEvent.FOCUS_OUT, applyBidified);
		}

		if (textfield.stage == null)
		{
			textfield.addEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
		}
		else
		{
			invoke(false, null);
		}
	}

	public static function __attachLiveOpenFL(textfield:TextField):Void
	{
		var startingLetter = "";
		var currentlyOppositeDirection = false;
		final getStartingDirection = () ->
		{
			return CharTools.isRTL(startingLetter) ? RTL : LTR;
		}
		final setOppositeDirection = () ->
		{
			trace((CharTools.isRTL(textfield.text.charAt(textfield.caretIndex))
				|| (currentlyOppositeDirection && textfield.text.charAt(textfield.caretIndex) == " ")
				|| (CharTools.generalMarks.contains(textfield.text.charAt(textfield.caretIndex)) && currentlyOppositeDirection)));
			return currentlyOppositeDirection = (CharTools.isRTL(textfield.text.charAt(textfield.caretIndex))
				|| (currentlyOppositeDirection && textfield.text.charAt(textfield.caretIndex) == " ")
				|| (CharTools.generalMarks.contains(textfield.text.charAt(textfield.caretIndex)) && currentlyOppositeDirection));
		}
		function manageTextInput(letter:String)
		{
			// if the user didnt intend to edit the text, dont do anything
			if (textfield.stage.focus != textfield)
				return;
			// if the caret is broken for some reason, fix it
			if (textfield.caretIndex < 0)
				textfield.setSelection(0, 0);
			// set up the letter - remove null chars, add rtl mark to letters from RTL languages
			var t:String = "",
				hasConverted:Bool = false,
				addedSpace:Bool = false;
			#if !js
			if (letter != null)
			{
				if (getStartingDirection() == LTR)
				{
					// logic for general RTL letters, spacebar, punctuation marks
					if (CharTools.isRTL(letter)
						|| (currentlyOppositeDirection && letter == " ")
						|| (CharTools.generalMarks.contains(letter) && currentlyOppositeDirection))
					{
						t = CharTools.RLO + letter;
						currentlyOppositeDirection = true;
					}
					// logic for when the user converted from RTL to LTR
					else if (currentlyOppositeDirection)
					{
						t = letter;
						currentlyOppositeDirection = false;
						hasConverted = true;

						// after conversion, the caret needs to move itself to he end of the RTL text.
						// the last spacebar also needs to be moved
						if (textfield.text.charAt(textfield.caretIndex) == " ")
						{
							t = CharTools.PDF + " " + letter;
							textfield.text = textfield.text.substring(0, textfield.caretIndex)
								+ textfield.text.substring(textfield.caretIndex + 1, textfield.text.length);
							addedSpace = true;
						}
						textfield.setSelection(textfield.caretIndex + 1, textfield.caretIndex + 1);

						while (CharTools.isRTL(textfield.text.charAt(textfield.caretIndex))
							|| CharTools.isSoft(textfield.text.charAt(textfield.caretIndex))
							&& textfield.caretIndex < textfield.text.length)
							textfield.setSelection(textfield.caretIndex + 1, textfield.caretIndex + 1);
					}
					// logic for everything else - LTR letters, special chars...
					else
					{
						t = letter;
					}
				}
				else
				{
					// logic for general RTL letters, spacebar, punctuation marks
					if (CharTools.isLTR(letter)
						|| (currentlyOppositeDirection && letter == " ")
						|| (CharTools.generalMarks.contains(letter) && currentlyOppositeDirection))
					{
						t = letter;
						currentlyOppositeDirection = true;
					}
					// logic for when the user converted from RTL to LTR
					else if (currentlyOppositeDirection)
					{
						t = letter;
						currentlyOppositeDirection = false;
						hasConverted = true;

						// after conversion, the caret needs to move itself to he end of the RTL text.
						// the last spacebar also needs to be moved
						if (textfield.text.charAt(textfield.caretIndex - 1) == " ")
						{
							t = letter + " ";
							textfield.text = textfield.text.substring(0, textfield.caretIndex - 1)
								+ textfield.text.substring(textfield.caretIndex, textfield.text.length);
							addedSpace = true;
						}
						textfield.setSelection(textfield.caretIndex - 1, textfield.caretIndex - 1);

						while (textfield.caretIndex > 0
							&& (CharTools.isLTR(textfield.text.charAt(textfield.caretIndex - 1))
								|| CharTools.isSoft(textfield.text.charAt(textfield.caretIndex - 1))))
						{
							textfield.setSelection(textfield.caretIndex - 1, textfield.caretIndex - 1);
						}
					}
					// logic for everything else - LTR letters, special chars...
					else
					{
						t = CharTools.RLO + letter;
					}
				}
			}
			else
				"";
			#else
			t = letter;
			#end
			if (t.length > 0 && (textfield.maxChars == 0 || (textfield.text.length + t.length) < textfield.maxChars))
			{
				if (!CharTools.isSoft(letter) && (textfield.text.length == 0 || startingLetter == ""))
					startingLetter = letter.charAt(0);
				final oc = textfield.caretIndex;
				textfield.replaceSelectedText(t);
				textfield.setSelection(oc + 1, oc + 1);
				if (getStartingDirection() == LTR)
				{
					if (hasConverted)
						textfield.setSelection(textfield.caretIndex + 1, textfield.caretIndex + 1);
					if (addedSpace)
						textfield.setSelection(textfield.caretIndex + 1, textfield.caretIndex + 1);
				}
				else
				{
					if (hasConverted)
						textfield.setSelection(textfield.caretIndex - 1, textfield.caretIndex - 1);
					if (addedSpace)
						textfield.setSelection(textfield.caretIndex - 1, textfield.caretIndex - 1);
				}
				trace(getStartingDirection());
			}
		}

		function manageKeyDown(key:KeyCode, modifier:KeyModifier):Void
		{
			switch (key)
			{
				case RETURN, NUMPAD_ENTER:
					if (textfield.__textEngine.multiline)
					{
						if (((currentlyOppositeDirection && getStartingDirection() == LTR)
							|| (!currentlyOppositeDirection && getStartingDirection() == RTL))
							&& textfield.selectionBeginIndex == textfield.selectionEndIndex)
						{
							// If we just insert a newline, everything would go one line down and leave an empty line at the top
							// we need to go through the letters until we hit something LTR, and insert a newline before that.
							// special case: if we have a spacebar before that LTR letter, we should insert the newline before that spacebar
							var spacebarDefecit = 0; // used to traverse back on spacebars
							while (CharTools.isRTL(textfield.text.charAt(textfield.caretIndex))
								|| CharTools.isSoft(textfield.text.charAt(textfield.caretIndex))
								&& textfield.caretIndex != textfield.text.length)
							{
								trace(textfield.text.charAt(textfield.caretIndex));
								textfield.setSelection(textfield.caretIndex + 1, textfield.caretIndex + 1);
								if (textfield.text.charAt(textfield.caretIndex) == " ")
									spacebarDefecit++
								else
									spacebarDefecit = 0;
							}
							textfield.setSelection(textfield.caretIndex - spacebarDefecit, textfield.caretIndex - spacebarDefecit);
						}

						var te = new TextEvent(TextEvent.TEXT_INPUT, true, true, "\n");

						textfield.dispatchEvent(te);

						if (!te.isDefaultPrevented())
						{
							textfield.__replaceSelectedText("\n", true);

							textfield.dispatchEvent(new Event(Event.CHANGE, true));
						}
					}
					else
					{
						textfield.__stopCursorTimer();
						textfield.__startCursorTimer();
					}

				case BACKSPACE, DELETE:
					setOppositeDirection();
					if (key == BACKSPACE && !currentlyOppositeDirection || key == DELETE && currentlyOppositeDirection)
					{
						if (textfield.__selectionIndex == textfield.__caretIndex && textfield.__caretIndex > 0)
							textfield.__selectionIndex = textfield.__caretIndex - 1;

						if (textfield.__selectionIndex != textfield.__caretIndex)
						{
							textfield.replaceSelectedText("");
							textfield.__selectionIndex = textfield.__caretIndex;

							textfield.dispatchEvent(new Event(Event.CHANGE, true));
						}
						else
						{
							textfield.__stopCursorTimer();
							textfield.__startCursorTimer();
						}
					}
					else if (key == DELETE && !currentlyOppositeDirection || key == BACKSPACE && currentlyOppositeDirection)
					{
						if (textfield.__selectionIndex == textfield.__caretIndex && textfield.__caretIndex < textfield.__text.length)
							textfield.__selectionIndex = textfield.__caretIndex + 1;

						if (textfield.__selectionIndex != textfield.__caretIndex)
						{
							textfield.replaceSelectedText("");
							textfield.__selectionIndex = textfield.__caretIndex;

							textfield.dispatchEvent(new Event(Event.CHANGE, true));
						}
						else
						{
							textfield.__stopCursorTimer();
							textfield.__startCursorTimer();
						}
					}
				case LEFT if (textfield.selectable):
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
						textfield.__caretBeginningOfPreviousLine();
					else
						textfield.__caretPreviousCharacter();

					if (!modifier.shiftKey)
						textfield.__selectionIndex = textfield.__caretIndex;

					textfield.setSelection(textfield.__selectionIndex, textfield.__caretIndex);
					setOppositeDirection();

				case RIGHT if (textfield.selectable):
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
						textfield.__caretBeginningOfNextLine();
					else
						textfield.__caretNextCharacter();

					if (!modifier.shiftKey)
						textfield.__selectionIndex = textfield.__caretIndex;

					textfield.setSelection(textfield.__selectionIndex, textfield.__caretIndex);
					setOppositeDirection();

				case DOWN if (textfield.selectable):
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
					{
						textfield.__caretIndex = textfield.__text.length;
					}
					else
					{
						textfield.__caretNextLine();
					}

					if (!modifier.shiftKey)
					{
						textfield.__selectionIndex = textfield.__caretIndex;
					}

					textfield.setSelection(textfield.__selectionIndex, textfield.__caretIndex);
					setOppositeDirection();

				case UP if (textfield.selectable):
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
					{
						textfield.__caretIndex = 0;
					}
					else
					{
						textfield.__caretPreviousLine();
					}

					if (!modifier.shiftKey)
					{
						textfield.__selectionIndex = textfield.__caretIndex;
					}

					textfield.setSelection(textfield.__selectionIndex, textfield.__caretIndex);
					setOppositeDirection();

				case HOME if (textfield.selectable):
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
					{
						textfield.__caretIndex = 0;
					}
					else
					{
						textfield.__caretBeginningOfLine();
					}

					if (!modifier.shiftKey)
					{
						textfield.__selectionIndex = textfield.__caretIndex;
					}

					textfield.setSelection(textfield.__selectionIndex, textfield.__caretIndex);
					setOppositeDirection();

				case END if (textfield.selectable):
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
					{
						textfield.__caretIndex = textfield.__text.length;
					}
					else
					{
						textfield.__caretEndOfLine();
					}

					if (!modifier.shiftKey)
					{
						textfield.__selectionIndex = textfield.__caretIndex;
					}

					textfield.setSelection(textfield.__selectionIndex, textfield.__caretIndex);
					setOppositeDirection();

				case C:
					#if lime
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
					{
						if (textfield.__caretIndex != textfield.__selectionIndex)
						{
							Clipboard.text = textfield.__text.substring(textfield.__caretIndex, textfield.__selectionIndex);
						}
					}
					#end

				case X:
					#if lime
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
					{
						if (textfield.__caretIndex != textfield.__selectionIndex)
						{
							Clipboard.text = textfield.__text.substring(textfield.__caretIndex, textfield.__selectionIndex);

							textfield.replaceSelectedText("");
							textfield.dispatchEvent(new Event(Event.CHANGE, true));
						}
					}
					#end

				#if !js
				case V:
					#if lime
					if (#if mac modifier.metaKey #else modifier.ctrlKey #end)
					{
						if (Clipboard.text != null)
						{
							var te = new TextEvent(TextEvent.TEXT_INPUT, true, true, Clipboard.text);

							textfield.dispatchEvent(te);

							if (!te.isDefaultPrevented())
							{
								textfield.__replaceSelectedText(#if !js bidifyString(Clipboard.text) #else Clipboard.text #end, true);

								textfield.dispatchEvent(new Event(Event.CHANGE, true));
							}
						}
					}
					else
					{
						// TODO: does this need to occur?
						textfield.__textEngine.textFormatRanges[textfield.__textEngine.textFormatRanges.length - 1].end = textfield.__text.length;
					}
					#end
				#end

				case A if (textfield.selectable):
					if (#if mac modifier.metaKey #elseif js modifier.metaKey || modifier.ctrlKey #else modifier.ctrlKey #end)
					{
						textfield.setSelection(0, textfield.__text.length);
					}

				default:
			}
		}

		function invoke(fromEvent = false, e:Event)
		{
			if (fromEvent)
				textfield.removeEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
			@:privateAccess textfield.__inputEnabled = true;
			textfield.addEventListener(FocusEvent.FOCUS_IN, e ->
			{
				textfield.stage.window.onTextInput.remove(@:privateAccess textfield.window_onTextInput);
				textfield.stage.window.onKeyDown.remove(@:privateAccess textfield.window_onKeyDown);
				textfield.stage.window.onTextInput.remove(manageTextInput);
				textfield.stage.window.onTextInput.add(manageTextInput);
				textfield.stage.window.onKeyDown.remove(manageKeyDown);
				textfield.stage.window.onKeyDown.add(manageKeyDown);
			});
			textfield.stage.window.onTextInput.remove(@:privateAccess textfield.window_onTextInput);
			textfield.stage.window.onKeyDown.remove(@:privateAccess textfield.window_onKeyDown);
			textfield.stage.window.onTextInput.remove(manageTextInput);
			textfield.stage.window.onTextInput.add(manageTextInput);
			textfield.stage.window.onKeyDown.remove(manageKeyDown);
			textfield.stage.window.onKeyDown.add(manageKeyDown);
		}

		if (textfield.stage == null)
		{
			textfield.addEventListener(Event.ADDED_TO_STAGE, invoke.bind(true));
		}
		else
		{
			invoke(false, null);
		}
	}

	public static overload extern inline function attachBidifier(textfield:TextField):Void
	{
		__attachLiveOpenFL(textfield);
	}

	public static overload extern inline function attachBidifier(textfield:DynamicTextField):Void
	{
		__attachOpenFL(textfield.textField);
	}

	public static overload extern inline function attachBidifier(textfield:TextFieldRTL)
	{
		__attachOpenFL(textfield);
	}
}
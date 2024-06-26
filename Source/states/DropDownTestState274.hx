package states;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.text.FlxText;

class DropDownTestState274 extends flixel.FlxState
{
	var dropdown:FlxUIDropDownMenu;
	var hudCam:FlxCamera;

	override public function create()
	{
		var bg = new FlxSprite().makeGraphic(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2), -1);
		bg.screenCenter();
		add(bg);

		var selectionText = new FlxText(10, 10, 0, "Current Selection: none");
		add(selectionText);
		final items = FlxUIDropDownMenu.makeStrIdLabelArray(["hello", "world", "test123"], true);
		dropdown = new FlxUIDropDownMenu(0, 0, items);
		dropdown.callback = (selection)->selectionText.text = 'Current Selection: $selection';
		dropdown.x = FlxG.width - dropdown.width - 10;
		dropdown.y = FlxG.height - dropdown.height - 10;
		add(dropdown);
		
		super.create();
	}
}
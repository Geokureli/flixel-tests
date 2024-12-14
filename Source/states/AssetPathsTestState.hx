package states;

import flixel.system.FlxAssets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUIGroup;

/**
 * Test
 */
@:build(flixel.system.FlxAssets.buildFileReferences("assets/", true))
class AssetPaths {}

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true, [".png"]))
// class AssetPaths_migrate {}

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true, null, null, null, "fullList"))
// class AssetPaths_fullList {}

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true, null, ~/\/test\/|.ase/))
// class AssetPaths_exclude {}

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true, null, null, function (file)
// {
// 	if (file.indexOf("lorem_ipsum.txt") != -1)
// 		return "allFiles"; 
	
// 	final spl = file.toLowerCase().split("assets/").join("").split(".");
// 	final ext = spl.pop();
// 	return spl.join("__").split(" ").join("_").split("/").join("_") + "__" + ext;
// }))
// class AssetPaths_rename {}

// @:build(flixel.system.FlxAssets.buildAllManifestReferences())
// class FlxManifest_simple {}

// @:build(flixel.system.FlxAssets.buildAllManifestReferences(null, "*/test/*"))
// class FlxManifest_exclude {}

/**
 * Test state for [flixel#2575](https://github.com/HaxeFlixel/flixel/pull/2575) and
 * [Geokureli/assetpaths_manifest](https://github.com/Geokureli/flixel/tree/assetpaths_manifest) 
**/
class AssetPathsTestState extends flixel.FlxState
{
	override public function create():Void
	{
		for (path in AssetPaths.allFiles)
			trace(path);
		
		// AssetPaths_migrate.haxe__png;
		// trace(AssetPaths_simple.a__png);
		
		// for (path in AssetPaths_fullList.fullList)
		// 	trace(path);
		
		// AssetPaths_exclude.
		// AssetPaths_rename.images_haxe;
		
		// FlxManifest_simple.
		// FlxManifest_exclude.
	}
}
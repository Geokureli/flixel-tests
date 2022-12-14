package states;

import flixel.FlxG;
import flixel.FlxSprite;

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true, [".png"]))
// class AssetPaths_migrate {}

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true))
// class AssetPaths_simple {}

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true, null, ~/\/test\/|.ase/))
// class AssetPaths_exclude {}

// @:build(flixel.system.FlxAssets.buildFileReferences("assets/", true, null, null, function (file)
// {
// 	if (file.indexOf(".ase") == file.length - 4)
// 		return null; // exclude .ase files
	
// 	var spl = file.toLowerCase().split("assets/").join("").split(".");
// 	spl.pop();
// 	return spl.join("__").split(" ").join("_").split("/").join("_");
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
		// AssetPaths_migrate.haxe__png;
		// AssetPaths_simple.
		// AssetPaths_exclude.
		// AssetPaths_rename.images_haxe;
		
		// FlxManifest_simple.
		// FlxManifest_exclude.
	}
}
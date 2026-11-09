package states;

import tools.Haxelib;

class GitShaTestState extends flixel.FlxState
{
    override function create()
    {
        // final version = new FlxVersion();
        // trace('HaxeFlixel $version');
        
        function gt(a:String, b:String)
        {
            return Version.fromString(a).greaterThan(Version.fromString(b));
        }
        
        final versions = 
            [ "1.0.0-alpha"
            , "1.0.0-alpha+meta"
            , "1.0.0-alpha.1+meta"
            , "1.0.0-alpha.1+atem"
            , "1.0.0-alpha.1"
            , "1.0.0-alpha.beta"
            , "1.0.0-beta"
            , "1.0.0-beta.2"
            , "1.0.0-beta.11"
            , "1.0.0-rc.1"
            , "1.0.0"
            , "2.0.0"
            , "2.1.0"
            , "2.1.1"
            ].map(Version.fromString);
        
        final sorted = versions.copy();
        sorted.sort(Version.compare);
        
        trace("original:\n" + versions.join("\n"));
        trace("sorted:\n" + sorted.join("\n"));
        
        for (i=>value in versions)
        {
            if (value != sorted[i])
                trace('Error comparing "$value" > "${sorted[i]}"');
        }
        
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
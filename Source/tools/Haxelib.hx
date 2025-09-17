package tools;


class FlxVersion extends AutoHaxelib<"flixel">
{
    override function toString()
    {
        if (branch == "master")
            return '$version';
        
        return super.toString();
    }
}

@:genericBuild(tools.macro.HaxelibUtil.build())
class AutoHaxelib<Const> extends Haxelib {}

class Haxelib
{
    public final version:Version;
    public final sha:Null<String>;
    public final branch:Null<String>;
    
    public inline function new (version, ?sha, ?branch)
    {
        this.version = version;
        this.sha = sha;
        this.branch = branch;
    }
    
    public function toString()
    {
        final displaySha = (sha == null ? "" : "@" + sha.substr(0, 7));
        final displayBranch = (branch == null ? "" : ' -$branch');
        return '$version$displaySha$displayBranch';
    }
}

class Version
{
    public final major:Int;
    public final minor:Int;
    public final patch:Int;
    public final prerelease:Null<String>;
    public final buildMetadata:Null<String>;
    
    public inline function new (major, minor, patch, ?prerelease, ?buildMetadata)
    {
        this.major = major;
        this.minor = minor;
        this.patch = patch;
        this.prerelease = prerelease;
        this.buildMetadata = buildMetadata;
    }
    
    inline public function toString()
    {
        final displayPrerelease = (prerelease == null ? "" : '-$prerelease');
        final displayMeta = (buildMetadata == null ? "" : '+$buildMetadata');
        return '$major.$minor.$patch$displayPrerelease$displayMeta';
    }
    
    inline public function greaterThan(v:Version)
    {
        return compare(this, v) > 0;
    }
    
    inline public function lessThan(v:Version)
    {
        return compare(this, v) < 0;
    }
    
    inline public function equals(v:Version)
    {
        return compare(this, v) == 0;
    }
    
    static public function fromString(ver:String)
    {
        final semver = tools.macro.HaxelibUtil.semver;
        if (false == semver.match(ver))
            throw '$ver is not a valid semver';
        
        return new Version
            ( Std.parseInt(semver.matched(1))
            , Std.parseInt(semver.matched(2))
            , Std.parseInt(semver.matched(3))
            , semver.matched(4)
            , semver.matched(5)
            );
    }
    
    static public function compare(a:Version, b:Version)
    {
        return if (a.major > b.major) 1;
        else   if (a.major < b.major) -1;
        else   if (a.minor > b.minor) 1;
        else   if (a.minor < b.minor) -1;
        else   if (a.patch > b.patch) 1;
        else   if (a.patch < b.patch) -1;
        else
            comparePrerelease(a.prerelease, b.prerelease);
    }
    
    static public function comparePrerelease(a:Null<String>, b:Null<String>):Int
    {
        return if (b == null) -1;
        else   if (a == null) 1;
        else
        {
            final splitA = a.split(".");
            final splitB = b.split(".");
            final lenA = splitA;
            final lenB = splitB;
            var diff = 0;
            final length = splitA.length > splitB.length ? splitA.length : splitB.length;
            for (i in 0...length)
            {
                if (splitA[i] == splitB[i])
                    continue;
                
                diff = if (splitA.length < i + 1) -1;
                else if (splitB.length < i + 1) 1;
                else comparePrereleaseIdentifier(splitA[i], splitB[i]);
                
                break;
            }
            diff;
        }
    }
    
    static final isInt = ~/^\d+$/;
    static public function comparePrereleaseIdentifier(a:String, b:String)
    {
        return switch [isInt.match(a), isInt.match(b)]
        {
            case [false, true ]:
                1;
            case [true , false]:
                -1;
            case [true , true]:
                Std.parseInt(a) - Std.parseInt(b);
            case [_, _]:
                a > b ? 1 : -1;
        }
    }
}
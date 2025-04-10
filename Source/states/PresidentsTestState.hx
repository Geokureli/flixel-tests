package states;

using StringTools;

class PresidentsTestState extends flixel.FlxState
{
    override function create()
    {
        final list = List.get();
        final listTrimmed = list.map(trim);
        final listSorted = listTrimmed.map(sortChars);
        final listChars = listSorted.map(uniqueChars);
        final total = sortChars(listSorted.join(""));
        
        final totalChars = total.length;
        final totalCharCount = getCharCounts(total);
        
        final listCount = [ for (i in 0...list.length) countMost(listSorted[i], listChars[i], totalCharCount) ];
        
        var maxList = 0;
        var maxTrimmed = 0;
        for (i in 0...list.length)
        {
            if (list[i].length > maxList)
                maxList = list[i].length;
            
            if (listTrimmed[i].length > maxTrimmed)
                maxTrimmed = listTrimmed[i].length;
        }
        
        final data =
        [
            for (i in 0...list.length)
            {
                { name   : list[i].lpad(" ", maxList)
                , trimmed: listTrimmed[i].lpad(" ", maxTrimmed)
                , sorted : listSorted[i].lpad(" ", maxTrimmed)
                , chars  : listChars[i].lpad(" ", maxTrimmed)
                , length : '${listTrimmed[i].length}'.lpad("", 2)
                , tips   : listCount[i]
                }
            }
        ];
        
        inline function count(char:Int)
        {
            return totalCharCount[char];
        }
        
        data.sort(function (a, b)
        {
            return switch [a.tips, b.tips]
            {
                case [Only(_, _), Counts(_)]:
                    -1;
                case [Counts(_), Only(_, _)]:
                    1;
                case [Only(_, aCount), Only(_, bCount)]:
                    bCount - aCount;
                case [Counts(_[0].count=>aCount), Counts(_[0].count=>bCount)] if (aCount != bCount):
                    bCount - aCount;
                case [Counts(_[1].count=>aCount), Counts(_[1].count=>bCount)] if (aCount != bCount):
                    bCount - aCount;
                case [Counts(count(_[0].char)=>aChar), Counts(count(_[0].char)=>bChar)] if (aChar != bChar):
                    bChar - aChar;
                case [Counts(count(_[1].char)=>aChar), Counts(count(_[1].char)=>bChar)] if (aChar != bChar):
                    bChar - aChar;
                default:
                    0;
            }
        });
        
        for (prez in data)
        {
            switch prez.tips
            {
                case Only(String.fromCharCode(_)=>char, _count):
                    trace('${prez.name}\t${prez.sorted}\t${prez.length}\t'
                        + 'No other has $_count $char');
                case Counts(counts):
                    final most = counts[0];
                    final second = counts[1];
                    trace('${prez.name}\t${prez.sorted}\t${prez.length}\t'
                        + '${most.count}${String.fromCharCode(most.char)} ${second.count}${String.fromCharCode(second.char)}');
            }
        }
    }
    
    static function getCharCounts(chars:String)
    {
        final counts = new Map<Int, Int>();
        for (c in 0...chars.length)
        {
            final char = chars.charCodeAt(c);
            if (counts.exists(char) == false)
                counts[char] = 0;
            
            counts[char]++;
        }
        
        return counts;
    }
    
    static function trim(name:String)
    {
        return name.split(".").join("").split(" ").join("").toLowerCase();
    }
    
    static function sortChars(name:String)
    {
        final chars = name.split("");
        chars.sort((a, b) -> a.charCodeAt(0) - b.charCodeAt(0));
        return chars.join("");
    }
    
    static function uniqueChars(sortedName:String)
    {
        var result = sortedName.charAt(0);
        for(i in 1...sortedName.length)
        {
            if (sortedName.charAt(i) != sortedName.charAt(i - 1))
                result += sortedName.charAt(i);
        }
        
        return result;
    }
    
    static function countMost(sortedName:String, chars:String, counts:Map<Int, Int>)
    {
        final charCounts = getCharCounts(sortedName);
        final sorted = new Array<CharCount>();
        for (c=>count in charCounts)
        {
            final char = String.fromCharCode(c);
            if (count * 2 > counts[c])
                return Only(c, count);
            
            sorted.push({char:c, count:count});
        }
        sorted.sort(function (a,b)
        {
            if (b.count != a.count)
                return b.count - a.count;
            
            return counts[b.char] - counts[a.char];
        });
        
        return Counts(sorted);
    }
}

typedef CharCount = {char:Int, count:Int};

enum CharInfo
{
    Only(char:Int, count:Int);
    Counts(counts:Array<CharCount>);
}

class List
{
  static public function get() return raw.split("\n");
}

final raw = 
"George Washington
John Adams
Thomas Jefferson
James Madison
James Monroe
John Quincy Adams
Andrew Jackson
Martin Van Buren
William Henry Harrison
John Tyler
James K. Polk
Zachary Taylor
Millard Fillmore
Franklin Pierce
James Buchanan
Abraham Lincoln
Andrew Johnson
Ulysses S. Grant
Rutherford B. Hayes
James A. Garfield
Chester A. Arthur
Thomas A. Hendricks
Benjamin Harrison
Grover Cleveland
William McKinley
Theodore Roosevelt
William Howard Taft
Woodrow Wilson
Warren G. Harding
Calvin Coolidge
Herbert Hoover
Franklin D. Roosevelt
Harry S. Truman
Dwight D. Eisenhower
John F. Kennedy
Lyndon B. Johnson
Richard Nixon
Gerald Ford
Jimmy Carter
Ronald Reagan
George H. W. Bush
Bill Clinton
George W. Bush
Barack Obama
Donald Trump
Joe Biden";
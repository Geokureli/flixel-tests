package states;

import flixel.FlxG;
import openfl.events.Event;

class BluePrinceTestState extends flixel.FlxState
{
    final chars =
        [ "ETPLRBSMUW"
        , "EWHANMRCOI"
        , "EDLASYIMBK"
        , "EK8ZSNMPOH"
        ];
    
    override function create()
    {
        super.create();
        
        final words = generateWords();
        
        for (a in 0...10)
        {
            final c0 = chars[0].charAt(a);
            for (b in 0...10)
            {
                final c1 = chars[1].charAt(b);
                for (c in 0...10)
                {
                    final c2 = chars[2].charAt(c);
                    for (d in 0...10)
                    {
                        final c3 = chars[3].charAt(d);
                        final word = '$c0$c1$c2$c3';
                        if (words.contains(word))
                            trace(word);
                    }
                }
            }
        }
    }
    
    static public function generateWords()
    {
        return FlxG.assets.getText("assets/data/4-letter-words.txt").split(" ");
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}
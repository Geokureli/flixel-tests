#!/bin/bash

echo "creating $1.hx"
echo "package states;

import flixel.FlxG;

class $1 extends flixel.FlxState
{
    override function create()
    {
        super.create();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}" > "Source/states/$1.hx"

#todo add to Source.Main.hx before "        //} endregion  Test States"
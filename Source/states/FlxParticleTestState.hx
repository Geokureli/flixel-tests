package states;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class FlxParticleTestState extends flixel.FlxState
{
    override function create()
    {
        new FlxEmitter();
    }
    
    override function update(elapsed)
    {
        super.update(elapsed);
    }
}

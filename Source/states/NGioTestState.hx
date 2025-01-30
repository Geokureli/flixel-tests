package states;

import flixel.FlxG;

class NGioTestState extends flixel.FlxState
{
    override function create()
    {
        super.create();
        
    }
}

import io.newgrounds.utils.ExternalAppList;

import io.newgrounds.Call;
import io.newgrounds.NG;
import io.newgrounds.NGLite;
import io.newgrounds.components.ScoreBoardComponent.Period;
import io.newgrounds.objects.Error;
import io.newgrounds.objects.Medal;
import io.newgrounds.objects.Score;
import io.newgrounds.objects.ScoreBoard;
import io.newgrounds.objects.events.Response;
import io.newgrounds.objects.events.Result;
import io.newgrounds.objects.events.Outcome;

import openfl.display.Stage;

import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

class NGio
{
	inline static var DEBUG_SESSION = #if NG_DEBUG true #else false #end;
    inline public static var API_ID = "55162:1upOg2fK";
    inline public static var ENC_KEY = "piZudF0Ym8YMEwxO8457Qw==";
	
	static var yuleDuel:ExternalApp;
	
	static public function attemptAutoLogin(callback:(LoginOutcome)->Void, passportHandler:((Bool)->Void)->Void) {
		
		trace('connecting to newgrounds, debug:$DEBUG_SESSION session:' + lastSessionId);
		NG.create(API_ID, lastSessionId, DEBUG_SESSION);
		NG.core.setupEncryption(ENC_KEY);
		#if NG_VERBOSE NG.core.verbose = true; #end
		
		// Add Yule Duel
		yuleDuel = NG.core.externalApps.add("57351:TNElixxi");
		
		NG.core.session.autoConnect(function (outcome)
		{
			switch outcome
			{
				case SUCCESS:
				case FAIL(error):
					throw 'Error logging in: $error';
			}
			callback(outcome);
		},
		(_)->passportHandler(function onClickDecide(connect)
		{
			if (connect)
				NG.core.openPassportUrl();
			else
				NG.core.session.cancel();
		}));
	}
	
	// --- MEDALS
	static function onMedalsRequested(outcome:Outcome<CallError>):Void
	{
		switch(outcome)
		{
			case SUCCESS: // nothing
			case FAIL(error):
				trace('ERROR loading medals: $error');
				return;
		}
		
		trace('loaded $numMedals medals, $numMedalsLocked locked ');
		
		checkYuleDuel();
	}
	
	static public function checkYuleDuel()
	{
		yuleDuel.medals.loadList((o)->switch o
		{
			case SUCCESS:
				for (medal in yuleDuel.medals)
				{
					trace('Yule Duel Medal[${medal.id}]: ${medal.name}');
				}
			case FAIL(error):
				trace('Error accessing Yule Duel medals, try again later\nError: ${error}');
		});
	}
}

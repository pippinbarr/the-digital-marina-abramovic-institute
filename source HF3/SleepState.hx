package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxG;


class SleepState extends FlxState
{
	private static var SLEEP_TIME:Float = 60*60;

	private var text:FlxText;

	private var timer:FlxTimer;


	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF000000;

		text = new FlxText(0,FlxG.height/2,FlxG.width,"");
		text.setFormat("Commodore",18,0xFFFFFFFF,"center");
		text.text = "You have fallen asleep.\n\nPlease come back in 1 hour";

		add(text);

		timer = FlxTimer.start(SLEEP_TIME, sleepFinished);
	}	


	private function sleepFinished(t:FlxTimer):Void
	{
		text.text = "Press ENTER to wake up.";
	}

	override public function destroy():Void
	{
		
	}

	override public function update():Void
	{
		if (timer.finished && FlxG.keyboard.pressed("ENTER"))
		{
			FlxG.switchState(new ParkingState());
			return;
		}
		else if (timer.finished) return;

		if (timer.timeLeft > 0)
		{
			if (Math.ceil(timer.timeLeft) >= 59*60)
			{
				text.text = "You have fallen asleep.\n\nYou can wake up in 1 hour.";		
			}
			else if (Math.ceil(timer.timeLeft) > 60)
			{
				text.text = "You have fallen asleep.\n\nYou can wake up in " + Math.ceil(timer.timeLeft / 60) + " minutes.";
			}
			else
			{
				if (Math.ceil(timer.timeLeft) != 1)
				{
					text.text = "You have fallen asleep.\n\nYou can wake up in " + Math.ceil(timer.timeLeft) + " seconds.";
				}
				else
				{
					text.text = "You have fallen asleep.\n\nYou can wake up in 1 second.";					
				}
			}
		}
		else if (Math.ceil(timer.timeLeft) == 0)
		{

		}
	}



}
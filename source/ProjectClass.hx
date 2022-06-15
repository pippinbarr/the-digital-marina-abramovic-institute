package;

import flash.Lib;
import flash.events.Event;

import org.flixel.FlxGame;
import org.flixel.FlxG;
import org.flixel.FlxSprite;

class ProjectClass extends FlxGame
{	
	private var focus:FlxSprite;

	public function new()
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		var ratioX:Float = stageWidth / 640;
		var ratioY:Float = stageHeight / 480;
		var ratio:Float = Math.min(ratioX, ratioY);

		super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), PerformanceState, ratio, 30, 30);
		// super(Math.ceil(stageWidth / ratio), Math.ceil(stageHeight / ratio), FeedbackState, ratio, 30, 30);

		if (!Helpers.sleepKeySetup) Helpers.setupSleepKeyListener();


		// this.useSoundHotKeys = false;
		FlxG.volume = 1.0;

		// FlxG.visualDebug = false;

		focus = new FlxSprite(0,0);
		focus.makeGraphic(FlxG.width,FlxG.height,0xFF000000);
	}
	

	override public function create(FlashEvent:Event):Void
	{
		super.create(FlashEvent);
		// stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
		// stage.removeEventListener(Event.ACTIVATE, onFocus);
	}


	override public function onFocusLost(e:Event = null):Void
	{
		// trace("Focus lost. Sleep key lost.");
		Helpers.focused = false;
		Helpers.sleepKeyIsDown = false;
		GameAssets.CURRENT_SLEEP_HELP = GameAssets.FOCUS_LOST_INSTRUCTION;
	}


	override public function onFocus(e:Event = null):Void
	{
		// trace("Focus gained. Sleep key lost.");
		Helpers.focused = true;
		Helpers.sleepKeyIsDown = false;
		GameAssets.CURRENT_SLEEP_HELP = GameAssets.WAKE_UP_INSTRUCTION;
	}
}

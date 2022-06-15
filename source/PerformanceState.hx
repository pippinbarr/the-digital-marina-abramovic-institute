package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;
import org.flixel.FlxObject;

import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.events.Event;


enum PerformanceStateState {
	INACTIVE;
	WAITING;
	DOOR_OPENING;
	WALKING_DOWN;
	WALKING_LEFT;
	PUNCHING;
	PHOTOGRAPH;
	WALKING_RIGHT;
	WALKING_UP;
	DOOR_CLOSING;
}

class PerformanceState extends ChamberState
{
	private static var PERFORMANCE_FRAMERATE:Int = 5;

	private var performanceBG:FlxSprite;
	private var avatarChair:Collidable;
	private var avatarChairTrigger:FlxSprite;

	private var timeClockDoorBG:FlxSprite;
	private var timeClockDoorFG:FlxSprite;
	private var tehChingWalk:Person;
	private var tehChingPunching:FlxSprite;
	private var tehChingHairState:Int = 0;
	private var tehChingLastHairState:Int = -1;

	private var goingUp:Bool = true;
	private var turningToRear:Bool = false;
	private var turningToNear:Bool = false;
	private var goingDown:Bool = false;

	private var NORMAL:Int = 0;
	private var SEATED:Int = 1;
	private var TITLE_MESSAGE:Int = 2;
	private var DESCRIPTION_MESSAGE:Int = 3;
	private var state:Int = 0; // Up to 7

	private var thePerformanceState:PerformanceStateState;

	private var photoTimer:FlxTimer;
	private var performTimer:FlxTimer;


	private var dateData:URLLoader;
	private var officialStartDate:Date;
	private var officialEndDate:Date;
	private var sessionStartDate:Date;
	private var sessionHours:Int = 0;


	private var timeDebugText:FlxText;


	override public function create():Void
	{
		super.create();	

		thePerformanceState = INACTIVE;

		// performanceBG = new FlxSprite(0,0,GameAssets.BG_PERFORMANCE_PNG);
		// Helpers.scaleSprite(performanceBG);

		if (Avatar.labcoat && Globals.enteringFrom == LEFT)
		{
			avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true);
		}
		else if (Avatar.labcoat && Globals.enteringFrom == RIGHT)
		{
			avatar = new Avatar(FlxG.width + 5,300,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,false);			
		}
		else
		{
			avatar = new Avatar(FlxG.width + 50,300,GameAssets.SS_BASIC_WALKCYCLE_PNG,false);						
		}
		avatar.frame = 20;
		

		timeClockDoorFG = new FlxSprite(200,0);
		timeClockDoorFG.loadGraphic(GameAssets.TIME_CLOCK_DOOR_FG,true,false,54,67);
		Helpers.scaleSprite(timeClockDoorFG);
		timeClockDoorFG.x = FlxG.width/2 - timeClockDoorFG.width/2;
		timeClockDoorFG.addAnimation("open",[0,1,2],5,false);
		timeClockDoorFG.addAnimation("close",[2,1,0],5,false);
		//timeClockDoorFG.play("open");

		timeClockDoorBG = new FlxSprite(200,0,GameAssets.TIME_CLOCK_DOOR_BG);
		Helpers.scaleSprite(timeClockDoorBG);
		timeClockDoorBG.x = timeClockDoorFG.x;

		tehChingWalk = new Person(340,180,GameAssets.TIME_CLOCK_WALKCYCLE);
		tehChingWalk.sprite.frame = 21;

		tehChingPunching = new FlxSprite(0,0);
		tehChingPunching.loadGraphic(GameAssets.TIME_CLOCK_PUNCHING,true,false,26,37);
		Helpers.scaleSprite(tehChingPunching);
		tehChingPunching.addAnimation("punch",[0,1,2,3,4,5,6,7,7,7,6,5,4,3,2,1,0],5,false);
		tehChingPunching.x = 208;
		tehChingPunching.y = 120;
		tehChingPunching.visible = false;

		bg.add(performanceBG);
		bg.add(timeClockDoorBG);
		bg.add(tehChingWalk);
		bg.add(tehChingWalk.sprite);
		bg.add(timeClockDoorFG);
		bg.add(tehChingPunching);

		add(avatar);

		display.add(avatar.sprite);

		makeAudience();

		audio = new HeadsetAudio([""]);

		canLeave = true;

		if (!Globals.inExercises)
		{
			canSleep = false;
		}

		maxWrapY = FlxG.height - 30;

		exitArrow.alpha = 0;
		exitText.alpha = 0;

		if (Globals.enteringFrom == LEFT)
		{
			walkIn(avatarChair.y + avatarChair.height);
		}
		else
		{
			walkIn(avatarChair.y + avatarChair.height,false);
		}

		photoTimer = new FlxTimer();
		performTimer = new FlxTimer();

		officialStartDate = new Date(2014,1,9,9,0,0);
		officialEndDate = new Date(2015,1,9,8,0,0);

		dateData = new URLLoader();
		dateData.addEventListener(Event.COMPLETE,dateLoadComplete);

		thePerformanceState = WAITING;

		// dateData.load(new URLRequest("get_date.php"));
	}


	private function dateLoadComplete(e:Event):Void
	{
		sessionStartDate = Date.fromTime((dateData.data * 1000));

		var secondsToGo:Int = 3600 - (sessionStartDate.getMinutes() * 60) - sessionStartDate.getSeconds();
		var runTimeMillis:Float = sessionStartDate.getTime() - officialStartDate.getTime();
		var runTime:Float = runTimeMillis / 1000;

		// timeDebugText.text = "" +
		// "Timer set to " + secondsToGo + " seconds.\n" + 
		// "Official start date is " + officialStartDate.toString() + "\n" +
		// "Session start date is " + sessionStartDate.toString() + "\n" +
		// "Performance has run for " + runTime + " seconds." + 
		// "or " + runTime / 60 / 60 / 24 + " days.";

		if (sessionStartDate.getTime() > officialEndDate.getTime()) return;

		if (sessionStartDate.getMinutes() == 0 && sessionStartDate.getSeconds() == 0)
		{
			perform(null);
		}
		else
		{
			performTimer.start(3600 - (sessionStartDate.getMinutes() * 60) - (sessionStartDate.getSeconds()),1,perform);
		}
	}


	private function perform(t:FlxTimer):Void
	{
		sessionHours++;


		// Check whether the performance is actually still running
		if (sessionStartDate.getTime() + (3600000 * sessionHours) > officialEndDate.getTime()) return;


		// Set the performance in motion and set the next timer
		thePerformanceState = WAITING;
		performTimer.start(3600,1,perform);

		var runTimeMillis:Float = sessionStartDate.getTime() - officialStartDate.getTime();
		var runTime:Float = runTimeMillis / 1000;

		// Set the correct hair length from 0 -> 9
		var totalPerformanceTime:Float = officialEndDate.getTime() - officialStartDate.getTime();
		var percentComplete:Float = runTimeMillis / totalPerformanceTime;

		tehChingHairState = Math.floor(percentComplete * 10);
		if (tehChingHairState == 10) tehChingHairState = 9;

		// timeDebugText.text = "" +
		// "Timer set to 3600 seconds.\n" + 
		// "Performance has run for " + runTime + " seconds.\n" + 
		// "or " + runTime / 60 / 60 / 24 + " days.\n" + 
		// "or " + percentComplete + " complete.\n" +
		// "Hair state is " + tehChingHairState;
	}


	private function makeAudience():Void
	{
		var leftMargin:Float = 24;
		var topMargin:Float = 350;
		var xSpace:Float = 54;

		for (i in 0...11)
		{
			if (i == 0 || i == 1) continue;
			if (i == 10 || i == 9) continue;
			if (i == 4)
			{
				var avatarChairSprite:Sortable = new Sortable(leftMargin + xSpace*i,320);
				avatarChairSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_PNG,true,false,10,30,true);
				Helpers.recolourPersonAsAvatar(avatarChairSprite,false);
				Helpers.recolourPersonAsAvatar(avatarChairSprite,true);
				Helpers.scaleSprite(avatarChairSprite);

				avatarChair = new Collidable(leftMargin + xSpace*i,320,avatarChairSprite,1.0);
				avatarChair.sprite.frame = 0;
				display.add(avatarChair.sprite);
				collidables.add(avatarChair);

				avatarChairTrigger = new FlxSprite(avatarChair.sprite.x,avatarChair.sprite.y + avatarChair.sprite.height);
				avatarChairTrigger.makeGraphic(Math.floor(avatarChair.sprite.width),20,0xFF00FF00);
				// add(avatarChairTrigger);
			}
			else
			{
				var audienceMemberSprite:Sortable = new Sortable(leftMargin + xSpace*i,340);
				audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_PNG,true,false,10,30,true);
				Helpers.scaleSprite(audienceMemberSprite);

				var audienceMember:Collidable = new Collidable(leftMargin + xSpace*i,320,audienceMemberSprite,1.0);			
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.frame = 1;

				display.add(audienceMember.sprite);
				collidables.add(audienceMember);
			}
		}


		for (i in 2...6)
		{
			var audienceMemberSprite:Sortable = new Sortable(leftMargin,140 + 30*i);
			audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_RIGHT_PNG,true,false,14,30,true);
			Helpers.randomColourPerson(audienceMemberSprite);
			Helpers.scaleSprite(audienceMemberSprite);

			var audienceMember:Collidable = new Collidable(leftMargin,140 + 30*i,audienceMemberSprite,1.0);			
			audienceMember.sprite.frame = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.frame = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.frame = 1;
			}

			var audienceMemberSprite:Sortable = new Sortable(leftMargin + 60,140 + 30*i);
			audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_RIGHT_PNG,true,false,14,30,true);
			Helpers.randomColourPerson(audienceMemberSprite);
			Helpers.scaleSprite(audienceMemberSprite);
			display.add(audienceMemberSprite);

			var audienceMember:Collidable = new Collidable(leftMargin + 60,140 + 30*i,audienceMemberSprite,1.0);			
			audienceMember.sprite.frame = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.frame = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.frame = 1;
			}

			var audienceMemberSprite:Sortable = new Sortable(600,140 + 30*i);
			audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_LEFT_PNG,true,false,14,30,true);
			Helpers.randomColourPerson(audienceMemberSprite);
			Helpers.scaleSprite(audienceMemberSprite);

			var audienceMember:Collidable = new Collidable(560,140 + 30*i,audienceMemberSprite,1.0);			
			audienceMember.sprite.frame = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.frame = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.frame = 1;
			}

			var audienceMemberSprite:Sortable = new Sortable(476,140 + 30*i);
			audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_LEFT_PNG,true,false,14,30,true);
			Helpers.randomColourPerson(audienceMemberSprite);
			Helpers.scaleSprite(audienceMemberSprite);
			display.add(audienceMemberSprite);

			var audienceMember:Collidable = new Collidable(494,140 + 30*i,audienceMemberSprite,1.0);			
			audienceMember.sprite.frame = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.frame = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.frame = 1;
			}

		}
	}

	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		avatarChair.destroy();
		avatarChairTrigger.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		handlePerformance();

		super.update();	
	}


	private function handlePerformance():Void
	{

		switch (thePerformanceState) 
		{
			case INACTIVE:


			case WAITING:

			if (true)
			{
				setupTehChingHair();
				tehChingWalk.facing = FlxObject.DOWN;
				timeClockDoorFG.play("open");
				thePerformanceState = DOOR_OPENING;
			}

			case DOOR_OPENING:

			if (timeClockDoorFG.finished)
			{
				tehChingWalk.moveDown();
				thePerformanceState = WALKING_DOWN;
			}

			case WALKING_DOWN:

			if (tehChingWalk.y + tehChingWalk.height >= timeClockDoorFG.y + timeClockDoorFG.height - 16)
			{
				tehChingWalk.moveLeft();
				timeClockDoorFG.visible = false;
				thePerformanceState = WALKING_LEFT;
			}

			case WALKING_LEFT:

			if (tehChingWalk.x <= timeClockDoorBG.x + 36)
			{
				tehChingWalk.idle();
				tehChingWalk.sprite.visible = false;
				tehChingPunching.visible = true;
				tehChingPunching.play("punch");
				thePerformanceState = PUNCHING;
				//tehChingWalk.moveRight();
				//thePerformanceState = WALKING_RIGHT;
			}

			case PUNCHING:

			if (tehChingPunching.finished)
			{
				tehChingPunching.visible = false;
				tehChingWalk.x += 12;
				tehChingWalk.y -= 6;
				tehChingWalk.sprite.visible = true;
				tehChingWalk.facing = FlxObject.DOWN;
				photoTimer.start(1.5,1,takePhoto);

				thePerformanceState = PHOTOGRAPH;
			}

			case PHOTOGRAPH:

			case WALKING_RIGHT:

			if (tehChingWalk.x >= 340)
			{
				timeClockDoorFG.visible = true;
				tehChingWalk.moveUp();
				thePerformanceState = WALKING_UP;
			}

			case WALKING_UP:

			if (tehChingWalk.y <= 180)
			{
				tehChingWalk.idle();
				timeClockDoorFG.play("close");
				thePerformanceState = DOOR_CLOSING;
			}

			case DOOR_CLOSING:

			if (timeClockDoorFG.finished)
			{
				tehChingWalk.facing = FlxObject.DOWN;
				// thePerformanceState = INACTIVE;
				thePerformanceState = WAITING;
				tehChingHairState = (tehChingHairState + 1) % 9;
			}
		}	
	}


	private function takePhoto(t:FlxTimer):Void
	{
		FlxG.camera.flash(0xFFFFFFFF,0.2);
		photoTimer.start(1,1,postPhoto);
	}


	private function postPhoto(t:FlxTimer):Void
	{
		tehChingWalk.moveRight();
		thePerformanceState = WALKING_RIGHT;
	}



	private function setupTehChingHair():Void
	{
		if (tehChingHairState == tehChingLastHairState) return;

		tehChingWalk.sprite.loadGraphic(GameAssets.TIME_CLOCK_WALKCYCLE,true,false,14,35,true);
		Helpers.scaleSprite(tehChingWalk.sprite);

		tehChingPunching.loadGraphic(GameAssets.TIME_CLOCK_PUNCHING,true,false,26,37,true);
		Helpers.scaleSprite(tehChingPunching);

		switch (tehChingHairState)
		{
			case 0:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0x00000000);
			tehChingPunching.replaceColor(0xFFFF0000,0x00000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFFad8e64);
			tehChingPunching.replaceColor(0xFF800080,0xFFad8e64);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFFad8e64);
			tehChingPunching.replaceColor(0xFF0000ff,0xFFad8e64);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0x00000000);
			tehChingPunching.replaceColor(0xFF00ff00,0x00000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0x00000000);
			tehChingPunching.replaceColor(0xFFFFff00,0x00000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0x00000000);
			tehChingPunching.replaceColor(0xFFff8000,0x00000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0x00000000);
			tehChingPunching.replaceColor(0xFF00ffff,0x00000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0x00000000);
			tehChingPunching.replaceColor(0xFFff00ff,0x00000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0x00000000);
			tehChingPunching.replaceColor(0xFFFFffff,0x00000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xffad8e64);
			tehChingPunching.replaceColor(0xFFff6699,0xffad8e64);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff517b7d);
			tehChingPunching.replaceColor(0xFF99ff99,0xff517b7d);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);

			case 1:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFFad8e64);
			tehChingPunching.replaceColor(0xFF0000ff,0xFFad8e64);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0x00000000);
			tehChingPunching.replaceColor(0xFF00ff00,0x00000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0x00000000);
			tehChingPunching.replaceColor(0xFFFFff00,0x00000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0x00000000);
			tehChingPunching.replaceColor(0xFFff8000,0x00000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0x00000000);
			tehChingPunching.replaceColor(0xFF00ffff,0x00000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0x00000000);
			tehChingPunching.replaceColor(0xFFff00ff,0x00000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0x00000000);
			tehChingPunching.replaceColor(0xFFFFffff,0x00000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xffad8e64);
			tehChingPunching.replaceColor(0xFFff6699,0xffad8e64);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff517b7d);
			tehChingPunching.replaceColor(0xFF99ff99,0xff517b7d);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);

			case 2:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0x00000000);
			tehChingPunching.replaceColor(0xFFFFff00,0x00000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0x00000000);
			tehChingPunching.replaceColor(0xFFff8000,0x00000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0x00000000);
			tehChingPunching.replaceColor(0xFF00ffff,0x00000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0x00000000);
			tehChingPunching.replaceColor(0xFFff00ff,0x00000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0x00000000);
			tehChingPunching.replaceColor(0xFFFFffff,0x00000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xffad8e64);
			tehChingPunching.replaceColor(0xFFff6699,0xffad8e64);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff517b7d);
			tehChingPunching.replaceColor(0xFF99ff99,0xff517b7d);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);

			case 3:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFff00,0xFF000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0x00000000);
			tehChingPunching.replaceColor(0xFFff8000,0x00000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0x00000000);
			tehChingPunching.replaceColor(0xFF00ffff,0x00000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0x00000000);
			tehChingPunching.replaceColor(0xFFff00ff,0x00000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0x00000000);
			tehChingPunching.replaceColor(0xFFFFffff,0x00000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xffad8e64);
			tehChingPunching.replaceColor(0xFFff6699,0xffad8e64);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff517b7d);
			tehChingPunching.replaceColor(0xFF99ff99,0xff517b7d);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);

			case 4:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFff00,0xFF000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0xFF000000);
			tehChingPunching.replaceColor(0xFFff8000,0xFF000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0x00000000);
			tehChingPunching.replaceColor(0xFF00ffff,0x00000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0x00000000);
			tehChingPunching.replaceColor(0xFFff00ff,0x00000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0x00000000);
			tehChingPunching.replaceColor(0xFFFFffff,0x00000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xffad8e64);
			tehChingPunching.replaceColor(0xFFff6699,0xffad8e64);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff517b7d);
			tehChingPunching.replaceColor(0xFF99ff99,0xff517b7d);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);

			case 5:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFff00,0xFF000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0xFF000000);
			tehChingPunching.replaceColor(0xFFff8000,0xFF000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ffff,0xFF000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0x00000000);
			tehChingPunching.replaceColor(0xFFff00ff,0x00000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0x00000000);
			tehChingPunching.replaceColor(0xFFFFffff,0x00000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xff000000);
			tehChingPunching.replaceColor(0xFFff6699,0xff000000);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff517b7d);
			tehChingPunching.replaceColor(0xFF99ff99,0xff517b7d);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);

			case 6:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFff00,0xFF000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0xFF000000);
			tehChingPunching.replaceColor(0xFFff8000,0xFF000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ffff,0xFF000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0xFF000000);
			tehChingPunching.replaceColor(0xFFff00ff,0xFF000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0x00000000);
			tehChingPunching.replaceColor(0xFFFFffff,0x00000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xff000000);
			tehChingPunching.replaceColor(0xFFff6699,0xff000000);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff000000);
			tehChingPunching.replaceColor(0xFF99ff99,0xff000000);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);			

			case 7:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFff00,0xFF000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0xFF000000);
			tehChingPunching.replaceColor(0xFFff8000,0xFF000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ffff,0xFF000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0xFF000000);
			tehChingPunching.replaceColor(0xFFff00ff,0xFF000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFffff,0xFF000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0x00000000);
			tehChingPunching.replaceColor(0xFF996633,0x00000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xff000000);
			tehChingPunching.replaceColor(0xFFff6699,0xff000000);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff000000);
			tehChingPunching.replaceColor(0xFF99ff99,0xff000000);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);	

			case 8:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFff00,0xFF000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0xFF000000);
			tehChingPunching.replaceColor(0xFFff8000,0xFF000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ffff,0xFF000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0xFF000000);
			tehChingPunching.replaceColor(0xFFff00ff,0xFF000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFffff,0xFF000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0xFF000000);
			tehChingPunching.replaceColor(0xFF996633,0xFF000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xff000000);
			tehChingPunching.replaceColor(0xFFff6699,0xff000000);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff000000);
			tehChingPunching.replaceColor(0xFF99ff99,0xff000000);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff517b7d);
			tehChingPunching.replaceColor(0xFF6699ff,0xff517b7d);

			case 9:
			// Shortest top hair (red)
			tehChingWalk.sprite.replaceColor(0xFFFF0000,0xFF000000);
			tehChingPunching.replaceColor(0xFFFF0000,0xFF000000);

			// Shortest side hair (dark purple)
			tehChingWalk.sprite.replaceColor(0xFF800080,0xFF000000);
			tehChingPunching.replaceColor(0xFF800080,0xFF000000);

			// Sideburn (blue)
			tehChingWalk.sprite.replaceColor(0xFF0000ff,0xFF000000);
			tehChingPunching.replaceColor(0xFF0000ff,0xFF000000);

			// Longer front hair (green)
			tehChingWalk.sprite.replaceColor(0xFF00ff00,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ff00,0xFF000000);

			// Longest top hair (yellow)
			tehChingWalk.sprite.replaceColor(0xFFFFff00,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFff00,0xFF000000);

			// Longest front hair (orange)
			tehChingWalk.sprite.replaceColor(0xFFff8000,0xFF000000);
			tehChingPunching.replaceColor(0xFFff8000,0xFF000000);

			// Fuller body hair (cyan)
			tehChingWalk.sprite.replaceColor(0xFF00ffff,0xFF000000);
			tehChingPunching.replaceColor(0xFF00ffff,0xFF000000);

			// More volume hair (bright purple)
			tehChingWalk.sprite.replaceColor(0xFFff00ff,0xFF000000);
			tehChingPunching.replaceColor(0xFFff00ff,0xFF000000);

			// Longer at the bottom (white)
			tehChingWalk.sprite.replaceColor(0xFFFFffff,0xFF000000);
			tehChingPunching.replaceColor(0xFFFFffff,0xFF000000);

			// Longest at the bottom (brown)
			tehChingWalk.sprite.replaceColor(0xFF996633,0xFF000000);
			tehChingPunching.replaceColor(0xFF996633,0xFF000000);

			// Back of head complete hair (pink)
			tehChingWalk.sprite.replaceColor(0xFFff6699,0xff000000);
			tehChingPunching.replaceColor(0xFFff6699,0xff000000);

			// Top of shirt hair cover (light green)
			tehChingWalk.sprite.replaceColor(0xFF99ff99,0xff000000);
			tehChingPunching.replaceColor(0xFF99ff99,0xff000000);

			// Bottom of shirt hair cover (nice blue)
			tehChingWalk.sprite.replaceColor(0xFF6699ff,0xff000000);
			tehChingPunching.replaceColor(0xFF6699ff,0xff000000);											
		}

		tehChingLastHairState = tehChingHairState;

		// tehChingHairState = (tehChingHairState + 1) % 10;
	}


	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;

		if (state == NORMAL && avatar.overlaps(avatarChairTrigger) && FlxG.keys.justPressed("ENTER"))
		{
			avatar.idle();
			avatar.sprite.visible = false;
			avatarMovementEnabled = false;
			if (Avatar.labcoat)
			avatarChair.sprite.frame = 1;
			else
			avatarChair.sprite.frame = 2;

			// message.setup("In the Field\n\nLynsey Peisinger\n\n(First performed at Kunstfest Weimar, 2012.)");

			// help.setText(GameAssets.CONTINUE_INSTRUCTION);

			help.setText("Press SPACE for information about the performance." + "\n" + GameAssets.STAND_INSTRUCTION);
			state = SEATED;
		}
		else if (state == SEATED && FlxG.keys.justPressed("ENTER"))
		{
			avatar.sprite.visible = true;
			avatarMovementEnabled = true;
			avatarChair.sprite.frame = 0;

			help.setText(GameAssets.SIT_INSTRUCTION + "\n" + GameAssets.PERFORMANCE_EXIT_INSTRUCTION);
			state = NORMAL;
		}
		else if (state == SEATED && FlxG.keys.justPressed("SPACE"))
		{
			message.setup("One Year Performance 1980-1981 (Time Clock Piece)\n\nTehching \"Sam\" Hsieh\n\nOriginally performed 11 April 1980 to 11 April 1981");
			help.setText(GameAssets.CONTINUE_INSTRUCTION);
			state = TITLE_MESSAGE;
		}

		return true;
	}


	override public function handleMessageInput():Bool
	{
		if (!super.handleMessageInput()) return false;

		if (state == TITLE_MESSAGE && FlxG.keys.justPressed("ENTER"))
		{
			state = DESCRIPTION_MESSAGE;
			message.setVisible(false);
			message.setup("For one year, Hsieh punches a time clock every hour on the hour. Each time he punches the clock, a single picture of him is taken, which together will yield a 6 minute movie. He shaved his head before the piece, so his growing hair reflects the passage of time.\n\nThis digital performance began on XX March 2014 and will continue until XX March 2015.");
			help.setText(GameAssets.CONTINUE_INSTRUCTION);
		}
		else if (state == DESCRIPTION_MESSAGE && FlxG.keys.justPressed("ENTER"))
		{
			state = SEATED;
			message.setVisible(false);
			help.setText("Press SPACE for information about the performance." + "\n" + GameAssets.STAND_INSTRUCTION);
		}

		return true;
	}



	override public function handleTriggers():Bool
	{
		if (!super.handleTriggers()) return false;

		if (avatar.sprite.visible && avatar.overlaps(avatarChairTrigger))
		{
			help.setText(GameAssets.SIT_INSTRUCTION + "\n" + GameAssets.PERFORMANCE_EXIT_INSTRUCTION);
		}
		else if (avatar.sprite.visible)
		{
			help.setText(GameAssets.PERFORMANCE_EXIT_INSTRUCTION);
		}

		return true;

	}


	override private function nextState(t:FlxTimer):Void
	{
		super.nextState(t);

		Globals.enteringFrom = LEFT;

		if (Globals.inExercises)
		{
			FlxG.switchState(new FeedbackState());
		}
		else
		{
			FlxG.switchState(new ScienceState());
		}
	}	
}

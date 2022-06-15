package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;
import org.flixel.FlxSound;
import org.flixel.plugin.photonstorm.FlxCollision;


class EntranceState extends FlxState
{
	private static var AVATAR_SPEED:Float = 100;

	private var display:FlxGroup;

	private var timer:FlxTimer;

	private var sky:FlxSprite;
	private var currentSky:String;
	private var darkness:FlxSprite;
	private var lastHour:Int = -1;

	private var bg:FlxSprite;
	private var fg:FlxSprite;
	private var hm:FlxSprite;
	private var doorTrigger:FlxSprite;
	private var doors:Sortable;

	private var avatar:Avatar;

	private var message:Message;
	private var help:HelpBar;
	private var focusHelp:HelpBar;

	private var wantToLeave:Bool = false;
	private var kickstarterVisible:Bool = false;
	private var movementEnabled:Bool = false;

	private static var WALK_IN:Int = 0;
	private static var PLAY:Int = 1;
	private static var INSIDE:Int = 2;
	private static var TRANSITION:Int = 2;
	private var state:Int = 0;

	private var closing:Bool = false;


	override public function create():Void
	{
		FlxG.bgColor = 0xFFb2b2b2;

		timer = new FlxTimer();

		display = new FlxGroup();

		sky = new FlxSprite(0,0,GameAssets.ENTRANCE_SKY_DAY_PNG);
		sky.setOriginToCorner();
		sky.scale.x = 4; sky.scale.y = 4;
		
		bg = new FlxSprite(0,0,GameAssets.ENTRANCE_BG_PNG);
		Helpers.scaleSprite(bg);

		fg = new FlxSprite(0,0,GameAssets.ENTRANCE_FG_PNG);
		Helpers.scaleSprite(fg);

		hm = new FlxSprite(0,0,GameAssets.ENTRANCE_HM_PNG);
		hm.setOriginToCorner();

		doors = new Sortable(0,0);
		doors.loadGraphic(GameAssets.DOORS_PNG,true,false,35*4,40*4);
		// Helpers.scaleSprite(doors);
		doors.x = FlxG.width / 2 - doors.width / 2 - 2;
		doors.y = 276;
		doors.addAnimation("open",[0,1,2,3,4,5],10,false);
		doors.addAnimation("close",[5,4,3,2,1,0],10,false);
		doors.origin.y = 1.0;


		doorTrigger = new FlxSprite(250,405);
		doorTrigger.makeGraphic(140,50,0xFFFF0000);


		avatar = new Avatar(-100,460,GameAssets.SS_BASIC_WALKCYCLE_PNG,false);
		avatar.moveRight();

		help = new HelpBar("",Globals.HELP_Y);
		message = new Message();

		focusHelp = new HelpBar("",Globals.SLEEP_HELP_Y);
		focusHelp.setText(GameAssets.FOCUS_INSTRUCTION);
		focusHelp.visible = false;

		display.add(doors);
		display.add(avatar.sprite);

		add(sky);
		add(bg);
		add(avatar);
		add(display);
		add(fg);


		darkness = new FlxSprite(0,0);
		darkness.makeGraphic(FlxG.width,FlxG.height,0xFF000000);
		darkness.alpha = 0;
		add(darkness);

		add(help);
		add(focusHelp);

		handleSky();

		Globals.arriveTime = Date.now();

		help.visible = Globals.HELP_VISIBLE;
		// audio.visible = Globals.AUDIO_VISIBLE;

		
	}


	override public function destroy():Void
	{
		bg.destroy();
		fg.destroy();
		display.destroy();
		hm.destroy();

		timer.destroy();

		sky.destroy();
		darkness.destroy();

		doorTrigger.destroy();
		doors.destroy();
		avatar.destroy();

		message.destroy();
		help.destroy();
		focusHelp.destroy();

		super.destroy();
	}

	override public function update():Void
	{
		handleSky();

		// txt.text = data.data + "";

		focusHelp.visible = !Helpers.focused;
		if (focusHelp.visible) FlxG.mouse.show();
		else FlxG.mouse.hide();

		if (FlxG.paused)
		{
			handleMessageInput();
			return;
		}

		super.update();

		if (state == WALK_IN && avatar.x >= 50)
		{
			avatar.idle();
			movementEnabled = true;
			state = PLAY;
			help.setText(GameAssets.WALK_INSTRUCTION);
		}

		if (!movementEnabled) return;

		handleCollisions();
		handleInput();

		display.sort();
	}	

	private function handleInput():Void
	{
		// if (FlxG.keys.TAB)
		// {
		// 	FlxG.switchState(new TestMenuState());
		// }

		if (state == INSIDE || state == TRANSITION) return;

		// IGNORE INPUT WHEN IN THE MIDDLE OF LOOPING
		if (avatar.x + avatar.width/2 < 0 || avatar.x + avatar.width/2 > FlxG.width) return;

		if (avatar.y > FlxG.height) return;

		if (!movementEnabled) return;

		avatar.handleInput();
	}


	private function handleMessageInput():Void
	{
		if (FlxG.keys.justPressed("ENTER"))
		{
			message.setVisible(false);
			kickstarterVisible = false;
		}
	}


	private function nextState(t:FlxTimer):Void
	{
		Globals.enteringFrom = BOTTOM;
		FlxG.switchState(new ReceptionState());
	}

	private function handleCollisions():Void
	{

		if (doors.frame == 0 && !movementEnabled)
		{
			closing = false;

		}

		if (!movementEnabled) return;

		// DON'T RUN INTO THE HITMAP
		if (FlxCollision.pixelPerfectCheck(avatar,hm))
		{
			avatar.undoAndStop();
		}

		if (FlxCollision.pixelPerfectCheck(avatar,doors))
		{
			avatar.undoAndStop();
		}



		// DON'T WALK OFF THE BOTTOM
		// if (avatar.y + avatar.height >= FlxG.height) avatar.undoAndStop();

		// WRAP AROUND THE EDGES
		if (avatar.x > FlxG.width + avatar.width)
		{
			avatar.x = 0 - avatar.width;
		}

		if (avatar.x < 0 - avatar.width)
		{
			avatar.x = FlxG.width + avatar.width;
		}

		if (avatar.sprite.y > FlxG.height)
		{
			if (Math.random() > 0.5)
			{
				avatar.x = -100;
				avatar.y = FlxG.height - 20;
				avatar.moveRight();
			}
			else
			{
				avatar.x = FlxG.width + 100;
				avatar.y = FlxG.height - 20;
				avatar.moveLeft();
			}
		}

		// TRIGGER THE DOOR MESSAGE
		if (avatar.overlaps(doorTrigger))
		{
			if (doors.frame == 0 && avatar.y >= FlxG.height - 100)
			{
				doors.play("open");
			}
		}
		else if (doors.frame == 5)
		{
			doors.play("close");
			closing == true;

			if (avatar.y < FlxG.height - 80)
			{
				avatar.moveUp();
				movementEnabled = false;
				state = TRANSITION;
				timer.start(1,1,nextState);
				help.fadeOut();
			}
		}
	}

	private function handleSky():Void
	{
		var newSky:String = chooseSky();

		if (currentSky != newSky)
		{
			sky.loadGraphic(newSky);
			sky.setOriginToCorner();

			if (newSky == GameAssets.ENTRANCE_SKY_NIGHT_PNG)
			{
				darkness.alpha = 0.75;
			}
			else if (newSky == GameAssets.ENTRANCE_SKY_EVENING_PNG ||
				newSky == GameAssets.ENTRANCE_SKY_EARLY_MORNING_PNG)
			{
				darkness.alpha = 0.25;
			}
			else
			{
				darkness.alpha = 0;
			}
		}

	}

	private function chooseSky():String
	{
		var date:Date = Date.now();
		var hour:Int = date.getHours();

		if (hour == lastHour) return currentSky;

		var skyString:String = "";

		if (hour > 19 || (hour >= 0 && hour <= 4))
		{
			skyString = GameAssets.ENTRANCE_SKY_NIGHT_PNG;
		}
		else if (hour > 16)
		{
			skyString = GameAssets.ENTRANCE_SKY_EVENING_PNG;
		}
		else if (hour > 8)
		{
			skyString = GameAssets.ENTRANCE_SKY_DAY_PNG;
		}
		else if (hour > 6)
		{
			skyString = GameAssets.ENTRANCE_SKY_MORNING_PNG;
		}
		else if (hour > 4)
		{
			skyString = GameAssets.ENTRANCE_SKY_EARLY_MORNING_PNG;
		}

		lastHour = hour;

		return skyString;
	}
}


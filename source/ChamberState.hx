package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;

import org.flixel.plugin.photonstorm.FlxCollision;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;


class ChamberState extends FlxState
{
	private static var ROOM_TIME:Float = 120;

	private var maxWrapY:Float = 0;

	private var walkInState:Bool = false;
	private var walkInFromLeft:Bool;
	private var fadingOut:Bool = false;
	private var wrapEnabled:Bool = true;
	private var wrapping:Bool = false;
	private var avatarMovementEnabled:Bool = true;
	private var canLeave:Bool = false;
	private var canSleep:Bool = true;
	private var audioCompletes:Bool = true;

	private var avatar:Avatar;

	private var bg:FlxGroup;
	private var display:FlxGroup;
	private var fg:FlxGroup;
	private var focus:FlxGroup;

	private var bgImage:FlxSprite;
	private var backWall:Collidable;

	private var collidables:FlxGroup;
	
	private var audio:HeadsetAudio;
	private var help:HelpBar;
	private var sleepHelp:HelpBar;
	private var focusHelp:HelpBar;

	private var roomTimer:FlxTimer;
	private var timer:FlxTimer;

	private var message:Message;

	private var prevHelp:Bool = false;
	private var prevMessage:Bool = false;
	private var prevAudio:Bool = true;

	private var prevHelpString:String;
	private var prevMessageString:String;
	private var sleeping:Bool = false;
	private var sleepSprite:Sprite;
	private var sleepTimer:FlxTimer;

	private var prevAvatarVX:Float = 0;
	private var prevAvatarVY:Float = 0;

	private var exitArrow:FlxSprite;
	private var exitText:FlxText;

	private var focusMessageWasVisible:Bool = false;
	private var focusHelpWasVisible:Bool = false;

	override public function create():Void
	{
		super.create();
		
		FlxG.bgColor = 0xFF444444;

		bg = new FlxGroup();
		display = new FlxGroup();
		fg = new FlxGroup();
		focus = new FlxGroup();

		collidables = new FlxGroup();

		bgImage = new FlxSprite(0,0,GameAssets.BG_STANDARD_CHAMBER_PNG);
		Helpers.scaleSprite(bgImage);

		var wallSprite:Sortable = new Sortable(0,0);
		wallSprite.loadGraphic(GameAssets.BG_STANDARD_WALL_PNG,false,false);
		Helpers.scaleSprite(wallSprite);

		backWall = new Collidable(0,0,wallSprite,1);

		message = new Message();
		timer = new FlxTimer();
		roomTimer = new FlxTimer();
		help = new HelpBar(GameAssets.WALK_INSTRUCTION,Globals.HELP_Y);
		sleepHelp = new HelpBar(GameAssets.WAKE_UP_INSTRUCTION,Globals.SLEEP_HELP_Y);
		focusHelp = new HelpBar("",Globals.SLEEP_HELP_Y);
		focusHelp.setText(GameAssets.FOCUS_INSTRUCTION);
		focusHelp.visible = false;
		focus.add(focusHelp);

		exitArrow = new FlxSprite(0,0,GameAssets.EXIT_ARROW_PNG);
		Helpers.scaleSprite(exitArrow);
		exitArrow.y = FlxG.height / 3;
		exitArrow.x = FlxG.width - exitArrow.width - 16;
		exitArrow.alpha = 0.75;

		exitText = new FlxText(exitArrow.x - 10,exitArrow.y + 16,Math.floor(exitArrow.width),"NEXT");
		exitText.setFormat("Commodore",14,0xFFFFFFFF,"center");

		exitArrow.visible = false;
		exitText.visible = false;

		sleepSprite = new Sprite();
		sleepSprite.addChild(new Bitmap(new BitmapData(FlxG.width,FlxG.height,false,0x000000)));
		sleepSprite.alpha = 0.0;

		bg.add(bgImage);
		bg.add(backWall);

		fg.add(help);
		fg.add(sleepHelp);
		fg.add(exitArrow);
		fg.add(exitText);

		collidables.add(backWall);

		add(bg);
		add(display);
		add(fg);
		add(focus);

		maxWrapY = FlxG.height / 2 + 10;

		FlxG.stage.addChild(sleepSprite);

		FlxG.paused = false;
	}
	
	
	override public function destroy():Void
	{
		bg.destroy();
		display.destroy();
		fg.destroy();
		focus.destroy();
		collidables.destroy();

		bgImage.destroy();

		backWall.destroy();

		message.destroy();
		timer.destroy();
		roomTimer.destroy();
		help.destroy();
		sleepHelp.destroy();
		focusHelp.destroy();

		exitArrow.destroy();
		exitText.destroy();

		FlxG.stage.removeChild(sleepSprite);

		super.destroy();
	}


	override public function update():Void
	{
		if (!canSleep && !focusHelp.visible && !Helpers.focused)
		{
			FlxG.mouse.show();
			focusHelpWasVisible = help.visible;
			help.visible = false;
			focusHelp.visible = true;
			focusMessageWasVisible = message.buffer.visible;
			message.buffer.visible = false;
			// trace("Lost focus.");
		}
		else if (!canSleep && focusHelp.visible && Helpers.focused)
		{
			FlxG.mouse.hide();
			help.visible = focusHelpWasVisible;
			focusHelp.visible = false;
			if (focusMessageWasVisible) message.buffer.visible = true;
			// trace("Regained focus.");
		}


		if (FlxG.paused)
		{			
			handleSleepInput();
			handleMessageInput();
			help.update();
			return;
		}

		super.update();

		if (audio.canLeave && audioCompletes)
		{
			canLeave = true;
		}
		
		if (canLeave)
		{
			exitArrow.visible = true;
			exitText.visible = true;
		}

		if (walkInState && 
			((walkInFromLeft && avatar.x >= 50) ||
			 (!walkInFromLeft && avatar.x <= FlxG.width - (50 + avatar.width))))
		{
			avatar.idle();
			avatarMovementEnabled = true;
			walkInState = false;
			prevAvatarVX = 0;
			prevAvatarVY = 0;
			// help.fadeIn();
		}

		handleSleepInput();
		handleCollisions();
		handleTriggers();
		handleInput();

		if (sleeping)
		{
			sleepSprite.alpha += Globals.SLEEP_INCREMENT;
			if (sleepSprite.alpha >= 1.0)
			{
				Helpers.lastAvatarY = -1;
				FlxG.switchState(new SleepState());
			}
		}

		display.sort("sortID");
	}	


	public function handleSleepInput():Void
	{
		if (!canSleep) return;

		sleepHelp.setTextNoFade(GameAssets.CURRENT_SLEEP_HELP);

		if (!Helpers.sleepKeyIsDown && !sleeping)
		{
			prevMessage = message.isVisible();
			message.setVisible(false);

			sleeping = true;

			prevHelp = help.visible;
			help.visible = false;

			prevAudio = audio.visible;
			audio.visible = false;

			sleepHelp.fadeIn();

			prevAvatarVX = avatar.velocity.x;
			prevAvatarVY = avatar.velocity.y;

			if (!walkInState)
			{
				avatar.idle();
			}
		}
		else if (Helpers.sleepKeyIsDown && sleeping)
		{			
			message.setVisible(prevMessage);

			sleepSprite.alpha = 0.0;

			sleeping = false;
			sleepHelp.fadeOut();

			help.visible = prevHelp;
			audio.visible = prevAudio;

			if (avatar.sprite.visible)
			{
				if (prevAvatarVX > 0) avatar.moveRight();
				else if (prevAvatarVX < 0) avatar.moveLeft();
				else if (prevAvatarVY > 0) avatar.moveDown();
				else if (prevAvatarVY < 0) avatar.moveUp();
				else avatar.idle();
			}

			if (walkInState) avatar.moveRight();
		}
	}


	public function handleInput():Bool
	{
		// if (FlxG.keys.justPressed("TAB"))
		// {
		// 	FlxG.switchState(new TestMenuState());
		// }

		if (walkInState) return false;
		if (sleeping) return false;
		if (wrapping) return false;
		if (!avatarMovementEnabled) return true;

		avatar.handleInput();

		return true;
	}


	public function handleMessageInput():Bool
	{
		if (walkInState) return false;
		if (sleeping) return false;

		return true;
	}


	private function avatarWrapping():Bool
	{
		return wrapEnabled && wrapping;
	}


	private function handleCollisions():Bool
	{
		if (sleeping) return false;
		if (walkInState) return false;

		// DON'T RUN INTO COLLIDABLES

		if (avatar.overlaps(collidables))
		{
			// trace("collided.");
			avatar.undoAndStop();
		}


		// WRAP AROUND THE EDGES IF ENABLED

		if (wrapping)
		{
			// trace("... Wrapping...");
			if (avatar.velocity.x > 0 && avatar.x + avatar.width/2 >= 0 && avatar.x < FlxG.width/2)
			{
				// trace("... avatar came in from LEFT, ending wrap...");
				avatar.idle();
				avatarMovementEnabled = true;
				wrapping = false;
			}
			else if (avatar.velocity.x < 0 && avatar.x + avatar.width/2 <= FlxG.width && avatar.x > FlxG.width/2)
			{
				// trace("... avatar came in from RIGHT, ending wrap...");
				avatar.idle();
				avatarMovementEnabled = true;
				wrapping = false;
			}
			else if (avatar.velocity.x < 0 && avatar.x + avatar.width < 0)
			{
				// trace("... avatar is off LEFT moving LEFT, so moving to RIGHT...");
				avatar.x = FlxG.width;
			}
			else if (avatar.velocity.x > 0 && avatar.x > FlxG.width)
			{
				// trace("... avatar is off RIGHT moving RIGHT, so moving to LEFT...");
				if (canLeave)
				{
					wrapping = false;
					avatarMovementEnabled = false;
					avatar.idle();
					Helpers.lastAvatarY = avatar.y;
					fadeToNextState();
				}
				else
				{
					avatar.x = 0 - avatar.width;
				}
			}
			else if	(avatar.sprite.y > FlxG.height)
			{
				// trace("... avatar is off BOTTOM, so moving to random side...");
				if (Math.random() > 0.5)
				{
					// trace("... moved to LEFT side.");
					avatar.x = 0 - avatar.width;
					avatar.y = maxWrapY + Math.min((Math.random() * (FlxG.height - maxWrapY)),FlxG.height - avatar.height);
					avatar.moveRight();
					avatar.velocity.x = Person.SPEED;
					avatar.velocity.y = 0;
					// trace("... y=" + avatar.y + ",x=" + avatar.x + ",vx=" + avatar.velocity.x + ",vy=" + avatar.velocity.y);

				}
				else
				{
					// trace("... moved to RIGHT side.");
					avatar.x = FlxG.width;
					avatar.y = maxWrapY + Math.min((Math.random() * (FlxG.height - maxWrapY)),FlxG.height - avatar.height);
					avatar.moveLeft();
					avatar.velocity.x = -Person.SPEED;
					avatar.velocity.y = 0;
					// trace("... y=" + avatar.y + ",x=" + avatar.x + ",vx=" + avatar.velocity.x + ",vy=" + avatar.velocity.y);
				}
			}
		}

		if (wrapEnabled && !wrapping && !walkInState)
		{
			// AVATAR IS OFF THE LEFT SIDE
			if (avatar.x  + avatar.width / 2 < 0 && avatar.velocity.x < 0)
			{
				// trace("... avatar off LEFT, starting wrap...");
				avatar.moveLeft();
				avatar.velocity.x = -Person.SPEED;

				avatarMovementEnabled = false;
				wrapping = true;
			}
			else if (avatar.x + avatar.width / 2 > FlxG.width && avatar.velocity.x > 0)
			{
				// trace("... avatar off RIGHT, starting wrap...");
				// if (!canLeave)
				{
					// trace("In here. canLeave is " + canLeave);
					avatar.moveRight();
					avatar.velocity.x = Person.SPEED;

					avatarMovementEnabled = false;
					wrapping = true;
				}
				// else if (!fadingOut)
				// {
				// 	// avatarMovementEnabled = false;
				// 	// avatar.idle();
				// 	// Helpers.lastAvatarY = avatar.y;
				// 	// fadeToNextState();
				// }
			}

			if (avatar.y > FlxG.height)
			{
				// trace("... avatar off BOTTOM, starting wrap...");
				wrapping = true;
				avatar.velocity.y = Person.SPEED;
				avatar.velocity.x = 0;
				avatarMovementEnabled = false;
			}
		}

		return true;
	}




	private function fadeToNextState():Void
	{
		fadingOut = true;
		avatarMovementEnabled = false;
		avatar.idle();
		// FlxG.fade(0xFF000000,1);
		timer.start(1,1,nextState);

		sleeping = false;
	}


	private function nextState(t:FlxTimer):Void
	{
		Helpers.lastAvatarY = avatar.y;
	}


	private function handleTriggers():Bool
	{
		return !walkInState && !sleeping;
	}


	private function walkIn(MinY:Float = -1,FromLeft:Bool = true):Void
	{
		avatarMovementEnabled = false;
		if (MinY == -1) avatar.y = 460;
		else if (Helpers.lastAvatarY != -1 && Helpers.lastAvatarY > MinY) avatar.y = Helpers.lastAvatarY;
		else if (Helpers.lastAvatarY != -1) avatar.y = MinY;
		else avatar.y = 460;
		if (FromLeft)
			avatar.moveRight();
		else
			avatar.moveLeft();
		walkInState = true;
		walkInFromLeft = FromLeft;
		help.setInvisible();
		maxWrapY = MinY;
		
		if (maxWrapY == -1) maxWrapY = 460;
	}

}

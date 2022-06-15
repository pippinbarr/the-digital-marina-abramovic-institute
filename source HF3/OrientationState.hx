package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;


enum OrientationStateState
{
	START;
	PRE_TV;
	TV;
	POST_TV_MESSAGE;
	CAN_LEAVE;
	KEY_WARNING;
	KEY_EXPLANATION;
	WRAP_MESSAGE;
}


class OrientationState extends ChamberState
{
	private var state:OrientationStateState;
	private var wrapPreviousState:OrientationStateState;

	private var listeningToAudio:Bool = false;

	private var bottomWrapping:Bool = false;

	private var firstWrap:Bool = true;

	private var tv:Sortable;
	private var tvTrigger:FlxSprite;

	override public function create():Void
	{
		super.create();

		Globals.inExercises = true;

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);

		add(avatar);

		display.add(avatar.sprite);

		tv = new Sortable(0,0);
		tv.loadGraphic(GameAssets.ORIENTATION_TV_PNG,true,false,33,23);
		Helpers.scaleSprite(tv);
		tv.animation.add("talking",[1,1,2,1,2,1,2,2,1,1,1,2,1,2,1,2],10,true);
		tv.animation.add("off",[0,0],10,true);
		tv.animation.add("not talking",[1,1],10,true);
		tv.animation.play("off");
		tv.x = FlxG.width/2 - tv.width/2;
		tv.y = 80;
		display.add(tv);

		tvTrigger = new FlxSprite(tv.x,backWall.height);
		tvTrigger.makeGraphic(Std.int(tv.width),40,0xFFFF0000);
		// add(tvTrigger);

		wrapEnabled = true;
		avatarMovementEnabled = true;
		canSleep = false;

		audio = new HeadsetAudio(Audio.LOREM_IPSUM);

		audioCompletes = false;

		state = START;

		walkIn(backWall.height);
	}




	override public function destroy():Void
	{
		avatar.destroy();

		if (audio != null) audio.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (listeningToAudio && audio.canLeave && !canLeave)
		{
			message.setup("One last thing. While you are at the digital institute you will need to hold the SHIFT key down to show that you are awake and committed. If you release the SHIFT key for too long you will fall asleep for an hour and miss out on the remaining exercises. Please begin now.");
			help.setText("Hold the SHIFT key to remain awake and committed.");
			state = POST_TV_MESSAGE;

			tv.animation.play("not talking");

			canLeave = true;
			firstWrap = false;
		}
	}	


	private function nextChamber(t:FlxTimer):Void
	{
		FlxG.switchState(new RampState());
	}



	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;
		if (avatar.y > FlxG.width) return false;
		
		return true;
	}


	override public function handleTriggers():Bool
	{
		if (!super.handleTriggers()) return false;

		if (state == START && avatar.overlaps(tvTrigger))
		{
			state = PRE_TV;
			tv.animation.play("not talking");
			timer = FlxTimer.start(2,startAudio);
		}

		return true;
	}


	private function startAudio(t:FlxTimer):Void
	{
			state = TV;
			tv.animation.play("talking");
			fg.remove(audio);
			audio = new HeadsetAudio(Audio.INTRODUCTION_AUDIO);
			// audio = new HeadsetAudio(Audio.LOREM_IPSUM);
			fg.add(audio);
			listeningToAudio = true;
	}


	override public function handleMessageInput():Bool
	{
		if (!super.handleMessageInput()) return false;

		if (state == POST_TV_MESSAGE && Helpers.sleepKeyIsDown)
		{
			avatarMovementEnabled = true;
			message.setVisible(false);
			// help.setText(GameAssets.WALK_INSTRUCTION);
			help.fadeOut();
			state = CAN_LEAVE;
			canSleep = true;
		}
		else if (state == KEY_WARNING && Helpers.sleepKeyIsDown && Helpers.focused)
		{
			avatarMovementEnabled = true;
			message.setVisible(false);
			// help.setText(GameAssets.WALK_INSTRUCTION);
			help.fadeOut();
			state = CAN_LEAVE;	
			canSleep = true;		
		}
		else if (state == WRAP_MESSAGE && FlxG.keyboard.justPressed("ENTER"))
		{
			// trace("Setting message to invisible, wrapping up, etc.");
			message.setVisible(false);
			avatarMovementEnabled = true;
			help.fadeOut();
			state = wrapPreviousState;
		}
		
		return true;
	}



	override private function handleCollisions():Bool
	{
		if (sleeping) return false;


		// DON'T RUN INTO COLLIDABLES

		if (avatar.overlaps(collidables))
		{
			avatar.undoAndStop();
		}

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

				}
				else
				{
					// trace("... moved to RIGHT side.");
					avatar.x = FlxG.width;
					avatar.y = maxWrapY + Math.min((Math.random() * (FlxG.height - maxWrapY)),FlxG.height - avatar.height);
					avatar.moveLeft();
					avatar.velocity.x = -Person.SPEED;
					avatar.velocity.y = 0;
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
					avatar.moveRight();
					avatar.velocity.x = Person.SPEED;

					avatarMovementEnabled = false;
					wrapping = true;
				}
			}

			if (avatar.y > FlxG.height)
			{
				// trace("... avatar off BOTTOM, starting wrap...");
				wrapping = true;
				avatar.velocity.y = Person.SPEED;
				avatarMovementEnabled = false;
			}
		}

		if (wrapping && firstWrap && !audio.canLeave)
		{
			avatarMovementEnabled = false;
			firstWrap = false;
			help.setText("Press ENTER to continue.");
			wrapPreviousState = state;
			state = WRAP_MESSAGE;
			message.setup("" +
				"Please note, while in the exercise chambers of the Digital Marina Abramovic Institute " +
				"you won't be able to leave a chamber until instructed over your headphones."
				);
		}

		return true;
	}


	override private function nextState(t:FlxTimer):Void
	{
		super.nextState(t);
		FlxG.switchState(new RampState());
	}

}



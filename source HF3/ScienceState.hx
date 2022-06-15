package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;


enum ScienceStateState
{
	TRY_PASSWORD;
	CANT_TRY_PASSWORD;
	ATTENDANT_INFORMATION;
	PRE_PASSWORD;
	PASSWORD;
	PASSWORD_REQUIRED;
	PASSWORD_CORRECT;
	PASSWORD_INCORRECT;
	PASSWORD_CANCEL;
	POST_PASSWORD;
	PRE_RACER;
	RACER;
	STOPPING;
	GET_OFF;
	POST_RACER;
}


class ScienceState extends ChamberState
{
	public static var passwordEntered:Bool = false;


	private static var PASSWORD_HASH:String = "0659de079d45e6de9a72f23e5d31048dddd19b58";
	private static var PASSWORD_HASH_NO_QUESTION:String = "6317513c96b7900cdaa873909b8baece6cc3416a";

	private static var otherArrowPositions:Array<Array<Int>> = [
	[11*8*4 + 4*4,4*8*4 + 1*4],
	[11*8*4 + 2*4,5*8*4],
	[11*8*4,5*8*4 + 4*4],
	[9*8*4 + 5*4,5*8*4 + 5*4],
	[8*8*4 + 1*4,5*8*4 + 4*4],
	[7*8*4 + 7*4,5*8*4],
	[7*8*4 + 5*4,4*8*4 + 1*4],
	[7*8*4 + 7*4,4*8*4],
	[8*8*4 + 2*4,3*8*4 + 3*4],
	[9*8*4 + 5*4,3*8*4],
	[10*8*4 + 7*4,3*8*4 + 3*4],
	[11*8*4 + 3*4,4*8*4],
	];
	private static var avatarArrowPositions:Array<Array<Int>> = [
	[15*8*4 + 4*4,4*8*4 + 1*4],
	[14*8*4 + 5*4,6*8*4 + 2*4],
	[12*8*4 + 5*4,7*8*4],
	[9*8*4 + 5*4,6*8*4 + 7*4],
	[6*8*4 + 3*4,7*8*4],
	[4*8*4 + 4*4,6*8*4 + 2*4],
	[3*8*4 + 6*4,4*8*4 + 1*4],
	[4*8*4 + 5*4,3*8*4],
	[6*8*4 + 5*4,2*8*4 + 3*4],
	[9*8*4 + 5*4,1*8*4 + 6*4],
	[12*8*4 + 5*4,2*8*4 + 3*4],
	[14*8*4 + 5*4,3*8*4],
	];

	private var state:ScienceStateState;

	private var frames:Int = 0;

	private var racer:Sortable;
	private var racerAvatar:Sortable;
	private var racerTrigger:FlxSprite;
	private var racerMoving:Bool = false;
	private var racerSpeed:Float = 60;
	private var racerTimer:FlxTimer;

	private var attendant:Person;
	private var attendantTrigger:FlxSprite;
	private var fenceBlock:Collidable;

	private var password:TextEntry;
	private var passwordForm:FlxGroup;

	private var walkInFromRightState:Bool = false;


	// ARROWS
	private static var RIGHT_ARROW:Int = 0;
	private static var DOWN_ARROW:Int = 1;
	private static var LEFT_ARROW:Int = 2;
	private static var UP_ARROW:Int = 3;
	private var arrowsAvatar:FlxSprite;
	private var arrowsOther:FlxSprite;

	private var matchThisFrame:Bool = false;



	override public function create():Void
	{
		super.create();

		backWall.y -= 60;

		bg.remove(bgImage);
		bgImage = new FlxSprite(0,0,GameAssets.BG_SCIENCE_PNG);
		Helpers.scaleSprite(bgImage);
		bg.add(bgImage);

		if (Avatar.labcoat && Globals.enteringFrom == RIGHT)
		{
			avatar = new Avatar(FlxG.width + 50,backWall.height,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true);						
		}
		else if (Avatar.labcoat && Globals.enteringFrom == LEFT)
		{
			avatar = new Avatar(-100,backWall.height,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true);						
		}
		else if (!Avatar.labcoat && Globals.enteringFrom == RIGHT)
		{
			avatar = new Avatar(FlxG.width + 50,backWall.height,GameAssets.SS_BASIC_WALKCYCLE_PNG,false);			
		}
		else
		{
			avatar = new Avatar(-100,backWall.height,GameAssets.SS_BASIC_WALKCYCLE_PNG,false);			
		}

		createPasswordForm();

		add(avatar);
		display.add(avatar.sprite);

		attendant = new Person(220,380,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG);
		Helpers.randomColourPerson(attendant.sprite);
		display.add(attendant.sprite);
		attendant.idle();
		attendant.facing = FlxObject.DOWN;
		attendant.handleAnimation();

		var racerYOffset:Int = -40;

		// pole = new Sortable(0,0,GameAssets.POLE_PNG);
		// Helpers.scaleSprite(pole);
		// pole.x = FlxG.width / 2 - pole.width / 2 + 2;
		// pole.y = 0 + racerYOffset;
		// // pole.sortID = pole.y + pole.height - 6;
		// pole.sortID = pole.y + pole.height - 10;

		var racerSortable:Sortable = new Sortable(0,0);
		racerSortable.makeGraphic(8 * 5 * 4,10,0xFFFF0000);
		racerSortable.x = FlxG.width/2 + 48;
		racerSortable.y = FlxG.height/2 + 40;
		var racerCollidable:Collidable = new Collidable(racerSortable.x,racerSortable.y,racerSortable,1);

		// display.add(racerCollidable.sprite);
		collidables.add(racerCollidable);

		racerTrigger = new FlxSprite(racerSortable.x + 50,racerSortable.y - 20);
		racerTrigger.makeGraphic(Std.int(racerSortable.width - 100),Std.int(40 + racerSortable.height),0xFFFF0000);
		// add(racerTrigger);


		racer = new Sortable(0,0,GameAssets.COMPATABILITY_RACER_PNG);
		racer.loadGraphic(GameAssets.COMPATABILITY_RACER_PNG,true,false,160,120);
		Helpers.randomColourPerson(racer);
		Helpers.scaleSprite(racer);
		// racer.animation.add("spinning",[0,1,2,3,4,5,6,7,8,9,10,11],10,true);
		racer.x = 0;
		racer.y = 0 + racerYOffset;
		racer.sortID = racerSortable.y;

		racerAvatar = new Sortable(0,0,GameAssets.COMPATABILITY_RACER_AVATAR_LABCOAT_SPIN_PNG);
		if (Avatar.labcoat)
		{
			racerAvatar.loadGraphic(GameAssets.COMPATABILITY_RACER_AVATAR_LABCOAT_SPIN_PNG,true,false,160,120);
			Helpers.recolourPersonAsAvatar(racerAvatar,true);
		}
		else
		{
			racerAvatar.loadGraphic(GameAssets.COMPATABILITY_RACER_AVATAR_CIVVIES_SPIN_PNG,true,false,160,120);
			Helpers.recolourPersonAsAvatar(racerAvatar,false);
		}
		Helpers.scaleSprite(racerAvatar);
		racerAvatar.x = 0;
		racerAvatar.y = 0 + racerYOffset;
		racerAvatar.sortID = racer.sortID;


		// racer.play("spinning");
		// racer.frameIndex = 8;


		var fenceLeftSprite:Sortable = new Sortable(0,0,GameAssets.FENCE_LEFT_PNG);
		Helpers.scaleSprite(fenceLeftSprite);
		var fenceLeft:Collidable = new Collidable(0,400,fenceLeftSprite,0.2);

		var fenceRightSprite:Sortable = new Sortable(0,0,GameAssets.FENCE_RIGHT_PNG);
		Helpers.scaleSprite(fenceRightSprite);
		var fenceRight:Collidable = new Collidable(FlxG.width - fenceRightSprite.width,400,fenceRightSprite,0.2);

		var fenceBlockSprite:Sortable = new Sortable(0,0);
		fenceBlockSprite.makeGraphic(Std.int(FlxG.width - fenceLeftSprite.width - fenceRightSprite.width),8,0xFFFF0000);
		fenceBlock = new Collidable(fenceLeft.x + fenceLeft.width,fenceLeft.y,fenceBlockSprite,1);

		attendantTrigger = new FlxSprite(Std.int(fenceBlock.x - fenceBlock.width/2),fenceBlock.y);
		attendantTrigger.makeGraphic(Std.int(fenceBlock.sprite.width),15,0xFFFF0000);


		createArrows();

		// display.add(pole);
		display.add(racer);
		racerAvatar.visible = false;
		display.add(racerAvatar);
		display.add(fenceLeft.sprite);
		display.add(fenceRight.sprite);
		// add(attendantTrigger);
		// display.add(fenceBlock.sprite);

		collidables.add(fenceLeft);
		collidables.add(fenceRight);

		if (!ScienceState.passwordEntered)
		{
			collidables.add(fenceBlock);
		}
		collidables.add(attendant);


		wrapEnabled = true;
		avatarMovementEnabled = true;
		canSleep = false;
		canLeave = false;

		audio = new HeadsetAudio([""]);

		if (!ScienceState.passwordEntered)
		{
			state = TRY_PASSWORD;
		}
		else 
		{
			state = PRE_RACER;
		}


		racerTimer = FlxTimer.start(5,changeRacerSpeed);


		if (Globals.enteringFrom == LEFT)
		{
			walkIn(fenceRight.y + fenceRight.height + 5);
		}
		else
		{
			walkIn(fenceRight.y + fenceRight.height + 5,false);
		}
	}


	private function createArrows():Void
	{
		arrowsAvatar = new Sortable(0,0);
		arrowsAvatar.loadGraphic(GameAssets.GAZE_ARROWS_PNG,true,false,7,7,false);
		Helpers.scaleSprite(arrowsAvatar);
		arrowsAvatar.visible = false;
		add(arrowsAvatar);

		arrowsOther = new Sortable(0,0);
		arrowsOther.loadGraphic(GameAssets.GAZE_ARROWS_PNG,true,false,7,7,false);
		Helpers.scaleSprite(arrowsOther);
		arrowsOther.visible = false;
		add(arrowsOther);
	}


	private function createPasswordForm():Void
	{
		passwordForm = new FlxGroup();

		var passwordFormSprite:FlxSprite = new FlxSprite(0,0,GameAssets.PASSWORD_FORM_PNG);
		Helpers.scaleSprite(passwordFormSprite);
		passwordFormSprite.x = FlxG.width/2 - passwordFormSprite.width / 2;
		passwordFormSprite.y = FlxG.height/2 - passwordFormSprite.height/2;

		var passwordPrompt:FlxText = new FlxText(passwordFormSprite.x + 20,passwordFormSprite.y + 30,FlxG.width,"PASSWORD: ",32,true);
		passwordPrompt.setFormat("Commodore",16,0xFF555555,"left");

		password = new TextEntry(passwordFormSprite.x + 140,passwordFormSprite.y + 30,FlxG.width - 400,12);
		password.setFormat("Commodore",16,0xFF000000,"left");
		password.disable();

		passwordForm.add(passwordFormSprite);
		passwordForm.add(passwordPrompt);
		passwordForm.add(password);

		passwordForm.visible = false;

		fg.add(passwordForm);
	}


	override public function destroy():Void
	{
		avatar.destroy();

		password.destroy();
		passwordForm.destroy();

		arrowsAvatar.destroy();
		arrowsOther.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (walkInFromRightState && avatar.x <= FlxG.width - 50)
		{
			avatar.idle();
			avatarMovementEnabled = true;
			walkInFromRightState = false;
			prevAvatarVX = 0;
			prevAvatarVY = 0;
			// help.fadeIn();
		}

		if (racerMoving)
		{

			frames++;

			if (frames > racerSpeed)
			{
				frames = 0;
				racer.animation.frameIndex = (racer.animation.frameIndex + 1) % racer.animation.frames;
				racerAvatar.animation.frameIndex = racer.animation.frameIndex;
			}

			updateArrows();

		}

	}	


	private function updateArrows():Void
	{
		arrowsAvatar.x = avatarArrowPositions[racer.animation.frameIndex][0];// - arrowsAvatar.width/2;
		arrowsAvatar.y = avatarArrowPositions[racer.animation.frameIndex][1] - 40;// - arrowsAvatar.height/2 - 40;

		arrowsOther.x = otherArrowPositions[racer.animation.frameIndex][0];// - arrowsOther.width/2;
		arrowsOther.y = otherArrowPositions[racer.animation.frameIndex][1] - 40;// - arrowsOther.height/2 - 40;
	}


	private function changeRacerSpeed(t:FlxTimer):Void
	{
			
	}


	private function nextChamber(t:FlxTimer):Void
	{
		FlxG.switchState(new PerformanceState());
	}



	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;
		if (avatar.y > FlxG.width) return false;

		if (state == PASSWORD && FlxG.keyboard.justPressed("ENTER"))
		{
			if (password.text.length == 12 &&
				haxe.crypto.Sha1.encode(password.text.substring(0,11)) == PASSWORD_HASH_NO_QUESTION)
			{
				password.disable();
				passwordForm.visible = false;
				state = PASSWORD_CORRECT;
				help.setText("Press ENTER to continue.");
				message.setup("That is correct.");

				ScienceState.passwordEntered = true;
			}
			else
			{
				password.disable();
				passwordForm.visible = false;
				state = PASSWORD_INCORRECT;
				help.setText("Press ENTER to try again.\nPress ESCAPE to stop.");
				message.setup("That is incorrect.");
			}
		}

		
		return true;
	}


	override public function handleTriggers():Bool
	{
		if (!super.handleTriggers()) return false;

		if (!ScienceState.passwordEntered && state == TRY_PASSWORD && avatar.overlaps(attendantTrigger))
		{
			state = ATTENDANT_INFORMATION;
			message.setup("Hi there.\n\nMAI has been working with neuroscientists to develop interactive installations. Here you can experience the compatibility racer, a project by Lauren Silbert, Jennifer Silbert, Suzanne Dikker, Matthias Oostrik, and Oliver Hess.");
			avatar.idle();
			avatar.facing = FlxObject.UP;
			avatar.handleAnimation();
			avatarMovementEnabled = false;
			help.setText("Press ENTER to continue.");
		}
		else if (state == PRE_RACER && avatar.overlaps(racerTrigger))
		{
			help.setText("Press ENTER to get onto the compatability racer.");
			if (FlxG.keyboard.justPressed("ENTER"))
			{
				avatar.sprite.visible = false;
				avatarMovementEnabled = false;
				// racer.play("spinning");
				racerMoving = true;
				racerAvatar.visible = true;
				arrowsAvatar.visible = true;
				arrowsOther.visible = true;

				state = RACER;

				timer = FlxTimer.start(0.5,showNewArrow);
			}
		}
		else if (state == RACER)
		{
			help.setText("Press ENTER at any time to stop the compatability racer.\nPress matching ARROW KEYS to synchronize with your partner.");

			handleRacerArrows();

			if (FlxG.keyboard.justPressed("ENTER"))
			{
				racerTimer.abort();
				state = STOPPING;

				timer.abort();
				arrowsAvatar.visible = false;
				arrowsOther.visible = false;

				help.setText("Please wait for the Racer to come to a complete stop.");
			}
		}
		else if (state == STOPPING && racerSpeed < 15)
		{
			if (Math.random() > 0.75)
			{
				racerSpeed = Math.min(racerSpeed + 0.5,15);
			}
		}
		else if (state == STOPPING && racerSpeed >= 15 && racer.animation.frameIndex == 0)
		{
			racer.animation.frameIndex = 0;
			racerMoving = false;
			state = GET_OFF;
		}
		else if (state == GET_OFF)
		{
			help.setText("Press ENTER to get off the compatability racer.");
			if (FlxG.keyboard.justPressed("ENTER"))
			{
				avatar.sprite.visible = true;
				avatarMovementEnabled = true;
				racerAvatar.visible = false;
				state = POST_RACER;
				help.fadeOut();
			}
		}
		else if (state == PRE_RACER && !avatar.overlaps(racerTrigger))
		{
			help.fadeOut();
			state = PRE_RACER;
		}
		else if (state == CANT_TRY_PASSWORD && !avatar.overlaps(attendantTrigger))
		{
			state = TRY_PASSWORD;
		}

		return true;
	}


	private function handleRacerArrows():Void
	{
		matchThisFrame = false;

		if (FlxG.keyboard.pressed("LEFT"))
		{
			arrowsAvatar.visible = true;
			arrowsAvatar.animation.frameIndex = LEFT_ARROW;
			if (arrowsOther.animation.frameIndex == LEFT_ARROW) matchThisFrame = true;
		}
		else if (FlxG.keyboard.pressed("RIGHT"))
		{
			arrowsAvatar.visible = true;

			arrowsAvatar.animation.frameIndex = RIGHT_ARROW;
			if (arrowsOther.animation.frameIndex == RIGHT_ARROW) matchThisFrame = true;
		}
		else if (FlxG.keyboard.pressed("UP"))
		{
			arrowsAvatar.visible = true;

			arrowsAvatar.animation.frameIndex = UP_ARROW;
			if (arrowsOther.animation.frameIndex == UP_ARROW) matchThisFrame = true;
		}
		else if (FlxG.keyboard.pressed("DOWN"))
		{
			arrowsAvatar.visible = true;

			arrowsAvatar.animation.frameIndex = DOWN_ARROW;
			if (arrowsOther.animation.frameIndex == DOWN_ARROW) matchThisFrame = true;
		}
		else
		{
			arrowsAvatar.visible = false;
		}

		if (matchThisFrame)
		{
			racerSpeed = Math.max(racerSpeed - 0.075,1);
		}
		else
		{
			racerSpeed = Math.min(racerSpeed + 0.075,120);
		}
	}


	private function showNewArrow(t:FlxTimer):Void
	{
		var index:Int = Math.floor(Math.random() * 4);
		arrowsOther.animation.frameIndex = index;
		arrowsOther.visible = true;

		timer = FlxTimer.start(3,showNewArrow);
	}


	override public function handleMessageInput():Bool
	{
		if (!super.handleMessageInput()) return false;


		if (state == ATTENDANT_INFORMATION && FlxG.keyboard.justPressed("ENTER"))
		{
			message.setVisible(false);
			message.setup("The compatibility racer is a cart controlled by the brainwaves of two drivers.\n\nYou simply put on the EEG cap and sit in the racer. The alignment of your brainwaves with your partner's will determine its speed.");
			help.setText("Press ENTER to continue.");
			state = PASSWORD_REQUIRED;
		}
		else if (state == PASSWORD_REQUIRED && FlxG.keyboard.justPressed("ENTER"))
		{
			message.setVisible(false);
			message.setup("The compatability racer is only available to Kickstarter backers.\n\nIf you are a backer, you will have received a password...");
			help.setText("Press ENTER to type in the password.\nPress ESCAPE if you do not have the password.");
			state = PRE_PASSWORD;
		}
		else if (state == PRE_PASSWORD && FlxG.keyboard.justPressed("ENTER"))
		{
			message.setVisible(false);
			state = PASSWORD;
			avatarMovementEnabled = false;
			passwordForm.visible = true;
			password.enable();
			help.setText("Type the password. (Maximum of 12 letters.)\nThen press ENTER.");
		}
		else if (state == PRE_PASSWORD && FlxG.keyboard.justPressed("ESCAPE"))
		{
			message.setVisible(false);
			state = PASSWORD_CANCEL;
			avatarMovementEnabled = false;
			message.setup("No problem. Feel free to go to the performance space to the left, or head back to reception to your right.");
			help.setText("Press ENTER to continue.");

		}
		else if (state == PASSWORD_CORRECT && FlxG.keyboard.justPressed("ENTER"))
		{
			// trace("Password correct and moving on.");
			message.setVisible(false);
			message.setup("Your partner is already waiting for you on the racer, please go and join them to get started. Simply put on the provided EEG headset when you get onto the racer and then attempt to synchronize with your partner.");
			state = POST_PASSWORD;
			avatarMovementEnabled = false;
			help.setText("Press ENTER to continue.");
		}
		else if (state == PASSWORD_INCORRECT && FlxG.keyboard.justPressed("ENTER"))
		{
			// trace("Password incorrect and trying again.");
			message.setVisible(false);
			passwordForm.visible = true;
			password.text = "";
			password.reenable();
			state = PASSWORD;
			avatarMovementEnabled = false;
			help.setText("Type the password. (Maximum of 12 letters.)\nThen press ENTER.");
		}
		else if (state == PASSWORD_INCORRECT && FlxG.keyboard.justPressed("ESCAPE"))
		{
			// trace("Password incorrect and trying again.");
			message.setVisible(false);
			message.setup("No problem. Feel free to go to the performance space to the left, or head back to reception to your right.");
			state = PASSWORD_CANCEL;
			avatarMovementEnabled = false;
			help.setText("Press ENTER to continue.");
		}
		else if (state == PASSWORD_CANCEL && FlxG.keyboard.justPressed("ENTER"))
		{
			// trace("Password incorrect and trying again.");
			message.setVisible(false);
			state = CANT_TRY_PASSWORD;
			avatarMovementEnabled = true;
			// help.setText(GameAssets.WALK_INSTRUCTION);
			help.fadeOut();
		}
		else if (state == POST_PASSWORD && FlxG.keyboard.justPressed("ENTER"))
		{
			collidables.remove(fenceBlock);
			message.setVisible(false);
			help.fadeOut();
			avatarMovementEnabled = true;
			state = PRE_RACER;
		}

		return true;
	}



	override private function handleCollisions():Bool
	{
		// DON'T RUN INTO COLLIDABLES

		if (avatar.overlaps(collidables))
		{
			avatar.undoAndStop();
		}


		// AVATAR IS OFF THE LEFT SIDE
		if (avatar.x  + avatar.width / 2 < 0 && avatar.velocity.x < 0)
		{
			// ACTUALLY NEED TO GO TO NEXT STATE

			avatar.moveLeft();
			avatar.velocity.x = -Person.SPEED;

			avatarMovementEnabled = false;
			wrapping = true;

			gotoPerformanceChamber(null);

			return true;
		}
		// AVATAR IS OFF THE RIGHT SIDE
		else if (avatar.x + avatar.width / 2 > FlxG.width && avatar.velocity.x > 0)
		{
			avatar.moveRight();
			avatar.velocity.x = Person.SPEED;

			avatarMovementEnabled = false;
			wrapping = true;

			gotoReceptionChamber(null);

			return true;
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
				avatar.moveRight();
				avatar.velocity.x = Person.SPEED;

				avatarMovementEnabled = false;
				wrapping = true;
			}

			if (avatar.y > FlxG.height)
			{
				// trace("... avatar off BOTTOM, starting wrap...");
				wrapping = true;
				avatar.velocity.y = Person.SPEED;
				avatarMovementEnabled = false;
			}
		}

		return true;
	}


	override private function nextState(t:FlxTimer):Void
	{

	}


	private function gotoPerformanceChamber(t:FlxTimer):Void
	{
		super.nextState(null);
		Globals.enteringFrom = RIGHT;
		FlxG.switchState(new PerformanceState());
	}


	private function gotoReceptionChamber(t:FlxTimer):Void
	{
		super.nextState(null);
		Globals.enteringFrom = LEFT;
		FlxG.switchState(new ReceptionState());
	}
}



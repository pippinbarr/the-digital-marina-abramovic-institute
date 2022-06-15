package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;


enum ReceptionStateState
{
	START;
	WELCOME;
	FURTHER_EXPLANATION;
	CONTRACT_QUESTION;
	PRE_CONTRACT;
	CONTRACT;
	POST_CONTRACT;
	FINAL_EXPLANATION;
	SIGNED_IN;
	FADE;
	PLAQUE;
	EXERCISES_MESSAGE;
}


class ReceptionState extends ChamberState
{
	private var state:ReceptionStateState;
	private var plaquePreviousState:ReceptionStateState;
	private var wrapPreviousState:ReceptionStateState;

	private var listeningToAudio:Bool = false;

	private var receptionWindow:FlxSprite;
	private var receptionist:FlxSprite;
	private var receptionTrigger:FlxSprite;

	private var contract:SortableGroup;
	private var name:TextEntry;
	private var signature:FlxSprite;
	private var dateText:FlxText;
	private var contractSigned:Bool = false;

	private var walkingIntoReception:Bool = false;
	private var bottomWrapping:Bool = false;

	private var plaque:Sortable;
	private var plaqueTrigger:FlxSprite;

	private var postContract:Bool = false;

	private var firstWrap:Bool = true;

	override public function create():Void
	{
		super.create();

		if (Avatar.labcoat)
		{
			avatar = new Avatar(-100,0,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,false);
		}
		else if (Globals.enteringFrom == LEFT)
		{
			avatar = new Avatar(-100,0,GameAssets.SS_BASIC_WALKCYCLE_PNG,false);
		}
		else
		{
			// Entering from bottom
			avatar = new Avatar(FlxG.width/2 - 20,FlxG.height + 200,GameAssets.SS_BASIC_WALKCYCLE_PNG,false);
		}

		receptionWindow = new FlxSprite(0,0);
		receptionWindow.loadGraphic(GameAssets.BG_RECEPTION_WINDOW_PNG,false,false);
		Helpers.scaleSprite(receptionWindow);

		receptionist = new FlxSprite(440,108,GameAssets.RECEPTIONIST_PNG);
		Helpers.scaleSprite(receptionist);
		Helpers.randomColourPerson(receptionist);

		var leftArrow:FlxSprite = new FlxSprite(20,20,GameAssets.LEFT_ARROW_PNG);
		Helpers.scaleSprite(leftArrow);
		var leftArrowText:FlxText = new FlxText(leftArrow.x + 20,22,Std.int(leftArrow.width - 20),"SCIENCE CHAMBER\nMAIN PERFORMANCE",14,true);
		leftArrowText.setFormat("Commodore",10,0xFFFFFFFF,"center");
		var leftArrowGroup:SortableGroup = new SortableGroup();
		leftArrowGroup.add(leftArrow);
		leftArrowGroup.add(leftArrowText);
		display.add(leftArrowGroup);

		var rightArrow:FlxSprite = new FlxSprite(0,0);
		rightArrow.loadGraphic(GameAssets.LEFT_ARROW_PNG,false,true);
		Helpers.scaleSprite(rightArrow);
		rightArrow.x = FlxG.width - rightArrow.width - 20;
		rightArrow.y = leftArrow.y;
		rightArrow.facing = FlxObject.LEFT;
		var rightArrowText:FlxText = new FlxText(rightArrow.x + 5,27,Std.int(rightArrow.width - 20),"EXERCISE CHAMBERS",14,true);
		rightArrowText.setFormat("Commodore",10,0xFFFFFFFF,"center");
		var rightArrowGroup:SortableGroup = new SortableGroup();
		rightArrowGroup.add(rightArrow);
		rightArrowGroup.add(rightArrowText);
		display.add(rightArrowGroup);

		receptionTrigger = new FlxSprite(435,240);
		receptionTrigger.makeGraphic(30,20,0xFFFF0000);

		createContract();
		createPlaque();

		bg.add(receptionWindow);
		bg.add(receptionist);

		add(avatar);

		display.add(avatar.sprite);
		display.add(contract);

		wrapEnabled = true;
		avatarMovementEnabled = true;
		canSleep = false;

		audio = new HeadsetAudio(Audio.LOREM_IPSUM);

		audioCompletes = true;

		if (Globals.enteringFrom == BOTTOM || Globals.enteringFrom == NONE)
		{
			walkInFromBottom();
		}
		else if (Globals.enteringFrom == LEFT)
		{
			walkIn(backWall.height + 5,true);
		}
		else
		{
			walkIn(backWall.height + 5,false);
		}

		if (!Avatar.labcoat)
		{
			state = START;
		}
		else
		{
			state = SIGNED_IN;
		}
	}


	private function createContract():Void
	{
		contract = new SortableGroup();
		contract.sortID = 1000;
		contract.visible = false;

		var contractSprite:FlxSprite = new FlxSprite(0,0,GameAssets.CONTRACT_PNG);
		Helpers.scaleSprite(contractSprite);
		contractSprite.x = FlxG.width/2 - contractSprite.width / 2;
		contractSprite.y = FlxG.height/2 - contractSprite.height/2;

		var contractWord:FlxText = new FlxText(0,140,FlxG.width,"CONTRACT",32,true);
		contractWord.setFormat("Commodore",18,0xFF000000,"center");

		var contractBetween:FlxText = new FlxText(0,160,FlxG.width,"between",32,true);
		contractBetween.setFormat("Commodore",12,0xFF000000,"center");

		var contractAndTheInstitute:FlxText = new FlxText(0,240,FlxG.width,"",32,true);
		contractAndTheInstitute.text = "" +
		"and the Institute\n\n" +
		"I give my word of honour\n" +
		"that I will stay for:" +
		"\n\n\n\nAnd that I will not\n" +
		"interrupt activities with\nmy early departure";
		contractAndTheInstitute.setFormat("Commodore",12,0xFF000000,"center");

		var contractTime:FlxText = new FlxText(0,295,FlxG.width,"1 hour",32,true);
		contractTime.setFormat("Commodore",14,0xFF000000,"center");

		name = new TextEntry(220,195,200,20);
		name.setFormat("Commodore",12,0xFF000000,"center");

		signature = new FlxSprite(210,370);
		signature.loadGraphic(GameAssets.SIGNATURE_PNG,true,false,52,12);
		Helpers.scaleSprite(signature);
		signature.addAnimation("sign",[0,1,2,3,4,5,6,7,8,9,10,11,12,13],10,false);

		dateText = new FlxText(330,390,FlxG.width,"",32,true);
		dateText.setFormat("Commodore",12,0xFF000000,"left");

		contract.add(contractSprite);
		contract.add(contractWord);
		contract.add(contractBetween);
		contract.add(contractAndTheInstitute);
		contract.add(contractTime);
		contract.add(name);
		contract.add(signature);
		contract.add(dateText);
	}


	private function createPlaque():Void
	{
		plaque = new Sortable(50,156,GameAssets.PLAQUE_PNG);
		Helpers.scaleSprite(plaque);
		plaqueTrigger = new FlxSprite(plaque.x,Math.floor(backWall.height));
		plaqueTrigger.makeGraphic(Math.floor(plaque.width),30,0xFF00FF00);

		display.add(plaque);
	}


	private function walkInFromBottom():Void
	{
		walkInState = false;
		avatarMovementEnabled = false;
		avatar.moveUp();
		walkingIntoReception = true;
		help.setInvisible();
	}

	
	override public function destroy():Void
	{
		avatar.destroy();

		if (audio != null) audio.destroy();
		receptionWindow.destroy();
		receptionist.destroy();
		receptionTrigger.destroy();
		contract.destroy();
		name.destroy();
		signature.destroy();
		dateText.destroy();
		plaque.destroy();
		plaqueTrigger.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (walkingIntoReception)
		{
			if (avatar.y <= FlxG.height - 50)
			{
				avatar.idle();
				avatarMovementEnabled = true;
				walkingIntoReception = false;
			}
		}
	}	




	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;
		if (avatar.y > FlxG.height) return false;

		handleContractInput();
		
		return true;
	}


	private function handleContractInput():Void
	{
		if (state == CONTRACT && name.text != "" && signature.frame == 0 && FlxG.keys.justReleased("ENTER"))
		{
			help.fadeOut();
			name.disable();
			signature.play("sign");
		}
		else if (state == CONTRACT && name.text != "" && signature.finished && dateText.text == "")
		{
			GameAssets.PLAYER_NAME_STRING = name.text;
			var theDate:Date = Date.now();
			dateText.text = "" + theDate.getDate() + "/" + (theDate.getMonth() + 1) + "/" + theDate.getFullYear();
			help.setText("Press ENTER to submit the contract.");
		}
		else if (state == CONTRACT && dateText.text != "" && FlxG.keys.justReleased("ENTER"))
		{
			state = POST_CONTRACT;
			contract.visible = false;
			contractSigned = true;
			help.setText("Press ENTER to continue.");
			message.setup("Thank you.");
		}
	}


	override public function handleTriggers():Bool
	{
		if (!super.handleTriggers()) return false;

		if (
			state == START && 
			avatar.overlaps(receptionTrigger)
			)
		{
			help.setText("Press ENTER to speak with the receptionist.");

			if (FlxG.keys.justPressed("ENTER"))
			{
				avatar.idle();
				avatarMovementEnabled = false;
				message.setup("" +
					"Hello, welcome to the Digital Marina Abramovic Institute!\n\n" +
					"Here at the digital institute you are able to participate in " +
					"exercises designed by Marina Abramovic as well as view a performance. " +
					"On completing the exercises you will receive an official certificate of completion.");
				help.setText("Press ENTER to continue.");
				state = WELCOME;
			}
		}
		else if (
			state == START && 
			!walkingIntoReception && 
			!avatar.overlaps(receptionTrigger) && 
			!avatar.overlaps(plaqueTrigger)
			)
		{
			help.fadeOut();
		}
		else if (
			avatar.overlaps(plaqueTrigger) && 
			state != PLAQUE
			)
		{
			help.setText("Press ENTER to view the plaque.");

			if (FlxG.keys.justPressed("ENTER"))
			{
				Globals.timesLoadedPlaque++;
				avatar.idle();
				avatarMovementEnabled = false;
				var backer:String = Backers.list[Math.floor(Math.random() * Backers.list.length)];
				message.setup("Right now, this plaque celebrates the support of:\n\n" + backer);
				help.setText("Press ENTER to continue.");
				plaquePreviousState = state;
				state = PLAQUE;
			}
		}
		else if (
			!avatar.overlaps(plaqueTrigger) && 
			!avatar.overlaps(receptionTrigger) && 
			state != EXERCISES_MESSAGE
			)
		{
			help.fadeOut();
		}

		return true;
	}


	override public function handleMessageInput():Bool
	{
		if (!super.handleMessageInput()) return false;

		if (state == WELCOME && FlxG.keys.justPressed("ENTER"))
		{
			message.setup("" +
				"You can also just visit the Science chamber and the main hall performance " +
				"by walking to the left."
				);
			help.setText("Press ENTER to continue.");
			state = FURTHER_EXPLANATION;
		}
		else if (state == FURTHER_EXPLANATION && FlxG.keys.justPressed("ENTER"))
		{
			message.setup("" +
				"If you wish to take part in the exercises you will need to sign a contract. " +
				"Otherwise you are free to view the Science chamber and performance. Do you want " +
				"to sign the contract?"
				);
			help.setText("Press ENTER to sign the contract.\nPress ESCAPE to decline the contract.");

			state = PRE_CONTRACT;
		}
		else if (state == PRE_CONTRACT && FlxG.keys.justPressed("ENTER"))
		{
			message.setVisible(false);
			state = CONTRACT;
			avatarMovementEnabled = false;
			contract.visible = true;
			help.setText("Type your name. (Maximum of 20 letters.)\nPress ENTER to sign.");
			name.enable();
		}
		else if (state == PRE_CONTRACT && FlxG.keys.justPressed("ESCAPE"))
		{
			message.setVisible(false);
			state = START;
			avatarMovementEnabled = true;
		}
		else if (state == POST_CONTRACT && FlxG.keys.justPressed("ENTER"))
		{
			message.setVisible(false);
			avatar.switchToCoat(false);
			avatarMovementEnabled = false;
			help.setText("Press ENTER to continue.");
			message.setup("Here are your headphones and labcoat. Please put the headphones on when you enter the exercise chambers. When you're ready, walk to the right to begin the exercises.");
			state = FINAL_EXPLANATION;
		}
		else if (state == FINAL_EXPLANATION && FlxG.keys.justPressed("ENTER"))
		{
			message.setVisible(false);
			help.fadeOut();
			avatarMovementEnabled = true;
			state = SIGNED_IN;
		}
		else if (state == PLAQUE && FlxG.keys.justPressed("ENTER"))
		{
			message.setVisible(false);
			avatarMovementEnabled = true;
			state = plaquePreviousState;
		}
		else if (state == EXERCISES_MESSAGE && FlxG.keys.justPressed("ENTER"))
		{
			message.setVisible(false);
			avatarMovementEnabled = false;
			avatar.moveLeft();
			help.fadeOut();
			state = wrapPreviousState;
		}

		return true;
	}



	override private function handleCollisions():Bool
	{
		if (sleeping) return false;
		if (walkingIntoReception) return false;

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
			else if (avatar.velocity.x > 0 && avatar.x > FlxG.width)
			{
				// Leave if possible
				if (Avatar.labcoat)
				{
					wrapping = false;
					avatarMovementEnabled = false;
					avatar.idle();
					Helpers.lastAvatarY = avatar.y;
					fadeToNextState();
				}
				else
				{
					avatar.idle();
					avatarMovementEnabled = false;
					help.setText("Press ENTER to continue.");
					wrapPreviousState = state;
					state = EXERCISES_MESSAGE;
					message.setup("You can't enter the exercise chambers until you've signed a contract at reception.");
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
				// ACTUALLY NEED TO GO TO NEXT STATE

				avatar.moveLeft();
				avatar.velocity.x = -Person.SPEED;

				avatarMovementEnabled = false;
				wrapping = true;

				gotoScienceChamber(null);
			}
			// AVATAR IS OFF THE RIGHT SIDE
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
		super.nextState(t);
		FlxG.switchState(new OrientationState());
	}


	private function gotoOrientationChamber(t:FlxTimer):Void
	{
		super.nextState(null);
		Globals.enteringFrom = LEFT;
		FlxG.switchState(new OrientationState());
	}


	private function gotoScienceChamber(t:FlxTimer):Void
	{
		super.nextState(null);
		Globals.enteringFrom = RIGHT;
		FlxG.switchState(new ScienceState());
	}


}



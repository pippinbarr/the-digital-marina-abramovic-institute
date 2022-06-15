package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;


class PerformanceState extends ChamberState
{
	private static var PERFORMANCE_FRAMERATE:Int = 5;

	private var performanceBG:FlxSprite;
	private var avatarChair:Collidable;
	private var avatarChairTrigger:FlxSprite;

	private var near:FlxSprite;
	private var turn:FlxSprite;
	private var rear:FlxSprite;

	private var goingUp:Bool = true;
	private var turningToRear:Bool = false;
	private var turningToNear:Bool = false;
	private var goingDown:Bool = false;

	private var NORMAL:Int = 0;
	private var SEATED:Int = 1;
	private var TITLE_MESSAGE:Int = 2;
	private var DESCRIPTION_MESSAGE:Int = 3;
	private var state:Int = 0;

	override public function create():Void
	{
		super.create();	

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
		avatar.animation.frameIndex = 20;
		
		near = new FlxSprite(0,0);
		near.loadGraphic(GameAssets.IN_THE_FIELD_NEAR_PNG,true,false,16,93);
		Helpers.scaleSprite(near);
		near.animation.add("up",GameAssets.IN_THE_FIELD_NEAR_UP_FRAMES,PERFORMANCE_FRAMERATE,false);
		near.animation.add("down",GameAssets.IN_THE_FIELD_NEAR_DOWN_FRAMES,PERFORMANCE_FRAMERATE,false);
		near.x = FlxG.width / 2 - near.width / 2;
		near.y = -10;

		near.animation.play("up");

		turn = new FlxSprite(0,0);
		turn.loadGraphic(GameAssets.IN_THE_FIELD_TURN_PNG,true,false,16,93);
		Helpers.scaleSprite(turn);
		turn.animation.add("near to rear",GameAssets.IN_THE_FIELD_TURN_TO_REAR_FRAMES,PERFORMANCE_FRAMERATE,false);
		turn.animation.add("rear to near",GameAssets.IN_THE_FIELD_TURN_TO_NEAR_FRAMES,PERFORMANCE_FRAMERATE,false);
		turn.x = near.x;
		turn.y = near.y;
		turn.visible = false;

		rear = new FlxSprite(0,0);
		rear.loadGraphic(GameAssets.IN_THE_FIELD_REAR_PNG,true,false,16,93);
		Helpers.scaleSprite(rear);
		rear.animation.add("up",GameAssets.IN_THE_FIELD_REAR_UP_FRAMES,PERFORMANCE_FRAMERATE,false);
		rear.animation.add("down",GameAssets.IN_THE_FIELD_REAR_DOWN_FRAMES,PERFORMANCE_FRAMERATE,false);
		rear.x = near.x;
		rear.y = near.y;
		rear.visible = false;

		rear.animation.play("up");

		bg.add(performanceBG);

		bg.add(near);
		bg.add(turn);
		bg.add(rear);

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
				avatarChair.sprite.animation.frameIndex = 0;
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
				audienceMember.sprite.animation.frameIndex = 1;

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
			audienceMember.sprite.animation.frameIndex = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.animation.frameIndex = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.animation.frameIndex = 1;
			}

			var audienceMemberSprite:Sortable = new Sortable(leftMargin + 60,140 + 30*i);
			audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_RIGHT_PNG,true,false,14,30,true);
			Helpers.randomColourPerson(audienceMemberSprite);
			Helpers.scaleSprite(audienceMemberSprite);
			display.add(audienceMemberSprite);

			var audienceMember:Collidable = new Collidable(leftMargin + 60,140 + 30*i,audienceMemberSprite,1.0);			
			audienceMember.sprite.animation.frameIndex = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.animation.frameIndex = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.animation.frameIndex = 1;
			}

			var audienceMemberSprite:Sortable = new Sortable(600,140 + 30*i);
			audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_LEFT_PNG,true,false,14,30,true);
			Helpers.randomColourPerson(audienceMemberSprite);
			Helpers.scaleSprite(audienceMemberSprite);

			var audienceMember:Collidable = new Collidable(560,140 + 30*i,audienceMemberSprite,1.0);			
			audienceMember.sprite.animation.frameIndex = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.animation.frameIndex = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.animation.frameIndex = 1;
			}

			var audienceMemberSprite:Sortable = new Sortable(476,140 + 30*i);
			audienceMemberSprite.loadGraphic(GameAssets.PERFORMANCE_CHAIR_LEFT_PNG,true,false,14,30,true);
			Helpers.randomColourPerson(audienceMemberSprite);
			Helpers.scaleSprite(audienceMemberSprite);
			display.add(audienceMemberSprite);

			var audienceMember:Collidable = new Collidable(494,140 + 30*i,audienceMemberSprite,1.0);			
			audienceMember.sprite.animation.frameIndex = 1;
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);
			display.add(audienceMember.sprite);
			collidables.add(audienceMember);

			if (Math.random() > 0.3)
			{
				Helpers.randomColourPerson(audienceMember.sprite);
				audienceMember.sprite.animation.frameIndex = 0;
			}
			else
			{
				Helpers.randomColourPerson(audienceMember.sprite,false);
				audienceMember.sprite.animation.frameIndex = 1;
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
		if (near.visible && goingUp && near.animation.finished)
		{
			near.visible = false;
			turn.visible = true;
			turn.animation.play("near to rear",true);
			goingUp = false;
			turningToRear = true;
		}
		else if (turn.visible && turningToRear && turn.animation.finished)
		{
			turn.visible = false;
			rear.visible = true;
			rear.animation.play("down",true);
			turningToRear = false;
			goingDown = true;
		}
		else if (rear.visible && goingDown && rear.animation.finished)
		{
			rear.animation.play("up",true);
			goingDown = false;
			goingUp = true;
		}
		else if (rear.visible && goingUp && rear.animation.finished)
		{
			rear.visible = false;
			turn.visible = true;
			turn.animation.play("rear to near",true);
			goingUp = false;
			turningToNear = true;
		}
		else if (turn.visible && turningToNear && turn.animation.finished)
		{
			turn.visible = false;
			near.visible = true;
			near.animation.play("down",true);
			turningToNear = false;
			goingDown = true;
		}
		else if (near.visible && goingDown && near.animation.finished)
		{
			near.animation.play("up",true);
			goingDown = false;
			goingUp = true;
		}
	}


	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;

		if (state == NORMAL && avatar.overlaps(avatarChairTrigger) && FlxG.keyboard.justPressed("ENTER"))
		{
			avatar.idle();
			avatar.sprite.visible = false;
			avatarMovementEnabled = false;
			if (Avatar.labcoat)
			avatarChair.sprite.animation.frameIndex = 1;
			else
			avatarChair.sprite.animation.frameIndex = 2;

			// message.setup("In the Field\n\nLynsey Peisinger\n\n(First performed at Kunstfest Weimar, 2012.)");

			// help.setText(GameAssets.CONTINUE_INSTRUCTION);

			help.setText("Press SPACE for information about the performance." + "\n" + GameAssets.STAND_INSTRUCTION);
			state = SEATED;
		}
		else if (state == SEATED && FlxG.keyboard.justPressed("ENTER"))
		{
			avatar.sprite.visible = true;
			avatarMovementEnabled = true;
			avatarChair.sprite.animation.frameIndex = 0;

			help.setText(GameAssets.SIT_INSTRUCTION + "\n" + GameAssets.PERFORMANCE_EXIT_INSTRUCTION);
			state = NORMAL;
		}
		else if (state == SEATED && FlxG.keyboard.justPressed("SPACE"))
		{
			message.setup("In the Field\n\nLynsey Peisinger\n\n(First performed at Kunstfest Weimar, 2012.)");
			help.setText(GameAssets.CONTINUE_INSTRUCTION);
			state = TITLE_MESSAGE;
		}

		return true;
	}


	override public function handleMessageInput():Bool
	{
		if (!super.handleMessageInput()) return false;

		if (state == TITLE_MESSAGE && FlxG.keyboard.justPressed("ENTER"))
		{
			state = DESCRIPTION_MESSAGE;
			message.setVisible(false);
			message.setup("There is no finish line, only hard work. Work to connect, work to survive, work to thrive, work to find meaning, work to find joy. Each time I climb the ladder, I hope to find something different, a different result. But I don't. And I continue to climb anyway because within the work, we find the reward.\n\n- Lynsey Peisinger");
			help.setText(GameAssets.CONTINUE_INSTRUCTION);
		}
		else if (state == DESCRIPTION_MESSAGE && FlxG.keyboard.justPressed("ENTER"))
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

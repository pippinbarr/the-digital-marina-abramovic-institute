package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;


class LuminosityState extends ChamberState
{
	var bed:Collidable;
	var bedTrigger:FlxSprite;
	var bedAvatar:Sortable;

	private var breathMeter:FlxGroup;
	private var breathMeterBorder:FlxSprite;
	private var breathMeterFill:FlxSprite;
	private var breathMeterBG:FlxSprite;
	private var breathMeterText:FlxText;

	private static var MIN_BREATHS:Int = 30;
	// private static var MIN_BREATHS:Int = 1;
	private static var MAX_BREATH_DIFFERENCE:Float = 0.1;

	private static var IN:Int = 0;
	private static var OUT:Int = 1;
	private var breathing:Int = 0;

	private var inCount:Int = 0;
	private var outCount:Int = 0;

	private var levitating:Bool = false;
	private var stoppedLevitating:Bool = false;
	private var goingUp:Bool = false;
	private var goingDown:Bool = false;

	private var bedSleeping:Bool = false;
	private var sleepZ1:FlxText;
	private var sleepZ2:FlxText;
	private var sleepZ3:FlxText;
	private var zTimer:FlxTimer;


	override public function create():Void
	{
		super.create();	

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);
		
		var bedSprite = new Sortable(0,0,GameAssets.STAND_AND_BED_PNG);
		Helpers.scaleSprite(bedSprite);

		bed = new Collidable(FlxG.width/2 - bedSprite.width/2,320,bedSprite,0.25);

		bedTrigger = new FlxSprite(bed.x + 96,bed.y - 30);
		bedTrigger.makeGraphic(Math.floor(bed.width - 128),Math.floor(bed.height + 40),0xFFFF0000);

		bedAvatar = new Sortable(bed.x + 68, bed.sprite.y + 52, GameAssets.BED_AVATAR_PNG);
		bedAvatar.loadGraphic(GameAssets.BED_AVATAR_PNG,true,false,32,8);
		Helpers.recolourPersonAsAvatar(bedAvatar,true);
		Helpers.scaleSprite(bedAvatar);
		bedAvatar.visible = false;
		bedAvatar.sortID = bed.sprite.sortID;
		Helpers.recolourPersonAsAvatar(bedAvatar,true);

		breathMeter = makeBreathMeter();

		sleepZ1 = new FlxText(bedAvatar.x + 16,bedAvatar.y - 24,50,"Z");
		sleepZ1.setFormat("Commodore",16,0xFF000000,"left");
		sleepZ1.visible = false;

		sleepZ2 = new FlxText(bedAvatar.x + 16,bedAvatar.y - 40,50,"Z");
		sleepZ2.setFormat("Commodore",16,0xFF000000,"left");
		sleepZ2.visible = false;
		sleepZ2.alpha = 0.75;

		sleepZ3 = new FlxText(bedAvatar.x + 16,bedAvatar.y - 56,50,"Z");
		sleepZ3.setFormat("Commodore",16,0xFF000000,"left");
		sleepZ3.visible = false;
		sleepZ3.alpha = 0.5;

		fg.add(sleepZ1);
		fg.add(sleepZ2);
		fg.add(sleepZ3);

		add(avatar);

		display.add(avatar.sprite);		
		display.add(bed.sprite);
		display.add(bedAvatar);
		
		fg.add(breathMeter);

		collidables.add(bed);

		audio = new HeadsetAudio(Audio.LUMINOSITY_AUDIO);
		fg.add(audio);


		walkIn(backWall.height);
	}


	private function makeBreathMeter():FlxGroup
	{
		var meter:FlxGroup = new FlxGroup();

		var ALPHA:Float = 0.5;

		breathMeterBorder = new FlxSprite(330,116);
		breathMeterBorder.makeGraphic(32,152,0xFFDDDDDD);
		breathMeterBorder.alpha = ALPHA;

		breathMeterBG = new FlxSprite(breathMeterBorder.x + 4,breathMeterBorder.y + 4);
		breathMeterBG.makeGraphic(Math.floor(breathMeterBorder.width - 8), Math.floor(breathMeterBorder.height - 8),0xFFEEEEEE);
		breathMeterBG.alpha = ALPHA;

		breathMeterFill = new FlxSprite(breathMeterBG.x,breathMeterBG.y);
		breathMeterFill.makeGraphic(Math.floor(breathMeterBG.width),Math.floor(breathMeterBG.height),0xFFff5d5f);
		breathMeterFill.y = breathMeterBG.y;
		breathMeterFill.alpha = ALPHA;

		breathMeterText = new FlxText(breathMeterBorder.x + breathMeterBorder.width/2 - 100,breathMeterBorder.y - 24,200,"BREATH");
		breathMeterText.setFormat("Commodore",18,0xFF000000,"center");
		breathMeterText.alpha = ALPHA;

		meter.add(breathMeterBorder);
		meter.add(breathMeterFill);
		meter.add(breathMeterBG);
		meter.add(breathMeterText);

		//breathMeterBG.setOriginToCorner();
		breathMeterBG.scale.y = 1; //1.0 - 1.0;

		breathMeterFill.scale.y = 0; //1.0 - 1.0;

		meter.visible = false;

		return meter;
	}

	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		bed.destroy();
		bedTrigger.destroy();
		bedAvatar.destroy();
		breathMeter.destroy();
		breathMeterBorder.destroy();
		breathMeterFill.destroy();
		breathMeterBG.destroy();
		breathMeterText.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		if (levitating && !FlxG.keyboard.pressed("SHIFT"))
		{
			levitating = false;
			goingUp = false;
			bedAvatar.velocity.y = 50;
			goingDown = true;
			stoppedLevitating = true;
		}

		super.update();

		if (!stoppedLevitating && !levitating && (inCount >= MIN_BREATHS || outCount >= MIN_BREATHS) &&
			Math.abs(inCount - outCount)/Math.max(inCount,outCount) <= MAX_BREATH_DIFFERENCE)
		{
			// Levitate?
			levitating = true;
			inCount = 0;
			outCount = 0;
			timer = FlxTimer.start(12,checkLevitationBreathing);

			goingUp = true;
			bedAvatar.velocity.y = -10;
		}

		if (goingUp && bedAvatar.y < 250)
		{
			bedAvatar.velocity.y = 0;
			goingUp = false;
		}
		else if (goingDown && bedAvatar.y >= bed.sprite.y + 52)
		{
			goingDown = false;
			bedAvatar.velocity.y = 0;
			timer.abort();
		}


	}	


	private function handleZZZ(t:FlxTimer):Void
	{
		if (!sleepZ1.visible && !sleepZ2.visible && !sleepZ3.visible)
		{
			sleepZ1.visible = true;
		}
		else if (sleepZ1.visible)
		{
			sleepZ1.visible = false;
			sleepZ2.visible = true;
		}
		else if (sleepZ2.visible)
		{
			sleepZ2.visible = false;
			sleepZ3.visible = true;
		}
		else if (sleepZ3.visible)
		{
			sleepZ3.visible = false;
		}

		zTimer = FlxTimer.start(0.2,handleZZZ);
	}


	private function checkLevitationBreathing(t:FlxTimer):Void
	{
		if (!levitating || stoppedLevitating) return;

		if ((inCount >= 1 || outCount >= 1) &&
			Math.abs(inCount - outCount)/Math.max(inCount,outCount) <= 0.5)
		{
			levitating = true;
			timer = FlxTimer.start(12,checkLevitationBreathing);
			inCount = 0;
			outCount = 0;
		}
		else
		{
			levitating = false;
			goingUp = false;
			bedAvatar.velocity.y = 50;
			goingDown = true;
		}

	}


	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;

		if (bedSleeping)
		{
			return false;
		}

		if (avatarMovementEnabled && avatar.overlaps(bedTrigger) && FlxG.keyboard.justPressed("ENTER"))
		{
			// AVATAR IS NEXT TO THE BED, STANDING UP
			// AND JUST CHOSE TO LIE DOWN

			avatar.idle();
			avatar.sprite.visible = false;
			avatarMovementEnabled = false;
			bedAvatar.visible = true;

			help.setText(GameAssets.CLOSE_EYES_INSTRUCTION + "\n" + GameAssets.LUMINOSITY_GET_OFF_BED_INSTRUCTION);
		}
		else if (bedAvatar.visible && bedAvatar.animation.frameIndex == 0 && !levitating && FlxG.keyboard.justPressed("SPACE"))
		{
			// AVATAR IS ON THE BED WITH EYES OPEN
			// AND JUST CHOSE TO CLOSE THEIR EYES

			bedAvatar.animation.frameIndex = 1;
			breathMeter.visible = true;
			breathMeterFill.scale.y = 0.0;
			help.setText(GameAssets.LUMINOSITY_BREATHE_INSTRUCTION + "\n" + GameAssets.OPEN_EYES_INSTRUCTION);
		}		
		else if (levitating && !stoppedLevitating && FlxG.keyboard.justPressed("SPACE"))
		{
			// AVATAR IS LEVITATING
			// AND CHOSE TO STOP

			stoppedLevitating = true;
			levitating = false;
			goingUp = false;
			bedAvatar.velocity.y = 50;
			goingDown = true;
		}
		else if (bedAvatar.visible && bedAvatar.animation.frameIndex == 1 && FlxG.keyboard.justPressed("SPACE"))
		{
			// AVATAR IS LYING ON THE BED WITH EYES CLOSED
			// AND CHOSE TO OPEN EYES

			bedAvatar.animation.frameIndex = 0;
			breathMeter.visible = false;
			help.setText(GameAssets.CLOSE_EYES_INSTRUCTION + "\n" + GameAssets.LUMINOSITY_GET_OFF_BED_INSTRUCTION);
		}
		else if (!avatar.sprite.visible && bedAvatar.animation.frameIndex == 0 && FlxG.keyboard.justPressed("ENTER"))
		{
			// AVATAR IS LYING ON THE BED WITH EYES OPEN
			// AND CHOSE TO GET OFF THE BED
			
			avatar.sprite.visible = true;
			avatarMovementEnabled = true;
			bedAvatar.visible = false;

			// help.setText(GameAssets.WALK_INSTRUCTION);
			help.fadeOut();
		}

		if (bedAvatar.visible && bedAvatar.animation.frameIndex == 1 && FlxG.keyboard.pressed("UP"))
		{
			if (breathing == OUT)
			{
				breathing = IN;
				breathMeterFill.scale.y <= 0.2 ? outCount++ : outCount;	

			}

			breathMeterFill.scale.y = Math.min(breathMeterFill.scale.y + 0.008,1.0);
		}
		else if (bedAvatar.visible && bedAvatar.animation.frameIndex == 1 && FlxG.keyboard.pressed("DOWN"))
		{
			if (breathing == IN)
			{
				breathing = OUT;

				breathMeterFill.scale.y >= 0.8 ? inCount++ : inCount;	
			}

			breathMeterFill.scale.y = Math.max(breathMeterFill.scale.y - 0.009,0.0);
		}


		if (bedAvatar.visible && bedAvatar.animation.frameIndex == 1 && levitating)
		{
			help.setText(GameAssets.LUMINOSITY_BREATHE_INSTRUCTION + "\n" + GameAssets.LUMINOSITY_STOP_LEVITATING_INSTRUCTION);
		}
		else if (bedAvatar.visible && bedAvatar.animation.frameIndex == 1 && !levitating)
		{
			help.setText(GameAssets.LUMINOSITY_BREATHE_INSTRUCTION + "\n" + GameAssets.OPEN_EYES_INSTRUCTION);			
		}

		return true;
	}


	override public function handleSleepInput():Void
	{
		if (!Helpers.sleepKeyIsDown && bedAvatar.visible && bedAvatar.animation.frameIndex == 1)
		{
			bedSleeping = true;
			breathMeter.visible = false;
			help.setText("Hold SHIFT to wake up.");
			zTimer = FlxTimer.start(1,handleZZZ);
		}
		else if (Helpers.sleepKeyIsDown && bedSleeping)
		{
			zTimer.abort();
			sleepZ1.visible = false;
			sleepZ2.visible = false;
			sleepZ3.visible = false;
			bedSleeping = false;
			breathMeter.visible = true;
			help.setText(GameAssets.LUMINOSITY_BREATHE_INSTRUCTION + "\n" + GameAssets.OPEN_EYES_INSTRUCTION);
		}

		if (!bedSleeping)
		{
			super.handleSleepInput();
		}
	}



	override public function handleCollisions():Bool
	{
		return super.handleCollisions();
	}


	override private function handleTriggers():Bool
	{
		if (!super.handleTriggers()) return false;

		if (avatar.sprite.visible && avatar.overlaps(bedTrigger))
		{
			help.setText(GameAssets.LUMINOSITY_GET_ON_BED_INSTRUCTION);
		}
		else if (avatar.sprite.visible)
		{
			// help.setText(GameAssets.WALK_INSTRUCTION);
			help.fadeOut();
		}

		return true;
	}


	override private function nextState(t:FlxTimer):Void
	{
		super.nextState(t);
		FlxG.switchState(new ParkingState());
	}
}

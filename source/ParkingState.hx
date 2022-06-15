package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxObject;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;



class ParkingState extends ChamberState
{

	private var hm:FlxSprite;

	private var avatarSleeping:FlxSprite;
	private var avatarWheelchair:Collidable;

	private var otherSleeping:FlxSprite;
	private var otherWheelchair:Collidable;

	private var startedAsleep:Bool;


	private var sleepZ1:FlxText;
	private var sleepZ2:FlxText;
	private var sleepZ3:FlxText;
	private var zTimer:FlxTimer;




	override public function create():Void
	{
		super.create();	

		bgImage.loadGraphic(GameAssets.BG_PARKING_PNG);
		bgImage.setOriginToCorner();
		bgImage.x = 0; bgImage.y = 0;

		// hm = new FlxSprite(0,0,GameAssets.HM_PARKING_PNG);
		hm = new FlxSprite(0,0);
		hm.makeGraphic(160,83,0xFFFF0000);
		Helpers.scaleSprite(hm);


		var avatarWheelchairSprite:Sortable = new Sortable(104,236,GameAssets.WHEELCHAIR_PNG);
		Helpers.scaleSprite(avatarWheelchairSprite);
		avatarWheelchair = new Collidable(104,316,avatarWheelchairSprite,0.2);

		avatarSleeping = new FlxSprite(avatarWheelchair.x,avatarWheelchair.y - 68);
		avatarSleeping.loadGraphic(GameAssets.SLEEPER_PNG,true,false,45,21,true);
		Helpers.recolourPersonAsAvatar(avatarSleeping,true);
		Helpers.scaleSprite(avatarSleeping);
		avatarSleeping.frame = 0;

		var otherWheelchairSprite:Sortable = new Sortable(104,236,GameAssets.WHEELCHAIR_PNG);
		Helpers.scaleSprite(otherWheelchairSprite);
		otherWheelchair = new Collidable(360,avatarWheelchair.y,otherWheelchairSprite,0.2);

		otherSleeping = new FlxSprite(otherWheelchair.x,avatarSleeping.y);
		otherSleeping.loadGraphic(GameAssets.SLEEPER_PNG,true,false,45,21,true);
		Helpers.randomColourPerson(otherSleeping);
		Helpers.scaleSprite(otherSleeping);
		otherSleeping.frame = 0;

		if (Helpers.lastAvatarY != -1)
		{
			if (Helpers.lastAvatarY > hm.height)
			{
				avatar = new Avatar(-100,Helpers.lastAvatarY,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true);
			}
			else
			{
				avatar = new Avatar(-100,hm.height + 20,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true);
			}
			avatar.sprite.visible = true;
			avatarSleeping.visible = false;
			startedAsleep = false;
			canLeave = true;
			walkIn(hm.height);
		}
		else 
		{
			avatar = new Avatar(140,334,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true);
			avatar.sprite.visible = false;
			startedAsleep = true;
			FlxG.fade(0xFF000000,20,true);
		}

		collidables.add(hm);
		add(avatar);

		display.add(avatar.sprite);	

		bg.add(avatarSleeping);
		bg.add(avatarWheelchair.sprite);
		bg.add(otherSleeping);
		bg.add(otherWheelchair.sprite);

		collidables.add(avatarWheelchair);
		collidables.add(otherWheelchair);

		wrapEnabled = true;
		avatarMovementEnabled = false;
		canSleep = false;

		if (startedAsleep)
		{
			help.setText(GameAssets.OPEN_EYES_INSTRUCTION);
		}

		audio = new HeadsetAudio(Audio.LOREM_IPSUM);
		fg.add(audio);

		audio.visible = false;

		audioCompletes = false;

		maxWrapY = 360;



		createZs();
	}



	private function createZs():Void
	{
		sleepZ1 = new FlxText(otherSleeping.x + 32,otherSleeping.y - 24,50,"Z");
		sleepZ1.setFormat("Commodore",16,0xFF000000,"left");
		sleepZ1.visible = false;

		sleepZ2 = new FlxText(otherSleeping.x + 32,otherSleeping.y - 40,50,"Z");
		sleepZ2.setFormat("Commodore",16,0xFF000000,"left");
		sleepZ2.visible = false;
		sleepZ2.alpha = 0.75;

		sleepZ3 = new FlxText(otherSleeping.x + 32,otherSleeping.y - 56,50,"Z");
		sleepZ3.setFormat("Commodore",16,0xFF000000,"left");
		sleepZ3.visible = false;
		sleepZ3.alpha = 0.5;

		zTimer = new FlxTimer();

		bg.add(sleepZ1);
		bg.add(sleepZ2);
		bg.add(sleepZ3);

		zTimer.start(1,1,handleZZZ);
	}

	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		hm.destroy();
		avatarSleeping.destroy();
		avatarWheelchair.destroy();
		otherSleeping.destroy();
		otherWheelchair.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();
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

		zTimer = new FlxTimer();
		zTimer.start(0.2,1,handleZZZ);
	}



	override public function handleInput():Bool
	{
		if (avatarSleeping.visible && avatarSleeping.frame == 0 && FlxG.keys.justPressed("SPACE"))
		{
			avatarSleeping.frame = 1;
			help.setText(GameAssets.PARKING_GET_UP_INSTRUCTION);
		}
		else if (
			avatarSleeping.visible == true && 
			avatarSleeping.frame == 1 && 
			FlxG.keys.justPressed("ENTER"))
		{
			avatarSleeping.visible = false;
			avatar.sprite.visible = true;
			avatarMovementEnabled = true;
			// help.setText(GameAssets.WALK_INSTRUCTION);
			help.fadeOut();
			canLeave = true;
		}

		if (!super.handleInput()) return false;

		return true;
	}


	override private function nextState(t:FlxTimer):Void
	{
		Globals.enteringFrom = LEFT;
		super.nextState(t);
		FlxG.switchState(new PerformanceState());
	}

}

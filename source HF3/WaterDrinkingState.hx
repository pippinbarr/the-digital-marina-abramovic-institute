package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;


class WaterDrinkingState extends ChamberState
{
	private var NO_WATER:Int = 0;
	private var CORAL:Int = 1;
	private var PURPLE:Int = 2;
	private var TOURMALINE:Int = 3;
	private var CRYSTAL:Int = 4;

	private static var RAISE_FULL_FRAMES:Array<Int> = [0,1,2,3,4];
	private static var RAISE_EMPTY_FRAMES:Array<Int> = [5,6,7,8,9];

	private static var LOWER_FULL_FRAMES:Array<Int> = [4,3,2,1,0];
	private static var LOWER_EMPTY_FRAMES:Array<Int> = [9,8,7,6,5];

	private var currentWater:Int = 0;

	private var waterRemaining:Array<Float>;

	private var waterStation:Collidable;

	private var coralGlass:Sortable;
	private var coralTrigger:FlxSprite;

	private var crystalGlass:Sortable;
	private var crystalTrigger:FlxSprite;

	private var tourmalineGlass:Sortable;
	private var tourmalineTrigger:FlxSprite;

	private var purpleGlass:Sortable;
	private var purpleTrigger:FlxSprite;

	private var drinking:Bool = false;
	private var raising:Bool = false;
	private var lowering:Bool = false;

	private var drinkingAvatar:Sortable;

	private var waterMeter:FlxGroup;
	private var waterMeterBorder:FlxSprite;
	private var waterMeterFill:FlxSprite;
	private var waterMeterBG:FlxSprite;
	private var waterMeterText:FlxText;

	private static var METER_LEFT_X:Float = 64;
	private static var METER_RIGHT_X:Float = 548;

	override public function create():Void
	{
		super.create();	

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);
		avatar.animation.frameIndex = 20;
		
		var waterStationSprite = new Sortable(0,0,GameAssets.WATER_STATION_PNG);
		Helpers.scaleSprite(waterStationSprite);
		waterStation = new Collidable(FlxG.width/2 - waterStationSprite.width/2,320,waterStationSprite,0.25);

		coralGlass = new Sortable(waterStation.sprite.x + 40,waterStation.sprite.y + 92);
		coralGlass.loadGraphic(GameAssets.WATER_GLASS_PNG,true,false,2,4);
		Helpers.scaleSprite(coralGlass);
		coralGlass.sortID = waterStation.sprite.sortID + 1;

		coralTrigger = new FlxSprite(coralGlass.x,waterStation.y);
		coralTrigger.makeGraphic(Math.floor(coralGlass.width),Math.floor(50),0xFFFF0000);
		coralTrigger.visible = Globals.DEBUG_TRIGGER;

		crystalGlass = new Sortable(coralGlass.x + 72,coralGlass.y);
		crystalGlass.loadGraphic(GameAssets.WATER_GLASS_PNG,true,false,2,4);
		Helpers.scaleSprite(crystalGlass);
		crystalGlass.sortID = waterStation.sprite.sortID + 1;

		crystalTrigger = new FlxSprite(crystalGlass.x,waterStation.y);
		crystalTrigger.makeGraphic(Math.floor(crystalGlass.width),Math.floor(50),0xFFFF0000);
		crystalTrigger.visible = Globals.DEBUG_TRIGGER;

		tourmalineGlass = new Sortable(crystalGlass.x + 72,crystalGlass.y);
		tourmalineGlass.loadGraphic(GameAssets.WATER_GLASS_PNG,true,false,2,4);
		Helpers.scaleSprite(tourmalineGlass);
		tourmalineGlass.sortID = waterStation.sprite.sortID + 1;

		tourmalineTrigger = new FlxSprite(tourmalineGlass.x,waterStation.y);
		tourmalineTrigger.makeGraphic(Math.floor(tourmalineGlass.width),Math.floor(50),0xFFFF0000);
		tourmalineTrigger.visible = Globals.DEBUG_TRIGGER;

		purpleGlass = new Sortable(tourmalineGlass.x + 80,tourmalineGlass.y);
		purpleGlass.loadGraphic(GameAssets.WATER_GLASS_PNG,true,false,2,4);
		Helpers.scaleSprite(purpleGlass);
		purpleGlass.sortID = waterStation.sprite.sortID + 1;

		purpleTrigger = new FlxSprite(purpleGlass.x,waterStation.y);
		purpleTrigger.makeGraphic(Math.floor(purpleGlass.width),Math.floor(50),0xFFFF0000);
		purpleTrigger.visible = Globals.DEBUG_TRIGGER;

		drinkingAvatar = new Sortable(0,0);
		drinkingAvatar.loadGraphic(GameAssets.DRINKING_AVATAR_PNG,true,false,14,35);
		drinkingAvatar.animation.add("raise_full",[0,1,2,3,4],2,false);
		drinkingAvatar.animation.add("lower_full",LOWER_FULL_FRAMES,2,false);
		drinkingAvatar.animation.add("raise_empty",[5,6,7,8,9],2,false);
		drinkingAvatar.animation.add("lower_empty",LOWER_EMPTY_FRAMES,2,false);

		Helpers.scaleSprite(drinkingAvatar);
		drinkingAvatar.animation.frameIndex = 0;
		Helpers.recolourPersonAsAvatar(drinkingAvatar,true);
		drinkingAvatar.visible = false;

		waterMeter = makeWaterMeter();
		waterRemaining = new Array();
		waterRemaining.push(0);
		waterRemaining.push(1.0);
		waterRemaining.push(1.0);
		waterRemaining.push(1.0);
		waterRemaining.push(1.0);

		add(avatar);
		add(purpleTrigger);
		add(tourmalineTrigger);
		add(crystalTrigger);
		add(coralTrigger);

		display.add(avatar.sprite);		
		display.add(waterStation.sprite);
		display.add(coralGlass);
		display.add(crystalGlass);
		display.add(tourmalineGlass);
		display.add(purpleGlass);
		display.add(drinkingAvatar);

		fg.add(waterMeter);

		collidables.add(waterStation);

		wrapEnabled = true;
		avatarMovementEnabled = true;

		help.setText("");
		help.setInvisible();
		audio = new HeadsetAudio(Audio.WATER_AUDIO);
		fg.add(audio);

		walkIn(backWall.height);
	}


	private function makeWaterMeter():FlxGroup
	{
		var meter:FlxGroup = new FlxGroup();

		var ALPHA:Float = 0.5;

		waterMeterBorder = new FlxSprite(64,128);
		waterMeterBorder.makeGraphic(32,256,0xFFDDDDDD);
		waterMeterBorder.alpha = ALPHA;

		waterMeterBG = new FlxSprite(waterMeterBorder.x + 4,waterMeterBorder.y + 4);
		waterMeterBG.makeGraphic(Math.floor(waterMeterBorder.width) - 8, Math.floor(waterMeterBorder.height - 8),0xFFEEEEEE);
		waterMeterBG.alpha = ALPHA;

		waterMeterFill = new FlxSprite(waterMeterBG.x,waterMeterBG.y);
		waterMeterFill.makeGraphic(Math.floor(waterMeterBG.width),Math.floor(waterMeterBG.height),0xFF5f9dff);
		waterMeterFill.y = waterMeterBG.y;
		waterMeterFill.alpha = ALPHA;

		waterMeterText = new FlxText(waterMeterBorder.x + waterMeterBorder.width/2 - 75,waterMeterBorder.y - 48,150,"WATER\nREMAINING");
		waterMeterText.setFormat("Commodore",18,0xFF000000,"center");
		waterMeterText.alpha = ALPHA;

		meter.add(waterMeterBorder);
		meter.add(waterMeterFill);
		meter.add(waterMeterBG);
		meter.add(waterMeterText);

		//waterMeterBG.setOriginToCorner();
		waterMeterBG.scale.y = 1.0 - 1.0;


		meter.visible = false;

		return meter;
	}


	private function showWaterMeter():Void
	{
		var X:Float;

		if (avatar.x + avatar.width + waterMeterText.width > FlxG.width)
		{
			X = avatar.x - waterMeterBorder.width - 20;
		}
		else
		{
			X = avatar.x + avatar.width + 20;
		}

		waterMeterBorder.x = X; 
		waterMeterBG.x = waterMeterBorder.x + 4;
		waterMeterFill.x = waterMeterBG.x;
		waterMeterText.x = waterMeterBorder.x + waterMeterBorder.width/2 - 75;
		waterMeterBG.scale.y = 1.0 - waterRemaining[currentWater];

		waterMeter.visible = true;
	}


	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		waterStation.destroy();
		coralGlass.destroy();
		coralTrigger.destroy();
		crystalGlass.destroy();
		crystalTrigger.destroy();
		tourmalineGlass.destroy();
		tourmalineTrigger.destroy();
		purpleGlass.destroy();
		purpleTrigger.destroy();
		drinkingAvatar.destroy();
		waterMeter.destroy();
		waterMeterBorder.destroy();
		waterMeterFill.destroy();
		waterMeterBG.destroy();
		waterMeterText.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}	



	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;

		if (currentWater != NO_WATER && !drinking && !raising && !lowering && FlxG.keyboard.pressed("ENTER"))
		{
			avatarMovementEnabled = false;
			avatar.idle();

			showDrinkingAvatar();

			if (waterRemaining[currentWater] > 0)
			{
				drinkingAvatar.animation.play("raise_full");
			}
			else
			{
				drinkingAvatar.animation.play("raise_empty");
			}

			raising = true;
			help.fadeOut();			
		}
		else if (raising)
		{
			if (drinkingAvatar.animation.frameIndex == 4 || drinkingAvatar.animation.frameIndex == 9)
			{
				raising = false;
				drinking = true;
				showWaterMeter();

				help.setText(GameAssets.WATER_SIP_INSTRUCTION + "\n" + GameAssets.WATER_LOWER_INSTRUCTION);			
			}
		}
		else if (drinking && !FlxG.keyboard.pressed("ENTER"))
		{
			if (waterRemaining[currentWater] > 0)
			{
				// drinkingAvatar.play("lower_full",true,LOWER_FULL_FRAMES.indexOf(drinkingAvatar.frame));
				// drinkingAvatar.play("lower_full",true,drinkingAvatar.frame);
				// drinkingAvatar.frameIndex = drinkingAvatar.frame;
				drinkingAvatar.animation.play("lower_full");
			}
			else
			{
				drinkingAvatar.animation.play("lower_empty");
				// drinkingAvatar.play("lower_empty",true,LOWER_EMPTY_FRAMES.indexOf(drinkingAvatar.frame));
			}

			lowering = true;
			drinking = false;			
			waterMeter.visible = false;
			help.fadeOut();			
		}
		else if (lowering)
		{
			if (drinkingAvatar.animation.frameIndex == 0 || drinkingAvatar.animation.frameIndex == 5)
			{
				if (waterRemaining[currentWater] <= 0) 
				{
					avatar.sprite.replaceColor(GameAssets.WATER_COLOR,GameAssets.GLASS_COLOR);
				}

				avatarMovementEnabled = true;

				avatar.sprite.visible = true;
				drinkingAvatar.visible = false;
				lowering = false;
			}
		}
		else if (drinking && FlxG.keyboard.pressed("SPACE"))
		{
			waterRemaining[currentWater] -= 0.005;
			if (waterRemaining[currentWater] < 0) 
			{
				waterRemaining[currentWater] = 0;
				drinkingAvatar.animation.frameIndex = 9;
				avatar.sprite.replaceColor(GameAssets.WATER_COLOR,GameAssets.GLASS_COLOR);
			}
			waterMeterBG.scale.y = 1.0 - waterRemaining[currentWater];
		}

		return true;
	}


	override private function handleTriggers():Bool
	{
		if (!super.handleTriggers()) return false;

		var triggered:Bool = false;

		triggered = handleTrigger(coralTrigger,coralGlass,CORAL,"coral water");
		triggered = triggered || handleTrigger(tourmalineTrigger,tourmalineGlass,TOURMALINE,"tourmaline water");
		triggered = triggered || handleTrigger(crystalTrigger,crystalGlass,CRYSTAL,"crystal quartz water");
		triggered = triggered || handleTrigger(purpleTrigger,purpleGlass,PURPLE,"rose quartz water");

		if (!triggered)
		{
			if (currentWater == NO_WATER)
			{
				// help.setText(GameAssets.WALK_INSTRUCTION);			
				help.fadeOut();
			}
			else if (!drinking && !raising && !lowering)
			{
				// trace("Water raise instruction.");
				help.setText(GameAssets.WATER_RAISE_INSTRUCTION);			
			}
		}

		return true;
	}


	private function handleTrigger(trigger:FlxSprite,glass:FlxSprite,type:Int,name:String):Bool
	{
		if (avatar.overlaps(trigger))
		{
			if (!glass.visible && !drinking && !lowering && !raising)
			{
				help.setText(GameAssets.WATER_RAISE_INSTRUCTION + "\n" + "Press SPACE to return the " + name + ".");

				if (FlxG.keyboard.justPressed("SPACE"))
				{
					glass.visible = true;
					avatar.switchToCoat();
					if (waterRemaining[currentWater] == 0) glass.animation.frameIndex = 3;
					else if (waterRemaining[currentWater] < 0.33) glass.animation.frameIndex = 2;
					else if (waterRemaining[currentWater] < 0.66) glass.animation.frameIndex = 1;
					else glass.animation.frameIndex = 0;
					currentWater = NO_WATER;
					avatar.sprite.animation.frameIndex = 29;
				}
			}
			else if (glass.visible && currentWater == NO_WATER)
			{
				help.setText("Press SPACE to take the " + name + ".");

				if (FlxG.keyboard.justPressed("SPACE"))
				{
					glass.visible = false;
					avatar.switchToWater();
					avatar.sprite.animation.frameIndex = 29;
					currentWater = type;
				}
			}

			return true;
		}
		else
		{
			return false;
		}

	}


	private function showDrinkingAvatar():Void
	{
		if (avatar.facing == FlxObject.LEFT)
		{
			drinkingAvatar.loadGraphic(GameAssets.DRINKING_AVATAR_LEFT_PNG,true,false,14,35);
		}
		else
		{
			avatar.facing = FlxObject.RIGHT;
			drinkingAvatar.loadGraphic(GameAssets.DRINKING_AVATAR_PNG,true,false,14,35);
		}
		//drinkingAvatar.setOriginToCorner();
		Helpers.recolourPersonAsAvatar(drinkingAvatar,true);
		drinkingAvatar.x = avatar.sprite.x;
		drinkingAvatar.y = avatar.sprite.y;

		drinkingAvatar.sortID = avatar.sprite.sortID;

		drinkingAvatar.visible = true;
		avatar.sprite.visible = false;

		drinkingAvatar.facing = avatar.facing;
	}


	override private function nextState(t:FlxTimer):Void
	{
		super.nextState(t);
		FlxG.switchState(new WallState());
	}

}

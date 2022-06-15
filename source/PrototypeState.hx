package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;


class PrototypeState extends FlxState
{
	private var bg:FlxSprite;
	private var avatar:FlxSprite;

	private var NUM_WALKERS:Int = 7;
	private var walkers:FlxGroup;

	private var floorSprite:FlxSprite;

	private var ANIMATION_RATE:Int = 10;

	override public function create():Void
	{
		FlxG.bgColor = 0xFF444444;
		FlxG.mouse.hide();

		bg = new FlxSprite(0,0,GameAssets.SLOMO_RAMP_PNG);
		add(bg);

		var animationRate:Int = Math.floor(Math.random() * ANIMATION_RATE) + 1;

		avatar = new FlxSprite(8,214);

		var avatarImageIndex:Int = Math.floor(Math.random() * NUM_WALKERS) + 1;
		avatar.loadGraphic(GameAssets.SLOMO_WALKCYCLE_PREFIX + avatarImageIndex + ".png",true,true,112,140);

		walkers = new FlxGroup();
		walkers.add(avatar);

		for (i in 0...NUM_WALKERS)
		{
			var walkerY:Float = 96 + Math.random() * 112;
			var walkerX:Float = 0 + Math.random() * 24;
			if (i+1 < avatarImageIndex)
				walkers.add(new RampClimber(i+1,walkerX,walkerY));
			else
				walkers.add(new RampClimber(i+2,walkerX,walkerY));

		}

		add(walkers);

		var text:FlxText = new FlxText(0,0,FlxG.width,"CLICK IN WINDOW THEN\nREPEATEDLY PRESS [G] TO WALK IN SLOW MOTION",64);
		text.setFormat(null,14,0xFF000000,"center");
		add(text);

		var sound:FlxSound = new FlxSound();
		FlxG.play("assets/mp3/test.mp3");
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		handleInput();

		walkers.sort("y");
	}	

	private function handleInput():Void
	{
		if (FlxG.keyboard.justPressed("G") || FlxG.mouse.justPressed())
		{
			avatar.frame++;
			if (avatar.frameIndex == 20) 
			{
				avatar.frameIndex = 0;
				avatar.x += 56;
				avatar.y -= 4;
			}
		}
	}
}



class RampClimber extends FlxSprite
{
	private var ANIMATION_RATE:Int = 4;

	private var shift:Bool = false;


	private var timer:FlxTimer;

	public function new(I:Int,X:Float,Y:Float):Void
	{
		super(X,Y);

		var animationRate:Int = Math.floor(Math.random() * ANIMATION_RATE) + 1;

		loadGraphic(GameAssets.SLOMO_WALKCYCLE_PREFIX + I + ".png",true,true,112,140,true);

		addAnimation("WALKCYCLE",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19],animationRate,false);

		timer = new FlxTimer();
		timer.start(Math.random() * 3,1,startWalking);
	}


	private function startWalking(t:FlxTimer):Void
	{
		play("WALKCYCLE");
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (finished)
		{
			play("WALKCYCLE");
			x += 56;
			y -= 4;
		}
	}	
}
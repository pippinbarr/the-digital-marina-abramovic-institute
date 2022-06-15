package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;


class RampState extends FlxState
{
	private var numFrames:Int = 0;


	private var bg:FlxSprite;

	private var rampAvatar:FlxSprite;

	private static var NUM_WALKERS:Int = 10;
	private var walkers:FlxGroup;

	private var othersCompleted:Bool = false;
	private var avatarCompleted:Bool = false;

	private var audio:HeadsetAudio;
	private var help:HelpBar;


	private var fadingOut:Bool = false;
	private var timer:FlxTimer;

	// WALKING IN

	private var walkingIn:Bool = true;
	private var avatar:Avatar;


	// SLEEPING

	private var sleeping:Bool = false;
	private var focusSleeping:Bool = false;
	private var sleepSprite:Sprite;
	private var sleepHelp:HelpBar;


	private var prevHelp:Bool = false;
	private var prevMessage:Bool = false;
	private var prevAudio:Bool = true;

	private var prevHelpString:String;
	private var prevMessageString:String;

	private var prevAvatarVX:Float = 0;
	private var prevAvatarVY:Float = 0;

	private var focusMessageWasVisible:Bool = false;

	override public function create():Void
	{
		bg = new FlxSprite(0,0,GameAssets.SLOMO_RAMP_BG_PNG);
		Helpers.scaleSprite(bg);

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);
		avatar.moveRight();

		rampAvatar = new FlxSprite(21,avatar.y - 126); //234);
		rampAvatar.loadGraphic(GameAssets.SLOMO_WALK_CYCLE_BASE_PNG,true,false,28,35,true);
		replaceAvatarColours();
		Helpers.scaleSprite(rampAvatar);
		rampAvatar.visible = false;

		rampAvatar.animation.frameIndex = 20;
		
		walkers = new FlxGroup();

		// for (i in 0...NUM_WALKERS)
		// {
		// 	var walkerY:Float = 120 + i*11;
		// 	var walkerX:Float = 0 + Math.random() * 24;
		// 	walkers.add(new RampClimber(i+1,walkerX,walkerY));
		// }
		walkers.add(rampAvatar);

		audio = new HeadsetAudio(Audio.RAMP_AUDIO);
		help = new HelpBar(GameAssets.SLOW_MOTION_WALK_INSTRUCTION,Globals.HELP_Y);
		sleepHelp = new HelpBar("",Globals.SLEEP_HELP_Y);
		
		add(bg);
		add(walkers);
		add(avatar);
		add(avatar.sprite);
		add(audio);
		add(help);
		add(sleepHelp);

		// SLEEP SPRITE

		sleepSprite = new Sprite();
		sleepSprite.addChild(new Bitmap(new BitmapData(FlxG.width,FlxG.height,false,0x000000)));
		sleepSprite.alpha = 0.0;
		FlxG.stage.addChild(sleepSprite);


		// FlxG.fade(0xFF000000,1,true);

		help.fadeIn();
	}


	private function replaceAvatarColours():Void
	{
		rampAvatar.replaceColor(GameAssets.HAIR_COLOR_1,GameAssets.AVATAR_HAIR_COLOR_1);
		rampAvatar.replaceColor(GameAssets.HAIR_COLOR_2,GameAssets.AVATAR_HAIR_COLOR_2);
		rampAvatar.replaceColor(GameAssets.HAIR_COLOR_3,GameAssets.AVATAR_HAIR_COLOR_3);
		rampAvatar.replaceColor(GameAssets.SKIN_COLOR,GameAssets.AVATAR_SKIN_COLOR);
		rampAvatar.replaceColor(GameAssets.PANTS_COLOR_BOTTOM,GameAssets.AVATAR_PANTS_COLOR_BOTTOM);
		rampAvatar.replaceColor(GameAssets.SHOES_COLOR_TOP,GameAssets.AVATAR_SHOES_COLOR_TOP);
		rampAvatar.replaceColor(GameAssets.SHOES_COLOR_BOTTOM,GameAssets.AVATAR_SHOES_COLOR_BOTTOM);
	}
	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		bg.destroy();

		rampAvatar.destroy();
		walkers.destroy();
		help.destroy();

		timer.destroy();

		sleepHelp.destroy();

		if (FlxG.stage.contains(sleepSprite)) FlxG.stage.removeChild(sleepSprite);

		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		if (!Helpers.focused) FlxG.mouse.show();
		else FlxG.mouse.hide();

		if (fadingOut) return;

		if (walkingIn && avatar.x >= 20)
		{
			avatar.idle();
			avatar.sprite.visible = false;
			rampAvatar.visible = true;
			walkingIn = false;
			help.setText(GameAssets.SLOW_MOTION_WALK_INSTRUCTION);
		}

		handleSleepInput();
		handleInput();
		walkers.sort("y");

		othersCompleted = true;
		avatarCompleted = rampAvatar.x >= FlxG.width - 30;

		for (i in 0...walkers.members.length)
		{
			if (walkers.members[i] != null && 
				cast(walkers.members[i],FlxSprite).x < FlxG.width - 30 &&
				walkers.members[i] != rampAvatar)
			{
				othersCompleted = false;
				break;
			}
		}

/*		if (othersCompleted)
			trace("OTHERS COMPLETED.");
		if (avatarCompleted)
			trace("AVATAR COMPLETED.");
*/

		if (audio.canLeave && avatarCompleted && !fadingOut)
		{
			help.fadeOut();
			fadeToNextState();
			fadingOut = true;
		}
		else if (avatarCompleted)
		{
			help.setText(GameAssets.SLOW_MOTION_WAIT_INSTRUCTION);
		}


		if (sleeping || focusSleeping)
		{
			sleepSprite.alpha += 0.01;
			if (sleepSprite.alpha >= 1.0)
			{
				Helpers.lastAvatarY = -1;
				FlxG.switchState(new SleepState());
			}
		}

	}	


	public function handleSleepInput():Void
	{
		// Handle focus sleeping first.
		if (!Helpers.focused && !focusSleeping)
		{
			focusSleeping = true;

			prevHelp = help.visible;
			help.visible = false;

			prevAudio = audio.visible;
			audio.visible = false;

			sleepHelp.setText(GameAssets.FOCUS_INSTRUCTION);
		}
		else if (Helpers.focused && focusSleeping)
		{
			focusSleeping = false;

			help.visible = prevHelp;
			audio.visible = prevAudio;
		}
		
		if (focusSleeping) return;


		// Now handle shift sleeping

		if (!Helpers.sleepKeyIsDown && !sleeping)
		{
			sleeping = true;

			prevHelp = help.visible;
			help.visible = false;

			prevAudio = audio.visible;
			audio.visible = false;

			sleepHelp.setText(GameAssets.WAKE_UP_INSTRUCTION);
			sleepHelp.fadeIn();
		}
		else if (Helpers.sleepKeyIsDown && Helpers.focused && sleeping)
		{			
			sleepSprite.alpha = 0.0;

			sleeping = false;
			sleepHelp.fadeOut();

			help.visible = prevHelp;
			audio.visible = prevAudio;
		}
	}



	public function handleInput():Void
	{
		// if (FlxG.keys.TAB)
		// {
		// 	FlxG.switchState(new TestMenuState());
		// }

		if (walkingIn) return;
		if (sleeping) return;
		if (focusSleeping) return;


		if (FlxG.keyboard.pressed("RIGHT"))
		{
			rampAvatar.animation.frameIndex++;
			numFrames++;
			// trace(numFrames);

			if (rampAvatar.animation.frameIndex == 20) 
			{
				rampAvatar.animation.frameIndex = 0;
				rampAvatar.x += 56;
			}
			// if (rampAvatar.frameIndex % 5 == 0)
			// {
			// 	if (rampAvatar.x > 80 && rampAvatar.x < FlxG.width - 140)
			// 	{
			// 		rampAvatar.y -= 2;
			// 	}
			// }
			if (rampAvatar.animation.frameIndex % 2 == 0)
			{
				if (rampAvatar.x > 80 && rampAvatar.x < FlxG.width - 140)
				{
					rampAvatar.y -= 1;
				}
			}

		}
	}


	private function fadeToNextState():Void
	{
		// nextState(null);

		fadingOut = true;
		// avatarMovementEnabled = false;
		// avatar.idle();
		// FlxG.fade(0xFF000000,1);

		timer = FlxTimer.start(1,nextState);
/*		FlxG.paused = true;      */

		sleeping = false;
		focusSleeping = false;
	}


	private function nextState(t:FlxTimer):Void
	{
		Helpers.lastAvatarY = rampAvatar.y + rampAvatar.height - 10;
		FlxG.switchState(new WaterDrinkingState());
	}

}





















class RampClimber extends FlxSprite
{
	// private var ANIMATION_RATE:Int = 0;
	 private var ANIMATION_RATE:Int = 3;
	 private var MIN_ANIMATION_RATE:Int = 1;
	// private var ANIMATION_RATE:Int = 20;
	// private var MIN_ANIMATION_RATE:Int = 20;
	private var shift:Bool = false;

	private var prevFrame:Int = -1;

	private var timer:FlxTimer;

	public function new(I:Int,X:Float,Y:Float):Void
	{
		super(X,Y);

		var animationRate:Int = Math.floor(Math.random() * ANIMATION_RATE) + MIN_ANIMATION_RATE;
		
		loadGraphic(GameAssets.SLOMO_WALK_CYCLE_BASE_PNG,true,true,28,35,true);
		Helpers.scaleSprite(this);
		animation.frameIndex = 20;

		reColor();

		animation.add("WALKCYCLE",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19],animationRate,false);

		prevFrame = -1;

		timer = FlxTimer.start(Math.random() * 3,startWalking);
	}


	private function reColor():Void
	{
		// HAIR //

		var hairColour:Int = GameAssets.HAIR_COLORS[Math.floor(Math.random() * GameAssets.HAIR_COLORS.length)];
		var hairType:Int = Math.floor(Math.random() * 3);

		replaceColor(GameAssets.HAIR_COLOR_1,hairColour);

		if (hairType > 0)
		{
			replaceColor(GameAssets.HAIR_COLOR_2,hairColour);

			if (hairType > 1)
			{
				replaceColor(GameAssets.HAIR_COLOR_3,hairColour);
			}
			else
			{
				replaceColor(GameAssets.HAIR_COLOR_3,0x00000000);
			}
		}
		else
		{
			replaceColor(GameAssets.HAIR_COLOR_2,0x00000000);
			replaceColor(GameAssets.HAIR_COLOR_3,0x00000000);
		}

		// SKIN //

		var skinColor:Int = GameAssets.SKIN_COLORS[Math.floor(Math.random() * GameAssets.SKIN_COLORS.length)];
		replaceColor(GameAssets.SKIN_COLOR,skinColor);


		// PANTS //

		var pantsColor:Int = GameAssets.PANTS_COLORS[Math.floor(Math.random() * GameAssets.PANTS_COLORS.length)];
		var pantsColorBottom:Int = pantsColor;

		if (Math.random() < 0.8)
		{
			replaceColor(GameAssets.PANTS_COLOR_BOTTOM,pantsColor);
		}
		else
		{
			replaceColor(GameAssets.PANTS_COLOR_BOTTOM,skinColor);
			pantsColorBottom = skinColor;
		}


		var shoesColor:Int = GameAssets.SHOES_COLORS[Math.floor(Math.random() * GameAssets.SHOES_COLORS.length)];

		if (Math.random() < 0.7)
		{
			// SHOES
			replaceColor(GameAssets.SHOES_COLOR_TOP,pantsColorBottom);
			replaceColor(GameAssets.SHOES_COLOR_BOTTOM,shoesColor);
		}
		else
		{
			// BOOTS
			replaceColor(GameAssets.SHOES_COLOR_TOP,shoesColor);
			replaceColor(GameAssets.SHOES_COLOR_BOTTOM,shoesColor);
		}
	}


	private function startWalking(t:FlxTimer):Void
	{
		animation.play("WALKCYCLE");
	}


	override public function destroy():Void
	{
		timer.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (animation.frameIndex != prevFrame)
		{
			prevFrame = animation.frameIndex;
			if (x > 80 && x < FlxG.width - 140)
			{
				if (animation.frameIndex % 2 == 0)
				{
					y -= 1;
				}
			}
		}

		if (animation.finished)
		{
			animation.play("WALKCYCLE");
			x += 56;
		}
	}	


}

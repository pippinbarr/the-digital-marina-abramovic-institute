package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

import flash.display.BitmapData;
// import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.net.FileReference;


class GazeState extends ChamberState
{
	var leftChair:Collidable;
	var rightChair:Collidable;
	var chairTrigger:FlxSprite;
	var chairAvatar:Sortable;
	var chairOther:Sortable;

	private static var RIGHT:Int = 0;
	private static var DOWN:Int = 1;
	private static var LEFT:Int = 2;
	private static var UP:Int = 3;
	var arrowsAvatar:FlxSprite;
	var arrowsOther:FlxSprite;

	private var gazeLine:FlxSprite;
	private var matchThisFrame:Bool = false;

	var avatarSeated:Bool = false;

	override public function create():Void
	{
		super.create();	

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);
		avatar.animation.frameIndex = 20;
		
		var leftChairSprite = new Sortable(0,0,GameAssets.CHAIR_PNG);
		Helpers.scaleSprite(leftChairSprite);
		leftChairSprite.facing = FlxObject.RIGHT;
		leftChair = new Collidable(FlxG.width/2 - leftChairSprite.width/2 - 50,320,leftChairSprite,0.1);


		var rightChairSprite = new Sortable(0,0,GameAssets.CHAIR_RIGHT_PNG);
		Helpers.scaleSprite(rightChairSprite);

		rightChairSprite.facing = FlxObject.LEFT;
		rightChair = new Collidable(FlxG.width/2 - rightChairSprite.width/2 + 50,320,rightChairSprite,0.1);


		chairTrigger = new Sortable(leftChair.x + 30,leftChair.y - 10);
		chairTrigger.makeGraphic(Math.floor(leftChair.width - 60),Math.floor(leftChair.height + 20),0xFFFF0000);

		chairAvatar = new Sortable(leftChair.x + 12, leftChair.sprite.y - 8);
		chairAvatar.loadGraphic(GameAssets.GAZE_AVATAR_PNG,true,false,14,30,true);
		Helpers.scaleSprite(chairAvatar);
		chairAvatar.visible = false;
		chairAvatar.sortID = leftChair.sprite.sortID;
		replaceAvatarColours();

		arrowsAvatar = new Sortable(chairAvatar.x + 8,chairAvatar.y - 48);
		arrowsAvatar.loadGraphic(GameAssets.GAZE_ARROWS_PNG,true,false,7,7,false);
		Helpers.scaleSprite(arrowsAvatar);
		arrowsAvatar.visible = false;

		chairOther = new Sortable(rightChair.x - 4,rightChair.sprite.y - 8);
		chairOther.loadGraphic(GameAssets.GAZE_OTHER_PNG,true,false,14,30,true);
		Helpers.scaleSprite(chairOther);
		chairOther.sortID = leftChair.sprite.sortID;
		Helpers.randomColourPerson(chairOther);

		arrowsOther = new Sortable(chairOther.x + 20,chairOther.y - 48);
		arrowsOther.loadGraphic(GameAssets.GAZE_ARROWS_PNG,true,false,7,7,false);
		Helpers.scaleSprite(arrowsOther);
		arrowsOther.visible = false;

		gazeLine = new Sortable(chairAvatar.x + 28,chairAvatar.y + 16,GameAssets.GAZE_LINE_PNG);
		Helpers.scaleSprite(gazeLine);
		gazeLine.alpha = 0.0;

		add(avatar);

		display.add(arrowsAvatar);
		display.add(arrowsOther);
		display.add(gazeLine);
		display.add(avatar.sprite);		
		display.add(leftChair.sprite);
		display.add(rightChair.sprite);
		display.add(chairAvatar);
		display.add(chairOther);

		collidables.add(leftChair);
		collidables.add(rightChair);

		audio = new HeadsetAudio(Audio.GAZE_AUDIO);
		fg.add(audio);


		walkIn(backWall.height);
	}


	private function replaceAvatarColours():Void
	{
		chairAvatar.replaceColor(GameAssets.HAIR_COLOR_1,GameAssets.AVATAR_HAIR_COLOR_1);
		chairAvatar.replaceColor(GameAssets.HAIR_COLOR_2,GameAssets.AVATAR_HAIR_COLOR_2);
		chairAvatar.replaceColor(GameAssets.HAIR_COLOR_3,GameAssets.AVATAR_HAIR_COLOR_3);
		chairAvatar.replaceColor(GameAssets.SKIN_COLOR,GameAssets.AVATAR_SKIN_COLOR);
		chairAvatar.replaceColor(GameAssets.PANTS_COLOR_BOTTOM,GameAssets.AVATAR_PANTS_COLOR_BOTTOM);
		chairAvatar.replaceColor(GameAssets.SHOES_COLOR_TOP,GameAssets.AVATAR_SHOES_COLOR_TOP);
		chairAvatar.replaceColor(GameAssets.SHOES_COLOR_BOTTOM,GameAssets.AVATAR_SHOES_COLOR_BOTTOM);
	}

	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		leftChair.destroy();
		rightChair.destroy();
		chairTrigger.destroy();
		chairAvatar.destroy();
		chairOther.destroy();
		arrowsAvatar.destroy();
		arrowsOther.destroy();
		gazeLine.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}	


	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;

		if (audio.textIndex >= 8 && !arrowsOther.visible && avatarSeated)
		{
			gazeLine.alpha = 0.8;
			gazeLine.visible = true;
			showNewArrow(null);
		}

		if (avatarMovementEnabled && avatar.overlaps(chairTrigger) && FlxG.keyboard.justPressed("ENTER"))
		{
			avatar.sprite.visible = false;
			avatarMovementEnabled = false;
			avatar.idle();
			chairAvatar.visible = true;
			avatarSeated = true;
		}
		else if (avatarSeated && FlxG.keyboard.justPressed("ENTER"))
		{
			avatar.sprite.visible = true;
			avatarMovementEnabled = true;
			chairAvatar.visible = false;
			avatarSeated = false;
			arrowsAvatar.visible = false;
			arrowsOther.visible = false;
			gazeLine.visible = false;
			
			timer.abort();
		}
		else if (avatarSeated && arrowsOther.visible)
		{
			matchThisFrame = false;

			if (FlxG.keyboard.pressed("LEFT"))
			{
				arrowsAvatar.visible = true;
				arrowsAvatar.animation.frameIndex = LEFT;
				if (arrowsOther.animation.frameIndex == LEFT) matchThisFrame = true;
			}
			else if (FlxG.keyboard.pressed("RIGHT"))
			{
				arrowsAvatar.visible = true;

				arrowsAvatar.animation.frameIndex = RIGHT;
				if (arrowsOther.animation.frameIndex == RIGHT) matchThisFrame = true;
			}
			else if (FlxG.keyboard.pressed("UP"))
			{
				arrowsAvatar.visible = true;

				arrowsAvatar.animation.frameIndex = UP;
				if (arrowsOther.animation.frameIndex == UP) matchThisFrame = true;
			}
			else if (FlxG.keyboard.pressed("DOWN"))
			{
				arrowsAvatar.visible = true;

				arrowsAvatar.animation.frameIndex = DOWN;
				if (arrowsOther.animation.frameIndex == DOWN) matchThisFrame = true;
			}
			else
			{
				arrowsAvatar.visible = false;
			}

			if (matchThisFrame)
			{
				gazeLine.alpha += 0.01;
				if (gazeLine.alpha > 1) gazeLine.alpha = 1;
				chairAvatar.animation.frameIndex = 0;
			}
			else
			{
				gazeLine.alpha -= 0.01;
				if (gazeLine.alpha <= 0) 
				{
					gazeLine.alpha = 0;
					chairAvatar.animation.frameIndex = 1;
				}

			}
		}

		return true;
	}


	private function showNewArrow(t:FlxTimer):Void
	{
		var index:Int = Math.floor(Math.random() * 4);
		arrowsOther.animation.frameIndex = index;
		arrowsOther.visible = true;

		timer = FlxTimer.start(3,showNewArrow);
	}


	override public function handleCollisions():Bool
	{
		if (!super.handleCollisions()) return false;

		if (avatar.overlaps(chairTrigger) && !avatarSeated)
		{
			help.setText(GameAssets.SIT_INSTRUCTION);
			// help.setText("Move with the arrow keys. Press ENTER to sit on the chair.");
		}
		else if (!avatarSeated)
		{
			// help.setText(GameAssets.WALK_INSTRUCTION);	
			help.fadeOut();		
		}
		else if (audio.textIndex >= 8 && avatarSeated)
		{
			help.setText(GameAssets.GAZE_MATCH_INSTRUCTION + "\n" + GameAssets.STAND_INSTRUCTION);
		}
		else
		{
			help.setText(GameAssets.STAND_INSTRUCTION);			
		}

		return true;
	}


	override private function nextState(t:FlxTimer):Void
	{
		super.nextState(t);
		FlxG.switchState(new SoundState());
	}
}

package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;


class WallState extends ChamberState
{
	override public function create():Void
	{
		super.create();	

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);
		avatar.animation.frameIndex = 20;

		var crystals:Sortable = new Sortable(0,0,GameAssets.BG_WALL_CRYSTALS_PNG);
		//crystals.setOriginToCorner();
		crystals.scale.x = crystals.scale.y = 4;
		crystals.sortID = 0;

		add(avatar);

		display.add(avatar.sprite);		
		display.add(crystals);

		audio = new HeadsetAudio(Audio.WALL_AUDIO);
		fg.add(audio);

		walkIn(backWall.height);
	}

	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();
		
		display.sort();
	}


	override private function nextState(t:FlxTimer):Void
	{
		super.nextState(t);
		FlxG.switchState(new GazeState());
	}	
}

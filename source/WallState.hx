package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;


class WallState extends ChamberState
{
	override public function create():Void
	{
		super.create();	

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);
		avatar.frame = 20;

		var crystals:Sortable = new Sortable(0,0,GameAssets.BG_WALL_CRYSTALS_PNG);
		crystals.setOriginToCorner();
		crystals.scale.x = crystals.scale.y = 4;
		crystals.sortID = 0;

		add(avatar);

		display.add(avatar.sprite);		
		display.add(crystals);

		audio = new HeadsetAudio(Audio.WALL_AUDIO);
		fg.add(audio);

		walkIn(backWall.height);

		help.visible = Globals.HELP_VISIBLE;
		audio.visible = Globals.AUDIO_VISIBLE;

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

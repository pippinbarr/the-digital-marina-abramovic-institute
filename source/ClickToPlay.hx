package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;
import org.flixel.FlxSound;
import org.flixel.plugin.photonstorm.FlxCollision;

import flash.net.URLRequest;


class ClickToPlay extends FlxState
{

	override public function create():Void
	{
		FlxG.bgColor = 0xFF444444;
		FlxG.mouse.show();

		var text:FlxText = new FlxText(50,FlxG.height/2,FlxG.width - 100,"CLICK TO PLAY",24,true);
		text.setFormat("Commodore",28,0xFF000000,"center");

		add(text);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		if (FlxG.mouse.justPressed())
		{
			FlxG.mouse.hide();
			FlxG.switchState(new EntranceState());
		}
	}	
}


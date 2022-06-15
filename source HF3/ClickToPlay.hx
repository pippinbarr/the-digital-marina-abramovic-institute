package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.plugin.photonstorm.FlxCollision;

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


package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxG;

class HeadsetAudio extends FlxGroup
{
	private static var TEXT_SPEED:Float = -110; // -100 works well
	// private static var TEXT_SPEED:Float = -1100; // -100 works well

	private static var CHAR_WIDTH:Float = 18;

	private var text:FlxText;
	private var icon:FlxSprite;
	private var bg:FlxSprite;

	public var texts:Array<String>;
	public var textIndex:Int = 0;
	public var completed = false;
	public var canLeave = false;

	public var canComplete = true;


	public function new(T:Array<String>)
	{
		super();

		texts = T;

		if (texts.length == 0)
		{
			completed = true;
			return;
		}

		text = new FlxText(FlxG.width,20,8000);

		setupText();

		bg = new FlxSprite(40,16);
		bg.makeGraphic(FlxG.width,32,0xFF000000);
		bg.alpha = 0.5;

		icon = new FlxSprite(0,16,GameAssets.AUDIO_ICON_PNG);
		icon.setOriginToCorner();
		icon.scale.x = 4;
		icon.scale.y = 4;
		icon.alpha = 0.5;

		add(bg);
		add(text);
		add(icon);
	}


	override public function destroy():Void
	{
		bg.destroy();
		icon.destroy();
		text.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (completed && canComplete) 
		{
			return;
		}

		if (text.x + text.width < 0)
		{
			textIndex++;

			if (textIndex == texts.length && canComplete)
			{
				completed = true;
			}
			else if (canComplete)
			{
				setupText();
			}
		}
	}


	private function setupText():Void
	{
		var theLength:Float = texts[textIndex].length * CHAR_WIDTH + CHAR_WIDTH;

		// text = new FlxText(FlxG.width,20,Math.floor(theLength),texts[textIndex],16,true);

		text.text = texts[textIndex];

		if (text.text == "")
		{
			// theLength = (10 * -TEXT_SPEED) - 640;

			text.text = ".    .    .    .    .";
			theLength = text.text.length * CHAR_WIDTH + CHAR_WIDTH;
			// theLength = 10;
		}
		else if (text.text == "[CAN LEAVE]")
		{
			canLeave = true;
			textIndex++;
			setupText();
			return;
		}

		text.x = FlxG.width;
		text.y = 20;
		text.width = theLength;
		text.setFormat("Commodore",22,0xFFFFFFFF);
		text.moves = true;	
		text.velocity.x = TEXT_SPEED;	
	}


	public function playTexts(T:Array<String>):Void
	{
		textIndex = 0;
		completed = false;
		texts = T;
		setupText();
	}
}
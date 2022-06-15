package;

import org.flixel.FlxGroup;
import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxG;

class HelpBar extends FlxGroup
{
	public var text:FlxText;
	private var bg:FlxSprite;

	private static var FADE_AMOUNT:Float = 0.1;

	private static var VISIBLE:Int = 0;
	private static var FADE_IN:Int = 1;
	private static var FADE_OUT:Int = 2;
	private static var FADE_OUT_AND_IN:Int = 3;
	private static var INVISIBLE:Int = 4;

	private var state:Int = 4;

	private var nextString:String = "";
	private var currentText:String = "-1";

	public var Y:Float;


	public function new(S:String,Y:Float)
	{
		super();

		text = new FlxText(0,0,FlxG.width,S,14,true);
		text.setFormat("Commodore",14,0xFFFFFFFF,"center");
		text.alpha = 0.0;
		text.y = Y + 24 - text.height/2;

		bg = new FlxSprite(0,Y);
		bg.makeGraphic(FlxG.width,48,0xFF000000);
		bg.alpha = 0.0;

		add(bg);
		add(text);
	}


	override public function destroy():Void
	{
		bg.destroy();
		text.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		if (state == FADE_IN)
		{
			if (currentText != nextString)
			{
				text.text = nextString;
				currentText = nextString;
			}
			
			text.y = bg.y + 24 - text.height/2;

			text.alpha = Math.min(text.alpha + 2*FADE_AMOUNT,1.0);
			bg.alpha = Math.min(bg.alpha + FADE_AMOUNT,1.0);

			if (text.alpha == 1.0)
			{
				// trace("FADE_IN -> VISIBLE");
				state = VISIBLE;
			}
		}
		else if (state == FADE_OUT_AND_IN)
		{
			text.alpha = Math.max(text.alpha - 2*FADE_AMOUNT,0.0);
			bg.alpha = Math.max(bg.alpha - FADE_AMOUNT,0.0);

			if (text.alpha == 0.0)
			{
				text.text = nextString;
				currentText = nextString;

				text.y = bg.y + 24 - text.height/2;
				
				state = FADE_IN;

				// trace("FADE_OUT_AND_IN -> FADE_IN (set text to nextString)");
			}
		}
		else if (state == FADE_OUT)
		{
			text.alpha = Math.max(text.alpha - 2*FADE_AMOUNT,0.0);
			bg.alpha = Math.max(bg.alpha - FADE_AMOUNT,0.0);

			if (text.alpha == 0.0)
			{
				// trace("FADE_OUT -> INVISIBLE");
				state = INVISIBLE;
			}
		}
	}


	public function setText(S:String):Void
	{
		// trace("Setting text to: " + S + "...");
		if (currentText == S && state == VISIBLE) 
		{
			return;
		}
		else if (currentText == S && state == FADE_IN)
		{
			return;
		}
		else if (nextString == S && state == FADE_OUT_AND_IN)
		{
			return;
		}

		// trace("text.text == S:\n" + text.text + "\n==\n" + S + "\nis " + (text.text == S));
		// trace("nextString == S:\n" + nextString + "\n==\n" + S + "\nis " + (nextString == S));
		// trace("text.text == nextString:\n" + text.text + "\n==\n" + nextString + "\nis " + (text.text == nextString));

		nextString = S;
		state = FADE_OUT_AND_IN;

		// trace("setText -> FADE_OUT_AND_IN");
	}


	public function setTextNoFade(S:String):Void
	{
		// trace("...ok.");
		text.text = S;
		currentText = S;
		text.y = bg.y + 24 - text.height/2;
	}



	public function setInvisible():Void
	{
		// trace("help.setInvisible()");
		text.alpha = 0.0;
		bg.alpha = 0.0;
		state = INVISIBLE;
	}


	public function fadeOut():Void
	{
		state = FADE_OUT;

		// trace("fadeOut() -> FADE_OUT");
	}


	public function fadeIn():Void
	{
		state = FADE_IN;

		// trace("fadeIn() -> FADE_IN");
	}


	public function isVisible():Bool
	{
		return (state == INVISIBLE);
	}


	private function getCurrentStateName():String
	{
		if (state == VISIBLE) return "VISIBLE";
		else if (state == FADE_IN) return "FADE_IN";
		else if (state == FADE_OUT) return "FADE_OUT";
		else if (state == FADE_OUT_AND_IN) return "FADE_OUT_AND_IN";
		else if (state == INVISIBLE) return "INVISIBLE";
		else return "UNKNOWN";
	}

}
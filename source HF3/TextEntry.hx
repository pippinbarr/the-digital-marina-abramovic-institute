package;


import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import flixel.text.FlxText;
import flixel.FlxG;


class TextEntry extends FlxText
{
	private static var VALID_CHARACTERS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.,/\\?<>():;'\"!@#$%^&*-+_={}[]| ";

	private var entered:Bool = false;
	private var maxLength:Int;
	private var enabled:Bool = false;

	public function new(X:Float,Y:Float,Width:Int,MaxLength:Int)
	{			
		super(X,Y,Width,"",true);

		maxLength = MaxLength;
	}


	public override function update():Void 
	{
		super.update();						
	}


	public function enable():Void
	{
		enabled = true;
		text = "";
		entered = false;
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
	}


	public function reenable():Void
	{
		enabled = true;
		entered = false;
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
	}


	public function disable():Void
	{
		enabled = false;
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
	}


	private function onKeyDown(e:KeyboardEvent):Void
	{
		if (!enabled) 
		{
			return;
		}

		if (e.keyCode == Keyboard.ENTER && text != "")
		{
			// FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			// entered = true;
		}
		else if (e.keyCode == Keyboard.BACKSPACE && text.length > 0) 
		{
			text = text.substring(0,text.length-1);
		}
		else
		{		
			var character:String = String.fromCharCode(e.charCode);
			character = character.toUpperCase();
			// Can't start with space
			if (character.indexOf(" ") != -1 && text.length == 0) return;			
			// Can't have illegal characters
			// if (VALID_CHARACTERS.indexOf(character) != -1 && text.length < maxLength)
			if (text.length < maxLength && e.keyCode != Keyboard.ENTER) 
			{
				text += character;
			}
		}
	}



	public override function destroy():Void 
	{
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

		super.destroy();
	}
}

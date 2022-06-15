package;

import flash.text.TextField;
import flash.text.TextFormat;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import org.flixel.FlxG;
import org.flixel.FlxGroup;



class Message extends FlxGroup
{
	public var buffer:Sprite;

	private var outerBox:Bitmap;
	private var lineBox:Bitmap;
	private var innerBox:Bitmap;

	public var text:TextField;
	private var textFormat:TextFormat;

	public var message:String;


	public function new()
	{			
		super();

		textFormat = new TextFormat("assets/ttf/Commodore",20,0xFF000000);

		text = new TextField();
		text.defaultTextFormat = textFormat;
		text.text = "";
		text.embedFonts = true;
		text.wordWrap = true;
		text.autoSize = flash.text.TextFieldAutoSize.CENTER;
		text.selectable = false;
		text.width = 480; 
		text.visible = false;

		visible = false;

		buffer = new Sprite();

	}


	public function setup(S:String):Void
	{
		if (outerBox != null)
		{
			buffer.removeChild(outerBox);
			buffer.removeChild(lineBox);
			buffer.removeChild(innerBox);
			buffer.removeChild(text);
		}

		message = S;

		// text.text = message;
		text.htmlText = message;

		outerBox = new Bitmap(new BitmapData(Math.floor(text.width + 48),Math.floor(text.height + 40),false,0xFFFFFF));
		lineBox = new Bitmap(new BitmapData(Math.floor(text.width + 48 - 8),Math.floor(text.height - 8 + 40),false,0xCCCCCC));
		innerBox = new Bitmap(new BitmapData(Math.floor(text.width + 48 - 16),Math.floor(text.height - 16 + 40),false,0xFFFFFF));

		outerBox.x = FlxG.width/2 - outerBox.width/2;
		outerBox.y = FlxG.height/2 - outerBox.height/2;

		lineBox.x = FlxG.width/2 - lineBox.width/2;
		lineBox.y = FlxG.height/2 - lineBox.height/2;

		innerBox.x = FlxG.width/2 - innerBox.width/2; 
		innerBox.y = FlxG.height/2 - innerBox.height/2;



		buffer.addChild(outerBox);
		buffer.addChild(lineBox);
		buffer.addChild(innerBox);
		buffer.addChild(text);



		displayMessage();
	}

	private function displayMessage():Void 
	{	
		text.text = message;	

		text.x = FlxG.width/2 - text.width/2;
		text.y = FlxG.height/2 - text.height/2;
		text.visible = true;

		FlxG.stage.addChild(buffer);

		outerBox.visible = true;
		lineBox.visible = true;
		innerBox.visible = true;

		buffer.visible = true;
		visible = true;

		FlxG.paused = true;
	}


	public override function update():Void 
	{
		super.update();
	}


	public override function destroy():Void 
	{
		if (buffer != null && FlxG.stage.contains(buffer))
		{
			FlxG.stage.removeChild(buffer);
		}

		FlxG.stage.focus = null;

		super.destroy();
	}


	public function setVisible(value:Bool):Void
	{
		visible = value;
		buffer.visible = value;
		FlxG.paused = value;
	}


	public function isVisible():Bool
	{
		return visible;
	}
}

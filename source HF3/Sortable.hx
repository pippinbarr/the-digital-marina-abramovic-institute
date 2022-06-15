package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import flixel.util.FlxPoint;


class Sortable extends FlxSprite
{

	public var sortID:Float;


	public function new(X:Float, Y:Float, SimpleGraphic:Dynamic = null)
	{
		super(X,Y,SimpleGraphic);
	}



	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}
}
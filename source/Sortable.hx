package;

import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

import org.flixel.util.FlxPoint;


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
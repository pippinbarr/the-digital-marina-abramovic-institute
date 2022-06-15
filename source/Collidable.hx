package;

import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

import org.flixel.util.FlxPoint;


class Collidable extends FlxSprite
{
	public var sprite:Sortable;


	public function new(X:Float,Y:Float,S:Sortable,HitScale:Float)
	{
		super(X,Y);

		sprite = S;

		setOriginToCorner();
		makeGraphic(Math.floor(sprite.width),Math.floor(sprite.height*HitScale),0xFFFF0000);

		updateSpritePosition();

		this.visible = Globals.DEBUG_COLLISION;
		this.immovable = true;

		sprite.sortID = y;
	}


	override public function destroy():Void
	{
		sprite.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		updateSpritePosition();
	}


	private function updateSpritePosition():Void
	{
		sprite.x = x;
		sprite.y = y + height - sprite.height;
		sprite.sortID = y;
	}
}
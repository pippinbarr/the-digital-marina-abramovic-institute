package;

import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

import org.flixel.util.FlxPoint;


class Person extends Collidable
{
	public static var SPEED:Float = 100;


	public function new(X:Float,Y:Float,Sprite:String)
	{
		var personSprite:Sortable = new Sortable(X,Y);
		personSprite.loadGraphic(Sprite,true,false,14,35,true);
		Helpers.scaleSprite(personSprite);

		super(X,Y,personSprite,0.1);

		addAnimations(personSprite);

		facing = FlxObject.RIGHT;
		updateSpritePosition();
		updateAnimation();
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		handleAnimation();
	}


	public function handleAnimation():Void
	{
		if (this.velocity.x > 0) {
			sprite.facing = FlxObject.RIGHT;
			sprite.play("rightWalk",false);
		}
		else if (this.velocity.x < 0) {
			sprite.facing = FlxObject.LEFT;
			sprite.play("leftWalk",false);
		}
		else if (this.velocity.y > 0) {
			sprite.facing = FlxObject.DOWN;
			sprite.play("frontWalk",false);
		}
		else if (this.velocity.y < 0) {
			sprite.facing = FlxObject.UP;
			sprite.play("backWalk",false);
		}
		else if (this.facing == FlxObject.LEFT) {
			sprite.play("leftIdle", false);
		}
		else if (this.facing == FlxObject.RIGHT) {
			sprite.play("rightIdle", false);
		}
		else if (this.facing == FlxObject.DOWN) {
			sprite.play("frontIdle", false);
		}
		else if (this.facing == FlxObject.UP) {
			sprite.play("backIdle", false);
		}
	}


	public function moveLeft():Void
	{
		// if (velocity.x < 0)
		// {
		// 	velocity.x = 0;
		// }
		// else
		{
			facing = FlxObject.LEFT;
			velocity.x = -SPEED;
			velocity.y = 0;
		}
	}


	public function moveRight():Void
	{
		// if (velocity.x > 0) 
		// {
		// 	velocity.x = 0;
		// }
		// else
		{
			facing = FlxObject.RIGHT;
			velocity.x = SPEED;
			velocity.y = 0;
		}
	}


	public function moveUp():Void
	{
		// if (velocity.y < 0)
		// {
		// 	velocity.y = 0;
		// }
		// else
		{
			facing = FlxObject.UP;
			velocity.y = -SPEED;
			velocity.x = 0;
		}
	}


	public function moveDown():Void
	{

		// if (velocity.y > 0)
		// {
		// 	velocity.y = 0;
		// }
		// else
		{
			facing = FlxObject.DOWN;
			velocity.y = SPEED;
			velocity.x = 0;
		}
	}


	public function idle():Void
	{
		velocity.x = 0;
		velocity.y = 0;
	}


	public function undoAndStop():Void
	{
		x -= (velocity.x * FlxG.elapsed);
		y -= (velocity.y * FlxG.elapsed);
		idle();
	}


	private function addAnimations(s:FlxSprite):Void
	{
		s.addAnimation("rightWalk",GameAssets.RIGHT_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.addAnimation("leftWalk",GameAssets.LEFT_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.addAnimation("frontWalk",GameAssets.FRONT_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.addAnimation("backWalk",GameAssets.BACK_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.addAnimation("rightIdle",GameAssets.RIGHT_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.addAnimation("leftIdle",GameAssets.LEFT_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.addAnimation("frontIdle",GameAssets.FRONT_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.addAnimation("backIdle",GameAssets.BACK_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
	}
}
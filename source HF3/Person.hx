package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

import flixel.util.FlxPoint;


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
		// V---- ACTUAL PROBLEM HERE ----V //
		// animation.updateAnimation();
		//
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
			sprite.animation.play("rightWalk",false);
		}
		else if (this.velocity.x < 0) {
			sprite.facing = FlxObject.LEFT;
			sprite.animation.play("leftWalk",false);
		}
		else if (this.velocity.y > 0) {
			sprite.facing = FlxObject.DOWN;
			sprite.animation.play("frontWalk",false);
		}
		else if (this.velocity.y < 0) {
			sprite.facing = FlxObject.UP;
			sprite.animation.play("backWalk",false);
		}
		else if (this.facing == FlxObject.LEFT) {
			sprite.animation.play("leftIdle", false);
		}
		else if (this.facing == FlxObject.RIGHT) {
			sprite.animation.play("rightIdle", false);
		}
		else if (this.facing == FlxObject.DOWN) {
			sprite.animation.play("frontIdle", false);
		}
		else if (this.facing == FlxObject.UP) {
			sprite.animation.play("backIdle", false);
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
		s.animation.add("rightWalk",GameAssets.RIGHT_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.animation.add("leftWalk",GameAssets.LEFT_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.animation.add("frontWalk",GameAssets.FRONT_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.animation.add("backWalk",GameAssets.BACK_WALK_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.animation.add("rightIdle",GameAssets.RIGHT_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.animation.add("leftIdle",GameAssets.LEFT_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.animation.add("frontIdle",GameAssets.FRONT_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
		s.animation.add("backIdle",GameAssets.BACK_IDLE_FRAMES,GameAssets.WALKCYCLE_FRAMERATE,true);
	}
}
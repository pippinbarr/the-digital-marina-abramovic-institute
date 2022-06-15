package;

import org.flixel.FlxG;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;

import org.flixel.util.FlxPoint;


class Avatar extends Person
{
	public static var labcoat:Bool = false;


	public function new(X:Float,Y:Float,Sprite:String,Coat:Bool = true)
	{		
		super(X,Y,Sprite);

		if (Sprite == GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG ||
			Sprite == GameAssets.SS_LABCOAT_WALKCYCLE_PNG)
		{
			Avatar.labcoat = true;
		}

		if (GameAssets.AVATAR_SKIN_COLOR == 0)
		{
			chooseAvatarColours();
		}

		Helpers.recolourPersonAsAvatar(sprite,Coat);
	}


	private function chooseAvatarColours():Void
	{
		// HAIR //

		var hairColour:Int = GameAssets.HAIR_COLORS[Math.floor(Math.random() * GameAssets.HAIR_COLORS.length)];
		var hairType:Int = Math.floor(Math.random() * 3);

		GameAssets.AVATAR_HAIR_COLOR_1 = hairColour;
		
		if (hairType > 0)
		{
			GameAssets.AVATAR_HAIR_COLOR_2 = hairColour;

			if (hairType > 1)
			{
				GameAssets.AVATAR_HAIR_COLOR_3 = hairColour;
			}
			else
			{
				GameAssets.AVATAR_HAIR_COLOR_3 = 0x00000000;
			}
		}
		else
		{
			GameAssets.AVATAR_HAIR_COLOR_2 = 0x00000000;
			GameAssets.AVATAR_HAIR_COLOR_3 = 0x00000000;
		}

		// SKIN //

		GameAssets.AVATAR_SKIN_COLOR = GameAssets.SKIN_COLORS[Math.floor(Math.random() * GameAssets.SKIN_COLORS.length)];

		// SHIRT //

		var shirtColor:Int = GameAssets.SHIRT_COLORS[Math.floor(Math.random() * GameAssets.SHIRT_COLORS.length)];
		var sleeveColor:Int = Helpers.darkenHex(shirtColor);

		if (hairType == 2)
		{
			GameAssets.AVATAR_NECK_COLOR = GameAssets.AVATAR_HAIR_COLOR_1;
			GameAssets.AVATAR_SHIRT_COLOR_TOP = GameAssets.AVATAR_HAIR_COLOR_1;
		}
		else
		{
			GameAssets.AVATAR_NECK_COLOR = GameAssets.AVATAR_SKIN_COLOR;
			GameAssets.AVATAR_SHIRT_COLOR_TOP = shirtColor;
		}

		var topRandom:Float = Math.random();

		GameAssets.AVATAR_SHIRT_COLOR_MAIN = shirtColor;

		if (topRandom > 0.6) 
		{ 	

			GameAssets.AVATAR_SHIRT_COLOR_TOP_SLEEVE = sleeveColor;
			GameAssets.AVATAR_SHIRT_COLOR_BOTTOM_SLEEVE = sleeveColor;
		}
		else if (topRandom > 0.2) 
		{
			GameAssets.AVATAR_SHIRT_COLOR_TOP_SLEEVE = sleeveColor;
			GameAssets.AVATAR_SHIRT_COLOR_BOTTOM_SLEEVE = GameAssets.AVATAR_SKIN_COLOR;
		}
		else 
		{
			GameAssets.AVATAR_SHIRT_COLOR_TOP_SLEEVE = GameAssets.AVATAR_SKIN_COLOR;
			GameAssets.AVATAR_SHIRT_COLOR_BOTTOM_SLEEVE = GameAssets.AVATAR_SKIN_COLOR;
		}

		// BELT //

		var beltColor:Int = GameAssets.BELT_COLORS[Math.floor(Math.random() * GameAssets.BELT_COLORS.length)];

		var beltRandom:Float = Math.random();
		if (beltRandom > 0.7) 
		{
			GameAssets.AVATAR_BELT_COLOR = beltColor;
		}
		else 
		{
			GameAssets.AVATAR_BELT_COLOR = shirtColor;
		}

		// PANTS //

		var pantsColor:Int = GameAssets.PANTS_COLORS[Math.floor(Math.random() * GameAssets.PANTS_COLORS.length)];

		if (Math.random() < 0.8)
		{
			// PANTS
			GameAssets.AVATAR_PANTS_COLOR_TOP = pantsColor;
			GameAssets.AVATAR_PANTS_COLOR_BOTTOM = pantsColor;
		}
		else
		{
			// SHORTS
			GameAssets.AVATAR_PANTS_COLOR_TOP = pantsColor;
			GameAssets.AVATAR_PANTS_COLOR_BOTTOM = GameAssets.AVATAR_SKIN_COLOR;
		}

		var shoesColor:Int = GameAssets.SHOES_COLORS[Math.floor(Math.random() * GameAssets.SHOES_COLORS.length)];

		if (Math.random() < 0.7)
		{
			// SHOES
			GameAssets.AVATAR_SHOES_COLOR_TOP = GameAssets.AVATAR_PANTS_COLOR_BOTTOM;
			GameAssets.AVATAR_SHOES_COLOR_BOTTOM = shoesColor;
		}
		else
		{
			// BOOTS
			GameAssets.AVATAR_SHOES_COLOR_TOP = shoesColor;
			GameAssets.AVATAR_SHOES_COLOR_BOTTOM = shoesColor;
		}

		// pippinAvatarColours();
	}


	private function pippinAvatarColours():Void
	{
		GameAssets.AVATAR_HAIR_COLOR_1 = 0xff3a2f0a;
		GameAssets.AVATAR_HAIR_COLOR_2 = 0x00000000;
		GameAssets.AVATAR_HAIR_COLOR_3 = 0x00000000;
		GameAssets.AVATAR_SKIN_COLOR = 0xffc38f9b;
		GameAssets.AVATAR_NECK_COLOR = 0xffc38f9b;
		GameAssets.AVATAR_SHIRT_COLOR_TOP = 0xff353535;
		GameAssets.AVATAR_SHIRT_COLOR_MAIN = 0xff353535;
		GameAssets.AVATAR_SHIRT_COLOR_TOP_SLEEVE = 0xff353535;
		GameAssets.AVATAR_SHIRT_COLOR_BOTTOM_SLEEVE = 0xffc38f9b;
		GameAssets.AVATAR_BELT_COLOR = 0xff353535;
		GameAssets.AVATAR_PANTS_COLOR_TOP = 0xff688faf;
		GameAssets.AVATAR_PANTS_COLOR_BOTTOM = 0xff688faf;
		GameAssets.AVATAR_SHOES_COLOR_TOP = 0xff688faf;
		GameAssets.AVATAR_SHOES_COLOR_BOTTOM = 0xffddddaa;
	}


	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}


	public function switchToCoat(Headphones:Bool = true):Void
	{
		Avatar.labcoat = true;

		if (Headphones)
		{
			sprite.loadGraphic(GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true,false,14,35,true);
		}
		else
		{
			sprite.loadGraphic(GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true,false,14,35,true);			
		}
		Helpers.recolourPersonAsAvatar(sprite,true);
		Helpers.scaleSprite(sprite);
		addAnimations(sprite);
		
		facing = FlxObject.UP;
		sprite.facing = FlxObject.UP;

		idle();

		updateSpritePosition();
		handleAnimation();
	}



	public function switchToWater():Void
	{
		sprite.loadGraphic(GameAssets.SS_WATER_WALKCYCLE_PNG,true,false,14,35,true);
		Helpers.recolourPersonAsAvatar(sprite,true);
		Helpers.scaleSprite(sprite);
		addAnimations(sprite);
		
		facing = FlxObject.UP;
		sprite.facing = FlxObject.UP;

		idle();

		updateSpritePosition();
		handleAnimation();
	}


	public function handleInput():Void
	{
		// HANDLE DIRECTIONAL KEYS
		if (FlxG.keys.RIGHT)
		{
			moveRight();
		}
		else if (FlxG.keys.LEFT)
		{
			moveLeft();
		}
		else if (FlxG.keys.UP)
		{
			moveUp();
		}
		else if (FlxG.keys.DOWN)
		{
			moveDown();
		}
		else
		{
			idle();
		}
	}



	public function handleInputOld():Void
	{
		// HANDLE DIRECTIONAL KEYS
		if (FlxG.keys.justPressed("RIGHT"))
		{
			moveRight();
		}
		else if (FlxG.keys.justPressed("LEFT"))
		{
			moveLeft();
		}
		else if (FlxG.keys.justPressed("UP"))
		{
			moveUp();
		}
		else if (FlxG.keys.justPressed("DOWN"))
		{
			moveDown();
		}
	}
}
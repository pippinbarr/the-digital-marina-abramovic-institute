package;


import org.flixel.FlxG;
import org.flixel.FlxSprite;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.Lib;


class Helpers
{
	public static var sleepKeySetup:Bool = false;
	public static var sleepKeyIsDown:Bool = false;
	public static var lastAvatarY:Float = -1;
	public static var focused:Bool = true;

	public static function setupSleepKeyListener():Void
	{
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP,keyUp);

		sleepKeySetup = true;		
	}


	public static function keyDown(e:KeyboardEvent):Void
	{
		if (e.keyCode == Keyboard.SHIFT)
		{
			// trace("Sleep key just pressed.");
			sleepKeyIsDown = true;
		}
	}

	public static function keyUp(e:KeyboardEvent):Void
	{
		if (e.keyCode == Keyboard.SHIFT)
		{
			// trace("Sleep key just released.");
			sleepKeyIsDown = false;
		}

	}

	public static function scaleSprite(sprite:FlxSprite):Void
	{
		sprite.setOriginToCorner();
		sprite.scale.x = 4;
		sprite.scale.y = 4;
		sprite.width *= 4;
		sprite.height *= 4;
	}


	public static function recolourPersonAsAvatar(sprite:FlxSprite,Coat:Bool):Void
	{
		sprite.replaceColor(GameAssets.HAIR_COLOR_1,GameAssets.AVATAR_HAIR_COLOR_1);
		sprite.replaceColor(GameAssets.HAIR_COLOR_2,GameAssets.AVATAR_HAIR_COLOR_2);
		sprite.replaceColor(GameAssets.HAIR_COLOR_3,GameAssets.AVATAR_HAIR_COLOR_3);
		sprite.replaceColor(GameAssets.SKIN_COLOR,GameAssets.AVATAR_SKIN_COLOR);
		sprite.replaceColor(GameAssets.PANTS_COLOR_BOTTOM,GameAssets.AVATAR_PANTS_COLOR_BOTTOM);
		sprite.replaceColor(GameAssets.SHOES_COLOR_TOP,GameAssets.AVATAR_SHOES_COLOR_TOP);
		sprite.replaceColor(GameAssets.SHOES_COLOR_BOTTOM,GameAssets.AVATAR_SHOES_COLOR_BOTTOM);
		sprite.replaceColor(GameAssets.NECK_COLOR,GameAssets.AVATAR_NECK_COLOR);

		if (!Coat)
		{		
			sprite.replaceColor(GameAssets.SHIRT_COLOR_MAIN,GameAssets.AVATAR_SHIRT_COLOR_MAIN);
			sprite.replaceColor(GameAssets.SHIRT_COLOR_TOP_SLEEVE,GameAssets.AVATAR_SHIRT_COLOR_TOP_SLEEVE);
			sprite.replaceColor(GameAssets.SHIRT_COLOR_BOTTOM_SLEEVE,GameAssets.AVATAR_SHIRT_COLOR_BOTTOM_SLEEVE);
			sprite.replaceColor(GameAssets.BELT_COLOR,GameAssets.AVATAR_BELT_COLOR);
			sprite.replaceColor(GameAssets.PANTS_COLOR_TOP,GameAssets.AVATAR_PANTS_COLOR_TOP);
			sprite.replaceColor(GameAssets.SHIRT_COLOR_TOP,GameAssets.AVATAR_SHIRT_COLOR_TOP);
		}
		else
		{
			if (GameAssets.AVATAR_SHIRT_COLOR_TOP != GameAssets.AVATAR_HAIR_COLOR_3)
			{
				sprite.replaceColor(GameAssets.SHIRT_COLOR_TOP,0xFFFFFFFF);
			}
			else
			{
				sprite.replaceColor(GameAssets.SHIRT_COLOR_TOP,GameAssets.AVATAR_HAIR_COLOR_3);				
			}

			if (GameAssets.AVATAR_HAIR_COLOR_3 != 0x00000000 || GameAssets.AVATAR_HAIR_COLOR_2 != 0x00000000)
			{
				sprite.replaceColor(GameAssets.HEADPHONE_COLOR_TOP,GameAssets.AVATAR_HAIR_COLOR_1);
				sprite.replaceColor(GameAssets.HEADPHONE_COLOR_MIDDLE,GameAssets.AVATAR_HAIR_COLOR_1);
				sprite.replaceColor(GameAssets.HEADPHONE_COLOR_BOTTOM,GameAssets.AVATAR_HAIR_COLOR_1);
			}
			else
			{
				sprite.replaceColor(GameAssets.HEADPHONE_COLOR_TOP,GameAssets.HEADPHONE_BAND_COLOR);
				sprite.replaceColor(GameAssets.HEADPHONE_COLOR_MIDDLE,GameAssets.HEADPHONE_BAND_COLOR);
				sprite.replaceColor(GameAssets.HEADPHONE_COLOR_BOTTOM,GameAssets.HEADPHONE_EARPIECE_COLOR);			
			}
		}
	}


	public static function randomColourPerson(S:FlxSprite,Labcoat:Bool = true):Void
	{
		var skinColor:Int = GameAssets.SKIN_COLORS[Math.floor(Math.random() * GameAssets.SKIN_COLORS.length)];
		var hairColour:Int = GameAssets.HAIR_COLORS[Math.floor(Math.random() * GameAssets.HAIR_COLORS.length)];
		var hairType:Int = Math.floor(Math.random() * 3);
		var shirtColor:Int = GameAssets.SHIRT_COLORS[Math.floor(Math.random() * GameAssets.SHIRT_COLORS.length)];

		S.replaceColor(GameAssets.HAIR_COLOR_1,hairColour);

		if (hairType > 0)
		{
			S.replaceColor(GameAssets.HAIR_COLOR_2,hairColour);
			S.replaceColor(GameAssets.HEADPHONE_COLOR_TOP,hairColour);
			S.replaceColor(GameAssets.HEADPHONE_COLOR_MIDDLE,hairColour);
			S.replaceColor(GameAssets.HEADPHONE_COLOR_BOTTOM,hairColour);


			if (hairType > 1)
			{
				S.replaceColor(GameAssets.HAIR_COLOR_3,hairColour);
				S.replaceColor(GameAssets.NECK_COLOR,hairColour);
				S.replaceColor(GameAssets.SHIRT_COLOR_TOP,hairColour);
			}
			else
			{
				S.replaceColor(GameAssets.HAIR_COLOR_3,0x00000000);
				S.replaceColor(GameAssets.NECK_COLOR,skinColor);
				if (Labcoat)
				{
					S.replaceColor(GameAssets.SHIRT_COLOR_TOP,0xFFFFFFFF);
				}
				else
				{
					S.replaceColor(GameAssets.SHIRT_COLOR_TOP,shirtColor);
				}
			}
		}
		else
		{
			S.replaceColor(GameAssets.HAIR_COLOR_2,0x00000000);
			S.replaceColor(GameAssets.HAIR_COLOR_3,0x00000000);
			S.replaceColor(GameAssets.NECK_COLOR,skinColor);
			if (Labcoat)
			{
				S.replaceColor(GameAssets.SHIRT_COLOR_TOP,0xFFFFFFFF);
			}
			else
			{
				S.replaceColor(GameAssets.SHIRT_COLOR_TOP,shirtColor);
			}
			S.replaceColor(GameAssets.HEADPHONE_COLOR_TOP,GameAssets.HEADPHONE_BAND_COLOR);
			S.replaceColor(GameAssets.HEADPHONE_COLOR_MIDDLE,GameAssets.HEADPHONE_BAND_COLOR);
			S.replaceColor(GameAssets.HEADPHONE_COLOR_BOTTOM,GameAssets.HEADPHONE_EARPIECE_COLOR);			
		}


		// SKIN //

		S.replaceColor(GameAssets.SKIN_COLOR,skinColor);


		// PANTS //

		var pantsColor:Int = GameAssets.PANTS_COLORS[Math.floor(Math.random() * GameAssets.PANTS_COLORS.length)];
		var pantsColorBottom:Int = pantsColor;

		if (Math.random() < 0.8)
		{
			S.replaceColor(GameAssets.PANTS_COLOR_BOTTOM,pantsColor);
		}
		else
		{
			S.replaceColor(GameAssets.PANTS_COLOR_BOTTOM,skinColor);
			pantsColorBottom = skinColor;
		}


		var shoesColor:Int = GameAssets.SHOES_COLORS[Math.floor(Math.random() * GameAssets.SHOES_COLORS.length)];

		if (Math.random() < 0.7)
		{
			// SHOES
			S.replaceColor(GameAssets.SHOES_COLOR_TOP,pantsColorBottom);
			S.replaceColor(GameAssets.SHOES_COLOR_BOTTOM,shoesColor);
		}
		else
		{
			// BOOTS
			S.replaceColor(GameAssets.SHOES_COLOR_TOP,shoesColor);
			S.replaceColor(GameAssets.SHOES_COLOR_BOTTOM,shoesColor);
		}


		if (!Labcoat)
		{
			var sleeveColor:Int = Helpers.darkenHex(shirtColor);

			var topRandom:Float = Math.random();

			S.replaceColor(GameAssets.SHIRT_COLOR_MAIN,shirtColor);

			if (topRandom > 0.6) 
			{ 	
				S.replaceColor(GameAssets.SHIRT_COLOR_TOP_SLEEVE,sleeveColor);
				S.replaceColor(GameAssets.SHIRT_COLOR_BOTTOM_SLEEVE,sleeveColor);
			}
			else if (topRandom > 0.2) 
			{
				S.replaceColor(GameAssets.SHIRT_COLOR_TOP_SLEEVE,sleeveColor);
				S.replaceColor(GameAssets.SHIRT_COLOR_BOTTOM_SLEEVE,skinColor);
			}
			else 
			{
				S.replaceColor(GameAssets.SHIRT_COLOR_TOP_SLEEVE,skinColor);
				S.replaceColor(GameAssets.SHIRT_COLOR_BOTTOM_SLEEVE,skinColor);
			}

			var beltColor:Int = GameAssets.BELT_COLORS[Math.floor(Math.random() * GameAssets.BELT_COLORS.length)];
			var beltRandom:Float = Math.random();
			if (beltRandom > 0.7) 
			{
				S.replaceColor(GameAssets.BELT_COLOR,beltColor);
			}
			else 
			{
				S.replaceColor(GameAssets.BELT_COLOR,shirtColor);
			}
			if (Math.random() < 0.8)
			{
				// PANTS
				S.replaceColor(GameAssets.PANTS_COLOR_TOP,pantsColor);
				S.replaceColor(GameAssets.PANTS_COLOR_BOTTOM,pantsColor);
			}
			else
			{
				// SHORTS
				S.replaceColor(GameAssets.PANTS_COLOR_TOP,pantsColor);
				S.replaceColor(GameAssets.PANTS_COLOR_BOTTOM,skinColor);
			}


		}
	}


	public static function darkenHex(hex:Int):Int 
	{
		var a:Int = hex >> 24 & 0xFF;
		var r:Int = hex >> 16 & 0xFF; r = Math.floor(Math.max(0x00,(r - 20)));
		var g:Int = hex >> 8 & 0xFF; g = Math.floor(Math.max(0x00,(g - 20)));
		var b:Int = hex & 0xFF; b = Math.floor(Math.max(0x00,(b - 20)));

		return ((a << 24) | (r << 16) | (g << 8) | b);
	}
}
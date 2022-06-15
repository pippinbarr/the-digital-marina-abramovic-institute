package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;



class TestMenuState extends FlxState
{
	override public function create():Void
	{		
		FlxG.bgColor = 0xFF444444;

		var menu:FlxText = new FlxText(0,50,FlxG.width,"");
		menu.setFormat("Commodore",12,0xFFFFFFFF,"center");
		menu.text = ""+
		"(E)NTRANCE\n\n" +
		"(R)ECEPTION\n\n" +
		"1. R(A)MP CHAMBER\n\n" +
		"2. (W)ATER DRINKING CHAMBER\n\n" +
		"3. (C)RYSTAL WALL CHAMBER\n\n" +
		"4. (G)AZE CHAMBER\n\n" +
		"5. (S)OUND CHAMBER\n\n" +
		"6. (L)UMINOSITY CHAMBER\n\n" +
		"PERF(O)RMANCE\n\n" +
		"(P)ARKING LOT\n\n" +
		"(F)EEDBACK FORM\n\n" +
		"CER(T)IFICATE\n\n" +
		"\n\n\n\n[ PRESS 'TAB' ALMOST ANY TIME\nTO RETURN TO THIS MENU. ]" +
		"\n\n[ CLICK IN THIS WINDOW TO GIVE IT FOCUS. ]";

		add(menu);

		var avatar:Avatar = new Avatar(50,150,GameAssets.SS_BASIC_WALKCYCLE_PNG,false);
		add(avatar.sprite);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();

		handleInput();
	}	


	private function handleInput():Void
	{
		if (FlxG.keys.pressed("E"))
		{
			FlxG.switchState(new EntranceState());
		}
		else if (FlxG.keys.pressed("R"))
		{
			FlxG.switchState(new ReceptionState());
		}
		else if (FlxG.keys.pressed("A"))
		{
			FlxG.switchState(new RampState());
		}
		else if (FlxG.keys.pressed("W"))
		{
			FlxG.switchState(new WaterDrinkingState());
		}
		else if (FlxG.keys.pressed("G"))
		{
			FlxG.switchState(new GazeState());
		}
		else if (FlxG.keys.pressed("L"))
		{
			FlxG.switchState(new LuminosityState());
		}
		else if (FlxG.keys.pressed("S"))
		{
			FlxG.switchState(new SoundState());
		}
		else if (FlxG.keys.pressed("C"))
		{
			FlxG.switchState(new WallState());
		}
		else if (FlxG.keys.pressed("P"))
		{
			FlxG.switchState(new ParkingState());
		}
		else if (FlxG.keys.pressed("O"))
		{
			FlxG.switchState(new PerformanceState());
		}
		else if (FlxG.keys.pressed("F"))
		{
			FlxG.switchState(new FeedbackState());
		}
		else if (FlxG.keys.pressed("T"))
		{
			FlxG.switchState(new CertificateState());
		}
	}
}
package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;


class SoundState extends ChamberState
{

	private static var SOUND_LENGTH:Float = 90;
	// private static var SOUND_LENGTH:Float = 2;
	private var FADE_SPEED:Float = 0.00;

	private var soundTimer:FlxTimer;

	var fireSound:FlxSound;
	var windSound:FlxSound;
	var waterSound:FlxSound;
	var silenceSound:FlxSound;

	var soundFadingIn:Bool = false;
	var soundFadingOut:Bool = false;
	var soundIsPlaying:Bool = false;

	var currentSound:FlxSound;


	override public function create():Void
	{
		super.create();	

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_WALKCYCLE_PNG,true);
		avatar.animation.frameIndex = 20;
		
		add(avatar);

		display.add(avatar.sprite);		

		fireSound = new FlxSound();
		fireSound.loadEmbedded(GameAssets.FIRE_MP3,true);
		fireSound.volume = 0.3;

		windSound = new FlxSound();
		windSound.loadEmbedded(GameAssets.WIND_MP3,true);
		windSound.volume = 0.5;

		waterSound = new FlxSound();
		waterSound.loadEmbedded(GameAssets.WATER_MP3,true);
		waterSound.volume = 0.2;

		silenceSound = new FlxSound();
		silenceSound.loadEmbedded(GameAssets.SILENCE_MP3,true);
		silenceSound.volume = 0;

		currentSound = null;

		audio = new HeadsetAudio(Audio.SOUND_INTRO_AUDIO);
		fg.add(audio);

		audioCompletes = false;

		walkIn(backWall.height);
	}

	
	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		silenceSound.destroy();
		fireSound.destroy();
		waterSound.destroy();
		windSound.destroy();
		soundTimer.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();	

		handleAudio();
		handleSoundFades();

		// if (FlxG.keys.W) waterSound.play();
		// else waterSound.stop();
		// if (FlxG.keys.F) fireSound.play();
		// else fireSound.stop();
		// if (FlxG.keys.I) windSound.play();
		// else windSound.stop();
	}


	private function handleAudio():Void
	{
		if (audio.completed && !soundIsPlaying)
		{
			if (currentSound == null)
			{
				currentSound = waterSound;
				soundFadingIn = true;
				currentSound.play();
				soundIsPlaying = true;
				soundTimer = FlxTimer.start(SOUND_LENGTH,handleSoundEnd);
			}
			else if (currentSound == waterSound)
			{
				currentSound = fireSound;
				soundFadingIn = true;
				currentSound.play();
				soundIsPlaying = true;
				soundTimer = FlxTimer.start(SOUND_LENGTH,handleSoundEnd);
			}
			else if (currentSound == fireSound)
			{
				currentSound = windSound;
				soundFadingIn = true;
				currentSound.play();
				soundIsPlaying = true;
				soundTimer = FlxTimer.start(SOUND_LENGTH,handleSoundEnd);
			}
			else if (currentSound == windSound)
			{
				currentSound = silenceSound;
				soundFadingIn = true;
				currentSound.play();
				soundIsPlaying = true;
				soundTimer = FlxTimer.start(SOUND_LENGTH,handleSoundEnd);
			}
		}
	}


	private function handleSoundFades():Void
	{
		if (soundFadingIn)
		{
			// currentSound.volume = Math.min(currentSound.volume + FADE_SPEED,1.0);	
			// if (currentSound.volume == 1)
			// {
			// 	soundFadingIn = false;
			// }
			soundFadingIn = false;
		}
		else if (soundFadingOut)
		{
			// currentSound.volume = Math.max(currentSound.volume - FADE_SPEED,0.0);	

			currentSound.volume = 0;
			if (currentSound.volume == 0)
			{
				soundIsPlaying = false;
				soundFadingOut = false;
				currentSound.stop();

				if (currentSound == silenceSound)
				{
					audio.playTexts(Audio.SOUND_OUTRO_AUDIO);
					canLeave = true;
				}
				else if (currentSound == waterSound)
				{
					audio.playTexts(Audio.SOUND_FIRE_INTRO_AUDIO);
				}
				else if (currentSound == fireSound)
				{
					audio.playTexts(Audio.SOUND_WIND_INTRO_AUDIO);
				}
				else if (currentSound == windSound)
				{
					audio.playTexts(Audio.SOUND_SILENCE_INTRO_AUDIO);
				}
			}			
		}
	}


	private function handleSoundEnd(t:FlxTimer):Void
	{
		soundFadingIn = false;
		soundFadingOut = true;
	}


	override private function nextState(t:FlxTimer):Void
	{
		super.nextState(t);
		FlxG.switchState(new LuminosityState());
	}	
}

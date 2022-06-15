package;


import org.flixel.FlxSprite;


class GameAssets
{
	// SHARED //

		// DETAILS //

		public static var PLAYER_NAME_STRING:String = "ANONYMOUS";



		// WALKCYCLES //

		public static var SS_BASIC_WALKCYCLE_PNG:String = "assets/png/shared/ss_basic_walkcycle.png";
		public static var SS_LABCOAT_WALKCYCLE_PNG:String = "assets/png/shared/ss_labcoat_walkcycle_nophones.png";
		public static var SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG:String = "assets/png/shared/ss_labcoat_walkcycle_no_headphones.png";
		// public static var SS_LABCOAT_WALKCYCLE_PNG:String = "assets/png/shared/ss_labcoat_walkcycle.png";
		public static var SS_WATER_WALKCYCLE_PNG:String = "assets/png/water/ss_water_walkcycle.png";


		public static var WALKCYCLE_FRAMERATE:Int = 10;
		public static var RIGHT_WALK_FRAMES:Array<Int> = [0,1,2,3,4,5,6,7];
		public static var LEFT_WALK_FRAMES:Array<Int> = [8,9,10,11,12,13,14,15];
		public static var FRONT_WALK_FRAMES:Array<Int> = [16,17,18,19,20,21];
		public static var BACK_WALK_FRAMES:Array<Int> = [23,24,25,26,27,28];
		public static var RIGHT_IDLE_FRAMES:Array<Int> = [30,30];
		public static var LEFT_IDLE_FRAMES:Array<Int> = [31,31];
		public static var FRONT_IDLE_FRAMES:Array<Int> = [22,22];
		public static var BACK_IDLE_FRAMES:Array<Int> = [29,29];



		// ICONS

		public static var AUDIO_ICON_PNG:String = "assets/png/shared/icon_headphones.png";
		public static var HELP_ICON_PNG:String = "assets/png/shared/icon_help.png";
		public static var EXCLAMATION_ICON_PNG:String = "assets/png/shared/icon_exclamation.png";
		public static var EXIT_ARROW_PNG:String = "assets/png/shared/exit_arrow.png";



		// BACKGROUNDS //



		public static var BG_STANDARD_CHAMBER_PNG:String = "assets/png/shared/bg_standard_chamber.png";
		public static var BG_STANDARD_WALL_PNG:String = "assets/png/shared/bg_standard_wall.png";




		// COLOURING //

		public static var AVATAR_HAIR_COLOR_1:Int = 0;
		public static var AVATAR_HAIR_COLOR_2:Int = 0;
		public static var AVATAR_HAIR_COLOR_3:Int = 0;
		public static var AVATAR_SKIN_COLOR:Int = 0;
		public static var AVATAR_NECK_COLOR:Int = 0;
		public static var AVATAR_SHIRT_COLOR_TOP:Int = 0;
		public static var AVATAR_SHIRT_COLOR_MAIN:Int = 0;
		public static var AVATAR_SHIRT_COLOR_TOP_SLEEVE:Int = 0;
		public static var AVATAR_SHIRT_COLOR_BOTTOM_SLEEVE:Int = 0;
		public static var AVATAR_BELT_COLOR:Int = 0;
		public static var AVATAR_PANTS_COLOR_TOP:Int = 0;
		public static var AVATAR_PANTS_COLOR_BOTTOM:Int = 0;
		public static var AVATAR_SHOES_COLOR_TOP:Int = 0;
		public static var AVATAR_SHOES_COLOR_BOTTOM:Int = 0;

		public static var HAIR_COLOR_1:Int = 0xfffaebac;
		public static var HAIR_COLOR_2:Int = 0xff94f4a2;
		public static var HAIR_COLOR_3:Int = 0xff464021;
		public static var HEADPHONE_COLOR_TOP:Int = 0xff4234f0;
		public static var HEADPHONE_COLOR_MIDDLE:Int = 0xffee8741;
		public static var HEADPHONE_COLOR_BOTTOM:Int = 0xffed32b0;
		public static var SKIN_COLOR:Int = 0xfff6483d;
		public static var NECK_COLOR:Int = 0xff96a5f2;
		public static var SHIRT_COLOR_TOP:Int = 0xfff3f352;
		public static var SHIRT_COLOR_MAIN:Int = 0xff0094e3;
		public static var SHIRT_COLOR_TOP_SLEEVE:Int = 0xff82ee75;
		public static var SHIRT_COLOR_BOTTOM_SLEEVE:Int = 0xff00a352;
		public static var BELT_COLOR:Int = 0xff585858;
		public static var PANTS_COLOR_TOP:Int = 0xFFf7e975;
		public static var PANTS_COLOR_BOTTOM:Int = 0xFF37ef94;
		public static var SHOES_COLOR_TOP:Int = 0xFFe7b4e6;
		public static var SHOES_COLOR_BOTTOM:Int = 0xFF39f9fa;

		public static var HAIR_COLORS:Array<Int> = [0xff3a2f0a,0xff8e8050,0xff8e6650,0xff5b323b,0xff470d1b,0xFF000000,0xff583b3b,0xff9d9b67,0xff9d9c9c,0xff757060,0xff5e4b11,0xff5b1515];
		public static var SKIN_COLORS:Array<Int> = [0xffc38f9b,0xffc3a58f,0xff8c5934,0xff572f12,0xff5b412d,0xff4a3f30,0xffbda688,0xffc69a55,0xffd2a7b6,0xffd2a9cb,0xff65331f,0xff7e5f36];
		public static var SHIRT_COLORS:Array<Int> = [0xffaf6868,0xff688faf,0xffab68af,0xff6daf68,0xffafae68,0xff353535,0xff232323,0xff292929,0xff361a1a,0xff14223e,0xff000000];
		public static var BELT_COLORS:Array<Int> = [0xFF000000,0xff4a210b,0xff872222,0xff1a4e1f,0xff474466];
		public static var PANTS_COLORS:Array<Int> = [0xff6b4f27,0xff556b27,0xff292f1c,0xff1c262f,0xff273a6b,0xff3a276b,0xff444342,0xff401c09,0xff385473,0xff628790,0xff434a3b];
		public static var SHOES_COLORS:Array<Int> = [0xff415115,0xff513015,0xff1d1551,0xff5b385a,0xff5b5338,0xFF000000,0xff4b370c,0xff474237];

		public static var HEADPHONE_BAND_COLOR:Int = 0xffd9d9d9;
		public static var HEADPHONE_EARPIECE_COLOR:Int = 0xffffffff;







	// ENTRANCE //

	public static var ENTRANCE_BG_PNG:String = "assets/png/entrance/bg_entrance.png";
	public static var ENTRANCE_HM_PNG:String = "assets/png/entrance/hm_entrance_4x.png";
	public static var ENTRANCE_FG_PNG:String = "assets/png/entrance/fg_entrance_top.png";

	public static var DOORS_PNG:String = "assets/png/entrance/ss_doors.png";

	public static var ENTRANCE_SKY_EARLY_MORNING_PNG:String = "assets/png/entrance/bg_sky_early_morning.png";
	public static var ENTRANCE_SKY_MORNING_PNG:String = "assets/png/entrance/bg_sky_morning.png";
	public static var ENTRANCE_SKY_DAY_PNG:String = "assets/png/entrance/bg_sky_day.png";
	public static var ENTRANCE_SKY_EVENING_PNG:String = "assets/png/entrance/bg_sky_evening.png";
	public static var ENTRANCE_SKY_NIGHT_PNG:String = "assets/png/entrance/bg_sky_night.png";

	public static var KICKSTARTER_MESSAGE:String = "The Digital Marina Abramovic Institute is opening soon!\n\n" +
	"Please consider supporting the real institute by pressing 'K' now to launch " +
	"its Kickstarter page. Backers gain early access to the digital institute along with other great rewards!" +
	"\n\n(Press 'K' for Kickstarter)\n\n(Press ENTER to continue)";


	// RECEPTION //

	public static var BG_RECEPTION_PNG:String = "assets/png/reception/bg_reception.png";
	public static var BG_RECEPTION_WINDOW_PNG:String = "assets/png/reception/bg_reception_window.png";
	public static var RECEPTIONIST_PNG:String = "assets/png/reception/receptionist.png";
	public static var CONTRACT_PNG:String = "assets/png/reception/contract.png";
	public static var SIGNATURE_PNG:String = "assets/png/reception/signature.png";
	public static var PASSWORD_FORM_PNG:String = "assets/png/reception/password_form.png";
	public static var PLAQUE_PNG:String = "assets/png/reception/plaque.png";
	public static var LEFT_ARROW_PNG:String = "assets/png/reception/left_arrow.png";


	// SCIENCE //

	public static var COMPATABILITY_RACER_PNG:String = "assets/png/science/compatability_racer.png";
	public static var COMPATABILITY_RACER_AVATAR_LABCOAT_SPIN_PNG:String = "assets/png/science/compatability_racer_avatar_labcoat_spin.png";
	public static var COMPATABILITY_RACER_AVATAR_CIVVIES_SPIN_PNG:String = "assets/png/science/compatability_racer_avatar_civvies_spin.png";

	public static var POLE_PNG:String = "assets/png/science/pole.png";
	public static var FENCE_LEFT_PNG:String = "assets/png/science/fence_left.png";
	public static var FENCE_RIGHT_PNG:String = "assets/png/science/fence_right.png";
	public static var BG_SCIENCE_PNG:String = "assets/png/science/bg_science_chamber.png";


	// ORIENTATION //

	public static var ORIENTATION_TV_PNG:String = "assets/png/orientation/orientation_tv.png";


	// FOUNDERS //

	public static var BG_FOUNDERS:String = "assets/png/founders/bg_founders.png";
	public static var HM_FOUNDERS:String = "assets/png/founders/hm_founders.png";


	// RAMP //

	public static var SLOMO_WALK_CYCLE_BASE_PNG:String = "assets/png/ramp/ss_ramp_walkcycle.png";

	public static var SLOMO_RAMP_BG_PNG:String = "assets/png/ramp/bg_ramp.png";


	// WATER DRINKING //

	public static var WATER_STATION_PNG:String = "assets/png/water/water_station.png";
	public static var WATER_GLASS_PNG:String = "assets/png/water/water_glass.png";
	public static var DRINKING_AVATAR_PNG:String = "assets/png/water/ss_water_drinking.png";
	public static var DRINKING_AVATAR_LEFT_PNG:String = "assets/png/water/ss_water_drinking_left.png";

	public static var WATER_COLOR:Int = 0xFF6db2ff;
	public static var GLASS_COLOR:Int = 0xFFe0eeff;


	// GAZE //

	public static var CHAIR_PNG:String = "assets/png/gaze/chair.png";
	public static var CHAIR_RIGHT_PNG:String = "assets/png/gaze/chair_right.png";
	public static var CHAIR_AVATAR_PNG:String = "assets/png/gaze/chair_avatar.png";
	public static var CHAIR_OTHER_PNG:String = "assets/png/gaze/chair_other.png";
	public static var GAZE_AVATAR_PNG:String = "assets/png/gaze/gaze_avatar.png";
	public static var GAZE_OTHER_PNG:String = "assets/png/gaze/gaze_other.png";
	public static var GAZE_ARROWS_PNG:String = "assets/png/gaze/gaze_arrows.png";
	public static var GAZE_LINE_PNG:String = "assets/png/gaze/gaze_line.png";


	// LEVITATION //

	public static var LEVITATION_BED_PNG:String = "assets/png/levitation/levitation_bed.png";
	public static var BED_AVATAR_PNG:String = "assets/png/levitation/bed_avatar.png";
	public static var CRYSTAL_STAND_PNG:String = "assets/png/levitation/crystal_stand.png";
	public static var STAND_AND_BED_PNG:String = "assets/png/levitation/stand_and_bed.png";


	// SOUND //

	public static var WIND_MP3:String = "assets/mp3/sound/wind.mp3";
	public static var FIRE_MP3:String = "assets/mp3/sound/fire.mp3";
	public static var WATER_MP3:String = "assets/mp3/sound/water.mp3";
	public static var SILENCE_MP3:String = "assets/mp3/sound/silence.mp3";


	// WALL //

	public static var BG_WALL_CRYSTALS_PNG:String = "assets/png/wall/bg_crystals.png";


	// PERFORMANCE //

	public static var BG_PERFORMANCE_PNG:String = "assets/png/performance/performance_bg.png";
	public static var PERFORMANCE_CHAIR_PNG:String = "assets/png/performance/performance_chair.png";
	public static var PERFORMANCE_CHAIR_LEFT_PNG:String = "assets/png/performance/chair_left.png";
	public static var PERFORMANCE_CHAIR_RIGHT_PNG:String = "assets/png/performance/chair_right.png";
	// public static var FIRST_GIANT_PNG:String = "assets/png/performance/first_giant.png";
	// public static var FIRST_GIANT_HAND_PNG:String = "assets/png/performance/black_hand.png";
	public static var IN_THE_FIELD_NEAR_PNG:String = "assets/png/performance/in_the_field_1.png";
	public static var IN_THE_FIELD_TURN_PNG:String = "assets/png/performance/in_the_field_2.png";
	public static var IN_THE_FIELD_REAR_PNG:String = "assets/png/performance/in_the_field_3.png";

	public static var IN_THE_FIELD_NEAR_UP_FRAMES:Array<Int> = [0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46];
	public static var IN_THE_FIELD_NEAR_DOWN_FRAMES:Array<Int> = [46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0];
	public static var IN_THE_FIELD_TURN_TO_REAR_FRAMES:Array<Int> = [0,1,2,3,4,5,6,7,8,9,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,23,23,23,23,23,23,23,23,24,25,26,27,28,29,30,31,32,33,34];
	public static var IN_THE_FIELD_TURN_TO_NEAR_FRAMES:Array<Int> = [34,33,32,31,30,29,28,27,26,25,24,23,23,22,22,21,21,20,20,19,19,18,18,17,17,16,16,15,15,14,14,13,13,12,12,11,11,11,11,11,11,11,11,11,11,10,9,8,7,6,5,4,3,2,1,0];
	public static var IN_THE_FIELD_REAR_UP_FRAMES:Array<Int> = [0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46];
	public static var IN_THE_FIELD_REAR_DOWN_FRAMES:Array<Int> = [46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0];

	// PERFORMANCE - TIME CLOCK PIECE //

	public static var TIME_CLOCK_WALKCYCLE:String = "assets/png/performance/time_clock_walkcycle.png";
	public static var TIME_CLOCK_DOOR_FG:String = "assets/png/performance/time_clock_door_fg.png";
	public static var TIME_CLOCK_DOOR_BG:String = "assets/png/performance/time_clock_door_bg.png";
	public static var TIME_CLOCK_PUNCHING:String = "assets/png/performance/time_clock_punching.png";


	// PARKING //

	public static var BG_PARKING_PNG:String = "assets/png/parking/bg_parking.png";
	public static var HM_PARKING_PNG:String = "assets/png/parking/hm_parking.png";
	public static var SLEEPER_PNG:String = "assets/png/parking/sleeper.png";
	public static var WHEELCHAIR_PNG:String = "assets/png/parking/wheelchair.png";


	// FEEDBACK FORM //

	public static var FEEDBACK_FORM_PNG:String = "assets/png/feedback/feedback_form.png";
	public static var DESK_PNG:String = "assets/png/feedback/desk.png";


	// CERTIFICATE //

	public static var CERTIFICATE_PNG:String = "assets/png/certificate/certificate.png";



	// INSTRUCTION TEXTS //

	public static var CONTINUE_INSTRUCTION:String = "Press ENTER to continue.";
	public static var WAKE_UP_INSTRUCTION:String = "Press and hold SHIFT to wake up!";
	public static var FOCUS_LOST_INSTRUCTION:String = "CLICK here to begin waking up!";
	public static var FOCUS_INSTRUCTION:String = "CLICK here to play.";

	public static var CURRENT_SLEEP_HELP:String = "Hold SHIFT to wake up!";

	public static var WALK_INSTRUCTION:String = "Use the ARROW KEYS to walk.";
	public static var OPEN_EYES_INSTRUCTION:String = "Press SPACE to open your eyes.";
	public static var CLOSE_EYES_INSTRUCTION:String = "Press SPACE to close your eyes.";
	public static var SIT_INSTRUCTION:String = "Press ENTER to sit on the chair.";
	public static var STAND_INSTRUCTION:String = "Press ENTER to stand.";

	public static var SLOW_MOTION_WALK_INSTRUCTION:String = "Tap the RIGHT ARROW to walk slowly.";
	public static var SLOW_MOTION_WAIT_INSTRUCTION:String = "Please wait for the sound of the gong.";
	public static var WATER_SIP_INSTRUCTION:String = "Press SPACE to sip the water.";
	public static var WATER_RAISE_INSTRUCTION:String = "Hold ENTER to raise the glass to your lips.";
	public static var WATER_LOWER_INSTRUCTION:String = "Release ENTER to lower the glass from your lips.";
	public static var GAZE_MATCH_INSTRUCTION:String = "Match the ARROW KEYS to hold your partner's gaze.";

	public static var LUMINOSITY_BREATHE_INSTRUCTION:String = "Use the UP arrow to breathe in.\nUse the DOWN arrow to breathe out.";
	public static var LUMINOSITY_GET_ON_BED_INSTRUCTION:String = "Press ENTER to get onto the bed.";
	public static var LUMINOSITY_GET_OFF_BED_INSTRUCTION:String = "Press ENTER to get off the bed.";
	public static var LUMINOSITY_STOP_LEVITATING_INSTRUCTION:String = "Press SPACE to stop levitating.";

	public static var PERFORMANCE_EXIT_INSTRUCTION:String = "Walk to the RIGHT to leave the performance.";
	public static var PARKING_GET_UP_INSTRUCTION:String = "Press ENTER to get out of the bed";
	
}














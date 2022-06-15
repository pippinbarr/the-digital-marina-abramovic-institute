package;

import flixel.FlxG;

enum Direction
{
	LEFT;
	RIGHT;
	BOTTOM;
	NONE;
}

class Globals
{
	public static var DEBUG_COLLISION:Bool = false;
	public static var DEBUG_TRIGGER:Bool = false;

	public static var SLEEP_INCREMENT:Float = 0.005;

	public static var timesLoadedPlaque:Int = 0;
	public static var arriveTime:Date;
	
	public static var enteringFrom:Direction = NONE;
	public static var enteredPassword:Bool = false;
	public static var inExercises:Bool = false;

	public static var SLEEP_HELP_Y:Float = 480 / 2; //FlxG.height/2;
	public static var HELP_Y:Float = 480 - 14 - 40;
}
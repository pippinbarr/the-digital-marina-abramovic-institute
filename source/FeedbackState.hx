package;

import org.flixel.FlxG;
import org.flixel.FlxState;
import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxTimer;
import org.flixel.FlxText;

import flash.net.URLVariables;
import flash.net.URLRequest;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequestMethod;
import flash.errors.Error;


class FeedbackState extends ChamberState
{

	private var desk:Collidable;
	private var deskTrigger:FlxSprite;

	private var feedback:TextEntry;
	private var feedbackForm:FlxGroup;
	private var feedbackString:String = "";
	private var pageCount:FlxText;
	private static var MAX_HEIGHT:Float = 250;

	private var page:Int = 1;

	private var feedbackState:Bool = false;
	private var FEEDBACK_INSTRUCTIONS:Int = 6;
	private static var FEEDBACK:Int = 1;
	private static var CONFIRMING:Int = 2;
	private static var CONFIRM_END:Int = 3;
	private static var STAND_UP_POST_FEEDBACK:Int = 4;
	private static var LEAVING:Int = 5;
	private var state:Int = 0;


	override public function create():Void
	{
		super.create();	

		avatar = new Avatar(-100,300,GameAssets.SS_LABCOAT_NO_HEADPHONES_WALKCYCLE_PNG,true);
		avatar.frame = 20;
		
		var deskSprite:Sortable = new Sortable(0,0,GameAssets.DESK_PNG);
		deskSprite.loadGraphic(GameAssets.DESK_PNG,true,false,33,30);
		Helpers.recolourPersonAsAvatar(deskSprite,true);
		Helpers.scaleSprite(deskSprite);
		desk = new Collidable(FlxG.width/2 - deskSprite.width/2,320,deskSprite,0.4);

		deskTrigger = new FlxSprite(desk.x,desk.y + desk.height);
		deskTrigger.makeGraphic(Math.floor(desk.width),20,0xFF00FF00);

		createFeedbackForm();

		add(avatar);

		collidables.add(desk);

		display.add(avatar.sprite);		
		display.add(desk.sprite);

		audio = new HeadsetAudio(Audio.FEEDBACK_AUDIO);
		// fg.add(audio);
		
		fg.remove(help);
		fg.add(feedbackForm);
		fg.add(help);

		canSleep = false;
		audioCompletes = false;

		walkIn(backWall.height);

		help.visible = Globals.HELP_VISIBLE;
		audio.visible = Globals.AUDIO_VISIBLE;
	}

	
	private function createFeedbackForm():Void
	{
		feedbackForm = new FlxGroup();

		var feedbackSprite:FlxSprite = new FlxSprite(0,0,GameAssets.FEEDBACK_FORM_PNG);
		Helpers.scaleSprite(feedbackSprite);
		feedbackSprite.x = FlxG.width/2 - feedbackSprite.width / 2;
		feedbackSprite.y = FlxG.height/2 - feedbackSprite.height/2;

		var feedbackTitle:FlxText = new FlxText(0,120,FlxG.width,"FEEDBACK FORM",32,true);
		feedbackTitle.setFormat("Commodore",14,0xFF555555,"center");

		var feedbackMAI:FlxText = new FlxText(0,74,FlxG.width,"dMAI",48,true);
		feedbackMAI.setFormat("Commodore",42,0xFFFF0000,"center");

		var feedbackMAI2:FlxText = new FlxText(0,422,FlxG.width,"DIGITAL MARINA ABRAMOVIC INSTITUTE",48,true);
		feedbackMAI2.setFormat("Commodore",6,0xFFFF0000,"center");

		pageCount = new FlxText(0,50,FlxG.width - 170,"PAGE " + page,48,true);
		pageCount.setFormat("Commodore",12,0xFF555555,"right");

		feedback = new TextEntry(200,150,FlxG.width - 400,1000);
		feedback.setFormat("Commodore",12,0xFF000000,"left");
		feedback.disable();

		feedbackForm.add(feedbackSprite);
		feedbackForm.add(feedbackTitle);
		feedbackForm.add(feedbackMAI);
		feedbackForm.add(feedbackMAI2);
		feedbackForm.add(feedback);
		feedbackForm.add(pageCount);

		feedbackForm.visible = false;
	}


	private function handlePageTurns():Void
	{
		if (feedback.height > MAX_HEIGHT)
		{
			var index:Int = feedback.text.lastIndexOf(" ");

			if (index != -1)
			{
				var carryString:String = feedback.text.substring(index+1,feedback.text.length);
				feedbackString += (feedback.text.substring(0,index) + " ");
				feedback.text = carryString;
			}
			else
			{
				feedbackString += feedback.text;
				feedback.text = "";
			}

			page++;
		}

		pageCount.text = "PAGE " + page;
	}

	override public function destroy():Void
	{
		avatar.destroy();
		audio.destroy();

		desk.destroy();
		deskTrigger.destroy();
		feedback.destroy();
		feedbackForm.destroy();
		pageCount.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();		

		handlePageTurns();
	}


	override public function handleInput():Bool
	{
		if (!super.handleInput()) return false;


		if (!feedbackState) return false;


		if (state == FEEDBACK)
		{
			if (FlxG.keys.justPressed("ENTER"))
			{
				feedback.disable();
				state = CONFIRMING;

				if (feedbackString == "" && feedback.text == "")
				{
					message.setup("Are you sure you don't want to send any feedback?");
					help.setText("Press ENTER to not send any feedback.\nPress ESCAPE to keep typing");
				}
				else
				{
					message.setup("Do you want to send this feedback now?");
					help.setText("Press ENTER to send this feedback.\nPress ESCAPE to keep typing");
				}
			}
		}
		else if (state == CONFIRMING)
		{
		}
		else if (state == CONFIRM_END)
		{
			if (FlxG.keys.justPressed("ENTER"))
			{
				message.setVisible(false);
				// timer.start(2,1,nextState);
				// FlxG.fade(0xFF000000,2);
			}
		}
		else if (state == STAND_UP_POST_FEEDBACK)
		{
			if (!avatar.sprite.visible && FlxG.keys.justPressed("ENTER"))
			{
				desk.sprite.frame = 2;
				avatar.sprite.visible = true;
				avatarMovementEnabled = true;

				state = LEAVING;

				help.fadeOut();
			}
		}

		return true;
	}


	public function sendFeedback():Void
	{
		// trace("Making URLVariables...");
		var variables:URLVariables = new URLVariables();
		variables.name = GameAssets.PLAYER_NAME_STRING;
		// trace("Assigned name... " + variables.name);
		variables.feedback = feedbackString;
		// trace("Assigned feedback..." + variables.feedback);
		if (Globals.arriveTime != null)
		{
			variables.arrival = Globals.arriveTime.toString();
		}
		else
		{
			variables.arrival = "UNKNOWN";
		}
		// trace("Assigned arrival..." + variables.arrival);
		variables.departure = Date.now().toString();
		// trace("Assigned departure..." + variables.departure);
		variables.timesLoadedPlaque = Globals.timesLoadedPlaque;
		// trace("Assigned plaque..." + variables.timesLoadedPlaque);

		// trace("Making URLRequest");
		var request:URLRequest = new URLRequest("feedback.php");
		request.method = URLRequestMethod.POST;
		request.data = variables;

		// trace("Making URLLoader");
		var loader:URLLoader = new URLLoader();
		loader.dataFormat = URLLoaderDataFormat.VARIABLES;

		try
		{
			// trace("... and loading it.");
			loader.load(request);
		}
		catch (error:Error) 
		{
			// trace("... and something went wrong!");
		}
	}


	private function showThanksMessage(t:FlxTimer):Void
	{
		message.setup("Thank you.");
		message.setVisible(true);

		help.setText(GameAssets.CONTINUE_INSTRUCTION);

		state = CONFIRM_END;

		canLeave = true;
	}


	override public function handleMessageInput():Bool
	{
		if (!super.handleMessageInput()) return false;

		if (state == FEEDBACK_INSTRUCTIONS)
		{
			if (FlxG.keys.justPressed("ENTER"))
			{
				message.setVisible(false);
				showFeedbackForm();
			}
		}
		else if (state == CONFIRMING)
		{
			if (FlxG.keys.justPressed("ENTER"))
			{
				message.setVisible(false);

				feedbackString += feedback.text;

				if (feedbackString != "")
				{
				}
				timer.start(1,1,showThanksMessage);
				help.fadeOut();
			}
			else if (FlxG.keys.justPressed("ESCAPE"))
			{
				help.setText("TYPE to fill in the feedback form.\nPress ENTER when done.");
				message.setVisible(false);
				feedback.reenable();

				state = FEEDBACK;
			}
		}
		else if (state == CONFIRM_END)
		{
			if (FlxG.keys.justPressed("ENTER"))
			{
				message.setVisible(false);
				feedbackForm.visible = false;
				help.setText(GameAssets.STAND_INSTRUCTION);

				state = STAND_UP_POST_FEEDBACK;
			}			
		}



		return true;
	}


	override public function handleTriggers():Bool
	{
		if (!super.handleTriggers()) return false;
		if (state == LEAVING) return false;

		if (avatarMovementEnabled && avatar.overlaps(deskTrigger))
		{
			help.setText(GameAssets.SIT_INSTRUCTION);

			if (FlxG.keys.justPressed("ENTER"))
			{
				help.fadeOut();

				avatar.idle();
				avatarMovementEnabled = false;
				avatar.sprite.visible = false;

				desk.sprite.frame = 1;

				timer.start(1,1,showFeedbackInstructions);
			}
		}
		else if (avatarMovementEnabled)
		{
			help.fadeOut();
		}

		return true;
	}


	private function showFeedbackInstructions(t:FlxTimer):Void
	{
		state = FEEDBACK_INSTRUCTIONS;
		help.setText(GameAssets.CONTINUE_INSTRUCTION);
		message.setup("Please write about your personal experience of the digital institute.\n\nYour feedback will be reviewed and used to help shape the MAI.\n\nWhen you have finished you may leave and collect your certificate of completion.");
	}


	private function showFeedbackForm():Void
	{
		feedbackForm.visible = true;
		feedback.enable();
		feedbackState = true;

		state = FEEDBACK;

		help.setText("TYPE to fill in the feedback form.\nPress ENTER when done.");
	}


	override private function nextState(t:FlxTimer):Void
	{
		sendFeedback();
		super.nextState(t);
		FlxG.switchState(new CertificateState());
	}	
}

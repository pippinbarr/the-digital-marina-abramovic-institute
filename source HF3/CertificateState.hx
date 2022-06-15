package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

import flixel.util.FlxTimer;

import flash.net.URLRequest;
import flash.net.URLLoader;

class CertificateState extends FlxState
{



	private var certificate:FlxGroup;
	private var name:FlxText;
	private var dateText:FlxText;

	// private var help:HelpBar;
	// private var helpTimer:FlxTimer;

	// private var donate:Bool = false;

	override public function create():Void
	{
		super.create();

		FlxG.camera.bgColor = 0xFFFFFFFF;

		certificate = new FlxGroup();
		certificate.visible = true;

		var yOffset:Int = 0;

		var certificateSprite:FlxSprite = new FlxSprite(0,0,GameAssets.CERTIFICATE_PNG);
		Helpers.scaleSprite(certificateSprite);
		certificateSprite.x = FlxG.width/2 - certificateSprite.width / 2;
		certificateSprite.y = FlxG.height/2 - certificateSprite.height/2 + yOffset;

		var certificateWord:FlxText = new FlxText(0,140 + yOffset,FlxG.width,"CERTIFICATE OF\nCOMPLETION",32,true);
		certificateWord.setFormat("Commodore",18,0xFF000000,"center");

		var certificateBetween:FlxText = new FlxText(0,160 + yOffset,FlxG.width,"",32,true);
		certificateBetween.setFormat("Commodore",12,0xFF000000,"center");

		var certificateAndTheInstitute:FlxText = new FlxText(0,280 + yOffset,FlxG.width,"",32,true);
		certificateAndTheInstitute.text = "" +
		"for your active participation\nin the activities.\nWe appreciate your\ntrust and commitment.";
		certificateAndTheInstitute.setFormat("Commodore",12,0xFF000000,"center");

		var certificateTime:FlxText = new FlxText(0,240 + yOffset,FlxG.width,GameAssets.PLAYER_NAME_STRING,32,true);
		certificateTime.setFormat("Commodore",14,0xFF000000,"center");

		name = new FlxText(220,200 + yOffset,200,"We would like to thank you,",20,true);
		name.setFormat("Commodore",12,0xFF000000,"center");

		var certificateMAI:FlxText = new FlxText(0,74 + yOffset,FlxG.width,"dMAI",48,true);
		certificateMAI.setFormat("Commodore",42,0xFFFF0000,"center");

		var certificateMAI2:FlxText = new FlxText(0,422 + yOffset,FlxG.width,"DIGITAL MARINA ABRAMOVIC INSTITUTE",48,true);
		certificateMAI2.setFormat("Commodore",6,0xFFFF0000,"center");

		dateText = new FlxText(0,388 + yOffset,FlxG.width - 220,"",32,true);
		dateText.setFormat("Commodore",10,0xFF000000,"right");
		var theDate:Date = Date.now();
		dateText.text = "MARINA ABRAMOVIC\n" + theDate.getDate() + "/" + (theDate.getMonth() + 1) + "/" + theDate.getFullYear();


		certificate.add(certificateSprite);
		certificate.add(certificateWord);
		certificate.add(certificateBetween);
		certificate.add(certificateAndTheInstitute);
		certificate.add(certificateTime);
		certificate.add(name);
		certificate.add(dateText);
		certificate.add(certificateMAI);
		certificate.add(certificateMAI2);

		add(certificate);


		// help = new HelpBar("",Globals.HELP_Y + 10);
		// helpTimer = new FlxTimer();
		// helpTimer.start(5,1,suggestDonation);

		// add(help);
	}


	private function suggestDonation(t:FlxTimer):Void
	{
		// donate = true;
		// help.setText("Please consider donating to the MAI by pressing ENTER.\nPress ESCAPE to remove this message.");
	}


	
	override public function destroy():Void
	{
		certificate.destroy();
		name.destroy();
		dateText.destroy();

		// help.destroy();
		// helpTimer.destroy();

		super.destroy();
	}


	override public function update():Void
	{
		super.update();

		// if (donate && FlxG.keyboard.justPressed("ENTER"))
		// {
		// 	var url:URLRequest = new URLRequest("http://www.marinaabramovicinstitute.org/get-involved/donate");
		// 	// var loader:URLLoader = new URLLoader();
		// 	// loader.load(url);

		// 	flash.Lib.getURL(url);

		// 	help.setInvisible();

		// 	donate = false;
		// }
		// else if (donate && FlxG.keyboard.justPressed("ESCAPE"))
		// {
		// 	help.setInvisible();

		// 	donate = false;
		// }


	}	


	public function handleInput():Void
	{

	}


	public function handleMessageInput():Void
	{

	}
}



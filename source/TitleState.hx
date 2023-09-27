package;

// project made in haxe 4.2.5
import Random;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class TitleState extends FlxState
{
	var background:FlxSprite;
	var luigiNum:Int = 0;
	var luigi:FlxSprite;
	var logo:FlxSprite;

	var startButton:FlxText;
	var optionsButton:FlxText;
	var exitButton:FlxText;

	var cursor:FlxSprite;

	var selected:Int = 0;
	var triedToEscape:Bool = false;
	var canSelect:Bool = true;

	override public function create()
	{
		luigiNum = Random.int(1, 14);

		// make a sprite thats just black and the size of the screen
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, 0xff003200);
		add(background);

		super.create();

		// pick a random luigi png from assets/images/luigi and put it in the bottom right corner
		luigi = new FlxSprite(445, 270, "assets/images/luigi/luigi" + luigiNum + ".png");
		luigi.scale.set(0.5, 0.5);
		add(luigi);

		changeLuigiPos();
		trace(luigiNum);

		// add the logo in the top left corner (small)
		logo = new FlxSprite(-230, -115, "assets/images/logo.png");
		logo.scale.set(0.25, 0.25);
		add(logo);

		// add a start button (in text) in Times New Roman
		startButton = new FlxText(0, 0, 100, "BEGIN");
		startButton.setFormat(null, 18, 0xffffff, "center", 0x000000);
		startButton.x = (FlxG.width - startButton.width) / 2;
		startButton.y = (FlxG.height - startButton.height) / 2;
		startButton.scale.set(1.5, 1.5);
		add(startButton);

		// optiona button beneath start button
		optionsButton = new FlxText(0, 0, 100, "Options");
		optionsButton.setFormat(null, 16, 0xffffff, "center", 0x000000);
		optionsButton.x = (FlxG.width - optionsButton.width) / 2;
		optionsButton.y = startButton.y + startButton.height + 10;
		add(optionsButton);

		// exit button beneath options button
		exitButton = new FlxText(0, 0, 100, "Exit");
		exitButton.setFormat(null, 16, 0xffffff, "center", 0x000000);
		exitButton.x = (FlxG.width - exitButton.width) / 2;
		exitButton.y = optionsButton.y + optionsButton.height + 10;
		add(exitButton);

		// create a pointer to the left of the selected option (farther away if its the start button)
		cursor = new FlxSprite(0, 0, "assets/images/pointer.png");
		cursor.scale.set(0.25, 0.25);
		add(cursor);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// check if the menu music has stopped playing if so, loop it (haxe 4.5)
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic("assets/music/menu.ogg");
		}

		/*
			// check if the mouse is over the start, options, or exit button, if so make it turn green
			if (selected == 0)
			{
				startButton.color = 0x00ff00;
			}
			else
			{
				startButton.color = 0xffffff;
			}
			if (selected == 1)
			{
				optionsButton.color = 0x00ff00;
			}
			else
			{
				optionsButton.color = 0xffffff;
			}
			if (selected == 2)
			{
				exitButton.color = 0x00ff00;
			}
			else
			{
				exitButton.color = 0xffffff;
			}
		 */

		if (FlxG.keys.justPressed.ENTER && selected == 0 && canSelect)
		{
			trace('goto PlayState');
			FlxG.switchState(new PlayState());
		}

		// when options button pressed go to OptionsState
		if (FlxG.keys.justPressed.ENTER && selected == 1 && canSelect)
		{
			FlxG.sound.music.stop();
			trace('goto OptionsState');
			FlxG.switchState(new OptionsState());
		}

		#if debug
		// when L pressed get a different luigi
		if (FlxG.keys.justPressed.L)
		{
			luigiNum = Random.int(1, 14);
			luigi.loadGraphic("assets/images/luigi/luigi" + luigiNum + ".png");
			luigi.x = 445;
			luigi.y = 270;
			changeLuigiPos();
			trace(luigiNum);
		}
		#end

		// when exit button pressed flash text saying "THERE IS NO ESCAPE" in red text
		if (FlxG.keys.justPressed.ENTER && selected == 2 && canSelect)
		{
			triedToEscape = true;
			canSelect = false;
			selected = 0;
			FlxG.save.data.strikes = FlxG.save.data.strikes + 1;
			luigi.visible = false;
			startButton.visible = false;
			optionsButton.visible = false;
			exitButton.visible = false;
			var text:FlxText = new FlxText(0, 0, 100, "THERE IS NO ESCAPE");
			FlxG.sound.music.stop();

			text.setFormat(null, 16, 0xff0000, "center", 0x000000);
			text.x = (FlxG.width - text.width) / 2;
			text.y = (FlxG.height - text.height) / 2;
			add(text);
			FlxG.camera.flash(0xffff0000, 1);
			// wait 1 second then go back to title screen
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				// reset the state
				startButton.visible = true;
				optionsButton.visible = true;

				canSelect = true;
				FlxG.sound.music.volume = 0.4;

				background.makeGraphic(FlxG.width, FlxG.height, 0xFF001E00);

				text.visible = false;
				remove(text);
			});
		}

		if (canSelect)
		{
			if (FlxG.keys.justPressed.DOWN)
				ChangeSelection(-1);
			else if (FlxG.keys.justPressed.UP)
				ChangeSelection(1);
		}

		// check what button is selected and make the pointer point at it from the left
		if (selected == 0)
		{
			cursor.x = startButton.x - 255;
			cursor.y = startButton.y - 140;
		}
		else if (selected == 1)
		{
			cursor.x = optionsButton.x - 255;
			cursor.y = optionsButton.y - 140;
		}
		else if (selected == 2)
		{
			cursor.x = exitButton.x - 255;
			cursor.y = exitButton.y - 140;
		}

		/*
			if (FlxG.sound.music == null || !FlxG.sound.music.playing)
			{
				// play the music
				FlxG.sound.music.loadEmbedded("assets/music/title.mp3", true);
				FlxG.sound.music.play();
			}
		 */
	}

	function ChangeSelection(amount:Int)
	{
		selected = selected - amount;

		if (!triedToEscape)
		{
			if (selected == -1)
				selected = 2;
			else if (selected == 3)
				selected = 0;
		}
		else
		{
			if (selected == -1)
				selected = 1;
			else if (selected == 2)
				selected = 0;
		}
	}

	function changeLuigiPos()
	{
		switch (luigiNum)
		{
			case 4:
				luigi.y = luigi.y + 100;
				luigi.x = luigi.x + 50;
			case 10:
				luigi.y = luigi.y + 100;
		}
	}
}

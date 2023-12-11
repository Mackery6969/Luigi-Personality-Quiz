package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var logo:FlxSprite;
	var background:FlxSprite;
	var question:FlxText;
	var answerOne:FlxText;
	var answerTwo:FlxText;
	var answerThree:FlxText;
	var cursor:FlxSprite;
	var strikes:Int = 0;

	var firstTime:Bool = true;

	var questionNum:Int = 0;
	var selected:Int = 0;
	var thirdAnswer:Bool = true;

	var questionList:Array<String> = [
		"What is your favorite colour?",
		"Who is the Superior Brother?",
		"you are aware of the stranger breathing on your neck.",
		"Which of your vital organs are you most willing to donate?",
		'Listen Closely,\nwho\'s voice is the loudest?',
		"pick a Girlfriend for Luigi",
		"How do you tend to react when someone disagrees with your opinion?"
	];
	var questionAnswerOne:Array<String> = [
		"Green",
		"Mario",
		"TRUE",
		"Brain",
		"Mario",
		"Rosilina",
		"With sincerity"
	];
	var questionAnswerTwo:Array<String> = [
		"Red",
		"Luigi",
		"FALSE",
		"Lungs",
		"Bowser",
		"Daisy",
		"With quite indifference"
	];
	var questionAnswerThree:Array<String> = [
		"Blue",
		"Other",
		"",
		"Heart",
		"",
		"Peach",
		"With violence"
	];

	override public function create()
	{
		// make a sprite thats just black and the size of the screen
		background = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, 0xff003200);
		add(background);

		super.create();

		logo = new FlxSprite(-230, -115, "assets/images/logo.png");
		logo.scale.set(0.25, 0.25);
		add(logo);

		question = new FlxText(0, 0, FlxG.width, questionList[0]);
		question.setFormat(null, 16, 0xffffffff, "center");
		question.x = (FlxG.width - question.width) / 2;
		question.y = (FlxG.height - question.height) / 2;
		add(question);

		answerOne = new FlxText(0, 0, FlxG.width, questionAnswerOne[0]);
		answerOne.setFormat(null, 16, 0xffffffff, "center");
		answerOne.x = (FlxG.width - answerOne.width) / 2;
		answerOne.y = question.y + question.height + 10;
		add(answerOne);

		answerTwo = new FlxText(0, 0, FlxG.width, questionAnswerTwo[0]);
		answerTwo.setFormat(null, 16, 0xffffffff, "center");
		answerTwo.x = (FlxG.width - answerTwo.width) / 2;
		answerTwo.y = answerOne.y + answerOne.height + 10;
		add(answerTwo);

		answerThree = new FlxText(0, 0, FlxG.width, questionAnswerThree[0]);
		answerThree.setFormat(null, 16, 0xffffffff, "center");
		answerThree.x = (FlxG.width - answerThree.width) / 2;
		answerThree.y = answerTwo.y + answerTwo.height + 10;
		add(answerThree);
		loadQuestion();

		cursor = new FlxSprite(0, 0, "assets/images/pointer.png");
		cursor.x = answerOne.x - 255;
		cursor.y = answerOne.y - 140;
		cursor.scale.set(0.25, 0.25);
		add(cursor);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		/*
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic("assets/music/questions.ogg");
		}
		*/
		
		{
			if (FlxG.keys.justPressed.DOWN)
				changeSelection(-1);
			else if (FlxG.keys.justPressed.UP)
				changeSelection(1);
		}

		//put the cursor to the right of the selected answer
		if (selected == 0)
		{
			cursor.x = answerOne.x - 5;
			cursor.y = answerOne.y - 140;
		}
		else if (selected == 1)
		{
			cursor.x = answerTwo.x - 5;
			cursor.y = answerTwo.y - 140;
		}
		else if (selected == 2)
		{
			cursor.x = answerThree.x - 5;
			cursor.y = answerThree.y - 140;
		}

		/*
		if (FlxG.keys.justPressed.ENTER)
		{
			//welcome to code hell
			switch(questionNum)
			{
				case 0:
					if (selected == 0)
					{
						//do nothing lol
					}
					else 
					{
						strikes++;
					}
				case 1:
					if (selected == 1)
					{
						//do nothing lol
					}
					else 
					{
						strikes++;
					}
				case 4 | 5:
					if (selected == 2)
					{
						//do nothing lol
					}
					else 
					{
						strikes++;
					}
			}
			answerOne.visible = false;
			answerTwo.visible = false;
			answerThree.visible = false;
			cursor.visible = false;

			loadQuestion();
		}
		*/
	}

	function loadQuestion()
	{

		//reset the questions and cursor
		answerOne.visible = true;
		answerTwo.visible = true;
		answerThree.visible = true;
		cursor.visible = true;
		selected = 0;

		if (firstTime == true)
			firstTime = false;
		else
			questionNum = questionNum + 1;
		var questionNumTxt = questionNum + 1;

		question.text = 'Question ' + questionNumTxt + ': ' + questionList[questionNum];
		answerOne.text = questionAnswerOne[questionNum];
		answerTwo.text = questionAnswerTwo[questionNum];
		if (questionAnswerThree[questionNum] != "")
		{
			answerThree.text = questionAnswerThree[questionNum];
			thirdAnswer = true;
		}
		else
		{
			answerThree.visible = false;
			thirdAnswer = false;
		}
	}

	function changeSelection(amount:Int)
	{
		selected = selected - amount;

		if (thirdAnswer)
		{
			if (selected > 2) selected = 0;
			if (selected < 0) selected = 2;
		}
		else
		{
			if (selected > 1) selected = 0;
			if (selected < 0) selected = 1;
		}
	}
}

package;

import flixel.FlxG;
import flixel.text.FlxText;

class OptionsState extends FlxState
{
	override public function create()
	{
		var unfinished:FlxText = new FlxText(0, 0, FlxG.width, "This state is unfinished");
		unfinished.setFormat(null, 16, 0xFFFFFFFF, "center");
		add(unfinished);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic("assets/music/options.ogg");
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.music.stop();
			FlxG.switchState(new TitleState());
		}
	}
}

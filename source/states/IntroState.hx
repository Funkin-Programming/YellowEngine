package states;

import flixel.FlxG;
import flixel.FlxState;
#if VIDEOS_ALLOWED
import hxcodec.flixel.FlxVideo;
#end

class IntroState extends FlxState
{
	override function create()
	{
		super.create();

		#if VIDEOS_ALLOWED
		var video:FlxVideo = new FlxVideo();
		video.onEndReached.add(function()
		{
			video.dispose();
			FlxG.switchState(new FlashingState());
		});
		video.play(Paths.video('intro'));
		#else
		FlxG.switchState(new FlashingState());
		#end
	}
}

package states;

import flixel.FlxSubState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var msg:String = "Hey, watch out!\n
		This Mod contains some flashing lights!\n
		#if mobile Press A to disable them or B to ignore.\n #else Press ENTER to disable them or ESCAPE to ignore.\n #end
		You've been warned!";

		var txt:String = "Hey, watch out!\n\nThis Mod contains some flashing lights!\n\n"
			+ #if mobile "Tap to disable flashing lights.\nPress BACK to ignore this message." #else "Press ENTER to disable flashing lights.\nPress ESCAPE to ignore this message." #end
			+ "\n\nYou've been warned!";

		controls.isInSubstate = false;

		warnText = new FlxText(0, 0, FlxG.width, txt, 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if (!leftState)
		{
			var back:Bool = controls.BACK;
			var accept:Bool = controls.ACCEPT;

			#if mobile
			if (FlxG.touches.list.length > 0 && FlxG.touches.getFirst().justReleased)
				accept = true;
			#end

			if (accept || back)
			{
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				if (!back)
				{
					ClientPrefs.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker)
					{
						new FlxTimer().start(0.5, function(tmr:FlxTimer)
						{
							MusicBeatState.switchState(new TitleState());
						});
					});
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function(twn:FlxTween)
						{
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}
}
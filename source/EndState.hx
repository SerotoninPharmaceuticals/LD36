package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
import flixel.system.FlxSound;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;


class EndState extends FlxState {

  private var typeText:FlxTypeText;

  public override function create() {
    super.create();
    var text:String = "This is Omicron to HQ, Omicron to HQ.\n\n" +
                      "This is transmitted from archaeology site #57.\n\n" +
                      "Evidence shows that there was once a primeval civilizaion which was extinct in approximated 40,000 years ago. The exact reason has not yet to be found, but presumably a Type C catastrophe.\n\n" +
                      "Not much to be seen on the planet really, however, a relatively well-preserved container has just been found today.\n\n" +
                      "But regrettably, all its content has turned to dust like everything else on this forsaken planet.\n\n" +
                      "Nonetheless, the container itself has been archived though.\n\n" +
                      "Turns out this is just another civilization passed without leaving a trace, poor souls.\n\n" +
                      "Anyway, it unlikely that there is anything worth further excavating，you can expect us to return home very soon.";
    typeText = new FlxTypeText(100, 50, 600, text, 12);
    typeText.sounds = [FlxG.sound.load("assets/sounds/type.wav"),
                       FlxG.sound.load("assets/sounds/type01.wav")];
    add(typeText);
    typeText.start();
  }
}

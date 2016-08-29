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
    typeText = new FlxTypeText(200, 150, 400, "All work and no play makes Jack a dull boy.", 12);
    typeText.sounds = [FlxG.sound.load("assets/sounds/type.wav"),
                       FlxG.sound.load("assets/sounds/type01.wav")];
    add(typeText);
    typeText.start();
  }
}

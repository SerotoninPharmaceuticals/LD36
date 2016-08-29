package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();

    addChild(new FlxGame(0, 0, IntroState, 1, 60, 60, true));
  }
}

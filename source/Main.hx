package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();

    if (GameConfig.DEBUG) {
      addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true));
    } else {
      addChild(new FlxGame(0, 0, IntroState, 1, 60, 60, true));
    }
  }
}

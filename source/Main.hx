package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
  public function new() {
    super();

    if (GameConfig.DEBUG) {
      addChild(new FlxGame(800, 480, PlayState));
    } else {
      addChild(new FlxGame(800, 480, IntroState));
    }
  }
}

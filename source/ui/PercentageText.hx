package ui;

import flixel.text.FlxText;

class PercentageText extends FlxText {

  private static inline var WIDTH = 300;

  public function new():Void {
    super(GameConfig.SCREEN_LEFT_PADDING, 185, WIDTH, "Completion: 0.0%");
    color = GameConfig.SCREEN_COLOR_YELLOW;
    size = 10;
  }

  public function setPercentage(percentage:Float) {
    text = "Completion: " + Std.int(percentage * 100) + "." + (Std.int(percentage * 10000) % 100) + "%";
  }
}

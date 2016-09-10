package ui;

import flixel.text.FlxText;

class TitleText extends FlxText {

  public function new(title:String = ""):Void {
    super(GameConfig.SCREEN_LEFT_PADDING, GameConfig.SCREEN_TOP_PADDING);
    color = GameConfig.SCREEN_COLOR_YELLOW;
    size = 14;
    setText(title);
  }

  public function setText(_text:String) {
    text = _text;
  }
}

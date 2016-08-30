package ui;

import flixel.text.FlxText;

class TitleText extends FlxText {

  public function new(title:String = ""):Void {
    super(10, 10);
    color = GameConfig.SCREEN_COLOR_YELLOW;
    size = 12;
    setText(title);
  }

  public function setText(_text:String) {
    text = _text;
  }
}

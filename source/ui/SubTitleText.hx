package ui;

import flixel.text.FlxText;

class SubTitleText extends FlxText {

  public function new(title:String = ""):Void {
    super(4, 18);
    color = GameConfig.SCREEN_COLOR_YELLOW;
    size = 10;
    setText(title);
  }

  public function setText(_text:String) {
    text = _text;
  }
}

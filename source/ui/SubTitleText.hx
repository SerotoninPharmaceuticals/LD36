package ui;

import flixel.text.FlxText;

class SubTitleText extends FlxText {

  public function new(title:String = ""):Void {
    super(6, 26);
    color = GameConfig.SCREEN_COLOR_YELLOW;
    size = 12;
    setText(title);
  }

  public function setText(_text:String) {
    text = _text;
  }
}

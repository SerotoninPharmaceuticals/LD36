package ui;

import libs.FloatUtil;
import flixel.text.FlxText;

class CoordText extends FlxText {

  public function new():Void {
    super(0, 185, MachineState.SCREEN_MAIN_WIDTH - GameConfig.SCREEN_LEFT_PADDING, "Coord.x:N/A y:N/A");
    alignment = FlxTextAlign.RIGHT;
    color = GameConfig.SCREEN_COLOR_YELLOW;
    size = 10;
  }

  public function setPos(x:Float, y:Float) {
    text = "Coord.x:" + FloatUtil.fixedFloat(x - MachineState.SCREEN_X) +
    " y:" + FloatUtil.fixedFloat(y - MachineState.SCREEN_Y);
  }
}

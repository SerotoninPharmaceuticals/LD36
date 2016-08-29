package ui;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;


class TemperatureStatus extends FlxSpriteGroup {

  private static inline var WIDTH = 300;
  private static inline var TEMP_TEXT_X = 20;
  private static inline var TEMP_TEXT_Y = 20;

  private var tempText:FlxText;
  private var name:FlxText;

  public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0, InitialTemp:Float = 30.5):Void {
    super(X, Y, MaxSize);

    name = new FlxText(0, 0, WIDTH, "Temperature");
    tempText = new FlxText(TEMP_TEXT_X, TEMP_TEXT_Y, WIDTH, tempToText(InitialTemp));
    add(name);
    add(tempText);
    setInvalid();
  }

  public function setTemperature(temp:Float) {
    tempText.text = tempToText(temp);
  }

  public function setValid():Void {
    name.setFormat(null, 14, 0xFF00FC00);
    tempText.setFormat(null, 15, 0xFF00FC00);
  }

  public function setInvalid():Void {
    name.setFormat(null, 14, GameConfig.SCREEN_COLOR_YELLOW0);
    tempText.setFormat(null, 15, GameConfig.SCREEN_COLOR_YELLOW0);
  }

  private function tempToText(temp:Float) {
    return "" + Std.int(temp) + "." + Math.abs(Std.int(temp * 10)) % 10 + "℃";
  }
}

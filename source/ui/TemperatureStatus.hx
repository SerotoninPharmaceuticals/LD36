package ui;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;


class TemperatureStatus extends FlxSpriteGroup {

  private static inline var WIDTH = 130;
  private static inline var TEMP_SIZE = 30;
  private static inline var NAME_SIZE = 14;
  private static inline var LINE_GAP = 8;

  private var tempText:FlxText;
  private var name:FlxText;

  public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0, InitialTemp:Float = 30.5):Void {
    super(X, Y, MaxSize);

    tempText = new FlxText(0, 0, WIDTH, tempToText(InitialTemp));
    name = new FlxText(0, TEMP_SIZE + LINE_GAP, WIDTH, "Temperature");

    tempText.alignment = FlxTextAlign.RIGHT;
    tempText.size = TEMP_SIZE;

    name.alignment = FlxTextAlign.RIGHT;
    name.size = NAME_SIZE;

    add(name);
    add(tempText);
    setInvalid();
  }

  public function setTemperature(temp:Float) {
    tempText.text = tempToText(temp);
  }

  public function setValid():Void {
    name.color = 0xFF00FC00;
    tempText.color = 0xFF00FC00;
  }

  public function setInvalid():Void {
    name.color = GameConfig.SCREEN_COLOR_YELLOW;
    tempText.color = GameConfig.SCREEN_COLOR_YELLOW;
  }

  private function tempToText(temp:Float) {
    return "" + Std.int(temp) + "." + Math.abs(Std.int(temp * 10)) % 10 + "℃";
  }
}

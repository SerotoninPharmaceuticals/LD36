package ui;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;


class TemperatureStatus extends FlxSpriteGroup {

  private static inline var TEMP_SIZE = 20;
  private static inline var TEMP_SMALL_SIZE = 16;
  private static inline var NAME_SIZE = 14;

  private static inline var PADDING_TOP = 16;
  private static inline var LINE_GAP = 8;
  private static inline var WIDTH = 98;
  private static inline var HEIGHT = 75;


  private var tempText:FlxText;
  private var name:FlxText;
  var highlightBg:FlxSprite;


  public function new(InitialTemp:Float = 30.5):Void {
    super(0, 201, 0);

    tempText = new FlxText(0, PADDING_TOP, WIDTH, tempToText(InitialTemp));
    name = new FlxText(0, PADDING_TOP + TEMP_SIZE + LINE_GAP, WIDTH, "TEMP");

    tempText.alignment = FlxTextAlign.CENTER;
    tempText.size = TEMP_SIZE;
    tempText.color = GameConfig.SCREEN_COLOR_YELLOW;

    name.alignment = FlxTextAlign.CENTER;
    name.size = NAME_SIZE;
    name.color = GameConfig.SCREEN_COLOR_YELLOW;

    highlightBg = new FlxSprite(0, 0);

    add(highlightBg);
    add(name);
    add(tempText);
    setInvalid();
  }

  public function setTemperature(temp:Float) {
    tempText.text = tempToText(temp);
    if (temp <= -100 || temp >= 1000) {
      tempText.size = TEMP_SMALL_SIZE;
      tempText.y = y + PADDING_TOP + 4;
    } else if (temp > -96 || temp < 996) {
      tempText.size = TEMP_SIZE;
      tempText.y = y + PADDING_TOP;
    }
  }

  public function setValid():Void {
    highlightBg.makeGraphic(WIDTH, HEIGHT, GameConfig.SCREEN_COLOR_YELLOW1);
  }

  public function setInvalid():Void {
    highlightBg.makeGraphic(WIDTH, HEIGHT, FlxColor.TRANSPARENT);
  }

  private function tempToText(temp:Float) {
    return "" + Std.int(temp) + "." + Math.abs(Std.int(temp * 10)) % 10 + "'C";
  }
}

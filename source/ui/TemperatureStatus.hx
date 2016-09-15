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


  public function new():Void {
    super(0, 201, 0);
    var InitialTemp = GameConfig.ROOM_TEMP_HI - 1;
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

  public var currentTemp:Float = GameConfig.ROOM_TEMP_HI - 1;
  var durationAfterLastJitter:Float = 0;

  override public function update(elapsed:Float) {
    if (currentTemp < GameConfig.ROOM_TEMP_LO) {
      setTemperature(currentTemp + elapsed * GameConfig.TEMP_INC_SPEED);
    } else if (currentTemp > GameConfig.ROOM_TEMP_HI) {
      setTemperature(currentTemp - elapsed * GameConfig.TEMP_INC_SPEED);
    } else {
      if (durationAfterLastJitter > GameConfig.ROOM_TEMP_JITTER_INTERVAL) {
        setTemperature(currentTemp + (Math.random() - 0.5) * 1.2);
        durationAfterLastJitter = 0;
      } else {
        durationAfterLastJitter += elapsed;
      }
    }
    super.update(elapsed);
  }

  public function setTemperature(temp:Float) {
    currentTemp = temp;
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

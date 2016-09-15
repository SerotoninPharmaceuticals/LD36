package ui;

import Std;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class PressureBarHoriz extends FlxTypedGroup<FlxSprite> {


  private static inline var height = 12;
  private static inline var width = 204;

  private static inline var text_width = width;
  private static inline var font_size = 12;
  private static inline var cursor_width = 5;

  private static inline var bar_x = 0;
  private static inline var bar_y = font_size + 6;
  private static inline var bar_width = width;

  var x:Float = 105;
  var y:Float = 240;
  var total:Int;

  private var title:FlxText;

  var cursor:FlxSprite;
  var border:FlxSprite;

  public function new(target_start:Int, target_end:Int, _total:Int):Void {
    super();
    total = _total;

    title = new FlxText(x, y, text_width, "Internal Pressure");
    title.color = GameConfig.SCREEN_COLOR_YELLOW;
    title.size = font_size;
    add(title);

    var target = new FlxSprite(x + bar_x + (1 - target_end / total) * bar_width + 1, y + bar_y + 1);
    target.makeGraphic(Std.int((target_end - target_start)/total * bar_width) - 2, height - 2, GameConfig.SCREEN_COLOR_YELLOW1);
    add(target);

    border = new FlxSprite(x + bar_x, y + bar_y);
    border.makeGraphic(bar_width, height, FlxColor.TRANSPARENT);
    FlxSpriteUtil.drawRect(border, 1, 1, bar_width - 2, height - 2, FlxColor.TRANSPARENT, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      thickness: 2,
      pixelHinting: true
    });

    add(border);

    cursor = new FlxSprite(x + bar_x, y + bar_y);
    cursor.makeGraphic(cursor_width, height, GameConfig.SCREEN_COLOR_YELLOW);
    add(cursor);
    setValue(0);
  }

  public function setValue(value:Int) {
    cursor.setPosition(border.x + (1 - value / total) * (bar_width - cursor.width), cursor.y);
  }
}

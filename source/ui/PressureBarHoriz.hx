package ui;

import flixel.group.FlxSpriteGroup;
import Std;
import flixel.math.FlxMath;
import Std;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class PressureBarHoriz extends FlxSpriteGroup {


  private static inline var outer_height = 12;
  private static inline var outer_width = 204;

  private static inline var text_width = outer_width;
  private static inline var font_size = 12;
  private static inline var cursor_width = 5;

  private static inline var bar_x = 0;
  private static inline var bar_y = font_size + 6;
  private static inline var bar_width = outer_width;

  var total:Int;

  private var title:FlxText;

  var cursor:FlxSprite;
  var border:FlxSprite;

  var originalValue:Int;

  public function new(target_start:Int = 0, target_end:Int = 0, _total:Int = 120, autorun:Bool = false):Void {
    super(105, 240);
    total = _total;

    title = new FlxText(0, 0, text_width, "Internal Pressure");
    title.color = GameConfig.SCREEN_COLOR_YELLOW;
    title.size = font_size;
    add(title);

    if (!autorun) {
      var target = new FlxSprite(bar_x + (1 - target_end / total) * bar_width + 1, bar_y + 1);
      target.makeGraphic(Std.int((target_end - target_start)/total * bar_width) - 2, outer_height - 2, GameConfig.SCREEN_COLOR_YELLOW1);
      add(target);
    }

    border = new FlxSprite(bar_x, bar_y);
    border.makeGraphic(bar_width, outer_height, FlxColor.TRANSPARENT);
    FlxSpriteUtil.drawRect(border, 1, 1, bar_width - 2, outer_height - 2, FlxColor.TRANSPARENT, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      thickness: 2,
      pixelHinting: true
    });

    add(border);

    cursor = new FlxSprite(bar_x, bar_y);
    cursor.makeGraphic(cursor_width, outer_height, GameConfig.SCREEN_COLOR_YELLOW);
    add(cursor);

    if (autorun) {
      originalValue = Std.int(Math.random() * total * 0.8 + total * 0.1);
      setValue(originalValue);
    } else {
      originalValue = 0;
      setValue(0);
    }
  }

  override public function update(d:Float):Void {
    setValue(originalValue + Std.int((Math.random()-0.5) * total * 0.1));
    super.update(d);
  }

  public function setValue(value:Int) {
    cursor.setPosition(border.x + (1 - value / total) * (bar_width - cursor.width), cursor.y);
  }
}

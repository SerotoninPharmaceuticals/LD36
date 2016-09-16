package ui;

import Std;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;

class DensityBarHoriz extends FlxSpriteGroup {

  private static inline var bar_height = 14;
  private static inline var bar_width = 204;

  private static inline var text_width = bar_width;
  private static inline var font_size = 12;
  private static inline var cursor_width = 5;

  private static inline var bar_x = 0;
  private static inline var bar_y = font_size + 6;

  var total:Int;
  var targetLimit:Int;
  var autorun:Bool;

  private var title:FlxText;

  var cursor:FlxSprite;
  var border:FlxSprite;
  var target:FlxSprite;

  var originalValue:Int;

  public function new(target_start:Int = 0, target_width:Int = 0, _target_limit = 70, _total:Int = 100, _autorun:Bool = true):Void {
    super(105, 204);
    total = _total;
    targetLimit = _target_limit;
    autorun = _autorun;

    title = new FlxText(0, 0, text_width, "Current Density");
    title.color = GameConfig.SCREEN_COLOR_YELLOW;
    title.size = font_size;
    add(title);

    if (!autorun) {
      target = new FlxSprite(bar_x + (target_start / total) * bar_width + 1, bar_y + 1);
      target.makeGraphic(Std.int(target_width / total * bar_width) - 2, bar_height - 2, GameConfig.SCREEN_COLOR_YELLOW1);
      add(target);

      var targetBoundary = new FlxSprite(bar_x + (targetLimit / total) * (bar_width - cursor_width) + target.width, bar_y);
      targetBoundary.loadGraphic('assets/images/procedures/bar_dash.png');
      add(targetBoundary);
    }

    border = new FlxSprite(bar_x, bar_y);
    border.makeGraphic(bar_width, bar_height, FlxColor.TRANSPARENT);
    FlxSpriteUtil.drawRect(border, 1, 1, bar_width - 2, bar_height - 2, FlxColor.TRANSPARENT, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      thickness: 2,
      pixelHinting: true
    });

    add(border);

    cursor = new FlxSprite(bar_x, bar_y);
    cursor.makeGraphic(cursor_width, bar_height, GameConfig.SCREEN_COLOR_YELLOW);
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
    if (autorun) {
      setValue(originalValue + Std.int((Math.random()-0.5) * total * 0.1));
    }
    super.update(d);
  }

  public function setValue(value:Float) {
    cursor.setPosition(border.x + (value / total) * (bar_width - cursor.width), cursor.y);
  }
  public function setTargetValue(value:Float) {
    value = Std.int(Math.min(targetLimit, value));
    target.setPosition(border.x + (value / total) * (bar_width - cursor.width), target.y);
  }
}

package ui;

import Std;
import flixel.addons.display.FlxSpriteAniRot;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class PressureBarHoriz extends FlxTypedGroup<FlxSprite> {


  private static inline var height = 10;
  private static inline var width = 300;

  private static inline var text_width = 80;
  private static inline var cursor_width = 5;

  private static inline var bar_x = text_width + 10;
  private static inline var bar_width = width - text_width - 10;

  var x:Int;
  var y:Int;
  var total:Int;

  private var title:FlxText;

  var cursor:FlxSprite;
  var border:FlxSprite;

  public function new(X:Float = 0, Y:Float = 0, target_start:Int, target_end:Int, _total:Int):Void {
    super();
    x = Std.int(X);
    y = Std.int(Y);
    total = _total;

    title = new FlxText(x, y, text_width, "Pressure");
    add(title);

    var target = new FlxSprite(x + bar_x + (target_start / total) * bar_width + 1, y + 1);
    target.makeGraphic(Std.int((target_end - target_start)/total * bar_width) - 2, height - 2, GameConfig.SCREEN_COLOR_YELLOW1 );
    add(target);

    border = new FlxSprite(x + bar_x, y);
    border.makeGraphic(bar_width, height, FlxColor.TRANSPARENT);
    FlxSpriteUtil.drawRect(border, 0, 0, bar_width - 1, height - 1, FlxColor.TRANSPARENT, { color: GameConfig.SCREEN_COLOR_YELLOW0 });
    add(border);

    cursor = new FlxSprite(x + bar_x, y - 4);
    cursor.makeGraphic(cursor_width, height + 8, GameConfig.SCREEN_COLOR_YELLOW0);
    add(cursor);
  }

  public function setValue(value:Int) {
    cursor.setPosition(border.x + value / total * bar_width, cursor.y);
  }
}

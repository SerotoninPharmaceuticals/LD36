package ui;

import flixel.group.FlxSpriteGroup;
import Std;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.NumTween;

class PressureBarHoriz extends FlxSpriteGroup {

  private static inline var bar_height = 13;
  private static inline var bar_width = 204;

  private static inline var text_width = bar_width;
  private static inline var font_size = 12;
  private static inline var cursor_width = 5;

  private static inline var bar_x = 0;
  private static inline var bar_y = font_size + 5;

  var total:Int;
  var autorun:Bool;

  private var title:FlxText;
  private var idleValue:NumTween;

  var cursor:FlxSprite;
  var border:FlxSprite;

  var originalValue:Int;
  var targetValue:Int;
  var tempValue:Int;
  var tweenDuration:Float;

  public function new(target_start:Int = 0, target_width:Int = 1, _total:Int = 100, _autorun:Bool = false):Void {
    super(104, 237);
    total = _total;
    autorun = _autorun;

    title = new FlxText(0, 0, text_width, "Internal Pressure");
    title.color = GameConfig.SCREEN_COLOR_YELLOW;
    title.size = font_size;
    add(title);

    if (!autorun) {
      var target = new FlxSprite(bar_x + (target_start / total) * bar_width + 1, bar_y + 1);
      target.makeGraphic(Std.int(target_width/total * bar_width) - 2, bar_height - 2, GameConfig.SCREEN_COLOR_YELLOW1);
      add(target);
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
      tempValue = originalValue;
	  setValue(originalValue);
      idleTween();
    } else {
      originalValue = 0;
      setValue(0);
    }
  }

  override public function update(d:Float):Void {
    if (autorun) {
      setValue(idleValue.value);
    }
    super.update(d);
  }
  
  public function idleTween() {
	targetValue = originalValue + Std.int((Math.random() - 0.5) * total * 0.08);
	tweenDuration = 0.25 + Math.random() * 0.15;
	
	idleValue = FlxTween.num(tempValue, targetValue, tweenDuration, {	
	  onComplete: function(tween) {
		tempValue = targetValue;  
        idleTween();
      }
	});
  }

  public function setValue(value:Float) {
    cursor.setPosition(border.x + (value / total) * (bar_width - cursor.width), cursor.y);
  }
}

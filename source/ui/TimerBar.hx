package ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;

import GameConfig;


class TimerBar extends FlxSpriteGroup {

  public static inline var TIME_SPEED = 20;

  private static inline var DIGIT_WIDTH = 138;
  private static inline var DIGIT_HEIGHT = 168;

  private var digitScale:Float = 5;

  public var currentTime:Int;
  public var digits:Array<FlxSprite>;

  public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0, scale:Float = 5) {
    currentTime = GameData.timerTime;
    digitScale = scale;
    super(X, Y, MaxSize);
    timer = new FlxTimer();
    createDigits();
  }

  private function createDigits():Void {
    digits = new Array<FlxSprite>();
    var i;
    var digit:FlxSprite;
    for (i in 0...5) {
      digit = new FlxSprite();
      digit.loadGraphic("assets/images/time_digits_map.png", true,
                        DIGIT_WIDTH, DIGIT_HEIGHT);
      digit.x = Std.int(105.5 / digitScale) * i;
      if (i == 2) {
        digit.animation.frameIndex = 10;
      } else {
        digit.animation.frameIndex = 0;
      }
      digits.push(digit);
      add(digit);
      digit.setGraphicSize(Std.int(DIGIT_WIDTH / digitScale), Std.int(DIGIT_HEIGHT / digitScale));
      digit.updateHitbox();
    }
  }

  public function start():Void {
    isStarted = true;
    timer.start(currentTime / TIME_SPEED, onComplete);
  }

  public function pause():Void {
    isStarted = false;
    timer.cancel();
  }

  public function forceUpdateTime() {
    currentTime = GameData.timerTime;
  }

  private function onComplete(timer:FlxTimer):Void {
    isStarted = false;
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    if (isStarted) {
      currentTime = Std.int(timer.timeLeft * TIME_SPEED);
      var min:Int = currentTime % 60;
      var hour:Int = Std.int(currentTime / 60);
      digits[0].animation.frameIndex = Std.int(hour / 10);
      digits[1].animation.frameIndex = hour % 10;
      digits[3].animation.frameIndex = Std.int(min / 10);
      digits[4].animation.frameIndex = min % 10;

      GameData.timerTime = currentTime;
    }
  }

  private var timer:FlxTimer;
  private var isStarted:Bool = false;
}

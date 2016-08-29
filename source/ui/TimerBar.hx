package ui;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

import GameConfig;


class TimerBar extends FlxSpriteGroup {

  public static inline var TIME_SPEED = 20;

  private static inline var DIGIT_WIDTH = 138;
  private static inline var DIGIT_HEIGHT = 168;

  private var digitScale:Float = 6;
  private var screenSprite:FlxSprite;

  public var currentTime:Int;
  public var digits:Array<FlxSprite>;

  public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0, scale:Float = 5.2) {
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

  public function onComplete(timer:FlxTimer):Void {
    isStarted = false;
    FlxG.camera.shake(0.5, 0.5, showEnd);
  }

  private function showEnd():Void {
    screenSprite = new FlxSprite(0, 0);
    screenSprite.makeGraphic(800, 480, FlxColor.WHITE);
    FlxG.state.clear();
    FlxG.state.add(screenSprite);
    FlxTween.tween(screenSprite.scale, { x: 1.2, y: 0.002 }, 0.2,
                   { type: FlxTween.ONESHOT, onComplete: onCompleteFirstPhase });
  }

  private function onCompleteFirstPhase(tween:FlxTween) {
    FlxTween.tween(screenSprite.scale, { x: 0.002, y: 0.002}, 0.2,
                   { type: FlxTween.ONESHOT,
                     onComplete: function (tween:FlxTween) {
                       FlxG.state.remove(screenSprite);
                     }});
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

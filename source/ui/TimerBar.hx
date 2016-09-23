package ui;

#if flash
import flash.ui.MouseCursor;
import flash.ui.Mouse;
#end

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class TimerBar extends FlxSpriteGroup {

  private static inline var DIGIT_WIDTH = 138;
  private static inline var DIGIT_HEIGHT = 168;

  private var digitScale:Float = 6;
  private var screenSprite:FlxSprite;

  public var currentTime:Int;
  public var digits:Array<FlxSprite>;

  public var state:FlxState;

  public var completeCallback:Void->Void;
  
  private var scrollSpeed:Float = 50;

  private var timer:FlxTimer;
  private var isStarted:Bool = false;

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
    timer.start(currentTime / (GameConfig.TIME_SCALE), onComplete);
  }

  public function pause():Void {
    isStarted = false;
    timer.cancel();
  }

  public function forceUpdateTime() {
    currentTime = GameData.timerTime;
  }

  public function onComplete(timer:FlxTimer):Void {
//    if (completeCallback != null) {
//      completeCallback();
//    }
    isStarted = false;
    FlxG.sound.pause();
    FlxG.sound.play("assets/sounds/ending.wav", 0.5, false, null, true);
    FlxG.camera.shake(0.5, 1, showEnd);
  }

  private function showEnd():Void {

    #if flash
    Mouse.cursor = MouseCursor.ARROW;
    #end
    screenSprite = new FlxSprite(0, 0);

    screenSprite.makeGraphic(800, 480, FlxColor.WHITE);
    FlxG.state.closeSubState();
    FlxG.state.clear();
    FlxG.state.add(screenSprite);
    FlxTween.tween(screenSprite.scale, { x: 1.2, y: 0.002 }, 0.2, {
      type: FlxTween.ONESHOT, onComplete: onCompleteFirstPhase
    });
  }

  private function onCompleteFirstPhase(tween:FlxTween) {
    FlxTween.tween(screenSprite.scale, { x: 0.002, y: 0.002}, 0.45, {
      ease: FlxEase.quartInOut,
      type: FlxTween.ONESHOT,
      onComplete: function (tween:FlxTween) {
        var timer = new FlxTimer();
        screenSprite.kill();
        timer.start(5, function(t) {
          showEndTitle();
        });
      }
    });
  }

  function showEndTitle() {
    var endTitle = new FlxSpriteGroup(0, FlxG.height);
    var currY:Float = 0;
	
    var title = new FlxSprite();
    title.loadGraphic('assets/images/end_title.png');
    title.x = FlxG.width / 2 - title.width / 2;
    title.y = currY;
    currY += title.height + 20;
    endTitle.add(title);	
	
    for (i in 0...GameData.finishedTechThings.length) {
      var img = new FlxSprite();
      img.loadGraphic(GameData.finishedTechThings[i].imageAfter);
      img.x = FlxG.width / 2 - img.width / 2;
      img.y = currY;
      currY += img.height + 50;
      endTitle.add(img);
    }
    var credits = new FlxSprite();
    credits.loadGraphic('assets/images/end_credits.png');
    credits.x = FlxG.width / 2 - credits.width / 2;
    credits.y = currY;
    currY += credits.height;
    endTitle.add(credits);

    var gameover = new FlxSprite();
    gameover.loadGraphic('assets/images/end_gameover.png');
    gameover.x = FlxG.width / 2 - gameover.width / 2;
    gameover.y = currY;
    currY += gameover.height;
    endTitle.add(gameover);

    FlxG.state.add(endTitle);
    FlxTween.linearMotion(endTitle, endTitle.x, endTitle.y, endTitle.x, endTitle.y - currY, currY / scrollSpeed);
  }

  private function onSoundComplete():Void {
//    FlxG.switchState(new EndState());
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    if (isStarted) {
      currentTime = Std.int(timer.timeLeft * GameConfig.TIME_SCALE);
      var min:Int = currentTime % 60;
      var hour:Int = Std.int(currentTime / 60);
      digits[0].animation.frameIndex = Std.int(hour / 10);
      digits[1].animation.frameIndex = hour % 10;
      digits[3].animation.frameIndex = Std.int(min / 10);
      digits[4].animation.frameIndex = min % 10;

      GameData.timerTime = currentTime;
    }
  }

  override public function destroy() {
    timer.destroy();
    super.destroy();
  }

}

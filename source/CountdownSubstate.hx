package;

#if flash
import flash.ui.Mouse;
import flash.ui.MouseCursor;
#end

import flixel.FlxSprite;
import flixel.util.FlxTimer;
import ui.TimerBar;
import flixel.FlxSubState;

class CountdownSubstate extends FlxSubState {
  static var timePoints = [
    // [time stamp, stay, has opened(0/1)]
    [60 * 3, 1.6, 0],
    [60 * 2, 1.0, 0],
    [60 + 15, 0.4, 0],
    [60 + 4, 0.6, 0],
    [50, 0.8, 0],
    [35, 0.4, 0],
    [25, 100.0, 0] // use 100 to prevent close.
  ];

  public static function check(elpased:Float):Null<CountdownSubstate> {
    for (i in 0...timePoints.length) {
      if (
        timePoints[i][0] >= GameData.timerTime &&
        timePoints[i][0] < GameData.timerTime + elpased * GameConfig.TIME_SCALE &&
        timePoints[i][2] == 0
      ) {
        timePoints[i][2] = 1;
        return new CountdownSubstate(timePoints[i][1]);
      }
    }
    return null;
  }

  var stayTime:Float;
  public function new(_stayTime:Float):Void {
    super();
    stayTime = _stayTime;
  }

  override public function create():Void {
    super.create();
    var timer = new FlxTimer();
    timer.start(stayTime, function(t) {
      close();
    });

    #if flash
    Mouse.cursor = MouseCursor.ARROW;
    #end

    createTitleScreen();
    createTimerBar();
  }
  private function createTitleScreen():Void {
    var titlescreen = new FlxSprite();
    titlescreen.loadGraphic("assets/images/titlescreen.png");
    add(titlescreen);
  }

  private function createTimerBar():Void {
    var timerBar = new TimerBar(-80, 83, 0, 0.57);
    timerBar.start();
    add(timerBar);
  }
}

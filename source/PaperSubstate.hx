package;

#if flash
import flash.ui.MouseCursor;
import flash.ui.Mouse;
#end

import ui.TimerBar;
import flixel.util.FlxAxes;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PaperSubstate extends FlxSubState {
  var wheel_speed = 5;
  var paper:FlxSprite;

  var pauseTimer:Bool;
  public function new(_paper:FlxSprite, _pauseTimer = true):Void {
    super();
    paper = _paper;
    pauseTimer = _pauseTimer;
  }

  override public function create():Void {
    super.create();

    var background:FlxSprite = new FlxSprite(0, 0);
    background.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
    background.alpha = 0.65;
    add(background);

    paper.screenCenter(FlxAxes.X);
    if (paper.frameWidth == 457) paper.y = 15;
    else paper.y = 40;
    add(paper);

    if (!pauseTimer) {
      createTimerBar();
    }
  }

  var lastMouseY:Float = -1.0;

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    if (
      FlxG.mouse.x < paper.x ||
      FlxG.mouse.x > paper.x + paper.width
    ) {
      #if flash
      Mouse.cursor = MouseCursor.ARROW;
      #end
      if (FlxG.mouse.justPressed) {
        close();
        return;
      }
    } else {
      #if flash
      Mouse.cursor = MouseCursor.HAND;
      #end

      var targetY:Float = 0;
      var moved = false;

      if (FlxG.mouse.wheel != 0) {
        targetY = paper.y + FlxG.mouse.wheel * wheel_speed;
        moved = true;
      }

      else if (FlxG.mouse.pressed) {
        if (lastMouseY > 0) {
          targetY = paper.y + FlxG.mouse.y - lastMouseY;
          moved = true;
        }
        lastMouseY = FlxG.mouse.y;
      }

      else if (FlxG.mouse.justReleased) {
        lastMouseY = -1.0;
      }

      if (moved) {
        if (paper.frameWidth == 457) {paper.y = Math.min(Math.max(targetY, FlxG.height - paper.height + 80), 15);}
        else paper.y = Math.min(Math.max(targetY, FlxG.height - paper.height - 40), 40);
      }
    }

    var countdownSubstate = CountdownSubstate.check(elapsed);
    if (countdownSubstate != null) {
      openSubState(countdownSubstate);
    }
  }

  private function createTimerBar():Void {
    var timerBar = new TimerBar(10, 10);
    add(timerBar);
    timerBar.start();
    timerBar.alpha = 0;

    timerBar.completeCallback = handleTimerBarComplete;
  }


  function handleTimerBarComplete() {
    close();
  }
}

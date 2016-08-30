package;

import flixel.util.FlxAxes;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PaperSubstate extends FlxSubState {
  var wheel_speed = 5;
  var paper:FlxSprite;
  public function new(_paper:FlxSprite):Void {
    super();
    paper = _paper;

  }

  override public function create():Void {
    super.create();

    var background:FlxSprite = new FlxSprite(0, 0);
    background.makeGraphic(FlxG.width, FlxG.height, 0xff000000);
    background.alpha = 0.3;
    add(background);

    paper.screenCenter(FlxAxes.X);
    paper.y = 10;
    add(paper);
  }

  var lastMouseY:Float = -1.0;

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    if (
      FlxG.mouse.justPressed &&
      (
        FlxG.mouse.x < paper.x ||
        FlxG.mouse.x > paper.x + paper.width
      )
    ) {
      close();
      return;
    }

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
      paper.y = Math.min(Math.max(targetY, FlxG.height - paper.height - 10), 10);
    }
  }
}

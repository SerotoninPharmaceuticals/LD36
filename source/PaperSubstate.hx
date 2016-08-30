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
    }

    else if (FlxG.mouse.wheel != 0) {
      if (FlxG.mouse.wheel > 0) {
        if (paper.y < 0) {
          paper.y = Math.min(paper.y + FlxG.mouse.wheel * wheel_speed, 10);
        }
      } else {
        if (paper.y + paper.height > FlxG.height) {
          paper.y = Math.max(paper.y + FlxG.mouse.wheel * wheel_speed, FlxG.height - paper.height - 10);
        }
      }
    }

  }
}

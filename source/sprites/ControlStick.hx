package sprites;

import flixel.FlxG;
import flixel.FlxSprite;


class ControlStick extends FlxSprite {

  private var origX:Float;
  private var origY:Float;

  private static inline var DELTA = 10;


  public function new(X:Float=0.0, Y:Float=0.0) {
    super(X, Y);
    loadGraphic("assets/images/machine/joystick.png");
    origX = X;
    origY = Y;
  }

  public override function update(elapsed:Float):Void {
    var dx:Float = 0;
    var dy:Float = 0;
    if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) {
      dx = - DELTA;
    } else if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
      dx = DELTA;
    }

    if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W) {
      dy = - DELTA;
    } else if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) {
      dy = DELTA;
    }

    if (dx != 0 && dy != 0) {
      dx *= Math.sqrt(2)/2;
      dy *= Math.sqrt(2)/2;
    }

    x = origX + dx;
    y = origY + dy;

    super.update(elapsed);
  }
}

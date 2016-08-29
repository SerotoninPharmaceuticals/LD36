package sprites;

import flixel.FlxG;
import flixel.FlxSprite;


class ControlStick extends FlxSprite {

  private var origX:Float;
  private var origY:Float;

  private static inline var DELTA = 10;


  public override function new(X:Float=0.0, Y:Float=0.0) {
    super(X, Y);
    loadGraphic("assets/images/machine/joystick.png");
    origX = X;
    origY = Y;
  }

  public override function update(elapsed:Float):Void {
    if (y == origY && FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) {
      x = origX - DELTA;
    } else if (y == origY && FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
      x = origX + DELTA;
    } else if (x == origX && FlxG.keys.pressed.UP || FlxG.keys.pressed.W) {
      y = origY - DELTA;
    } else if (x == origX && FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) {
      y = origY + DELTA;
    } else {
      x = origX;
      y = origY;
    }
    super.update(elapsed);
  }
}

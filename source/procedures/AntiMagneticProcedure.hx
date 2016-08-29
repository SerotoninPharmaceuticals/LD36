package procedures;

import flash.globalization.CurrencyParseResult;
import ui.PercentageText;
import GameConfig;
import sprites.TechThing;
import sprites.Erasable;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class AntiMagneticProcedure extends FlxSpriteGroup {

  static var CURSOR_RADIUS = GameConfig.DEBUG ? 50 : 20;

  static inline var CURSOR_MOVE_LEFT = 0;
  static inline var CURSOR_MOVE_RIGHT = 1;
  static inline var CURSOR_MOVE_UP = 2;
  static inline var CURSOR_MOVE_DOWN = 3;
  static inline var CURSOR_MOVE_SPEED = 200;
  static inline var TAEGET_PERCENTAGE = 0.02;

  static inline var cursor_drop_per_sec = 10;
  static inline var cursor_min_r:Int = 4;
  static inline var cursor_gain_per_press:Int = 2;

  var erasableStep1:Erasable;

  var target:TechThing;
  var onFinsihed:Void->Void;

  var percentage:PercentageText;

  private var cursor:FlxSprite;
  private var cursorRadius:Float = CURSOR_RADIUS;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;

    percentage = new PercentageText(0, 0);
    add(percentage);

    createStep1();
  }

  override public function update(elapsed:Float):Void {

    if (erasableStep1 != null && erasableStep1.percentage < TAEGET_PERCENTAGE) {
      onFinsihed();
    }

    if (FlxG.keys.justPressed.X) {
      cursorRadius = Math.min(CURSOR_RADIUS, cursorRadius + cursor_gain_per_press);
    } else if(FlxG.keys.pressed.Z) {
      cursorRadius = Math.max(cursor_min_r, cursorRadius - cursor_drop_per_sec * elapsed);
    }
    changeCursorSize(Std.int(cursorRadius));

    var currentErasable:Erasable = erasableStep1;
    percentage.setPercentage(currentErasable.percentage);

    if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) {
      moveCursor(CURSOR_MOVE_LEFT, elapsed);
    }
    if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
      moveCursor(CURSOR_MOVE_RIGHT, elapsed);
    }
    if (FlxG.keys.pressed.UP || FlxG.keys.pressed.W) {
      moveCursor(CURSOR_MOVE_UP, elapsed);
    }
    if (FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) {
      moveCursor(CURSOR_MOVE_DOWN, elapsed);
    }

    currentErasable.eraseEnabled = FlxG.keys.pressed.Z;

    if (GameConfig.DEBUG) {
      // TEST, remove me!
//      cursor.x = FlxG.mouse.x;
//      cursor.y = FlxG.mouse.y;
      currentErasable.eraseEnabled = true;
    }

    currentErasable.brush.setPosition(cursor.x, cursor.y);
    currentErasable.update(elapsed);
    super.update(elapsed);
  }

  private function createCursor():Void {
    cursor = new FlxSprite();
    cursor.setPosition(MachineState.SCREEN_MAIN_WIDTH/2, MachineState.SCREEN_MAIN_HEIGHT/2);
    cursor.makeGraphic(2 * CURSOR_RADIUS, 2 * CURSOR_RADIUS, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(cursor, CURSOR_RADIUS, CURSOR_RADIUS, CURSOR_RADIUS, FlxColor.WHITE);
    add(cursor);
  }

  function createStep1():Void {
    erasableStep1 = new Erasable(
      MachineState.SCREEN_X, MachineState.SCREEN_Y,
      target.config.modeDBackImage,
      target.config.modeDFrontImage,
      CURSOR_RADIUS
    );
    for (i in 0...erasableStep1.length) {
      add(erasableStep1.members[i]);
    }

    createCursor();
  }

  function changeCursorSize(r:Int) {
    cursor.x = cursor.x + cursor.width/2 - r;
    cursor.y = cursor.y + cursor.height/2 - r;
    cursor.makeGraphic(2 * r, 2 * r, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(cursor, r, r, r, FlxColor.WHITE);

    erasableStep1.brush.setPosition(cursor.x, cursor.y);
    erasableStep1.brush.makeGraphic(2 * r, 2 * r, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(erasableStep1.brush, r, r, r, FlxColor.WHITE);
  }

  private function moveCursor(action:Int, elapsed:Float) {
    var movement = elapsed * CURSOR_MOVE_SPEED;
    switch(action) {
      case CURSOR_MOVE_UP:
        cursor.y -= movement;
      case CURSOR_MOVE_DOWN:
        cursor.y += movement;
      case CURSOR_MOVE_LEFT:
        cursor.x -= movement;
      case CURSOR_MOVE_RIGHT:
        cursor.x += movement;
    }

    if (cursor.x < MachineState.SCREEN_X) {
      cursor.x = MachineState.SCREEN_X;
    } else if (cursor.x > MachineState.SCREEN_X + MachineState.SCREEN_MAIN_WIDTH - cursor.width) {
      cursor.x = MachineState.SCREEN_X + MachineState.SCREEN_MAIN_WIDTH - cursor.width;
    }

    if (cursor.y < MachineState.SCREEN_Y) {
      cursor.y = MachineState.SCREEN_Y;
    } else if (cursor.y > MachineState.SCREEN_Y + MachineState.SCREEN_MAIN_HEIGHT - cursor.height) {
      cursor.y = MachineState.SCREEN_Y + MachineState.SCREEN_MAIN_HEIGHT - cursor.height;
    }
  }
}

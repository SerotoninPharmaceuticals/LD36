package procedures;

import libs.TimerUtil;
import flixel.util.FlxTimer;
import ui.CoordText;
import ui.DensityBarHoriz;
import ui.PressureBarHoriz;
import ui.TemperatureStatus;
import ui.SubTitleText;
import ui.TitleText;
import flixel.math.FlxPoint;
import ui.PercentageText;
import sprites.TechThing;
import sprites.Erasable;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class CleaningProcedure extends FlxSpriteGroup {

  static inline var CURSOR_RADIUS = GameConfig.DEBUG ? 50 : 10;

  static inline var CURSOR_MOVE_LEFT = 0;
  static inline var CURSOR_MOVE_RIGHT = 1;
  static inline var CURSOR_MOVE_UP = 2;
  static inline var CURSOR_MOVE_DOWN = 3;
  static inline var TAEGET_PERCENTAGE = 0.004;
  var CURSOR_MOVE_MAX_SPEED = GameConfig.CURSOR_MOVE_MAX_SPEED;
  var CURSOR_DRAG = GameConfig.CURSOR_DRAG;

  var erasableStep1:Erasable;

  var target:TechThing;
  var onFinsihed:Void->Void;

  var percentage:PercentageText;

  private var cursor:FlxSprite;

  var titleText:TitleText;
  var subtitleText:SubTitleText;

  var coordText:CoordText;

  var completed = false;
  var initialized = false;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;

    titleText = new TitleText("Mode.A.Step1");
    add(titleText);
    subtitleText = new SubTitleText("Surface Cleaning");
    add(subtitleText);

    add(new TemperatureStatus());
    add(new PressureBarHoriz(0, 1, 100, true));
    add(new DensityBarHoriz());


    TimerUtil.progressivelyLoad([
      function() {
        percentage = new PercentageText();
        add(percentage);
      },
      function() {
        coordText = new CoordText();
        add(coordText);
      },
      function() {
        createStep1();
      }
    ], MachineState.PROCEDURE_INIT_TIME);

    var timer = new FlxTimer();
    timer.start(MachineState.PROCEDURE_INIT_TIME, function(t:FlxTimer) {
      initialized = true;
    });
  }

  override public function update(elapsed:Float):Void {
    if (completed || !initialized || erasableStep1 == null) {
      return;
    }

    if (erasableStep1 != null && erasableStep1.percentage < TAEGET_PERCENTAGE) {
      completed = true;
      percentage.setPercentage(1);
      onFinsihed();
    }
    var currentErasable:Erasable = erasableStep1;

    percentage.setPercentage(1 - currentErasable.percentage);

    if (GameConfig.ENABLE_CURSOR_OBLIQUE) {
      var upOrDownPressed:Bool = (FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN ||
                                  FlxG.keys.pressed.S || FlxG.keys.pressed.W);
      if (cursor.velocity.y == 0 && !upOrDownPressed && FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) {
        moveCursor(CURSOR_MOVE_LEFT, elapsed);
      }
      if (cursor.velocity.y == 0 && !upOrDownPressed && FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
        moveCursor(CURSOR_MOVE_RIGHT, elapsed);
      }
      if (cursor.velocity.x == 0 && FlxG.keys.pressed.UP || FlxG.keys.pressed.W) {
        moveCursor(CURSOR_MOVE_UP, elapsed);
      }
      if (cursor.velocity.x == 0 && FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S) {
        moveCursor(CURSOR_MOVE_DOWN, elapsed);
      }
    } else {
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
    }

    limitCursor();

    currentErasable.eraseEnabled = FlxG.keys.pressed.Z;

    if (GameConfig.DEBUG) {
      // TEST, remove me!
      cursor.x = FlxG.mouse.x;
      cursor.y = FlxG.mouse.y;
      currentErasable.eraseEnabled = true;
    }

    coordText.setPos(cursor.x, cursor.y);

    currentErasable.brush.setPosition(cursor.x, cursor.y);
    currentErasable.update(elapsed);
    super.update(elapsed);
  }

  private function createCursor():Void {
    cursor = new FlxSprite();
    cursor.setPosition(MachineState.SCREEN_TECH_THING_CENTER_X_R - CURSOR_RADIUS, MachineState.SCREEN_TECH_THING_CENTER_Y_R - CURSOR_RADIUS);
    cursor.makeGraphic(2 * CURSOR_RADIUS, 2 * CURSOR_RADIUS, FlxColor.TRANSPARENT, true);

    FlxSpriteUtil.drawCircle(cursor, CURSOR_RADIUS, CURSOR_RADIUS, CURSOR_RADIUS, FlxColor.TRANSPARENT, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      pixelHinting: true,
      thickness: 2
    });

    cursor.drag = new FlxPoint(CURSOR_DRAG, CURSOR_DRAG);
    cursor.maxVelocity = new FlxPoint(CURSOR_MOVE_MAX_SPEED, CURSOR_MOVE_MAX_SPEED);
    add(cursor);
  }

  function createStep1():Void {
    erasableStep1 = new Erasable(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
      target.config.modeAStep1BackImage,
      target.config.modeAStep1FrontImage,
      CURSOR_RADIUS
    );
    for (i in 0...erasableStep1.length) {
      add(erasableStep1.members[i]);
    }

    createCursor();
  }

  private function moveCursor(action:Int, elapsed:Float) {
    switch(action) {
      case CURSOR_MOVE_UP:
        cursor.velocity.y = -CURSOR_MOVE_MAX_SPEED;
      case CURSOR_MOVE_DOWN:
        cursor.velocity.y = CURSOR_MOVE_MAX_SPEED;
      case CURSOR_MOVE_LEFT:
        cursor.velocity.x = -CURSOR_MOVE_MAX_SPEED;
      case CURSOR_MOVE_RIGHT:
        cursor.velocity.x = CURSOR_MOVE_MAX_SPEED;
    }
  }

  function limitCursor() {
    if (cursor.x <= MachineState.SCREEN_X) {
      cursor.x = MachineState.SCREEN_X;
      cursor.acceleration.x = 0;
      cursor.velocity.x = Math.max(0, cursor.velocity.x);
    } else if (cursor.x >= MachineState.SCREEN_X + MachineState.SCREEN_MAIN_WIDTH - cursor.width) {
      cursor.x = MachineState.SCREEN_X + MachineState.SCREEN_MAIN_WIDTH - cursor.width;
      cursor.acceleration.x = 0;
      cursor.velocity.x = Math.min(0, cursor.velocity.x);
    }

    if (cursor.y <= MachineState.SCREEN_Y) {
      cursor.y = MachineState.SCREEN_Y;
      cursor.acceleration.y = 0;
      cursor.velocity.y = Math.max(0, cursor.velocity.y);
    } else if (cursor.y >= MachineState.SCREEN_Y + MachineState.SCREEN_MAIN_HEIGHT - cursor.height) {
      cursor.y = MachineState.SCREEN_Y + MachineState.SCREEN_MAIN_HEIGHT - cursor.height;
      cursor.acceleration.y = 0;
      cursor.velocity.y = Math.min(0, cursor.velocity.y);
    }

  }
}

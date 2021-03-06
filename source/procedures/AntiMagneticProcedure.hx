package procedures;

import libs.TimerUtil;
import flixel.text.FlxText;
import sprites.Machine;
import flixel.util.FlxTimer;
import ui.CoordText;
import ui.DensityBarHoriz;
import ui.PressureBarHoriz;
import ui.TemperatureStatus;
import ui.TitleText;
import sprites.TechThing;
import flixel.math.FlxPoint;
import ui.PercentageText;
import GameConfig;
import sprites.Erasable;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.math.FlxMath;

class AntiMagneticProcedure extends FlxSpriteGroup {

  static var CURSOR_RADIUS = GameConfig.DEBUG ? 50 : 10;

  static inline var CURSOR_MOVE_LEFT = 0;
  static inline var CURSOR_MOVE_RIGHT = 1;
  static inline var CURSOR_MOVE_UP = 2;
  static inline var CURSOR_MOVE_DOWN = 3;
  static inline var TAEGET_PERCENTAGE = 0.004;
  var CURSOR_MOVE_MAX_SPEED = GameConfig.CURSOR_MOVE_MAX_SPEED;
  var CURSOR_DRAG = GameConfig.CURSOR_DRAG;

  static inline var cursor_drop_per_sec = 4;
  static inline var cursor_min_r:Int = 3;
  static inline var cursor_gain_per_press:Int = 1;

  var erasableStep1:Erasable;

  var target:TechThing;
  var onFinsihed:Void->Void;

  var percentage:PercentageText;
  var coordText:CoordText;
  
  private var spraySfx:FlxSound;

  private var cursor:FlxSprite;
  private var cursorRadius:Float = CURSOR_RADIUS;

  var completed = false;
  var initialized = false;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;

    add(new TitleText("Mode.D"));

    var temperatureStatus = new TemperatureStatus();
    add(temperatureStatus);
    add(new PressureBarHoriz(0, 1, 100, true));
    add(new DensityBarHoriz());
	
    spraySfx = FlxG.sound.load("assets/sounds/modeD.wav", 0.5, true);
    spraySfx.pan = -0.5;
	
    percentage = new PercentageText();
    add(percentage);
    coordText = new CoordText();
    add(coordText);
    createStep1();

	var progArray = [];
	for (i in 0...10){
	  progArray.push(function(){erasableStep1.thingyMask.scale.y -= 0.1;});
	}	
    TimerUtil.progressivelyLoad(progArray, MachineState.PROCEDURE_INIT_TIME);

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
      spraySfx.fadeOut(0.5);
      percentage.setPercentage(1);
      completed = true;
      onFinsihed();
    }

    if (FlxG.keys.justPressed.X) {
      cursorRadius = Math.min(CURSOR_RADIUS, cursorRadius + cursor_gain_per_press);
    } else if(FlxG.keys.pressed.Z) {
      cursorRadius = Math.max(cursor_min_r, cursorRadius - cursor_drop_per_sec * elapsed);
    }
    changeCursorSize(Std.int(cursorRadius));

    var currentErasable:Erasable = erasableStep1;
    percentage.setPercentage(1 - currentErasable.percentage);

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

    limitCursor();

    currentErasable.eraseEnabled = FlxG.keys.pressed.Z;
	
    if (FlxG.keys.justPressed.Z && erasableStep1.percentage > TAEGET_PERCENTAGE) spraySfx.play();
    else if (FlxG.keys.justReleased.Z) spraySfx.stop();
	
    spraySfx.volume = FlxMath.remapToRange(cursorRadius, cursor_min_r, CURSOR_RADIUS, 0.05, 0.5);
	
    if (GameConfig.DEBUG) {
      // TEST, remove me!
      cursor.x = FlxG.mouse.x;
      cursor.y = FlxG.mouse.y;
      currentErasable.eraseEnabled = true;
    }

    coordText.setPos(cursor.x, cursor.y);
	
    if (cursorRadius != cursor_min_r) {
      currentErasable.brush.setPosition(cursor.x, cursor.y);
      currentErasable.update(elapsed);
    }

    super.update(elapsed);
  }

  private function createCursor():Void {
    cursor = new FlxSprite();
    cursor.setPosition(MachineState.SCREEN_TECH_THING_CENTER_X_R - CURSOR_RADIUS, MachineState.SCREEN_TECH_THING_CENTER_Y_R - CURSOR_RADIUS);
    cursor.makeGraphic(2 * CURSOR_RADIUS, 2 * CURSOR_RADIUS, FlxColor.TRANSPARENT, true);

    FlxSpriteUtil.drawCircle(cursor, CURSOR_RADIUS, CURSOR_RADIUS, CURSOR_RADIUS - 1, FlxColor.TRANSPARENT, {
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
      target.config.modeDBackImage,
      target.config.modeDFrontImage,
      CURSOR_RADIUS, true
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
    FlxSpriteUtil.drawCircle(cursor, r, r, r - 1, FlxColor.TRANSPARENT, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      pixelHinting: true,
      thickness: 2
    });

    erasableStep1.brush.setPosition(cursor.x, cursor.y);
    erasableStep1.brush.makeGraphic(2 * r, 2 * r, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(erasableStep1.brush, r, r, r - 1, FlxColor.WHITE);
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

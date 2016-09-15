package procedures;

import ui.TemperatureStatus;
import sprites.Outline;
import ui.TitleText;
import ui.PressureBarHoriz;
import GameConfig;
import sprites.TechThing;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class VacuumPackingProcedure extends FlxSpriteGroup {

  static var CURSOR_RADIUS = GameConfig.DEBUG ? 50 : 10;

  static inline var CURSOR_MOVE_LEFT = 0;
  static inline var CURSOR_MOVE_RIGHT = 1;
  static inline var CURSOR_MOVE_UP = 2;
  static inline var CURSOR_MOVE_DOWN = 3;
  static inline var CURSOR_MOVE_MAX_SPEED = GameConfig.CURSOR_MOVE_MAX_SPEED;

  static inline var pressure_per_press = 10;
  static inline var target_pressure = 80;
  static inline var max_pressure = 120;
  static inline var pressure_drop_per_sec = 50;

  var moveEnabled = false;

  var target:TechThing;
  var onFinsihed:Void->Void;

  var anchors:Array<FlxSprite> = new Array<FlxSprite>();
  var anchorPoints:Array<Array<Float>>;
  var remainAnchorCounts = 6;

  var pressure:Float = 0;
  var pressureBar:PressureBarHoriz;

  private var cursor:FlxSprite;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;

    anchorPoints = [
      [0, 0], [1/2, 0], [1, 0],
      [0, 1], [1/2, 1], [1, 1]
    ];
    remainAnchorCounts = anchorPoints.length;

    add(new TitleText("Mode.E"));

    add(new TemperatureStatus());

    createStep1();
  }

  override public function update(elapsed:Float):Void {

    moveEnabled = pressure > target_pressure;

    if (FlxG.keys.justPressed.X) {
      pressure += pressure_per_press;
    } else {
      pressure -= pressure_drop_per_sec * elapsed;
    }
    pressure = Math.min(max_pressure, Math.max(0, pressure));
    trace(pressure);
    pressureBar.setValue(Std.int(pressure));

    if (moveEnabled) {
      if (GameConfig.ENABLE_CURSOR_OBLIQUE) {
        var upOrDownPressed:Bool = (FlxG.keys.pressed.UP || FlxG.keys.pressed.DOWN ||
                                    FlxG.keys.pressed.S || FlxG.keys.pressed.W);
        if (cursor.velocity.y == 0 && !upOrDownPressed && FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A) {
          moveCursor(CURSOR_MOVE_LEFT, elapsed);
        }
        if (cursor.velocity.y == 0 && upOrDownPressed && FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D) {
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
    }

    if (GameConfig.DEBUG) {
      cursor.x = FlxG.mouse.x;
      cursor.y = FlxG.mouse.y;
      moveEnabled = true;
    }

    detectAnchor();
    if (remainAnchorCounts == 0) {
      onFinsihed();
    }
  }

  private function createCursor():Void {
    cursor = new FlxSprite();
    cursor.setPosition(MachineState.SCREEN_MAIN_WIDTH/2, MachineState.SCREEN_MAIN_HEIGHT/2);
    cursor.makeGraphic(2 * CURSOR_RADIUS, 2 * CURSOR_RADIUS, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(cursor, CURSOR_RADIUS, CURSOR_RADIUS, CURSOR_RADIUS, FlxColor.TRANSPARENT, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      pixelHinting: true,
      thickness: 2
    });
    add(cursor);
  }

  function createAnchor(target:FlxSprite):Void {
    for(i in 0...anchorPoints.length) {
      var anchor = new FlxSprite();
      anchor.loadGraphic(GameConfig.IMAGE_PATH + "procedures/anchor.png");
      anchor.x = Std.int(target.x) + target.width * anchorPoints[i][0] - anchor.width / 2;
      anchor.y = Std.int(target.y) + target.height * anchorPoints[i][1] - anchor.height / 2;
      anchors.push(anchor);
      add(anchor);
    }
  }

  function createPressureBar() {
    pressureBar = new PressureBarHoriz(target_pressure, max_pressure, max_pressure);
    for (i in 0...pressureBar.length) {
      add(pressureBar.members[i]);
    }
  }

  function createRect(target:FlxSprite) {
    var rect = new FlxSprite(0, 0);
    rect.makeGraphic(MachineState.SCREEN_MAIN_WIDTH, MachineState.SCREEN_MAIN_HEIGHT, FlxColor.TRANSPARENT);
    FlxSpriteUtil.fill(rect, 0); // WHY???
    FlxSpriteUtil.drawRect(rect, Std.int(target.x) - 1, Std.int(target.y) - 1, target.width, target.height, FlxColor.TRANSPARENT, {
      color: GameConfig.SCREEN_COLOR_YELLOW1,
      pixelHinting: true
    });
    add(rect);
  }

  function createStep1():Void {
    var itemBody = new Outline(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
      target.config.modeEImage
    );
    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }

    createRect(itemBody.origin);
    createAnchor(itemBody.origin);
    createCursor();
    createPressureBar();
  }

  function detectAnchor() {
    for(i in 0...anchors.length) {
      var anchor = anchors[i];
      if (anchor.alive) {
        if (anchor.overlaps(cursor, true)) {
          anchor.kill();
          remainAnchorCounts -= 1;
        }
      }
    }
  }

  private function moveCursor(action:Int, elapsed:Float) {
    var movement = elapsed * CURSOR_MOVE_MAX_SPEED;
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

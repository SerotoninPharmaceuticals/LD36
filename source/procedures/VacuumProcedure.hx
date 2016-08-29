package procedures;

import flixel.addons.ui.AnchorPoint;
import GameConfig;
import sprites.TechThing;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

class VacuumProcedure extends FlxSpriteGroup {

  static var CURSOR_RADIUS = GameConfig.DEBUG ? 50 : 20;

  static inline var CURSOR_MOVE_LEFT = 0;
  static inline var CURSOR_MOVE_RIGHT = 1;
  static inline var CURSOR_MOVE_UP = 2;
  static inline var CURSOR_MOVE_DOWN = 3;
  static inline var CURSOR_MOVE_SPEED = 200;

  static inline var anchor_x = 40;
  static inline var anchor_y = 50;
  static inline var anchor_h_margin = 80;
  static inline var anchor_v_margin = 150;

  var moveEnabled = false;

  var target:TechThing;
  var onFinsihed:Void->Void;

  var anchors:Array<FlxSprite> = new Array<FlxSprite>();
  var anchorPoints:Array<Array<Int>>;
  var remainAnchorCounts = 6;

  private var cursor:FlxSprite;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;

    anchorPoints = [
      [0, 0], [anchor_h_margin, 0], [anchor_h_margin*2, 0],
      [0, anchor_v_margin], [anchor_h_margin, anchor_v_margin], [anchor_h_margin*2, anchor_v_margin]
    ];
    remainAnchorCounts = anchorPoints.length;

    createStep1();
  }

  override public function update(elapsed:Float):Void {

    moveEnabled = FlxG.keys.justPressed.X;

    if (moveEnabled) {
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

    if (GameConfig.DEBUG) {
      // TEST, remove me!
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
    FlxSpriteUtil.drawCircle(cursor, CURSOR_RADIUS, CURSOR_RADIUS, CURSOR_RADIUS, FlxColor.WHITE);
    add(cursor);
  }

  function createAnchor():Void {
    for(i in 0...anchorPoints.length) {
      var anchor = new FlxSprite(anchor_x + anchorPoints[i][0], anchor_y + anchorPoints[i][1]);
      anchor.makeGraphic(30, 30, FlxColor.YELLOW);
      anchors.push(anchor);
      add(anchor);
    }
  }

  function createStep1():Void {
    var itemBody = new FlxSprite();
    itemBody.loadGraphic(target.config.modeEImage);

    createAnchor();
    createCursor();
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

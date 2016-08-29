package procedures;

import sprites.TechThing;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;


class ElectroplatingProcedure extends FlxSpriteGroup {

  private var cursor:FlxSprite;
  private var sector:FlxSprite;
  private var validArea:FlxSprite;

  private static inline var MAX_DEG = 223;
  private static inline var CURSOR_MIN_DEG = 10;
  private static inline var VALID_AREA_DEG = 36.8699;
  private static inline var VALID_AREA_INIT_DEG = 26.5650;

  var target:TechThing;
  var onFinsihed:Void->Void;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;
    createSprites();
  }

  private function createSprites():Void {
    sector = new FlxSprite(10, 10);
    sector.loadGraphic("assets/images/procedures/densimeter_sector.png");
    validArea = new FlxSprite(10, 10);
    validArea.loadGraphic("assets/images/procedures/densimeter_valid_area.png");
    cursor = new FlxSprite(5, 5);
    cursor.loadGraphic("assets/images/procedures/densimeter_cursor.png");

    var itemBody = new FlxSprite(GameConfig.SCREEN_TECH_THING_X, GameConfig.SCREEN_TECH_THING_Y);
    itemBody.loadGraphic(target.config.modeCImage);
    add(itemBody);

    add(sector);
    add(validArea);
    add(cursor);
    cursor.angle = CURSOR_MIN_DEG;
  }

  override public function update(elapsed:Float):Void {
    if (FlxG.keys.pressed.Z) {
      if (cursor.angle < MAX_DEG) {
        cursor.angle += GameConfig.ELECTROP_PROC_CURSOR_INC_SPEED * elapsed;
      }
    } else {
      cursor.angle -= GameConfig.ELECTROP_PROC_CURSOR_DEC_SPEED * elapsed;
      if (cursor.angle < CURSOR_MIN_DEG) {
        cursor.angle = CURSOR_MIN_DEG;
      }
    }

    var validAreaStartDeg = validArea.angle + VALID_AREA_INIT_DEG;
    if (validAreaStartDeg >= MAX_DEG - VALID_AREA_DEG) {
      trace("Game finished.");
      onFinsihed();
    } else if (cursor.angle >= validAreaStartDeg &&
               cursor.angle <= validAreaStartDeg + VALID_AREA_DEG) {
      validArea.angle += GameConfig.ELECTROP_PROC_VALID_AREA_SPEED * elapsed;
    }

    super.update(elapsed);
  }

}

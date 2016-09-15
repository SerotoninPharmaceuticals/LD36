package procedures;

import ui.TemperatureStatus;
import ui.TemperatureStatus;
import sprites.Outline;
import flixel.text.FlxText;
import ui.TitleText;
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

  private static inline var DENSIMETER_X = 220;
  private static inline var DENSIMETER_Y = 140;

  var target:TechThing;
  var onFinsihed:Void->Void;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;

    var temperatureStatus = new TemperatureStatus();
    add(temperatureStatus);

    createSprites();

    add(new TitleText("Mode.C"));

  }

  private function createSprites():Void {
    sector = new FlxSprite(DENSIMETER_X, DENSIMETER_Y);
    sector.loadGraphic("assets/images/procedures/densimeter_sector.png");
    validArea = new FlxSprite(DENSIMETER_X, DENSIMETER_Y);
    validArea.loadGraphic("assets/images/procedures/densimeter_valid_area.png");
    cursor = new FlxSprite(DENSIMETER_X, DENSIMETER_Y);
    cursor.loadGraphic("assets/images/procedures/densimeter_cursor.png");

    var name = new FlxText(DENSIMETER_X - 50, DENSIMETER_Y + 100, 200, "Current Density");
    name.size = 15;
    name.color = GameConfig.SCREEN_COLOR_YELLOW0;
    add(name);


    var itemBody = new Outline(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
      target.config.modeEImage
    );
    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }

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

      if (GameConfig.DEBUG) {
        validArea.angle += 3 * GameConfig.ELECTROP_PROC_VALID_AREA_SPEED * elapsed;
      }

    }

    super.update(elapsed);
  }

}

package procedures;

import flixel.FlxSprite;
import sprites.TechThing;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;

import ui.TemperatureStatus;

class CoolingProcedure extends FlxSpriteGroup {

  static inline var SCREEN_TEMP_STATUS_X = 280;
  static inline var SCREEN_TEMP_STATUS_Y = 50;

  private var temperatureStatus:TemperatureStatus;
  private var timer:FlxTimer;
  private var isValid = false;

  private var currentTemp:Float = GameConfig.COOLING_PROC_INITIAL_TEMP;

  var target:TechThing;
  var onFinished:Void->Void;


  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinished = _onFinished;
    timer = new FlxTimer();
    setupScreen();

    var itemBody = new FlxSprite(GameConfig.SCREEN_TECH_THING_X, GameConfig.SCREEN_TECH_THING_Y);
    itemBody.loadGraphic(target.config.modeBStep1Image);
    add(itemBody);
  }

  override public function update(elapsed:Float):Void {
    if (currentTemp < GameConfig.COOLING_PROC_INITIAL_TEMP) {
      currentTemp += elapsed * GameConfig.COOLING_PROC_TEMP_INC_SPEED;
    }
    if (FlxG.keys.justPressed.Z) {
      currentTemp -= GameConfig.COOLING_PROC_TEMP_DEC;
    }
    temperatureStatus.setTemperature(currentTemp);
    if (currentTemp >= GameConfig.COOLING_PROC_LOWER_TEMP &&
        currentTemp <= GameConfig.COOLING_PROC_UPPER_TEMP &&
        !isValid) {
      temperatureStatus.setValid();
      timer.start(GameConfig.COOLING_PROC_TIMEOUT, onProcFinished);
    } else {
      temperatureStatus.setInvalid();
      if (isValid && (currentTemp < GameConfig.COOLING_PROC_LOWER_TEMP ||
                      currentTemp > GameConfig.COOLING_PROC_UPPER_TEMP)) {
        timer.cancel();
      }
    }
    super.update(elapsed);
  }

  public function onProcFinished(timer:FlxTimer) {
    trace("Game finished");
    onFinished();
  }

  private function setupScreen():Void {
    createTemperatureStatus();
  }

  private function createTemperatureStatus():Void {
    temperatureStatus = new TemperatureStatus(SCREEN_TEMP_STATUS_X, SCREEN_TEMP_STATUS_Y);
    add(temperatureStatus);
  }

}

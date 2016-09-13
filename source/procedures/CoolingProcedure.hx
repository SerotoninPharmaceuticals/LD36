package procedures;

import flixel.text.FlxText;
import sprites.Outline;
import ui.TitleText;
import sprites.TechThing;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxTimer;

import ui.TemperatureStatus;

class CoolingProcedure extends FlxSpriteGroup {

  private var temperatureStatus:TemperatureStatus;
  private var timer:FlxTimer;
  private var timerIsStarted:Bool = false;
  private var isValid = false;

  private var currentTemp:Float = GameConfig.COOLING_PROC_INITIAL_TEMP;

  var target:TechThing;
  var onFinished:Void->Void;

  var debugTime:FlxText;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinished = _onFinished;
    timer = new FlxTimer();
    setupScreen();

    var itemBody = new Outline(
      MachineState.SCREEN_X + GameConfig.SCREEN_TECH_THING_X, MachineState.SCREEN_Y + GameConfig.SCREEN_TECH_THING_Y,
      target.config.modeEImage
    );

    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }

    if (GameConfig.DEBUG) {
      debugTime = new FlxText(10, 200, 200, '');
      add(debugTime);
    }

    add(new TitleText("Mode.B"));
  }

  override public function update(elapsed:Float):Void {
    if (currentTemp < GameConfig.COOLING_PROC_INITIAL_TEMP) {
      currentTemp += elapsed * GameConfig.COOLING_PROC_TEMP_INC_SPEED;
    }
    if (FlxG.keys.justPressed.Z) {
      currentTemp -= GameConfig.COOLING_PROC_TEMP_DEC;
    }
    temperatureStatus.setTemperature(currentTemp);

    if (timerIsStarted) {
      if (
        currentTemp < GameConfig.COOLING_PROC_LOWER_TEMP ||
        currentTemp > GameConfig.COOLING_PROC_UPPER_TEMP
      ) {
        timer.cancel();
        timerIsStarted = false;
        temperatureStatus.setInvalid();
      }
    } else {
      if (
        currentTemp >= GameConfig.COOLING_PROC_LOWER_TEMP &&
        currentTemp <= GameConfig.COOLING_PROC_UPPER_TEMP
      ) {
        timer.start(GameConfig.COOLING_PROC_TIMEOUT, onProcFinished);
        timerIsStarted = true;
        temperatureStatus.setValid();
      }
    }

    if (debugTime != null) {
      debugTime.text = timer.timeLeft + '';
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
    temperatureStatus = new TemperatureStatus();
    add(temperatureStatus);
  }

}

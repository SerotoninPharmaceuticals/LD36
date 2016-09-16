package procedures;

import ui.CoordText;
import ui.DensityBarHoriz;
import ui.PressureBarHoriz;
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


  var target:TechThing;
  var onFinished:Void->Void;

  var debugTime:FlxText;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinished = _onFinished;
    timer = new FlxTimer();
    setupScreen();

    add(new PressureBarHoriz(0, 1, 100, true));
    add(new DensityBarHoriz());
    add(new CoordText());

    var itemBody = new Outline(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
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
    if (FlxG.keys.justPressed.Z) {
      temperatureStatus.setTemperature(temperatureStatus.currentTemp - GameConfig.COOLING_PROC_TEMP_DEC);
    }

    if (timerIsStarted) {
      if (
        temperatureStatus.currentTemp < GameConfig.COOLING_PROC_LOWER_TEMP ||
        temperatureStatus.currentTemp > GameConfig.COOLING_PROC_UPPER_TEMP
      ) {
        timer.cancel();
        timerIsStarted = false;
        temperatureStatus.setInvalid();
      }
    } else {
      if (
        temperatureStatus.currentTemp >= GameConfig.COOLING_PROC_LOWER_TEMP &&
        temperatureStatus.currentTemp <= GameConfig.COOLING_PROC_UPPER_TEMP
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

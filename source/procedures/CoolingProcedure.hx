package procedures;

import flixel.util.FlxTimer;
import ui.SubTitleText;
import ui.PercentageText;
import ui.CoordText;
import ui.DensityBarHoriz;
import ui.PressureBarHoriz;
import sprites.Outline;
import ui.TitleText;
import sprites.TechThing;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;

import ui.TemperatureStatus;

class CoolingProcedure extends FlxSpriteGroup {

  private var temperatureStatus:TemperatureStatus;
  private var isValid = false;

  var percentage:Float = 0;
  var percentageText:PercentageText;

  var target:TechThing;
  var onFinished:Void->Void;

  var completed = false;
  var initialized = false;
  var itemBody:Outline;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinished = _onFinished;
    setupScreen();

    add(new PressureBarHoriz(0, 1, 100, true));
    add(new DensityBarHoriz());
    add(new CoordText());

    percentageText = new PercentageText();
    add(percentageText);

    itemBody = new Outline(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
      target.config.modeEImage
    );

    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }
    itemBody.origin.alpha = 0;


    add(new TitleText("Mode.B.Step1"));
    add(new SubTitleText("Flash Freezing"));

    var timer = new FlxTimer();
    timer.start(MachineState.PROCEDURE_INIT_TIME, function(t:FlxTimer) {
      initialized = true;
    });
  }

  override public function update(elapsed:Float):Void {
    if (completed || !initialized) {
      return;
    }

    if (FlxG.keys.justPressed.Z) {
      temperatureStatus.setTemperature(temperatureStatus.currentTemp - GameConfig.COOLING_PROC_TEMP_DEC);
    }

    if (
      temperatureStatus.currentTemp < GameConfig.COOLING_PROC_LOWER_TEMP ||
      temperatureStatus.currentTemp > GameConfig.COOLING_PROC_UPPER_TEMP
    ) {
      temperatureStatus.setInvalid();
      percentage -= 0.08 * elapsed;
    } else {
      temperatureStatus.setValid();
      percentage += 0.1 * elapsed;
    }

    percentage = Math.min(1, Math.max(0, percentage));
    percentageText.setPercentage(percentage);
    itemBody.origin.alpha = percentage;

    super.update(elapsed);

    if (percentage >= 1) {
      completed = true;
      onFinished();
    }
  }

  private function setupScreen():Void {
    createTemperatureStatus();
  }

  private function createTemperatureStatus():Void {
    temperatureStatus = new TemperatureStatus();
    add(temperatureStatus);
  }

}

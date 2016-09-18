package procedures;

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

class VacuumDryingProcedure extends FlxSpriteGroup {

  private var temperatureStatus:TemperatureStatus;
  private var isValid = false;

  var percentage:Float = 0;
  var percentageText:PercentageText;

  var pressure_target_start = 13;
  var pressure_target_width = 15;
  var pressure_total = 100;
  var pressureBar:PressureBarHoriz;
  var pressure:Float = 60;
  var moving_speed = 20;
  var autorunTimeRemain:Float = 0;
  var autorunSpeed:Float = 1;

  var target:TechThing;
  var onFinished:Void->Void;

  var completed = false;
  var initialized = true;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinished = _onFinished;
    setupScreen();

    add(new DensityBarHoriz());
    add(new CoordText());

    pressureBar = new PressureBarHoriz(pressure_target_start, pressure_target_width, pressure_total, false);
    add(pressureBar);

    percentageText = new PercentageText();
    add(percentageText);

    var itemBody = new Outline(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
      target.config.modeEImage
    );

    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }


    add(new TitleText("Mode.B.Step2"));
    add(new SubTitleText("Vacuum Drying"));
  }


  override public function update(elapsed:Float):Void {
    if (!initialized || completed) { return; }

    if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.LEFT) {
      pressure += elapsed * moving_speed * (FlxG.keys.pressed.RIGHT ? 1 : -1);
    } else {
      if (autorunTimeRemain <= 0) {
        autorunTimeRemain = Math.random() * 2 + 0.5;
        autorunSpeed = Math.random() * 30 * (autorunSpeed > 0 ? -1 : 1);
      }
      pressure += autorunSpeed * elapsed;
      autorunTimeRemain -= elapsed;
    }

    pressure = Math.min(pressure_total, Math.max(0, pressure));
    pressureBar.setValue(pressure);

    var inTarget = pressure < pressure_target_start + pressure_target_width && pressure > pressure_target_start;

    if (inTarget && FlxG.keys.justPressed.X) {
      temperatureStatus.setTemperature(temperatureStatus.currentTemp + GameConfig.DRYING_PROC_TEMP_GAIN);
    }

    if (
      temperatureStatus.currentTemp < GameConfig.DRYING_PROC_LOWER_TEMP ||
      temperatureStatus.currentTemp > GameConfig.DRYING_PROC_UPPER_TEMP
    ) {
      temperatureStatus.setInvalid();
      percentage -= 0.08 * elapsed;
    } else {
      temperatureStatus.setValid();
      percentage += 0.1 * elapsed;
    }

    percentage = Math.min(1, Math.max(0, percentage));
    percentageText.setPercentage(percentage);

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

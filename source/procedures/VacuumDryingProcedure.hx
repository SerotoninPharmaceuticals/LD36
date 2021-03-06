package procedures;

import libs.TimerUtil;
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
  var initialized = false;

  var itemBody:Outline;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinished = _onFinished;
    setupScreen();

    add(new DensityBarHoriz());

    pressureBar = new PressureBarHoriz(pressure_target_start, pressure_target_width, pressure_total, false);
    add(pressureBar);

    itemBody = new Outline(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
      target.config.modeEImage
    );

    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }

    add(new TitleText("Mode.B.Step2"));
    add(new SubTitleText("Vacuum Drying"));

    percentageText = new PercentageText();
    add(percentageText);
    add(new CoordText());
	
    itemBody = new Outline(
    MachineState.SCREEN_TECH_THING_CENTER_X,
    MachineState.SCREEN_TECH_THING_CENTER_Y,
    target.config.modeEImage
    );

    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }
    itemBody.origin.alpha = 0;

    var progArray = [];
    for (i in 0...10){
      progArray.push(function(){itemBody.thingyMask.scale.y -= 0.1;});
    }	
    TimerUtil.progressivelyLoad(progArray, MachineState.PROCEDURE_INIT_TIME);

    var timer = new FlxTimer();
    timer.start(MachineState.PROCEDURE_INIT_TIME, function(t:FlxTimer) {
      initialized = true;
    });
  }


  override public function update(elapsed:Float):Void {
    if (!initialized || completed || itemBody == null) { return; }

    if (FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.LEFT) {
      pressure += elapsed * moving_speed * (FlxG.keys.pressed.RIGHT ? 1 : -1);
    } else {
      if (autorunTimeRemain <= 0) {
        autorunTimeRemain = 0.35 + Math.random() * 1.25 ;
        autorunSpeed = (5 + Math.random() * 25) * (autorunSpeed > 0 ? -1 : 1);
      }
      pressure += autorunSpeed * elapsed;
      autorunTimeRemain -= elapsed;
    }

    pressure = Math.min(pressure_total, Math.max(0, pressure));
    pressureBar.setValue(pressure);

    var inTarget = pressure < pressure_target_start + pressure_target_width && pressure > pressure_target_start;

    if (inTarget){
	  pressureBar.setValid();	
      if(FlxG.keys.justPressed.X) temperatureStatus.setTemperature(temperatureStatus.currentTemp + GameConfig.DRYING_PROC_TEMP_GAIN);
    }else pressureBar.setInvalid();	

    if (
      temperatureStatus.currentTemp < GameConfig.DRYING_PROC_LOWER_TEMP ||
      temperatureStatus.currentTemp > GameConfig.DRYING_PROC_UPPER_TEMP
    ) {
      temperatureStatus.setInvalid();
    } else {
      temperatureStatus.setValid();
      percentage += 1 / 15 * elapsed;
    }

    percentage = Math.min(1, Math.max(0, percentage));
    percentageText.setPercentage(percentage);
    itemBody.origin.alpha = 1 - percentage;

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

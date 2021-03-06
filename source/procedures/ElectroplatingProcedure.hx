package procedures;

import libs.TimerUtil;
import flixel.util.FlxTimer;
import ui.CoordText;
import ui.PercentageText;
import ui.DensityBarHoriz;
import ui.PressureBarHoriz;
import ui.TemperatureStatus;
import sprites.Outline;
import flixel.text.FlxText;
import ui.TitleText;
import sprites.TechThing;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;


class ElectroplatingProcedure extends FlxSpriteGroup {

  private var validArea:FlxSprite;

  var target:TechThing;
  var onFinsihed:Void->Void;

  static inline var density_gain_per_sec = 28;
  static inline var density_drop_per_sec = 50;
  static inline var max_density = 100;

  static inline var target_gain_per_sec = 10;
  static inline var target_drop_per_sec = 20;
  static inline var target_width = 10;
  static inline var target_limit = 75;
  static inline var target_min = 10;

  var density:Float = 0;
  var targetValue:Float = target_min;
  var percentage:Float = 0;

  var densityBar:DensityBarHoriz;
  var percentageText:PercentageText;

  var elecSfx:FlxSound;
  
  var completed = false;
  var initialized = false;

  var itemBody:Outline;

  public function new(_target:TechThing, _onFinished) {
    super();
    target = _target;
    onFinsihed = _onFinished;

    var temperatureStatus = new TemperatureStatus();
    add(temperatureStatus);

    add(new PressureBarHoriz(0, 1, 100, true));

    densityBar = new DensityBarHoriz(target_min, target_width, target_limit, max_density, false);
    add(densityBar);

    createSprites();

    add(new TitleText("Mode.C"));
    percentageText = new PercentageText();
    add(percentageText);
    add(new CoordText());
	
    elecSfx = FlxG.sound.load("assets/sounds/modeC.wav", 0.85, true);
    elecSfx.pan = -0.35;
    elecSfx.volume = 0.25;
    elecSfx.play();

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
  var text:FlxText;

  private function createSprites():Void {
    itemBody = new Outline(
      MachineState.SCREEN_TECH_THING_CENTER_X,
      MachineState.SCREEN_TECH_THING_CENTER_Y,
      target.config.modeEImage
    );
    for (i in 0...itemBody.length) {
      add(itemBody.members[i]);
    }
  }

  override public function update(elapsed:Float):Void {
    if (completed || !initialized || itemBody == null) {
      return;
    }

    if (FlxG.keys.pressed.Z) {
      density += density_gain_per_sec * elapsed;
    } else {
      density -= density_drop_per_sec * elapsed;
    }
    density = Math.min(max_density, Math.max(0, density));

    if (density >= targetValue && density <= targetValue + target_width) {
      targetValue += target_gain_per_sec * elapsed;
      if (targetValue >= target_limit) {
        densityBar.setValid();  
        percentage += 1 / 12 * elapsed;
        if(elecSfx.volume < 0.85) elecSfx.volume += 1 * elapsed;
      }
    } else {
      densityBar.setInvalid();	
      targetValue -= target_drop_per_sec * elapsed;
      if(elecSfx.volume > 0.25) elecSfx.volume -= 2 * elapsed;
    }
    targetValue = Math.min(target_limit, Math.max(target_min, targetValue));

    densityBar.setValue(density);
    densityBar.setTargetValue(targetValue);

    if (percentage >= 1) {
      elecSfx.fadeOut(0.5);
      percentageText.setPercentage(1);
      completed = true;
      onFinsihed();
    }

    percentageText.setPercentage(percentage);

    super.update(elapsed);
  }

}

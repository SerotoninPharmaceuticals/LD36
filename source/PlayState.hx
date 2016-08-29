package;

import ui.TimerBar;
import flixel.FlxSprite;
import sprites.Paper;
import sprites.Coffin;
import sprites.Machine;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import sprites.TechThing;
import openfl.geom.Point;
import flixel.FlxState;


class PlayState extends FlxState {
  var deckPoint:Point = new Point(450, 50); // top left point
  var deckMarginH:Float = 50.0; // actually origin to origin distance.
  var deckMarginV:Float = 90.0; // as above.

  var machinePoint:Point = new Point(20, 100);

  var papersPoint:Point = new Point(10, 10);

  // Sprites
  var techThingGroup:FlxTypedSpriteGroup<TechThing>;
  var machine:Machine;
  var coffin:Coffin;

  var timerBar:TimerBar;

  override public function create():Void {
    super.create();
    loadMachine();
    loadCoffin();
    loadTechObjects();

    loadPapers();

    createTimerBar();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  function loadTechObjects():Void {
    techThingGroup = new FlxTypedSpriteGroup<TechThing>(0, 0, 10);
    for(i in 0...GameConfig.techThingConfigs.length) {
      var config = GameConfig.techThingConfigs[i];

      config.modeAStep1FrontImage = "assets/images/" + config.codeName + "_mode_a_step1_front.png";
      config.modeAStep1BackImage = "assets/images/" + config.codeName + "_mode_a_step1_back.png";
      config.modeAStep2FrontImage = "assets/images/" + config.codeName + "_mode_a_step2_front.png";
      config.modeAStep2BackImage = "assets/images/" + config.codeName + "_mode_a_step2_back.png";

      config.modeBStep1Image = "assets/images/" + config.codeName + "_mode_b_step1.png";
      config.modeBStep2Image = "assets/images/" + config.codeName + "_mode_b_step2.png";

      config.modeCImage = "assets/images/" + config.codeName + "_mode_c.png";

      config.modeDFrontImage = "assets/images/" + config.codeName + "_mode_d_front.png";
      config.modeDBackImage = "assets/images/" + config.codeName + "_mode_d_back.png";

      config.modeEImage = "assets/images/" + config.codeName + "_mode_e.png";

      var item = new TechThing(deckPoint.x + config.x, deckPoint.y + config.y, machine, coffin.body);
      item.config = config;
      item.procedures = config.procedureTypes;
      techThingGroup.add(item);
    }
    add(techThingGroup);
  }

  function loadMachine():Void {
    machine = new Machine(20, 100, handleBeginProcedures);
    add(machine);
  }
  function handleBeginProcedures(techThing:TechThing) {
    timerBar.kill();
    var machineState = new MachineState(techThing);
    machineState.closeCallback = handleMachineFinish;
    openSubState(machineState);
  }
  function handleMachineFinish() {
    timerBar.forceUpdateTime();
    timerBar.revive();
    machine.startFinishProcess();
  }

  function loadCoffin() {
    coffin = new Coffin(450, 250);
    add(coffin);
  }

  function loadPapers() {
    for(i in 0...6) {
      add(new Paper(papersPoint.x + i*30, papersPoint.y, "assets/images/paper_small.png", "assets/images/paper.png", handleOpenPaper));
    }
    // Manual
    add(new Paper(20, 200, "assets/images/paper_small.png", "assets/images/manual.png", handleOpenPaper));
  }
  function handleOpenPaper(paper:FlxSprite) {
    openSubState(new PaperSubstate(paper));
  }

  private function createTimerBar():Void {
    timerBar = new TimerBar(0, 0, 150);
    add(timerBar);
    timerBar.start();
  }
}

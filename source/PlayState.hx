package;

#if flash
import flixel.FlxSprite;
import flash.display.Sprite;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
#end

import ui.TimerBar;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import sprites.Paper;
import sprites.Coffin;
import sprites.Machine;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import sprites.TechThing;
import openfl.geom.Point;
import flixel.FlxState;
import flixel.system.FlxSound;


class PlayState extends FlxState {
  var deckPoint:Point = new Point(300, 35); // top left point

  var machinePoint:Point = new Point(20, 100);
  var machineSound:FlxSound;

  var papersPoint:Point = new Point(10, 10);

  // Sprites
  var techThingGroup:FlxTypedSpriteGroup<TechThing>;
  var machine:Machine;
  var coffin:Coffin;

  var timerBar:TimerBar;

  override public function create():Void {
    super.create();
    FlxG.mouse.useSystemCursor = true;


    var bg = new FlxSprite();
    bg.loadGraphic("assets/images/bg.png");
    add(bg);

    loadCoffin();

    loadPapers();

    loadMachine();

    loadTechObjects();
    loadFrontPapers();

    createTimerBar();

    FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
    machineSound = FlxG.sound.load("assets/sounds/machine.wav", 0.5, true);
    machineSound.pan = -0.5;
    machineSound.play();
  }

  override public function update(elapsed:Float):Void {
    #if flash
    Mouse.cursor = MouseCursor.ARROW;
    #end

    if (GameConfig.DEBUG && FlxG.keys.justPressed.ENTER) {
      timerBar.onComplete(null);
    }
    super.update(elapsed);
  }

  function loadTechObjects():Void {
    var gunSupport = new FlxSprite(deckPoint.x + 286, deckPoint.y + 54);
    gunSupport.loadGraphic(GameConfig.TECHTHINGS_PATH + "gun_support.png");
    add(gunSupport);

    techThingGroup = new FlxTypedSpriteGroup<TechThing>(0, 0);
    for(i in 0...GameConfig.techThingConfigs.length) {
      var config = GameConfig.techThingConfigs[i];

      config.image = GameConfig.TECHTHINGS_PATH + config.codeName + ".png";
      config.imageAfter = GameConfig.TECHTHINGS_PATH + config.codeName + "_after.png";

      config.modeAStep1FrontImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_a_step1_front.png";
      config.modeAStep1BackImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_a_step1_back.png";
      config.modeAStep2FrontImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_a_step2_front.png";
      config.modeAStep2BackImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_a_step2_back.png";

      config.modeBStep1Image = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_b_step1.png";
      config.modeBStep2Image = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_b_step2.png";

      config.modeCImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_c.png";

      config.modeDFrontImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_d_front.png";
      config.modeDBackImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_d_back.png";

      config.modeEImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_e.png";

      var item = new TechThing(deckPoint.x + config.x, deckPoint.y + config.y, machine, coffin.body, config);
      item.procedures = config.procedureTypes;
      techThingGroup.add(item);
    }

    add(techThingGroup);

    var brainJar = new FlxSprite(deckPoint.x + 66, deckPoint.y - 3);
    brainJar.loadGraphic(GameConfig.TECHTHINGS_PATH + "brain_jar.png");
    brainJar.alpha = 0.8;
    add(brainJar);
  }

  function loadMachine():Void {
    machine = new Machine(20, 100, handleBeginProcedures);
    add(machine);
  }
  function handleBeginProcedures(techThing:TechThing) {
    timerBar.kill();
    var machineState = new MachineState(techThing);
    machineState.closeCallback = handleMachineFinish;
    machineSound.pan = 0;
    machineSound.volume = 1;
    openSubState(machineState);
  }
  function handleMachineFinish() {
    timerBar.forceUpdateTime();
    timerBar.revive();
    machineSound.pan = -0.5;
    machineSound.volume = 0.5;
    machine.startFinishProcess();
  }

  function loadCoffin() {
    coffin = new Coffin(428, 240);
    add(coffin);
  }

  function loadPapers() {
    for(i in 0...6) {
      add(new Paper(papersPoint.x + i*30, papersPoint.y, "assets/images/paper_small.png", "assets/images/paper.png", handleOpenPaper));
    }

    add(new Paper(305, 102, "assets/images/tech_thing_papers/note_1_sphere_small.png",
                  "assets/images/tech_thing_papers/note_1_sphere.png", handleOpenPaper));
    add(new Paper(370, 106, "assets/images/tech_thing_papers/note_2_brain_small.png",
                  "assets/images/tech_thing_papers/note_2_brain.png", handleOpenPaper));
    add(new Paper(408, 193, "assets/images/tech_thing_papers/note_6_bible_small.png",
                  "assets/images/tech_thing_papers/note_6_bible.png", handleOpenPaper));
    add(new Paper(454, 191, "assets/images/tech_thing_papers/note_7_cola_small.png",
                  "assets/images/tech_thing_papers/note_7_cola.png", handleOpenPaper));
    add(new Paper(523, 188, "assets/images/tech_thing_papers/note_8_gold_small.png",
                  "assets/images/tech_thing_papers/note_8_gold.png", handleOpenPaper));
    add(new Paper(582, 193, "assets/images/tech_thing_papers/note_9_phone_small.png",
                  "assets/images/tech_thing_papers/note_9_phone.png", handleOpenPaper));
    add(new Paper(663, 191, "assets/images/tech_thing_papers/note_10_farewell_small.png",
                  "assets/images/tech_thing_papers/note_10_farewell.png", handleOpenPaper));
    add(new Paper(710, 195, "assets/images/tech_thing_papers/note_11_bonsai_small.png",
                  "assets/images/tech_thing_papers/note_11_bonsai.png", handleOpenPaper));
    // Manual
    add(new Paper(174, 262, "assets/images/manual_small.png", "assets/images/manual.png", handleOpenPaper));
  }

  function loadFrontPapers() {
    add(new Paper(443, 104, "assets/images/tech_thing_papers/note_3_internet_small.png",
                  "assets/images/tech_thing_papers/note_3_internet.png", handleOpenPaper));
    add(new Paper(538, 106, "assets/images/tech_thing_papers/note_4_david_small.png",
                  "assets/images/tech_thing_papers/note_4_david.png", handleOpenPaper));
    add(new Paper(602, 105, "assets/images/tech_thing_papers/note_5_pistol_small.png",
                  "assets/images/tech_thing_papers/note_5_pistol.png", handleOpenPaper));
  }

  function handleOpenPaper(paper:FlxSprite) {
    openSubState(new PaperSubstate(paper));
  }

  private function createTimerBar():Void {
    timerBar = new TimerBar(670, 25, 160);
    add(timerBar);
    timerBar.start();
  }
}

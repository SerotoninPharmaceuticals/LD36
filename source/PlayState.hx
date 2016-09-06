package;

import flixel.addons.plugin.FlxMouseControl;
import openfl.Assets;
import flixel.FlxSprite;
import ui.TimerBar;
import flixel.FlxG;
import flixel.util.FlxColor;
import sprites.Paper;
import sprites.Coffin;
import sprites.Machine;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import sprites.TechThing;
import openfl.geom.Point;
import flixel.FlxState;
import flixel.system.FlxSound;

#if flash
import flash.ui.Mouse;
import flash.ui.MouseCursor;
#end


class PlayState extends FlxState {
  var deckPoint:Point = new Point(300, 35); // top left point

  var machinePoint:Point = new Point(20, 100);
  var machineSound:FlxSound;

  var papersPoint:Point = new Point(40, 10);

  // Sprites
  var techThingGroup:FlxTypedSpriteGroup<TechThing>;
  var techThingFrontGroup:FlxTypedSpriteGroup<TechThing>;
  var machine:Machine;
  var coffin:Coffin;

  var timerBar:TimerBar;

  var mouseControl:FlxMouseControl = new FlxMouseControl();

  override public function create():Void {
    super.create();
    FlxG.mouse.useSystemCursor = true;

    FlxG.plugins.add(mouseControl);

    var bg = new FlxSprite();
    bg.loadGraphic("assets/images/bg.png");
    add(bg);

    loadCoffin();

    loadPapers();

    loadMachine();

    loadTechObjects();
    loadFrontPapers();

    techThingFrontGroup = new FlxTypedSpriteGroup<TechThing>(0, 0);
    add(techThingFrontGroup);

    createTimerBar();

    FlxG.camera.fade(FlxColor.BLACK, 0.5, true);
    machineSound = FlxG.sound.load("assets/sounds/machine.wav", 0.5, true);
    machineSound.pan = -0.5;
    machineSound.play();
  }


  override public function update(elapsed:Float):Void {
    #if flash
    if (GameData.dragHoverCount > 0) {
      Mouse.cursor = MouseCursor.HAND;
    } else if (GameData.hoverCount > 0) {
      Mouse.cursor = MouseCursor.BUTTON;
    } else {
      Mouse.cursor = MouseCursor.ARROW;

      GameData.dragHoverCount = Std.int(Math.max(0, GameData.dragHoverCount));
      GameData.hoverCount = Std.int(Math.max(0, GameData.hoverCount));
    }
    #end

    // Moving dragging tech thing to front.
    if (
      FlxMouseControl.isDragging &&
      Type.getClass(FlxMouseControl.dragTarget) == TechThing &&
      techThingFrontGroup.length == 0
    ) {
      techThingFrontGroup.add(techThingGroup.remove(cast(FlxMouseControl.dragTarget, TechThing)));
    }

    // Moving the just draged tech thing back.
    if (
      !FlxMouseControl.isDragging &&
      techThingFrontGroup.length > 0
    ) {
      techThingFrontGroup.forEach(function(techThing:TechThing) {
        techThingGroup.add(techThing);
      });
      techThingFrontGroup.clear();
    }

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

      if (Assets.exists(GameConfig.TECHTHINGS_PATH + config.codeName + "_hitbox.png")) {
        config.imageHitbox = GameConfig.TECHTHINGS_PATH + config.codeName + "_hitbox.png";
      }

      config.modeAStep1FrontImage = "assets/images/pattern1.png";
      config.modeAStep1BackImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_back.png";
      config.modeAStep2FrontImage = "assets/images/pattern2.png";
      config.modeAStep2BackImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_back.png";

      config.modeBStep1Image = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_back.png";
      config.modeBStep2Image = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_back.png";

      config.modeCImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_back.png";

      config.modeDFrontImage = "assets/images/pattern3.png";
      config.modeDBackImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_back.png";

      config.modeEImage = GameConfig.TECHTHINGS_PATH + config.codeName + "_mode_back.png";

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
    add(new Paper(305, 102, "tech_thing_papers/note_1_sphere", handleOpenPaper));
    add(new Paper(370, 106, "tech_thing_papers/note_2_brain", handleOpenPaper));
    add(new Paper(408, 193, "tech_thing_papers/note_6_bible", handleOpenPaper));
    add(new Paper(454, 191, "tech_thing_papers/note_7_cola", handleOpenPaper));
    add(new Paper(523, 188, "tech_thing_papers/note_8_gold", handleOpenPaper));
    add(new Paper(582, 193, "tech_thing_papers/note_9_phone", handleOpenPaper));
    add(new Paper(663, 191, "tech_thing_papers/note_10_farewell", handleOpenPaper));
    add(new Paper(710, 195, "tech_thing_papers/note_11_bonsai", handleOpenPaper));
    // Manual
    add(new Paper(170, 255, "manual", handleOpenPaper));
  }

  function loadFrontPapers() {
    add(new Paper(443, 104, "tech_thing_papers/note_3_internet", handleOpenPaper));
    add(new Paper(538, 106, "tech_thing_papers/note_4_david", handleOpenPaper));
    add(new Paper(602, 105, "tech_thing_papers/note_5_pistol", handleOpenPaper));
  }

  function handleOpenPaper(paper:FlxSprite, onClose:Void->Void) {
    var substate:PaperSubstate = new PaperSubstate(paper);
    substate.closeCallback = function () {
      timerBar.start();
      onClose();
    }
    timerBar.pause();
    openSubState(substate);
  }

  private function createTimerBar():Void {
    timerBar = new TimerBar(674, 15, 160);
    add(timerBar);
    timerBar.start();
  }
}

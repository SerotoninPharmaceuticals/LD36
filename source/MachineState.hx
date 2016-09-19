package;

#if flash
import procedures.GrammaRay;
import flash.ui.MouseCursor;
import flash.ui.Mouse;
#end

import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
import procedures.VacuumDryingProcedure;
import procedures.VacuumPackingProcedure;
import procedures.AntiMagneticProcedure;
import GameConfig.ProcedureType;
import procedures.ElectroplatingProcedure;
import sprites.TechThing;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

import procedures.CoolingProcedure;
import procedures.CleaningProcedure;
import sprites.ControlStick;
import ui.ScreenMenu;
import ui.TimerBar;

class MachineState extends FlxSubState {
  public static inline var SCREEN_X = 201;
  public static inline var SCREEN_Y = 51;
  public static inline var SCREEN_WIDTH = 466;
  public static inline var SCREEN_HEIGHT = 276;

  public static var SCREEN_MENU_X = SCREEN_WIDTH - ScreenMenu.SCREEN_MENU_WIDTH;
  public static var SCREEN_MENU_Y = 2;

  public static var SCREEN_DASHBOARD_X = 0;
  public static var SCREEN_DASHBOARD_Y = 201;

  public static var SCREEN_MAIN_WIDTH = SCREEN_MENU_X; // in where cursor moves.
  public static var SCREEN_MAIN_HEIGHT = SCREEN_DASHBOARD_Y;

  public static var SCREEN_TECH_THING_CENTER_X_R = MachineState.SCREEN_MAIN_WIDTH/2;
  public static var SCREEN_TECH_THING_CENTER_Y_R = MachineState.SCREEN_MAIN_HEIGHT/2 + 6;
  public static var SCREEN_TECH_THING_CENTER_X = MachineState.SCREEN_X + SCREEN_TECH_THING_CENTER_X_R;
  public static var SCREEN_TECH_THING_CENTER_Y = MachineState.SCREEN_Y + SCREEN_TECH_THING_CENTER_Y_R;


  public static var X_KEY_IMAGE = "assets/images/machine/x.png";
  public static var X_KEY_DOWN_IMAGE = "assets/images/machine/x_down.png";
  public static var Z_KEY_IMAGE = "assets/images/machine/z.png";
  public static var Z_KEY_DOWN_IMAGE = "assets/images/machine/z_down.png";

  public static var LIGHT_OFF_IMAGE = "assets/images/machine/lightoff.png";
  public static var LIGHT_ON_IMAGE = "assets/images/machine/lighton.png";

  public static var BG_IMAGE = GameConfig.MACHINE_PATH + "bg.png";
  public static var BG_NO_MANUAL_IMAGE = GameConfig.MACHINE_PATH + "bg_no_manual.png";

  public static var PROCEDURE_INIT_TIME:Float = 2;
  public static var PROCEDURE_COMP_TIME:Float = 3;

  public var screen:FlxSpriteGroup;
  public var screenMenu:ScreenMenu;
  public var target:TechThing;

  private var timerBar:TimerBar;
  private var buttonSound:FlxSound;

  private var currentProc:FlxSpriteGroup;
  private var currentProcIndex:Int = 0;

  private var leftKey:FlxSprite;
  private var rightKey:FlxSprite;

  private var lights:Array<FlxSprite>;

  var paperHover = false;

  public function new(_target:TechThing):Void  {
    super();
    target = _target;
  }

  override public function create():Void {
    super.create();
    var bg = new FlxSprite();
    bg.loadGraphic(BG_IMAGE);
    add(bg);

    buttonSound = FlxG.sound.load("assets/sounds/button.wav", 0.5, false);
    createPaper();
    createTimerBar();

    createScreen();
    createScreenMessage();

    var screenBg = new FlxSprite(SCREEN_X, SCREEN_Y);
    screenBg.loadGraphic(GameConfig.IMAGE_PATH + "frame.png");
    add(screenBg);

    createControlStick();
    createKeys();
    createLights();
    startNextProc();
  }

  private function createLights():Void {
    lights = new Array<FlxSprite>();
    for (i in 0...GameConfig.allProcedures.length) {
      var light = new FlxSprite(707, 34 + 55 * i);
      lights.push(light);

      if (target.config.procedureTypes.indexOf(GameConfig.allProcedures[i]) == -1) {
        turnOffLight(i);
      } else {
        turnOnLight(i);
      }

      add(light);
    }
  }

  private function turnOnLight(index:Int):Void {
    var light:FlxSprite = lights[index];
    light.loadGraphic(LIGHT_ON_IMAGE);
  }

  private function turnOffLight(index:Int):Void {
    var light:FlxSprite = lights[index];
    light.loadGraphic(LIGHT_OFF_IMAGE);
  }

  private function createControlStick():Void {
    var stick:ControlStick = new ControlStick(254, 379);
    add(stick);
  }

  private function createKeys():Void {
    leftKey = new FlxSprite(402, 384);
    rightKey = new FlxSprite(554, 385);
    leftKey.loadGraphic(Z_KEY_IMAGE);
    rightKey.loadGraphic(X_KEY_IMAGE);
    add(leftKey);
    add(rightKey);
  }

  public function startNextProc() {
    if (currentProc == null) {
      startNewProc();
    } else {
      showComplete();

      var timer = new FlxTimer();
      timer.start(PROCEDURE_COMP_TIME, function(t:FlxTimer) {
        screen.remove(currentProc);
        if (currentProcIndex >= 0) {
          turnOffLight(currentProcIndex);
        }
        currentProcIndex += 1;

        if (currentProcIndex >= target.procedures.length) {
          FlxG.log.notice("close");
          close();
          return;
        }

        hideComplete();
        startNewProc();
      });
    }
  }

  function startNewProc() {
    FlxG.log.notice("start new proc");
    showInit();
    _startNewProc();

    var timer = new FlxTimer();
    timer.start(PROCEDURE_INIT_TIME, function(t:FlxTimer) {
      hideInit();
    });
  }

  function _startNewProc():Void {

    switch(target.procedures[currentProcIndex]) {
      case ProcedureType.Cleaning:
        currentProc = new CleaningProcedure(target, function() {
          showComplete();
          var timer = new FlxTimer();
          timer.start(PROCEDURE_COMP_TIME, function(t:FlxTimer) {
            hideComplete();

            screen.remove(currentProc);
            currentProc = new GrammaRay(target, startNextProc);
            screen.add(currentProc);

            showInit();
            var timer = new FlxTimer();
            timer.start(PROCEDURE_INIT_TIME, function(t:FlxTimer) {
              hideInit();
            });
          });
        });
        screenMenu.activateBar(ScreenMenu.MENU_CLEANING_INDEX);
        screen.add(currentProc);
      case ProcedureType.Cooling:
        currentProc = new CoolingProcedure(target, function() {
          showComplete();
          var timer = new FlxTimer();
          timer.start(PROCEDURE_COMP_TIME, function(t:FlxTimer) {
            hideComplete();

            screen.remove(currentProc);
            currentProc = new VacuumDryingProcedure(target, startNextProc);
            screen.add(currentProc);

            showInit();
            var timer = new FlxTimer();
            timer.start(PROCEDURE_INIT_TIME, function(t:FlxTimer) {
              hideInit();
            });
          });
        });
        screen.add(currentProc);
        screenMenu.activateBar(ScreenMenu.MENU_DEHYDRATION_INDEX);
      case ProcedureType.Electroplating:
        currentProc = new ElectroplatingProcedure(target, startNextProc);
        screenMenu.activateBar(ScreenMenu.MENU_ELECTROPLATING_INDEX);
        screen.add(currentProc);
      case ProcedureType.AntiMagnetic:
        currentProc = new AntiMagneticProcedure(target, startNextProc);
        screenMenu.activateBar(ScreenMenu.MENU_COATING_INDEX);
        screen.add(currentProc);
      case ProcedureType.VacuumPacking:
        currentProc = new VacuumPackingProcedure(target, startNextProc);
        screenMenu.activateBar(ScreenMenu.MENU_PACKAGING_INDEX);
        screen.add(currentProc);
      default:
    }
  }

  override public function update(elapsed:Float):Void {
    if (GameConfig.DEBUG && FlxG.keys.justPressed.P) {
      close();
    }
    if (GameConfig.DEBUG && FlxG.keys.justPressed.ENTER) {
      timerBar.onComplete(null);
    }

    if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X) {
      buttonSound.play();
    }
    if (FlxG.keys.pressed.Z) {
      leftKey.loadGraphic(Z_KEY_DOWN_IMAGE);
    } else {
      leftKey.loadGraphic(Z_KEY_IMAGE);
    }
    if (FlxG.keys.pressed.X) {
      rightKey.loadGraphic(X_KEY_DOWN_IMAGE);
    } else {
      rightKey.loadGraphic(X_KEY_IMAGE);
    }

    if (
      FlxG.mouse.getPosition().inCoords(p1.x, p1.y, p1.width, p1.height) ||
      FlxG.mouse.getPosition().inCoords(p2.x, p2.y, p2.width, p2.height)
    ) {
      if (!paperHover) {
        #if flash
        Mouse.cursor = MouseCursor.BUTTON;
        #end
        paperHover = true;
      }
      if (FlxG.mouse.justPressed) {
        var paperLarge = new FlxSprite();
        paperLarge.loadGraphic(GameConfig.IMAGE_PATH + "manual.png");
        paperCover.revive();
        var paperState = new PaperSubstate(paperLarge);
        paperState.closeCallback = handlePaperClose;
        openSubState(paperState);
      }
    } else if(paperHover) {
      #if flash
      Mouse.cursor = MouseCursor.ARROW;
      #end
      paperHover = false;
    }

    super.update(elapsed);
  }

  function handlePaperClose() {
    paperCover.kill();
  }

  private function createScreen():Void {
    screen = new FlxSpriteGroup(SCREEN_X, SCREEN_Y);
    createScreenMenu();

    add(screen);
  }

  var initMsg:FlxSpriteGroup;
  var compMsg:FlxSpriteGroup;
  function createScreenMessage() {
    initMsg = new FlxSpriteGroup(SCREEN_X, SCREEN_Y);

    var width = 200;
    var height = 40;
    var initRect = new FlxSprite(SCREEN_MAIN_WIDTH/2 - width/2, SCREEN_MAIN_HEIGHT/2 - height/2 + 8);
    initRect.makeGraphic(width, height);
    FlxSpriteUtil.drawRect(initRect, 1, 1, width - 2, height - 2, GameConfig.SCREEN_COLOR_YELLOW1, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      thickness: 2,
      pixelHinting: true
    });
    initMsg.add(initRect);

    var initText = new FlxText(0, SCREEN_MAIN_HEIGHT/2, SCREEN_MAIN_WIDTH, "INITIALIZING...");
    initText.alignment = FlxTextAlign.CENTER;
    initText.size = 13;
    initText.color = GameConfig.SCREEN_COLOR_YELLOW;
    initMsg.add(initText);

    add(initMsg);
    initMsg.kill();

    compMsg = new FlxSpriteGroup(SCREEN_X, SCREEN_Y);

    width = 160;
    height = 60;
    var compRect = new FlxSprite(SCREEN_MAIN_WIDTH/2 - width/2, SCREEN_MAIN_HEIGHT/2 - height/2 + 8);
    compRect.makeGraphic(width, height);
    FlxSpriteUtil.drawRect(compRect, 1, 1, width - 2, height - 2, GameConfig.SCREEN_COLOR_YELLOW1, {
      color: GameConfig.SCREEN_COLOR_YELLOW,
      thickness: 2,
      pixelHinting: true
    });
    compMsg.add(compRect);

    var compText = new FlxText(0, SCREEN_MAIN_HEIGHT/2 - 9, SCREEN_MAIN_WIDTH, "PROCEDURE\nCOMPELTE");
    compText.alignment = FlxTextAlign.CENTER;
    compText.size = 13;
    compText.color = GameConfig.SCREEN_COLOR_YELLOW;
    compMsg.add(compText);

    add(compMsg);

    initMsg.kill();
    compMsg.kill();
  }
  function showInit() {
    initMsg.revive();
  }
  function hideInit() {
    initMsg.kill();
  }

  function showComplete() {
    compMsg.revive();
  }
  function hideComplete() {
    compMsg.kill();
  }


  private function createScreenMenu():Void {
    screenMenu = new ScreenMenu();
    screenMenu.x = SCREEN_MENU_X;
    screenMenu.y = SCREEN_MENU_Y;
    screen.add(screenMenu);
  }

  public var p1:FlxSprite;
  public var p2:FlxSprite;
  public var paperCover:FlxSprite;

  function createPaper() {
    p1 = new FlxSprite(8, 322);
    p1.makeGraphic(107, 153, FlxColor.TRANSPARENT);
    p2 = new FlxSprite(7, 458);
    p2.makeGraphic(425, 22, FlxColor.TRANSPARENT);
    add(p1);
    add(p2);

    paperCover = new FlxSprite(0, 0);
    paperCover.loadGraphic(BG_NO_MANUAL_IMAGE);
    add(paperCover);
    paperCover.kill();
  }

  private function createTimerBar():Void {
    timerBar = new TimerBar(10, 10);
    add(timerBar);
    timerBar.start();
    timerBar.alpha = 0;

    timerBar.completeCallback = handleTimerBarComplete;
  }


  function handleTimerBarComplete() {
    close();
  }
}

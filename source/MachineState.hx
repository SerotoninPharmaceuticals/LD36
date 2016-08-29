package;

#if flash
import flash.ui.MouseCursor;
import flash.ui.Mouse;
#end

import flixel.util.FlxCollision;
import procedures.VacuumPackingProcedure;
import procedures.AntiMagneticProcedure;
import GameConfig.ProcedureType;
import procedures.ElectroplatingProcedure;
import sprites.TechThing;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

import procedures.CoolingProcedure;
import procedures.CleaningProcedure;
import sprites.ControlStick;
import ui.ScreenMenu;
import ui.TimerBar;

class MachineState extends FlxSubState {
  public static inline var SCREEN_X = 198;
  public static inline var SCREEN_Y = 48;
  public static inline var SCREEN_WIDTH = 472;
  public static inline var SCREEN_HEIGHT = 281;

  public static var SCREEN_MENU_X = SCREEN_WIDTH - ScreenMenu.SCREEN_MENU_WIDTH - 3;
  public static var SCREEN_MENU_Y = 2;

  public static var SCREEN_MAIN_WIDTH = SCREEN_MENU_X; // in where cursor moves.
  public static var SCREEN_MAIN_HEIGHT = SCREEN_HEIGHT;

  public static var X_KEY_IMAGE = "assets/images/machine/x.png";
  public static var X_KEY_DOWN_IMAGE = "assets/images/machine/x_down.png";
  public static var Z_KEY_IMAGE = "assets/images/machine/z.png";
  public static var Z_KEY_DOWN_IMAGE = "assets/images/machine/z_down.png";

  public var screen:FlxSpriteGroup;
  public var screenMenu:ScreenMenu;
  public var target:TechThing;

  private var timerBar:TimerBar;

  private var currentProc:FlxSpriteGroup;
  private var currentProcIndex:Int = -1;

  private var leftKey:FlxSprite;
  private var rightKey:FlxSprite;

  public function new(_target:TechThing):Void  {
    super();
    target = _target;
  }

  override public function create():Void {
    super.create();
    var bg = new FlxSprite();
    bg.loadGraphic(GameConfig.MACHINE_PATH + "bg.jpg");
    add(bg);

    createPaper();
    createTimerBar();
    createScreen();
    startNextProc();
    createControlStick();
    createKeys();
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

  public function startNextProc():Void {
    if (currentProc != null) {
      screen.remove(currentProc);
    }
    currentProcIndex += 1;

    if (currentProcIndex >= target.procedures.length) {
      close();
      return;
    }

    switch(target.procedures[currentProcIndex]) {
      case ProcedureType.Cleaning:
        currentProc = new CleaningProcedure(target, startNextProc);
        screenMenu.activateBar(ScreenMenu.MENU_CLEANING_INDEX);
        screen.add(currentProc);
      case ProcedureType.Cooling:
        currentProc = new CoolingProcedure(target, startNextProc);
        screenMenu.activateBar(ScreenMenu.MENU_DEHYDRATION_INDEX);
        screen.add(currentProc);
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
    if (GameConfig.DEBUG && FlxG.mouse.justPressed && !FlxG.mouse.getPosition().inCoords(SCREEN_X, SCREEN_Y, SCREEN_WIDTH, SCREEN_HEIGHT)) {
      close();
    }
    if (GameConfig.DEBUG && FlxG.keys.justPressed.ENTER) {
      timerBar.onComplete(null);
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
      #if flash
      Mouse.cursor = MouseCursor.BUTTON;
      #end
      if (FlxG.mouse.justPressed) {
        var paperLarge = new FlxSprite();
        paperLarge.loadGraphic(GameConfig.IMAGE_PATH + "manual.png");
        openSubState(new PaperSubstate(paperLarge));
      }
    } else {

      Mouse.cursor = MouseCursor.ARROW;
    }

    super.update(elapsed);
  }

  private function createScreen():Void {
    screen = new FlxSpriteGroup(SCREEN_X, SCREEN_Y);
    var screenBg = new FlxSprite(0, 0);
    screenBg.makeGraphic(SCREEN_WIDTH, SCREEN_HEIGHT, FlxColor.GREEN, true);
    screen.add(screenBg);
    createScreenMenu();

    add(screen);
  }

  private function createScreenMenu():Void {
    screenMenu = new ScreenMenu();
    screenMenu.x = SCREEN_MENU_X;
    screenMenu.y = SCREEN_MENU_Y;
    screen.add(screenMenu);
  }

  public var p1:FlxSprite;
  public var p2:FlxSprite;
  function createPaper() {
    p1 = new FlxSprite(8, 322);
    p1.makeGraphic(107, 153, FlxColor.TRANSPARENT);
    p2 = new FlxSprite(7, 458);
    p2.makeGraphic(425, 22, FlxColor.TRANSPARENT);
    add(p1);
    add(p2);
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

package;

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
import ui.ScreenMenu;
import ui.TimerBar;

class MachineState extends FlxSubState {
  public static inline var SCREEN_X = 100;
  public static inline var SCREEN_Y = 50;
  public static inline var SCREEN_WIDTH = 600;
  public static inline var SCREEN_HEIGHT = 300;
  public static inline var SCREEN_MENU_X = 448;
  public static inline var SCREEN_MENU_Y = 2;

  public static inline var SCREEN_MAIN_WIDTH = SCREEN_MENU_X; // in where cursor moves.
  public static inline var SCREEN_MAIN_HEIGHT = SCREEN_HEIGHT;

  public var screen:FlxSpriteGroup;
  public var screenMenu:ScreenMenu;
  public var target:TechThing;

  private var timerBar:TimerBar;

  private var currentProc:FlxSpriteGroup;
  private var currentProcIndex:Int = -1;

  public function new(_target:TechThing):Void  {
    super();
    target = _target;
  }

  override public function create():Void {
    super.create();
    createTimerBar();
    createScreen();
    startNextProc();
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
    // XXX: code for test
    if (FlxG.mouse.justPressed && !FlxG.mouse.getPosition().inCoords(SCREEN_X, SCREEN_Y, SCREEN_WIDTH, SCREEN_HEIGHT)) {
      close();
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

  private function createTimerBar():Void {
    timerBar = new TimerBar(10, 10);
    add(timerBar);
    timerBar.start();
  }
}

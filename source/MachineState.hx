package;

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

  public var screen:FlxSpriteGroup;
  public var screenMenu:ScreenMenu;
  public var target:TechThing;

  private var timerBar:TimerBar;

  private var currentProc:FlxSpriteGroup;

  public function new(_target:TechThing):Void  {
    super();
    target = _target;
  }

  override public function create():Void {
    super.create();
    createScreen();
    startNextProc();
    createTimerBar();
  }

  public function startNextProc():Void {
    if (currentProc != null) {
      remove(currentProc);
    }
    currentProc = new CoolingProcedure();
    screen.add(currentProc);
  }

  override public function update(elapsed:Float):Void {
    if (currentProc != null) {
      currentProc.update(elapsed);
    }
    if (FlxG.mouse.justPressed) {
      close();
    }

    super.update(elapsed);
  }

  private function createScreen():Void {
    screen = new FlxSpriteGroup(SCREEN_X, SCREEN_Y);
    add(screen);
    var screenBg = new FlxSprite(0, 0);
    screenBg.makeGraphic(SCREEN_WIDTH, SCREEN_HEIGHT, FlxColor.BLACK, true);
    screen.add(screenBg);
    createScreenMenu();
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

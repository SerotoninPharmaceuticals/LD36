package ui;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;


class ScreenMenu extends FlxSpriteGroup {

  public static inline var MENU_CLEANING_INDEX = 0;
  public static inline var MENU_DEHYDRATION_INDEX = 1;
  public static inline var MENU_ELECTROPLATING_INDEX = 2;
  public static inline var MENU_COATING_INDEX = 3;
  public static inline var MENU_PACKAGING_INDEX = 4;

  public static inline var SCREEN_MENU_COUNT = 5;
  public static inline var SCREEN_MENU_WIDTH = 150;
  public static inline var SCREEN_MENU_TEXT_PADDING = 4;

  public var SCREEN_MENU_ITEM_HEIGHT:Float = (MachineState.SCREEN_HEIGHT - 2) / 5;

  private static var MENU_COLOR = GameConfig.SCREEN_COLOR_YELLOW;
  private static var ACTIVATED_MENU_FILL_COLOR = GameConfig.SCREEN_COLOR_YELLOW1;

  private var bars:Array<FlxBar>;

  private var currentActivatedBar:FlxBar = null;

  public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0):Void {
    super(X, Y, MaxSize);
    bars = new Array<FlxBar>();
    createMenuItem(MENU_CLEANING_INDEX, "Surface Cleaning & Sterilization");
    createMenuItem(MENU_DEHYDRATION_INDEX, "Dehydrating Process");
    createMenuItem(MENU_ELECTROPLATING_INDEX, "Electroplating Process");
    createMenuItem(MENU_COATING_INDEX, "Anti-Magnetic Coating");
    createMenuItem(MENU_PACKAGING_INDEX, "Vacuum Packaging");

    activateBar(MENU_CLEANING_INDEX);
  }

  public function activateBar(index:Int):Void {
    if (currentActivatedBar != null) {
      currentActivatedBar.percent = 0;
    }
    currentActivatedBar = bars[index];
    currentActivatedBar.percent = 100;
  }


  private function createMenuItem(index:Int, text:String):Void {
    var itemY = index * SCREEN_MENU_ITEM_HEIGHT;
    var itemBar = new FlxBar(0, itemY, FlxBarFillDirection.LEFT_TO_RIGHT, SCREEN_MENU_WIDTH, Std.int(SCREEN_MENU_ITEM_HEIGHT));

    itemBar.createColoredEmptyBar(FlxColor.TRANSPARENT, false);
    itemBar.createColoredFilledBar(ACTIVATED_MENU_FILL_COLOR, false);
    itemBar.x = 0;
    itemBar.y = itemY;
    var text = new FlxText(SCREEN_MENU_TEXT_PADDING, itemY + SCREEN_MENU_TEXT_PADDING,
                           SCREEN_MENU_WIDTH - 2 * SCREEN_MENU_TEXT_PADDING, text);
    text.setFormat(null, 12, MENU_COLOR);
    bars.insert(index, itemBar);
    itemBar.percent = 0;
    add(itemBar);
    add(text);
  }
}

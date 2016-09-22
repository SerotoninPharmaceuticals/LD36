package ;

import GameConfig.TechThingConfig;

class GameData {
  static public var timerTime:Int = GameConfig.GAME_TIME;
  static public var finishedTechThings:Array<TechThingConfig> = new Array<TechThingConfig>();
  static public var dragHoverCount:Int = 0;
  static public var disabledHoverCount:Int = 0;
  static public var hoverCount:Int = 0;
  static public var hatchinOpened = false;
  static public var reading = false;
}

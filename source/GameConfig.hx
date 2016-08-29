package;

import flixel.util.FlxColor;

enum ProcedureType {
  Cleaning;
  Cooling;
  Electroplating;
  AntiMagnetic;
  Vacuum;
}


typedef TechThingConfig = {
  var codeName:String;
  var name:String;
  var x:Int;
  var y:Int;

  var procedureTypes:Array<ProcedureType>;

  var image:String;
  var imageAfter:String;

  // Mode A
  var modeAStep1FrontImage:String;
  var modeAStep1BackImage:String;
  var modeAStep2FrontImage:String;
  var modeAStep2BackImage:String;

  // Mode B
  var modeBStep1Image:String;
  var modeBStep2Image:String;

  // Mode C
  var modeCImage:String;

  // Mode D
  var modeDFrontImage:String;
  var modeDBackImage:String;

  // Mode E
  var modeEImage:String;
};



class GameConfig {

  public static inline var DEBUG = true;
  public static inline var GAME_TIME = 72 * 60;
  public static inline var SCREEN_COLOR_YELLOW0 = 0xFFFAEF38;
  public static inline var SCREEN_COLOR_YELLOW1 = 0xFF7F7C15;

  public static inline var SCREEN_COLOR_GREEN = FlxColor.GREEN;

  public static inline var COOLING_PROC_INITIAL_TEMP = 30.5;
  public static inline var COOLING_PROC_TEMP_DEC = 2.0;
  public static inline var COOLING_PROC_TIMEOUT = 10;
  public static inline var COOLING_PROC_LOWER_TEMP = -40;
  public static inline var COOLING_PROC_UPPER_TEMP = -30;
  public static inline var COOLING_PROC_TEMP_INC_SPEED = 5;

  public static inline var ELECTROP_PROC_CURSOR_INC_SPEED= 60;
  public static inline var ELECTROP_PROC_CURSOR_DEC_SPEED= 90;
  public static inline var ELECTROP_PROC_VALID_AREA_SPEED= 10;

  public static inline var IMAGE_PATH = "assets/images/";
  public static inline var TECHTHINGS_PATH = "assets/images/techthings/";

  public static var techThingConfigs:Array<TechThingConfig> = [
    {
      codeName: "bible",
      name: "Bible",
      x: 0,
      y: 0,

      procedureTypes: [
        ProcedureType.Vacuum,
        ProcedureType.Cleaning, ProcedureType.Cooling,
        ProcedureType.Electroplating, ProcedureType.AntiMagnetic
      ],

      image: "",
      imageAfter: "",

      modeAStep1FrontImage: "",
      modeAStep1BackImage: "",
      modeAStep2FrontImage: "",
      modeAStep2BackImage: "",

      modeBStep1Image: "",
      modeBStep2Image: "",

      modeCImage: "",

      modeDFrontImage: "",
      modeDBackImage: "",

      modeEImage: ""
    }
  ];
}

package;

import flixel.util.FlxColor;

enum ProcedureType {
  Cleaning;
  Cooling;
  Electroplating;
  AntiMagnetic;
  VacuumPacking;
}


typedef TechThingConfig = {
  var codeName:String;
  var name:String;
  var x:Int;
  var y:Int;

  var procedureTypes:Array<ProcedureType>;

  @:optional var image:String;
  @:optional var imageDraggin:String;
  @:optional var imageAfter:String;
  @:optional var imageHitbox: String;

  // Mode A
  @:optional var modeAStep1FrontImage:String;
  @:optional var modeAStep1BackImage:String;
  @:optional var modeAStep2FrontImage:String;
  @:optional var modeAStep2BackImage:String;

  // Mode B
  @:optional var modeBStep1Image:String;
  @:optional var modeBStep2Image:String;

  // Mode C
  @:optional var modeCImage:String;

  // Mode D
  @:optional var modeDFrontImage:String;
  @:optional var modeDBackImage:String;

  // Mode E
  @:optional var modeEImage:String;
};



class GameConfig {

  public static inline var DEBUG = false;
  public static inline var GAME_TIME = 73 * 60;

  public static var SCREEN_COLOR_YELLOW = FlxColor.fromRGB(216, 197, 65);
  public static inline var SCREEN_COLOR_YELLOW1 = 0xFF7F7C15;

  public static inline var SCREEN_COLOR_GREEN = FlxColor.GREEN;
  public static inline var SCREEN_BG_COLOR = 0xFF37363B;

  public static inline var ENABLE_CURSOR_OBLIQUE = false;


  public static inline var COOLING_PROC_TEMP_DEC = 1.0;
  public static inline var COOLING_PROC_LOWER_TEMP = -42 + (GameConfig.DEBUG ? -10 : 0);
  public static inline var COOLING_PROC_UPPER_TEMP = -38 + (GameConfig.DEBUG ? 40 : 0);
  public static inline var TEMP_INC_SPEED = 2.6;

  public static inline var DRYING_PROC_TEMP_GAIN = 1.0;
  public static inline var DRYING_PROC_LOWER_TEMP = 25 + (GameConfig.DEBUG ? -8 : 0);
  public static inline var DRYING_PROC_UPPER_TEMP = 30 + (GameConfig.DEBUG ? 40 : 0);

  public static inline var ELECTROP_PROC_CURSOR_INC_SPEED= 60;
  public static inline var ELECTROP_PROC_CURSOR_DEC_SPEED= 90;
  public static inline var ELECTROP_PROC_VALID_AREA_SPEED= 10;

  public static inline var CURSOR_MOVE_MAX_SPEED = 80;
  public static inline var CURSOR_DRAG = 1000;


  public static inline var SCREEN_LEFT_PADDING = 4;
  public static inline var SCREEN_TOP_PADDING = 2;

  public static inline var IMAGE_PATH = "assets/images/";
  public static inline var TECHTHINGS_PATH = "assets/images/techthings/";
  public static inline var MACHINE_PATH = "assets/images/machine/";

  public static inline var TIME_SCALE = 6 * 60;  // The scale factor of the play time compare to the real time

  public static var allProcedures = [
    ProcedureType.Cleaning,
    ProcedureType.Cooling,
    ProcedureType.Electroplating,
    ProcedureType.AntiMagnetic,
    ProcedureType.VacuumPacking
  ];

  public static var techThingConfigs:Array<TechThingConfig> = [
    {
      codeName: "ball",
      name: "Ball",
      x: 0,
      y: 0,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "brain",
      name: "brain",
      x: 69,
      y: 21,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Cooling,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "disk",
      name: "Disk",
      x: 134,
      y: 13,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Electroplating,
        ProcedureType.AntiMagnetic,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "david",
      name: "David",
      x: 205,
      y: -64,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Electroplating,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "gun",
      name: "Gun",
      x: 274,
      y: 24,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Electroplating,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "bible",
      name: "Bible",
      x: 112,
      y: 85,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "cola",
      name: "Cola",
      x: 180,
      y: 77,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Electroplating,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "gold",
      name: "Gold",
      x: 218,
      y: 112,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Electroplating,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "iphone",
      name: "iPhone",
      x: 273,
      y: 103,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Electroplating,
        ProcedureType.AntiMagnetic,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "cd",
      name: "CD",
      x: 326,
      y: 92,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Electroplating,
        ProcedureType.VacuumPacking
      ]
    },
    {
      codeName: "bonsai",
      name: "Bonsai",
      x: 371,
      y: 30,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.Cooling,
        ProcedureType.VacuumPacking
      ]
    }
  ];
}

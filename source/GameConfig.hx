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

  public static inline var DEBUG = false;
  public static inline var GAME_TIME = 72 * 60;
  public static inline var SCREEN_COLOR_YELLOW0 = 0xFFFAEF38;
  public static inline var SCREEN_COLOR_YELLOW1 = 0xFF7F7C15;

  public static inline var SCREEN_COLOR_GREEN = FlxColor.GREEN;

  public static inline var ENABLE_CURSOR_OBLIQUE = false;

  public static inline var COOLING_PROC_INITIAL_TEMP = 30.5;
  public static inline var COOLING_PROC_TEMP_DEC = 2.0;
  public static inline var COOLING_PROC_TIMEOUT = 10;
  public static inline var COOLING_PROC_LOWER_TEMP = -40;
  public static inline var COOLING_PROC_UPPER_TEMP = -30;
  public static inline var COOLING_PROC_TEMP_INC_SPEED = 5;

  public static inline var ELECTROP_PROC_CURSOR_INC_SPEED= 60;
  public static inline var ELECTROP_PROC_CURSOR_DEC_SPEED= 90;
  public static inline var ELECTROP_PROC_VALID_AREA_SPEED= 10;

  public static inline var CURSOR_MOVE_MAX_SPEED = 200;
  public static inline var CURSOR_DRAG = 1000;

  public static inline var IMAGE_PATH = "assets/images/";
  public static inline var TECHTHINGS_PATH = "assets/images/techthings/";
  public static inline var MACHINE_PATH = "assets/images/machine/";

  public static inline var SCREEN_TECH_THING_X = 55;
  public static inline var SCREEN_TECH_THING_Y = 37;

  public static var techThingConfigs:Array<TechThingConfig> = [
    {
      codeName: "ball",
      name: "Ball",
      x: 0,
      y: 0,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.VacuumPacking
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
    },
    {
      codeName: "disk",
      name: "Disk",
      x: 133,
      y: 13,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.AntiMagnetic,
        ProcedureType.VacuumPacking
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
    },
    {
      codeName: "bible",
      name: "Bible",
      x: 112,
      y: 85,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.VacuumPacking
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
    },
    {
      codeName: "cola",
      name: "Cola",
      x: 180,
      y: 77,

      procedureTypes: [
        ProcedureType.VacuumPacking,
        ProcedureType.AntiMagnetic,
        ProcedureType.Cleaning,
        ProcedureType.Cooling,
        ProcedureType.Electroplating
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
    },
    {
      codeName: "iphone",
      name: "iPhone",
      x: 273,
      y: 103,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.AntiMagnetic,
        ProcedureType.VacuumPacking
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
    },
    {
      codeName: "cd",
      name: "CD",
      x: 316,
      y: 92,

      procedureTypes: [
        ProcedureType.Cleaning,
        ProcedureType.AntiMagnetic,
        ProcedureType.VacuumPacking
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

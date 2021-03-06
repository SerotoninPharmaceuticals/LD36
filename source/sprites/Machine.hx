package sprites;

import flixel.util.FlxTimer;
import GameData;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.tweens.FlxTween;
import sprites.TechThing.TechThingState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSound;


class Machine extends FlxTypedGroup<FlxSprite> {

  var x:Float;
  var y:Float;
  var onBeginProcedures:TechThing->Void;

  public var backGroup = new FlxTypedGroup<FlxSprite>();
  public var frontGroup = new FlxTypedGroup<FlxSprite>();
  public var uiGroup = new FlxTypedGroup<FlxSprite>();

  public var entrance:Dropable<TechThing>;
  public var exit:FlxSprite;
  public var hatchin:FlxSprite;

  public var currentTechThing:TechThing;

  var standby:FlxSprite;

  private var hatchOpenSound:FlxSound;
  private var hatchCloseSound:FlxSound;

  var canClickHatchout = false;

  public function new(_x:Float = 0.0, _y:Float = 0.0, _onBeginProcedures:TechThing->Void) {
    super();
    x = _x;
    y = _y;
    onBeginProcedures = _onBeginProcedures;

    loadEntrance();
    loadExit();
    loadScreen();
    loadHatchin();
    hatchOpenSound = FlxG.sound.load("assets/sounds/exit_open.wav", 0.5, false);
    hatchOpenSound.pan = -0.35;
    hatchCloseSound = FlxG.sound.load("assets/sounds/exit_close.wav", 0.5, false);
    hatchCloseSound.pan = -0.35;

    enableHatchinClick();
    enableHatchoutClick();
  }

  override public function update(elasped:Float):Void {
    super.update(elasped);
  }

  function loadEntrance():Void {
    entrance = new Dropable<TechThing>(151, 364, "assets/images/hatchin_bg.png", null);
    backGroup.add(entrance.body);
    uiGroup.add(entrance.hintArrow);
    entrance.handleDrop = handleEntranceDrop;
  }

  function loadHatchin():Void {
    hatchin = new FlxSprite(150, 364);
    hatchin.loadGraphic("assets/images/hatchin.png");

//    var machineFront = new FlxSprite(0, 0);
//    machineFront.loadGraphic("assets/images/machine_front.png");
//    frontGroup.add(machineFront);

    frontGroup.add(hatchin);
  }

  function enableHatchinClick() {
    FlxMouseEventManager.add(hatchin, function(target:FlxSprite) {
      if (this.canClickHatchin()) {
        hatchOpenSound.play();
        FlxTween.tween(target, { y: 466 }, 0.58, {
          type: FlxTween.ONESHOT,
          ease: FlxEase.circInOut
        });
        GameData.hatchinOpened = true;
        GameData.hoverCount -= 1;
      }
    }, null, function(target) {
      if (this.canClickHatchin()) {
        GameData.hoverCount += 1;
      } else {
        FlxG.log.notice("+1");
        if(!GameData.reading) GameData.disabledHoverCount += 1;
      }
    }, function(target) {
      if (this.canClickHatchin()) {
        GameData.hoverCount -= 1;
      } else {
        if(!GameData.reading) GameData.disabledHoverCount -= 1;
      }
    });
  }
  
  function enableHatchoutClick() {
    FlxMouseEventManager.add(exit, function(target:FlxSprite) {
      if (canClickHatchout) {
        onFinishedProcess();
        GameData.hoverCount -= 1;
        canClickHatchout = false;
      }
    }, null, function(target) {
      if (canClickHatchout) {
        GameData.hoverCount += 1;
      } else {
        GameData.disabledHoverCount += 1;
      }
    }, function(target) {
      if (canClickHatchout) {
        GameData.hoverCount -= 1;
      } else {
        GameData.disabledHoverCount -= 1;
      }
    }, false, true, false);
  }


  function canClickHatchin():Bool {
    return !GameData.hatchinOpened && !GameData.reading && currentTechThing == null;
  }


  function handleEntranceDrop(techThing:TechThing) {
    currentTechThing = techThing;
    entrance.setHover(false, techThing);
    entrance.isItemPlaced = true;

    hatchCloseSound.play();
    FlxTween.tween(hatchin, {y: 365}, 0.4, {
      type: FlxTween.ONESHOT,
      ease: FlxEase.circIn,
      onComplete: function(tween) {
        standby.loadGraphic("assets/images/standby.png");
        FlxMouseEventManager.setObjectMouseEnabled(standby, true);
        turnOnScreen();
      }
    });
    GameData.hatchinOpened = false;
  }

  function turnOnScreen() {
    standby.revive();
    standby.alpha = 0;
    var timer = new FlxTimer();
    timer.start(Math.random() * 0.03, function(t) {
      standby.alpha = 1;
      timer.start(Math.random() * 0.03, function(t) {
        standby.alpha = 0;
        timer.start(Math.random() * 0.03, function(t) {
          standby.alpha = 1;
        });
      });
    });

//    FlxTween.color(standby, 0.4, FlxColor.TRANSPARENT, FlxColor.WHITE, {
//      type: FlxTween.ONESHOT,
//      ease: FlxEase.elasticInOut
//    });
  }

  function loadExit():Void {
    exit = new FlxSprite(0, 253);
    exit.loadGraphic("assets/images/hatchout.png");

    var exitFront = new FlxSprite(0, 0);
    exitFront.loadGraphic("assets/images/hatchout_cover.png");
    frontGroup.add(exitFront);

    frontGroup.add(exit);
  }

  function loadScreen():Void {
    var screen = new FlxSprite(180, 125);
    screen.loadGraphic("assets/images/screen_small.png");

    standby = new FlxSprite(218, 147);
    standby.kill();

    FlxMouseEventManager.add(standby, function(target:FlxSprite) {
      onBeginProcedures(currentTechThing);
    }, null, function(target) {
      GameData.hoverCount += 1;
    }, function(target) {
      GameData.hoverCount -= 1;
    }, false, true, false);

    backGroup.add(screen);
    backGroup.add(standby);
  }

  public function closeExit():Void {
    hatchCloseSound.play();
    standby.kill();
    FlxTween.tween(exit, {x: 0}, 0.5, { type: FlxTween.ONESHOT, ease:FlxEase.circOut});
  }

  public function startFinishProcess():Void {
    if (currentTechThing == null) { return; }
    canClickHatchout = true;
	
    standby.loadGraphic("assets/images/standby_end.png");
    FlxMouseEventManager.setObjectMouseEnabled(standby, false);
    turnOnScreen();
	
    currentTechThing.toAfter();
    if (currentTechThing.config.codeName == "david") {currentTechThing.angle = 0; currentTechThing.setPosition(exit.getMidpoint().x - currentTechThing.width / 2 -35, exit.getMidpoint().y - currentTechThing.height / 2);}
    else if (currentTechThing.config.codeName == "bonsai") currentTechThing.setPosition(exit.getMidpoint().x - currentTechThing.width / 2 -20, exit.getMidpoint().y - currentTechThing.height / 2 - 15);
    else currentTechThing.setPosition(exit.getMidpoint().x - currentTechThing.width/2, exit.getMidpoint().y - currentTechThing.height/2);
    currentTechThing.alpha = 1;
  }


  function onFinishedProcess(?tween:FlxTween):Void {
    hatchOpenSound.play();
    FlxTween.tween(exit, { x: -200 }, 0.42, {
      type: FlxTween.ONESHOT, ease:FlxEase.circIn,
      onComplete: function(tween:FlxTween) {
        // exit.alpha = 0;
        entrance.setHover(false);
        entrance.isItemPlaced = false;
        currentTechThing.setState(TechThingState.ProcessFinished);
      }
    });
  }
}


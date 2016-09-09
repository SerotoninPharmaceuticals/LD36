package sprites;

import GameData;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.text.FlxText;
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

  public var entrance:Dropable<TechThing>;
  public var exit:FlxSprite;
  public var hatchin:FlxSprite;

  public var currentTechThing:TechThing;

  var standby:FlxSprite;

  private var hatchOpenSound:FlxSound;
  private var hatchCloseSound:FlxSound;

  var hatchinClickable = false;

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
    hatchOpenSound.pan = -0.8;
    hatchCloseSound = FlxG.sound.load("assets/sounds/exit_close.wav", 0.5, false);
    hatchCloseSound.pan = -0.8;
  }

  override public function update(elasped:Float):Void {
    if (!hatchinClickable && !GameData.hatchinOpened && currentTechThing == null) {
      enableHatchinClick();
    }
    super.update(elasped);
  }

  function loadEntrance():Void {
    entrance = new Dropable(151, 364, "assets/images/hatchin_bg.png", null);
    backGroup.add(entrance);
    entrance.handleDrop = handleEntranceDrop;
  }

  function loadHatchin():Void {
    hatchin = new FlxSprite(151, 365);
    hatchin.loadGraphic("assets/images/hatchin.png");

    frontGroup.add(hatchin);
  }

  function enableHatchinClick() {
    hatchinClickable = true;
    FlxMouseEventManager.add(hatchin, function(target:FlxSprite) {
      hatchOpenSound.play();
      FlxTween.tween(target, {y: 468}, 0.2, { type: FlxTween.ONESHOT });
      GameData.hatchinOpened = true;
      GameData.hoverCount -= 1;

      FlxMouseEventManager.remove(hatchin);
      hatchinClickable = false;
    }, null, function(target) {
      GameData.hoverCount += 1;
    }, function(target) {
      GameData.hoverCount -= 1;
    });
  }

  function handleEntranceDrop(techThing:TechThing) {
    currentTechThing = techThing;
    entrance.setHover(false, techThing);
    entrance.isItemPlaced = true;

    FlxTween.tween(hatchin, {y: 365}, 0.2, {
      type: FlxTween.ONESHOT,
      onComplete: function(tween) {
        turnOnScreen();
      }
    });
    GameData.hatchinOpened = false;
  }

  function turnOnScreen() {
    standby.revive();
    standby.alpha = 0;
    FlxTween.color(standby, 0.4, FlxColor.TRANSPARENT, FlxColor.WHITE, {
      type: FlxTween.ONESHOT,
      ease: FlxEase.elasticOut
    });
  }

  function loadExit():Void {
    exit = new FlxSprite(0, 253);
    exit.loadGraphic("assets/images/hatchout.png");
    frontGroup.add(exit);
  }

  function loadScreen():Void {
    var screen = new FlxSprite(180, 125);
    screen.loadGraphic("assets/images/screen_small.png");

    standby = new FlxSprite(218, 147);
    standby.loadGraphic("assets/images/standby.png");
    standby.kill();

    FlxMouseEventManager.add(standby, function(target:FlxSprite) {
      onBeginProcedures(currentTechThing);
      standby.kill();
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
    FlxTween.tween(exit, {x: 0}, 0.2, { type: FlxTween.ONESHOT });
  }

  public function startFinishProcess():Void {
    if (currentTechThing == null) { return; }
    currentTechThing.toAfter();
    currentTechThing.setPosition(exit.getMidpoint().x - currentTechThing.width/2, exit.getMidpoint().y - currentTechThing.height/2);
    currentTechThing.alpha = 1;

    FlxMouseEventManager.add(exit, function(target:FlxSprite) {
      onFinishedProcess();
      FlxMouseEventManager.remove(target);
      GameData.hoverCount -= 1;
    }, null, function(target) {
      GameData.hoverCount += 1;
    }, function(target) {
      GameData.hoverCount -= 1;
    }, false, true, false);
  }

  function onFinishedProcess(?tween:FlxTween):Void {
    hatchOpenSound.play();
    FlxTween.tween(exit, {x: -100}, 0.2, { type: FlxTween.ONESHOT });
    // exit.alpha = 0;
    entrance.setHover(false);
    entrance.isItemPlaced = false;
    currentTechThing.setState(TechThingState.ProcessFinished);
  }
}


package sprites;

import haxe.Log;
import flixel.tweens.FlxTween;
import sprites.TechThing.TechThingState;
import openfl.geom.Point;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.FlxSprite;
import flixel.util.FlxColor;


class Machine extends FlxTypedGroup<FlxSprite> {

  var x:Float;
  var y:Float;
  var onBeginProcedures:TechThing->Void;

  public var entrance:Dropable<TechThing>;
  public var exit:FlxSprite;

  public var currentTechThing:TechThing;

  public function new(_x:Float = 0.0, _y:Float = 0.0, _onBeginProcedures:TechThing->Void) {
    super();
    x = _x;
    y = _y;
    onBeginProcedures = _onBeginProcedures;

    loadEntrance();
    loadExit();
    loadScreen();
  }

  override public function update(elasped:Float):Void {
    if (exit.alpha == 0 && currentTechThing == null) {
      exit.alpha = 1;
    }
    super.update(elasped);
  }

  function loadEntrance():Void {
    entrance = new Dropable(151, 362, "assets/images/hatchin.png", null);
    add(entrance);
    entrance.handleDrop = handleEntranceDrop;
  }
  function handleEntranceDrop(techThing:TechThing) {
    currentTechThing = techThing;
    entrance.setHover(false, techThing);
    entrance.isItemPlaced = true;
    onBeginProcedures(techThing);
    currentTechThing.alpha = 0;
  }

  function loadExit():Void {
    exit = new FlxSprite(0, 253);
    exit.loadGraphic("assets/images/hatchout.png");
    add(exit);
  }

  function loadScreen():Void {
    var screen = new FlxSprite(184, 125);
    screen.loadGraphic("assets/images/screen_small.png");
    add(screen);
  }

  public function startFinishProcess():Void {

    if (currentTechThing == null) { return; }
    currentTechThing.toAfter();
    currentTechThing.setPosition(exit.getMidpoint().x - currentTechThing.width/2, exit.getMidpoint().y - currentTechThing.height/2);
    currentTechThing.alpha = 1;
    onFinishedProcess();
  }
  function onFinishedProcess(?tween:FlxTween):Void {
    FlxTween.tween(exit, {x: -100}, 0.2, { type: FlxTween.ONESHOT });
    // exit.alpha = 0;
    entrance.setHover(false);
    entrance.isItemPlaced = false;
    currentTechThing.setState(TechThingState.ProcessFinished);

  }
}


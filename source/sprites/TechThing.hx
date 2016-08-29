package sprites;

import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flixel.util.FlxCollision;
import GameConfig.TechThingConfig;
import GameConfig.ProcedureType;
import haxe.Log;
import sprites.TechThing.TechThingState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;

enum TechThingState {
  Candidate;
  Selected;
  Processed;
  ProcessFinished;
  Buried;
}

class TechThing extends FlxExtendedSprite {

  public var originalX:Float;
  public var originalY:Float;
  public var procedures:Array<ProcedureType>;

  public var config:TechThingConfig;

  public var machine:Machine;
  public var machineEntrance:Dropable<TechThing>;
  public var coffinEntrance:Dropable<TechThing>;

  public var prevState:TechThingState;
  public var state:TechThingState;

  public function new(X:Float = 0, Y:Float = 0, _machine:Machine, _coffinEntrance:Dropable<TechThing>, _config:TechThingConfig) {
    super(X, Y);
    FlxG.plugins.add(new FlxMouseControl());

    machine = _machine;
    machineEntrance = _machine.entrance;
    coffinEntrance = _coffinEntrance;
    config = _config;

    originalX = X;
    originalY = Y;

    state = TechThingState.Candidate;

    loadGraphic(config.image);
  }

  public function toAfter() {
    loadGraphic(config.imageAfter);
  }

  override public function update(elasped:Float):Void {
    #if flash
    if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), this)) {
      Mouse.cursor = MouseCursor.HAND;
    }
    #end

    switch(state) {
      case TechThingState.Candidate:
        handleCandidate();
      case TechThingState.ProcessFinished:
        handleProcessFinished();
      default:
        if (draggable) { disableMouseDrag(); }
    }

    super.update(elasped);

    if (draggable && !isDragged) {
      x = originalX;
      y = originalY;
    }

    if (!draggable) {
      originalX = x;
      originalY = y;
    }
  }

  override public function setPosition(X:Float = 0, Y:Float = 0):Void {
    originalX = X;
    originalY = Y;
    super.setPosition(X, Y);
  }

  function handleCandidate() {
    if (!draggable && machine.currentTechThing == null) {
      enableDrag();
      return;
    }
    if (draggable && machineEntrance.relatedItem != null && machineEntrance.isItemPlaced){
      disableMouseDrag();
      return;
    }

    if (isDragged) {
      if (getMidpoint().inCoords(machineEntrance.x, machineEntrance.y, machineEntrance.width, machineEntrance.height)) {
//        haxe.Log.trace("onDrop");
        machineEntrance.setHover(true, this);
        machineEntrance.stopHint();
      } else {
//        haxe.Log.trace("not onDrop");
        machineEntrance.setHover(false);
        machineEntrance.showHint();
      }
    }
  }

  function handleProcessFinished() {
    if (!draggable) {
      enableDrag();
      return;
    }
    if (isDragged) {
      if (getMidpoint().inCoords(coffinEntrance.x, coffinEntrance.y, coffinEntrance.width, coffinEntrance.height)) {
        coffinEntrance.setHover(true, this);
        coffinEntrance.stopHint();
      } else {
        coffinEntrance.setHover(false);
        coffinEntrance.showHint();
      }
    }
  }

  public function enableDrag():Void {
    mouseStartDragCallback = onDragStart;
    mouseStopDragCallback = onDragStop;

    enableMouseDrag();
  }

  public function setState(_state:TechThingState):Void {
    prevState = state;
    state = _state;
  }


  private function onDragStart(sprite:FlxExtendedSprite, _x:Float, _y:Float):Void {
  }

  private function onDragStop(sprite:FlxExtendedSprite, _x:Float, _y:Float):Void {
    machineEntrance.stopHint();
    coffinEntrance.stopHint();
    Log.trace(state);
    switch(state) {
      case TechThingState.Candidate:
        if (machineEntrance.relatedItem == this) {
          x = machineEntrance.getMidpoint().x - width/2;
          y = machineEntrance.getMidpoint().y - height/2;
          setState(TechThingState.Selected);

          if(machineEntrance.handleDrop != null) {
            machineEntrance.handleDrop(this);
          }
        }
      case TechThingState.ProcessFinished:
        Log.trace(coffinEntrance.relatedItem);
        if (coffinEntrance.relatedItem == this) {
          coffinEntrance.handleDrop(this);
          setState(TechThingState.Buried);
          machine.currentTechThing = null;
        }
      default:
    }
  }
}


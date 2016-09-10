package sprites;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxCollision;
import GameConfig.TechThingConfig;
import GameConfig.ProcedureType;
import sprites.TechThing.TechThingState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;

enum TechThingState {
  Standby;
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

  var hover = false;

  var hitbox:FlxSprite;

  public function new(X:Float = 0, Y:Float = 0, _machine:Machine, _coffinEntrance:Dropable<TechThing>, _config:TechThingConfig) {
    super(X, Y);

    machine = _machine;
    machineEntrance = _machine.entrance;
    coffinEntrance = _coffinEntrance;
    config = _config;

    originalX = X;
    originalY = Y;

    state = TechThingState.Standby;

    loadGraphic(config.image);

    if (config.imageHitbox != null) {
      hitbox = new FlxSprite(x, y);
      hitbox.loadGraphic(config.imageHitbox);
    } else {
      hitbox = this;
    }
  }

  public function toAfter() {
    loadGraphic(config.imageAfter);
  }

  // Only changed the checked target when pixelPerfectPointCheck()
  override private function checkForClick():Void
  {
    #if !FLX_NO_MOUSE
    if (mouseOver && FlxG.mouse.justPressed)
    {
      //	If we don't need a pixel perfect check, then don't bother running one! By this point we know the mouse is over the sprite already
      if (_clickPixelPerfect == false && _dragPixelPerfect == false)
      {
        FlxMouseControl.addToStack(this);
        return;
      }

      if (_clickPixelPerfect && FlxCollision.pixelPerfectPointCheck(Math.floor(FlxG.mouse.x), Math.floor(FlxG.mouse.y), hitbox, _clickPixelPerfectAlpha))
      {
        FlxMouseControl.addToStack(this);
        return;
      }

      if (_dragPixelPerfect && FlxCollision.pixelPerfectPointCheck(Math.floor(FlxG.mouse.x), Math.floor(FlxG.mouse.y), hitbox, _dragPixelPerfectAlpha))
      {
        FlxMouseControl.addToStack(this);
        return;
      }
    }
    #end
  }

  override public function update(elasped:Float):Void {
    super.update(elasped);
    if (
      draggable && !isDragged &&
      !FlxMouseControl.isDragging &&
      FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), hitbox)
    ) {
      if (!hover) {
        GameData.dragHoverCount += 1;
        hover = true;
      }
      color = 0x7F7F7F;
    } else {
      color = FlxColor.WHITE;
      if (hover) {
        GameData.dragHoverCount -= 1;
        hover = false;
      }
    }

    if (state == TechThingState.Standby && GameData.hatchinOpened) {
      setState(TechThingState.Candidate);
    } else if (state == TechThingState.Candidate && !GameData.hatchinOpened) {
      setState(TechThingState.Standby);
    }

    switch(state) {
      case TechThingState.Standby:
        handleStandby();
      case TechThingState.Candidate:
        handleCandidate();
      case TechThingState.ProcessFinished:
        handleProcessFinished();
      default:
        if (draggable) { disableMouseDrag(); }
    }


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

  function handleStandby() {
    if (!draggable && machine.currentTechThing == null) {
      enableDrag();
      return;
    }
  }

  function handleCandidate() {
    if (!draggable && machine.currentTechThing == null) {
      enableDrag();
      return;
    }

    if (isDragged) {
      if (getMidpoint().inCoords(machineEntrance.x, machineEntrance.y, machineEntrance.body.width, machineEntrance.body.height)) {
//        haxe.Log.trace("onDrop");
        machineEntrance.setHover(true, this);
//        machineEntrance.stopHint();
      } else {
//        haxe.Log.trace("not onDrop");
        machineEntrance.setHover(false);
//        machineEntrance.showHint();
      }
    }
  }

  function handleProcessFinished() {
    if (!draggable) {
      hitbox = this;
      enableDrag();
      return;
    }
    if (isDragged) {
      if (getMidpoint().inCoords(coffinEntrance.x, coffinEntrance.y, coffinEntrance.body.width, coffinEntrance.body.height)) {
        coffinEntrance.setHover(true, this);
//        coffinEntrance.stopHint();
      } else {
        coffinEntrance.setHover(false);
//        coffinEntrance.showHint();
      }
    }
  }

  public function enableDrag():Void {
    mouseStartDragCallback = onDragStart;
    mouseStopDragCallback = onDragStop;

    enableMouseDrag(false, true, 1);
  }

  public function setState(_state:TechThingState):Void {
    prevState = state;
    state = _state;
  }


  private function onDragStart(sprite:FlxExtendedSprite, _x:Float, _y:Float):Void {
    scale.x = scale.y = 1.08;
  }

  private function onDragStop(sprite:FlxExtendedSprite, _x:Float, _y:Float):Void {
    scale.x = scale.y = 1;
//    machineEntrance.stopHint();
//    coffinEntrance.stopHint();
//    Log.trace(state);
    switch(state) {
      case TechThingState.Candidate:
        if (machineEntrance.relatedItem == this) {
          x = machineEntrance.body.getMidpoint().x - width/2 + 15;
          y = machineEntrance.y + 15;
          color = 0x7F7F7F;
          });
          setState(TechThingState.Selected);

          if(machineEntrance.handleDrop != null) {
            machineEntrance.handleDrop(this);
          }
        }
      case TechThingState.ProcessFinished:
        if (coffinEntrance.relatedItem == this) {

          x = coffinEntrance.body.getMidpoint().x - width/2;
          y = coffinEntrance.y;
          FlxTween.linearMotion(this, x, y, x, y+100, 0.8, true, {
            ease: FlxEase.bounceOut
          });

          setState(TechThingState.Buried);

          coffinEntrance.handleDrop(this);
          machine.closeExit();
          GameData.finishedTechThings.push(config);

          machine.currentTechThing = null;
        }
      default:
    }
  }
}


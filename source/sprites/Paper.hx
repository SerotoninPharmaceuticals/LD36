package sprites;

#if flash
import flash.ui.MouseCursor;
import flash.ui.Mouse;
#end

import flixel.util.FlxCollision;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic.FlxType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class Paper extends FlxTypedGroup<FlxSprite> {
  var opened = false;
  var onOpen:FlxSprite->Void;

  var paper:FlxSprite;

  var largeImage:String;
  var paperSound:FlxSound;

  var hover = false;

  public function new(X:Float = 0, Y:Float = 0, image:String, _largeImage:String, _onOpen:FlxSprite->Void) {
    super();
    paper = new FlxSprite(X, Y);
    paper.loadGraphic(image);


    largeImage = _largeImage;
    onOpen = _onOpen;

    paperSound = FlxG.sound.load("assets/sounds/paper.wav", 0.6, false);

    add(paper);
  }

  override public function update(elasped:Float):Void {
    handleClick();

    #if flash
    if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), paper)) {
      if (!hover) {
        Mouse.cursor = MouseCursor.BUTTON;
        hover = true;
      }
    } else {
      if (hover) {
        Mouse.cursor = MouseCursor.ARROW;
        hover = false;
      }
    }
    #end
    super.update(elasped);
  }

  function handleClick() {
    if (FlxG.mouse.justPressed && !opened) {
      if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), paper)) {
//      if (paper.pixels.getPixel(FlxG.mouse.x, FlxG.mouse.y) != FlxColor.TRANSPARENT) {
        var largePaper = new FlxSprite(50, 0);
        paperSound.play();
        largePaper.loadGraphic(largeImage);
        onOpen(largePaper);
      }
    }
  }
}


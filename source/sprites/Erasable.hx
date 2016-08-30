package sprites;

import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import flixel.FlxSprite;

class Erasable extends FlxTypedGroup<FlxSprite> {
  public var brush:FlxSprite;
  public var eraseEnabled = false;
  public var percentage:Float = 1.0;

  var imageBack:String;
  var imageFront:String;

  var x:Int;
  var y:Int;

  var origin:FlxSprite;
  var dirt:FlxSprite;

  var brushRadius = 10;

  var dirtTotalsPxCount:Int;
  var dirtCurrPxCount:Int;

  var lastBrushX:Float = 0.0;
  var lastBrushY:Float = 0.0;

  var drawMode = false;

  public function new(_x:Int, _y:Int, _imageBack:String, _imageFront:String, _brushRaidus:Int, _drawMode = false):Void {
    super();

    drawMode = _drawMode;
    trace(drawMode);

    x = _x;
    y = _y;
    imageBack = _imageBack;
    imageFront = _imageFront;
    brushRadius = _brushRaidus;
    trace(imageFront);

    origin = new FlxSprite(x - 198, y - 48); // dirty fix.
    origin.loadGraphic(imageBack, false, 0, 0, true);

    if (drawMode) {
      var toDraw = new FlxSprite(x - 198, y - 48); // dirty fix.
      toDraw.loadGraphic(imageFront, false, 0, 0, true);
      add(toDraw);

      dirt = new FlxSprite(x - 198, y - 48); // dirty fix.
      dirt.loadGraphic(imageFront, false, 0, 0, true);
      dirt.updateFramePixels();
      colorOverlay(dirt.framePixels, GameConfig.SCREEN_BG_COLOR);
    } else {
      dirt = new FlxSprite(x - 198, y - 48); // dirty fix.
      dirt.loadGraphic(imageFront, false, 0, 0, true);
      dirt.updateFramePixels();
    }

    brush = new FlxSprite();
    brush.makeGraphic(brushRadius*2, brushRadius*2, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(brush, brushRadius, brushRadius, brushRadius, FlxColor.YELLOW);

    add(origin);
    add(dirt);
    if (GameConfig.DEBUG) {
//      add(brush); // for TEST
    }
    dirtTotalsPxCount = getSolidPixelsCount(dirt.pixels);
  }

  function colorOverlay(bitmap:BitmapData, _color:FlxColor) {
    var color:FlxColor;
    for (y in 0...bitmap.height) {
      for (x in 0...bitmap.width) {
        color = FlxColor.fromInt(bitmap.getPixel32(x, y));
        if (color.alpha != 0) {
          bitmap.setPixel32(x, y, _color);
        }
      }
    }
  }

  var updated = false;

  override public function draw() {
    super.draw();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    handleErase();
  }

  private function handleErase():Void {
    if (
      eraseEnabled &&
      brush.getPosition().inCoords(origin.x, origin.y, origin.width, origin.height)
    ) {
//      origin.pixels.copyPixels(source.pixels, new Rectangle(brush.x, brush.y, brush.pixels.rect.width, brush.pixels.rect.height), new Point(brush.x, brush.y), brush.pixels);
      for (innerY in 0...Std.int(brush.height)) {
        var start = -1;
        var end = -1;
        for(innerX in 0...Std.int(brush.width)) {
          if (start == -1) {
            if (brush.pixels.getPixel(innerX, innerY) != FlxColor.TRANSPARENT) {
              start = innerX;
            }
          } else if (end == -1) {
            if (brush.pixels.getPixel(innerX, innerY) == FlxColor.TRANSPARENT) {
              end = innerX;
              break;
            }
          }
        }
        if (end == -1) { end = Std.int(brush.width); }

        dirt.framePixels.colorTransform(new Rectangle(brush.x + start - x, brush.y + innerY - y, end - start, 1), new ColorTransform(0, 0, 0, 0));
      }

      // Reduce the frequence of counting.

      if (Math.abs(lastBrushX - brush.x) > 10 || Math.abs(lastBrushY - brush.y) > 10) {
        countPercentage();
        lastBrushX = brush.x;
        lastBrushY = brush.y;
      }
    }
  }

  private function getSolidPixelsCount(bitmap:BitmapData):Int {
    var count = 0;
    var color:FlxColor;
    for (y in 0...bitmap.height) {
      for (x in 0...bitmap.width) {
        color = FlxColor.fromInt(bitmap.getPixel32(x, y));
        if (color.alpha != 0 && (color.red != 0 || color.blue != 0 || color.green != 0)) {
          count += 1;
        }
      }
    }
    return count;
  }

  private function countPercentage() {
    percentage = getSolidPixelsCount(dirt.framePixels) / dirtTotalsPxCount;
  }
}

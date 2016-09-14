package sprites;

import Std;
import Std;
import Std;
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
  public var border:Int = 2;
  public var borderColor:FlxColor = GameConfig.SCREEN_COLOR_YELLOW;

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

  public function new(_x:Int, _y:Int, _imageBack:String, _pattern:String, _brushRaidus:Int, _drawMode = false):Void {
    super();

    drawMode = _drawMode;

    x = _x;
    y = _y;
    imageBack = _imageBack;
    brushRadius = _brushRaidus;

    origin = new FlxSprite(x - 198, y - 48); // dirty fix.
    origin.loadGraphic(imageBack, false, 0, 0, true);

    var outlineBitmap:BitmapData = drawOutline(origin.framePixels, border, borderColor);
    var outline:FlxSprite = new FlxSprite(x - 198 - border, y - 48 - border);
    outline.makeGraphic(outlineBitmap.width, outlineBitmap.height, 0, true);
    outline.updateFramePixels(); // required
    outline.framePixels = outlineBitmap;

    var pattern = new FlxSprite(0, 0);
    pattern.loadGraphic(_pattern);
    var patternBitmap = pattern.framePixels;

    if (drawMode) {
      var toDraw = new FlxSprite(x - 198, y - 48); // dirty fix.
      toDraw.makeGraphic(Std.int(origin.width), Std.int(origin.height), 0, true);
      toDraw.updateFramePixels();
      toDraw.framePixels = patternOverlay(origin.framePixels, patternBitmap);
      add(toDraw);

      dirt = new FlxSprite(x - 198, y - 48); // dirty fix.
      dirt.makeGraphic(Std.int(origin.width), Std.int(origin.height), 0, true);
      dirt.updateFramePixels(); // required
      dirt.framePixels = toDraw.framePixels.clone();
      colorOverlay(dirt.framePixels, GameConfig.SCREEN_BG_COLOR);
    } else {
      dirt = new FlxSprite(x - 198, y - 48); // dirty fix.
      dirt.makeGraphic(Std.int(origin.width), Std.int(origin.height), 0, true);
      dirt.updateFramePixels(); // required
      dirt.framePixels = patternOverlay(origin.framePixels, patternBitmap);
    }

    brush = new FlxSprite();
    brush.makeGraphic(brushRadius*2, brushRadius*2, FlxColor.TRANSPARENT, true);
    FlxSpriteUtil.drawCircle(brush, brushRadius, brushRadius, brushRadius, FlxColor.YELLOW);

//    add(origin);
    add(outline);
    add(dirt);

    if (GameConfig.DEBUG) {
      add(brush); // for TEST
    }

    dirtTotalsPxCount = getSolidPixelsCount(dirt.framePixels);
  }

  function drawOutline(b:BitmapData, border:Int, borderColor:FlxColor):BitmapData {
    var nb = new BitmapData(b.width + border*2, b.height + border*2, true, 0);
    for (y in 0...nb.height) {
      for (x in 0...nb.width) {
        if (b.getPixel(x - border, y - border) > 0) { continue; }

        var bytes = b.getPixels(new Rectangle(x - border*2, y - border*2, border*2 + 1, border*2 + 1));
        var hasPixel = false;
        for (i in 0...bytes.length) {
          if (bytes[i] == 255) {
            hasPixel = true;
            break;
          }
        }
        if (hasPixel) {
          nb.setPixel32(x, y, borderColor);
        }
      }
    }
    return nb;
  }

  function patternOverlay(target:BitmapData, pattern:BitmapData):BitmapData {
    var nb = new BitmapData(target.width, target.height, true, 0);
    var drawed = 0;
    for (y in 0...nb.height) {
      for (x in 0...nb.width) {
        if (target.getPixel(x, y) == 0) { continue; }
        drawed += 1;
        nb.setPixel32(x, y, pattern.getPixel32(x % pattern.width, y % pattern.height));
      }
    }
    return nb;
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
      brush.getPosition().inCoords(dirt.x, dirt.y, dirt.width, dirt.height)
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

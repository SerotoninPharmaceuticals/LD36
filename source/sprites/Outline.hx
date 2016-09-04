package sprites;

import Std;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;

class Outline extends FlxTypedGroup<FlxSprite> {
  public var border:Int = 3;
  public var borderColor:FlxColor = GameConfig.SCREEN_COLOR_YELLOW;

  var imageBack:String;

  var x:Int;
  var y:Int;

  var origin:FlxSprite;
  var dirt:FlxSprite;

  public function new(_x:Int, _y:Int, _imageBack:String):Void {
    super();

    x = _x;
    y = _y;
    imageBack = _imageBack;

    origin = new FlxSprite(x - 198, y - 48); // dirty fix.
    origin.loadGraphic(imageBack, false, 0, 0, true);
    origin.updateFramePixels(); // required
    origin.alpha = 0.5;


    var outlineBitmap:BitmapData = drawOutline(origin.framePixels, border, borderColor);
    var outline:FlxSprite = new FlxSprite(x - 198 - border, y - 48 - border);
    outline.makeGraphic(outlineBitmap.width, outlineBitmap.height, 0, true);
    outline.updateFramePixels(); // required
    outline.framePixels = outlineBitmap;

    add(origin);
    add(outline);
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
}

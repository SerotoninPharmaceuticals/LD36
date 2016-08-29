package sprites;

import Std;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;

class Dropable<T> extends FlxSprite {
  public var relatedItem:T;
  public var isItemPlaced:Bool = false;
  public var handleDrop:T->Void;

  private var brightnessTween:ColorTween = null;

  var isHover:Bool = false;

  var normalImage:String;
  var onDropImage:String;

  public function new(X:Float = 0, Y:Float = 0, _normalImage:String, _onDropImage:String) {
    super(X, Y);

    normalImage = _normalImage;
    onDropImage = _onDropImage;

    setHover(isHover);
  }

  override public function update(elasped:Float):Void {
    super.update(elasped);
  }

  public function showHint():Void {
    if (brightnessTween == null) {
      trace("Hint");
      var stopColor = FlxColor.fromRGB(255, 255, 255);
      stopColor.brightness = 0.5;
      brightnessTween = FlxTween.color(this, 0.8, FlxColor.WHITE, stopColor,
                                       { type: FlxTween.PINGPONG });
    }
  }

  public function stopHint():Void {
    if (brightnessTween != null) {
      trace("Stop hint");
      brightnessTween.cancel();
      brightnessTween = null;
      color = FlxColor.WHITE;
    }
  }

  public function setHover(_isHover:Bool = true, ?_item:T):Void {
    isHover = _isHover;
    relatedItem = _item;
    if (isHover) {
      if (onDropImage != null) {
        loadGraphic(onDropImage);
      } else {
        makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT);
      }
    } else {
      if (normalImage != null) {
        loadGraphic(normalImage);
      } else {
        makeGraphic(Std.int(width), Std.int(height), FlxColor.TRANSPARENT);
      }
    }
  }
}


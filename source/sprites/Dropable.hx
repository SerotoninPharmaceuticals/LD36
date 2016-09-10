package sprites;

import flixel.group.FlxGroup.FlxTypedGroup;
import Std;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;

class Dropable<T> extends FlxTypedGroup<FlxSprite> {
  public var relatedItem:T;
  public var isItemPlaced:Bool = false;
  public var handleDrop:T->Void;
  public var x:Float;
  public var y:Float;
  public var body:FlxSprite;
  public var hintArrow:FlxSprite;

  private var brightnessTween:ColorTween = null;

  var isHover:Bool = false;

  var normalImage:String;
  var onDropImage:String;

  public function new(X:Float = 0, Y:Float = 0, _normalImage:String, _onDropImage:String) {
    super();
    normalImage = _normalImage;
    onDropImage = _onDropImage;

    x = X;
    y = Y;

    body = new FlxSprite(x, y);
    add(body);

    loadHintArrow();

    setHover(isHover);
  }

  override public function update(elasped:Float):Void {
    super.update(elasped);
  }

  public function loadHintArrow() {
    hintArrow = new FlxSprite(x, y);
    hintArrow.loadGraphic(GameConfig.IMAGE_PATH + "arrow.png");
    add(hintArrow);
    hintArrow.kill();
  }

  public function showHint():Void {
    if (brightnessTween == null) {
      var stopColor = FlxColor.fromRGB(255, 255, 255);
      stopColor.brightness = 0.5;
      brightnessTween = FlxTween.color(body, 0.8, FlxColor.WHITE, stopColor,
                                       { type: FlxTween.PINGPONG });
    }
  }

  public function stopHint():Void {
    if (brightnessTween != null) {
      brightnessTween.cancel();
      brightnessTween = null;
      body.color = FlxColor.WHITE;
    }
  }

  public function setHover(_isHover:Bool = true, _item:T = null):Void {
    isHover = _isHover;
    relatedItem = _item;
    if (isHover) {
      if (onDropImage != null) {
        body.loadGraphic(onDropImage);
      } else {
        body.makeGraphic(Std.int(body.width), Std.int(body.height), FlxColor.TRANSPARENT);
      }
      if (relatedItem != null) {
        var target = cast(relatedItem, FlxSprite);
        hintArrow.x = target.x + target.width/2 - hintArrow.width/2 - 2;
        hintArrow.y = target.y + target.height - 2;
        hintArrow.revive();
      }
    } else {
      if (normalImage != null) {
        body.loadGraphic(normalImage);
      } else {
        body.makeGraphic(Std.int(body.width), Std.int(body.height), FlxColor.TRANSPARENT);
      }
      hintArrow.kill();
    }
  }
}


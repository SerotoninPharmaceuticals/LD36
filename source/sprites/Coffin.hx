package sprites;

import openfl.geom.Point;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;


class Coffin extends FlxTypedGroup<FlxSprite> {
  var x:Float;
  var y:Float;

  var techThingsPoint = new Point(10, 10);
  var techThingMargin = 50.0;

  public var body:Dropable<TechThing>;
  public var techThingCount:Int = 0;

  public function new(_x:Float = 0.0, _y:Float = 0.0) {
    super();

    x = _x;
    y = _y;

    body = new Dropable<TechThing>(_x, _y, GameConfig.IMAGE_PATH + "coffin.png", GameConfig.IMAGE_PATH + "coffin.png");
    add(body);
    body.handleDrop = handleDrop;
  }

  function handleDrop(item:TechThing):Void {
    techThingCount += 1;

    body.setHover(false, item);
  }

  override public function update(elasped:Float):Void {
    super.update(elasped);
  }
}


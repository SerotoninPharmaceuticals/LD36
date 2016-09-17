package ui;

import libs.FloatUtil;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class CoordText extends FlxSpriteGroup {
	
  private var coordxText:FlxText;
  private var coordyText:FlxText;
  private var coordxValue:FlxText;
  private var coordyValue:FlxText;

  public function new():Void {
    super(200, 185, 0);
	
    coordxText = new FlxText(0, 0, 0, "Coord.X:");
    coordxValue = new FlxText(53, 0, 0, "n/a");
    coordyText = new FlxText(77, 0, 0, "Y:");
    coordyValue = new FlxText(90, 0, 0, "n/a");

    coordxText.alignment = coordyText.alignment = coordxValue.alignment = coordyValue.alignment = FlxTextAlign.LEFT;
    coordxText.size = coordyText.size = coordxValue.size = coordyValue.size = 10;
    coordxText.color = coordyText.color = coordxValue.color = coordyValue.color = GameConfig.SCREEN_COLOR_YELLOW;
	
    add(coordxText);
    add(coordxValue);
    add(coordyText);
    add(coordyValue);
  }

  public function setPos(x:Float, y:Float) {
    coordxValue.text = "" + Math.floor(x - MachineState.SCREEN_X);
    coordyValue.text = "" + Math.floor(y - MachineState.SCREEN_Y);
  }
}

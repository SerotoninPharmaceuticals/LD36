package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

import ui.TimerBar;


class IntroState extends FlxState {

  private var pressed:Bool = false;

  override public function create():Void {
    super.create();
    createTimerBar();
    createText();
  }

  private function createTimerBar():Void {
    var timerBar = new TimerBar(-50, 100, 0, 0.6);
    timerBar.start();
    add(timerBar);
  }

  private function createText():Void {
    var titleText = new FlxText(0, 120, 800, "A FUNERAL");
    titleText.setFormat("assets/fonts/Avera-Sans-Cn-Lt.ttf", 120, FlxColor.WHITE, CENTER);
    var text0 = new FlxText(0, 350, 800, "A short game for Ludum Dare 36");
    text0.setFormat("assets/fonts/Avera-Sans-Cn-Lt.ttf", 24, FlxColor.WHITE, CENTER);
    var text1 = new FlxText(0, 380, 800, "click anywhere to start");
    text1.setFormat("assets/fonts/Avera-Sans-Cn-Lt.ttf", 18, FlxColor.WHITE, CENTER);
    add(titleText);
    add(text0);
    add(text1);
  }

  override public function update(elapsed:Float):Void {
    if (FlxG.mouse.justPressed && !pressed) {
      pressed = true;
      fadeOut();
    }
    super.update(elapsed);
  }

  private function fadeOut():Void {
    FlxG.camera.fade(FlxColor.BLACK, 1, false, startPlayState, true);
  }

  private function startPlayState() {
    FlxG.switchState(new PlayState());
  }

}

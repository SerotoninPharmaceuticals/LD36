package;

import sprites.Erasable;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

import ui.TimerBar;


class IntroState extends FlxState {

  private var pressed:Bool = false;
  var sound:FlxSound;

  override public function create():Void {
    super.create();
    FlxG.mouse.useSystemCursor = true;
    createTitleScreen();
    createTimerBar();
    createText();
    sound = FlxG.sound.load("assets/sounds/ambient.wav", 0.8, false);
    sound.play();
  }

  private function createTitleScreen():Void {
    var titlescreen = new FlxSprite();
    titlescreen.loadGraphic("assets/images/titlescreen.png");
    add(titlescreen);
  }

  private function createTimerBar():Void {
    var timerBar = new TimerBar(-50, 90, 0, 0.6);
    timerBar.start();
    add(timerBar);
  }

  private function createText():Void {
    var titletext = new FlxSprite(304,135);
    titletext.loadGraphic("assets/images/titletext.png");
        add(titletext);
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
    sound.fadeOut(1);
  }

  private function startPlayState() {
    FlxG.switchState(new PlayState());
  }

}

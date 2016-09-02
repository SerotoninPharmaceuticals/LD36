package sprites;

import openfl.Assets;
import flixel.util.FlxCollision;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxBasic.FlxType;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class Paper extends FlxTypedGroup<FlxSprite> {
  var opened = false;
  var onOpen:FlxSprite->(Void->Void)->Void;

  var paper:FlxSprite;
  var hitbox:FlxSprite;

  var largeImage:String;
  var paperSound:FlxSound;

  var hover = false;

  public function new(X:Float = 0, Y:Float = 0, name:String, _onOpen:FlxSprite->(Void->Void)->Void) {
    super();
    paper = new FlxSprite(X, Y);
    var image:String = GameConfig.IMAGE_PATH + name + '_small.png';

    paper.loadGraphic(image);
    largeImage = GameConfig.IMAGE_PATH + name + '.png';

    if (Assets.exists(GameConfig.IMAGE_PATH + name + "_small_hitbox.png")) {
      hitbox = new FlxSprite(X, Y);
      hitbox.loadGraphic(GameConfig.IMAGE_PATH + name + "_small_hitbox.png");
      trace("loaded hitbox");
    } else {
      hitbox = paper;
    }

    onOpen = _onOpen;

    paperSound = FlxG.sound.load("assets/sounds/paper.wav", 0.6, false);

    add(paper);
  }

  override public function update(elasped:Float):Void {
    handleClick();

    if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), hitbox)) {
      if (!hover) {
        GameData.hoverCount += 1;
        hover = true;
      }
    } else {
      if (hover) {
        GameData.hoverCount -= 1;
        hover = false;
      }
    }

    super.update(elasped);
  }

  function handleClick() {
    if (FlxG.mouse.justPressed && !opened) {
      if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), hitbox)) {
        var largePaper = new FlxSprite(50, 0);
        paperSound.play();
        largePaper.loadGraphic(largeImage);

        paper.kill();

        onOpen(largePaper, function() {
          paper.revive();
        });
      }
    }
  }
}


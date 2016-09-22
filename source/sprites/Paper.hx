package sprites;

import openfl.Assets;
import flixel.util.FlxCollision;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;

class Paper extends FlxTypedGroup<FlxSprite> {
  var opened = false;
  var onOpen:FlxSprite->(Void->Void)->Void;

  var paper:FlxSprite;
  var hitbox:FlxSprite;

  var largeImage:String;
  var indexName:String;
  var paperSound:FlxSound;
  var phoneSound:FlxSound;

  var hover = false;
  private var iniOn:Bool;

  public function new(X:Float = 0, Y:Float = 0, name:String, _onOpen:FlxSprite->(Void->Void)->Void, startOn:Bool = false) {
    super();
    iniOn = startOn;
    indexName = name;
    paper = new FlxSprite(X, Y);
    var image:String = GameConfig.IMAGE_PATH + name + '_small.png';

    paper.loadGraphic(image);
    largeImage = GameConfig.IMAGE_PATH + name + '.png';

    if (Assets.exists(GameConfig.IMAGE_PATH + name + "_small_hitbox.png")) {
      hitbox = new FlxSprite(X, Y);
      hitbox.loadGraphic(GameConfig.IMAGE_PATH + name + "_small_hitbox.png");
    } else {
      hitbox = paper;
    }

    onOpen = _onOpen;

    paperSound = FlxG.sound.load("assets/sounds/paper.wav", 0.6, false);
    phoneSound = FlxG.sound.load("assets/sounds/phone.wav", 0.5, false);

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
    if(iniOn) {
      var largePaper = new FlxSprite(50, 0);
      phoneSound.play();
      largePaper.loadGraphic(GameConfig.IMAGE_PATH + "phone.png");
	  
      paper.kill();
      GameData.reading = true;

      onOpen(largePaper, function() {
        GameData.reading = false;
        paper.revive();
        iniOn = false;
      });
    }
	  
    if (FlxG.mouse.justPressed && !opened) {
      if (FlxCollision.pixelPerfectPointCheck(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y), hitbox)) {
        var largePaper = new FlxSprite(50, 0);
        if (indexName == "phone") phoneSound.play();
        else paperSound.play();
        largePaper.loadGraphic(largeImage);

        paper.kill();
        GameData.reading = true;

        onOpen(largePaper, function() {
          GameData.reading = false;
          paper.revive();
        });
      }
    }
  }
}


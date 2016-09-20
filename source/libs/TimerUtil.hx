package libs;
import flixel.util.FlxTimer;

class TimerUtil {
  public static function progressivelyLoad(funcArr:Array<Void->Void>, time:Float) {
    var len = funcArr.length;
    for (i in 0...len) {
      var delay = (i + Math.random()) * time/len;
      var timer = new FlxTimer();
      timer.start(delay, function(t:FlxTimer) { funcArr[i](); });
    }
  }
}

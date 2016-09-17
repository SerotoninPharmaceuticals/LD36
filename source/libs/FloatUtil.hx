package libs;

class FloatUtil
{
  public static function fixedFloat(n:Float, prec:Int = 2){
    n = Math.round(n * Math.pow(10, prec));
    var str:String = ''+n;
    var len = str.length;
    if(len <= prec){
      while(len < prec){
        str = '0'+str;
        len++;
      }
      return '0.'+str;
    }
    else{
      return str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec);
    }
  }
}

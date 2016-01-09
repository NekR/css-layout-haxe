package csslayout;

class Assert {
  public static function notNull(something: Null<Dynamic>) {
    if (something == null) {
      throw "Something is null";
    }
  }
}
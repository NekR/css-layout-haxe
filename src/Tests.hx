package;

import haxe.unit.TestRunner;
import tests.LayoutEngineTest;
import tests.LayoutCachingTest;
import tests.CSSNodeTest;

class Tests {
  static function main() {
    var tests = new haxe.unit.TestRunner();

    tests.add(new LayoutEngineTest());
    tests.add(new LayoutCachingTest());
    tests.add(new CSSNodeTest());
    tests.run();
  }
}
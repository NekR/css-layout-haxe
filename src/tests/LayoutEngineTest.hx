/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */
package tests;

import haxe.unit.TestCase;

import csslayout.CSSNode;
import csslayout.CSSLayout;
import csslayout.Spacing;
import csslayout.CSSFlexDirection;
import csslayout.CSSJustify;
import csslayout.CSSWrap;
import csslayout.CSSDirection;
import csslayout.CSSPositionType;
import csslayout.CSSAlign;
import csslayout.CSSConstants;

class TestCSSNode extends CSSNode {
  public var context: String = null;

  override public function getChildAt(i: Int): TestCSSNode {
    return cast (super.getChildAt(i), TestCSSNode);
  }

  public function new() {
    super();
  }
}

/**
 * Tests for {@link LayoutEngine}
 */
class LayoutEngineTest extends TestCase {
  private static var DIMENSION_HEIGHT = CSSLayout.DIMENSION_HEIGHT;
  private static var DIMENSION_WIDTH = CSSLayout.DIMENSION_WIDTH;
  private static var POSITION_BOTTOM = CSSLayout.POSITION_BOTTOM;
  private static var POSITION_LEFT = CSSLayout.POSITION_LEFT;
  private static var POSITION_RIGHT = CSSLayout.POSITION_RIGHT;
  private static var POSITION_TOP = CSSLayout.POSITION_TOP;

  private function sTestMeasureFunction(node: CSSNode, width: Float, height: Float): Array<Float> {
    var testNode = cast (node, TestCSSNode);

    if (testNode.context == TestConstants.SMALL_TEXT) {
      if (CSSConstants.isUndefined(width)) {
        width = 10000000;
      }

      return [Math.min(width, TestConstants.SMALL_WIDTH), TestConstants.SMALL_HEIGHT];
    } else if (testNode.context == TestConstants.LONG_TEXT) {
      if (CSSConstants.isUndefined(width)) {
        width = 10000000;
      }

      return [
        width >= TestConstants.BIG_WIDTH ? TestConstants.BIG_WIDTH : Math.max(TestConstants.BIG_MIN_WIDTH, width),
        width >= TestConstants.BIG_WIDTH ? TestConstants.SMALL_HEIGHT : TestConstants.BIG_HEIGHT
      ];
    } else if (testNode.context == TestConstants.MEASURE_WITH_RATIO_2) {
      if (width > 0) {
        return [width, width * 2];
      } else if (height > 0) {
        return [height * 2, height];
      } else {
        return [99999, 99999];
      }
    } else {
      throw "Got unknown test: " + testNode.context;
    }
  }

  private function performTest(message: String, style: CSSNode, expectedLayout: CSSNode) {
    style.calculateLayout();
    assertLayoutsEqual(message, style, expectedLayout);
  }

  private function addChildren(node: TestCSSNode, numChildren: Int) {
    for (i in 0...numChildren) {
      node.addChildAt(new TestCSSNode(), i);
    }
  }

  private function assertLayoutsEqual(message: String, actual: CSSNode, expected: CSSNode) {
    var passed = areLayoutsEqual(actual, expected);

    if (!passed) {
      // trace(message + "\nActual:\n" + actual.toString() + "\nExpected:\n" + expected.toString());
      trace('Error: ' + message);
    }

    assertTrue(passed);
  }

  private function areLayoutsEqual(a: CSSNode, b: CSSNode): Bool {
    var doNodesHaveSameLayout =
        areFloatsEqual(a.layout.position[POSITION_LEFT], b.layout.position[POSITION_LEFT]) &&
        areFloatsEqual(a.layout.position[POSITION_TOP], b.layout.position[POSITION_TOP]) &&
        areFloatsEqual(a.layout.dimensions[DIMENSION_WIDTH], b.layout.dimensions[DIMENSION_WIDTH]) &&
        areFloatsEqual(a.layout.dimensions[DIMENSION_HEIGHT], b.layout.dimensions[DIMENSION_HEIGHT]);

    if (!doNodesHaveSameLayout) {
      return false;
    }

    for (i in 0...a.getChildCount()) {
      if (!areLayoutsEqual(a.getChildAt(i), b.getChildAt(i))) {
        return false;
      }
    }

    return true;
  }

  private function areFloatsEqual(a: Float, b: Float): Bool {
    return Math.abs(a - b) < 0.00001;
  }

  /** START_GENERATED **/
  public function testCase0()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
    }

    performTest("should layout a single node with width and height", root_node, root_layout);
  }

  public function testCase1()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 250;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 250;
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 125;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 125;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 500;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 250;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 250;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 750;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 125;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 125;
      }
    }

    performTest("should layout node with children", root_node, root_layout);
  }

  public function testCase2()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 250;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 250;
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 125;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 125;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 500;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 250;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 250;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 250;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 125;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 125;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 125;
      }
    }

    performTest("should layout node with children in reverse", root_node, root_layout);
  }

  public function testCase3()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 500;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.dimensions[DIMENSION_WIDTH] = 250;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 250;
          node_2 = node_1.getChildAt(1);
          node_2.style.dimensions[DIMENSION_WIDTH] = 250;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 250;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 500;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 500;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 250;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 250;
          node_2 = node_1.getChildAt(1);
          node_2.layout.position[POSITION_TOP] = 250;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 250;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 250;
        }
      }
    }

    performTest("should layout node with nested children", root_node, root_layout);
  }

  public function testCase4()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 500;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.dimensions[DIMENSION_WIDTH] = 250;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 250;
          node_2 = node_1.getChildAt(1);
          node_2.style.dimensions[DIMENSION_WIDTH] = 250;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 250;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 500;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 500;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 250;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 250;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 250;
          node_2 = node_1.getChildAt(1);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 250;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 250;
        }
      }
    }

    performTest("should layout node with nested children in reverse", root_node, root_layout);
  }

  public function testCase5()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      node_0.setMargin(Spacing.LEFT, 10);
      node_0.setMargin(Spacing.TOP, 10);
      node_0.setMargin(Spacing.RIGHT, 10);
      node_0.setMargin(Spacing.BOTTOM, 10);
      node_0.setMargin(Spacing.START, 10);
      node_0.setMargin(Spacing.END, 10);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 10;
      node_0.layout.position[POSITION_LEFT] = 10;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
    }

    performTest("should layout node with margin", root_node, root_layout);
  }

  public function testCase6()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      node_0.setMargin(Spacing.LEFT, 10);
      node_0.setMargin(Spacing.TOP, 10);
      node_0.setMargin(Spacing.RIGHT, 10);
      node_0.setMargin(Spacing.BOTTOM, 10);
      node_0.setMargin(Spacing.START, 10);
      node_0.setMargin(Spacing.END, 10);
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 50);
        node_1.setMargin(Spacing.TOP, 50);
        node_1.setMargin(Spacing.RIGHT, 50);
        node_1.setMargin(Spacing.BOTTOM, 50);
        node_1.setMargin(Spacing.START, 50);
        node_1.setMargin(Spacing.END, 50);
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 25);
        node_1.setMargin(Spacing.TOP, 25);
        node_1.setMargin(Spacing.RIGHT, 25);
        node_1.setMargin(Spacing.BOTTOM, 25);
        node_1.setMargin(Spacing.START, 25);
        node_1.setMargin(Spacing.END, 25);
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 10;
      node_0.layout.position[POSITION_LEFT] = 10;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 50;
        node_1.layout.position[POSITION_LEFT] = 50;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 225;
        node_1.layout.position[POSITION_LEFT] = 25;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 360;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with several children", root_node, root_layout);
  }

  public function testCase7()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      node_0.setMargin(Spacing.LEFT, 10);
      node_0.setMargin(Spacing.TOP, 10);
      node_0.setMargin(Spacing.RIGHT, 10);
      node_0.setMargin(Spacing.BOTTOM, 10);
      node_0.setMargin(Spacing.START, 10);
      node_0.setMargin(Spacing.END, 10);
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 50);
        node_1.setMargin(Spacing.TOP, 50);
        node_1.setMargin(Spacing.RIGHT, 50);
        node_1.setMargin(Spacing.BOTTOM, 50);
        node_1.setMargin(Spacing.START, 50);
        node_1.setMargin(Spacing.END, 50);
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 25);
        node_1.setMargin(Spacing.TOP, 25);
        node_1.setMargin(Spacing.RIGHT, 25);
        node_1.setMargin(Spacing.BOTTOM, 25);
        node_1.setMargin(Spacing.START, 25);
        node_1.setMargin(Spacing.END, 25);
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 10;
      node_0.layout.position[POSITION_LEFT] = 10;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 850;
        node_1.layout.position[POSITION_LEFT] = 50;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 675;
        node_1.layout.position[POSITION_LEFT] = 25;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 540;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with several children in reverse", root_node, root_layout);
  }

  public function testCase8()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 300;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 300;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    performTest("should layout rtl with reverse correctly", root_node, root_layout);
  }

  public function testCase9()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 300;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 300;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    performTest("should layout node with row flex direction", root_node, root_layout);
  }

  public function testCase10()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 300;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 900;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 600;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 300;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    performTest("should layout node with row flex direction in rtl", root_node, root_layout);
  }

  public function testCase11()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 300;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 350;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 200;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 300;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    performTest("should layout node based on children main dimensions", root_node, root_layout);
  }

  public function testCase12()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 300;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 350;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 150;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 300;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 150;
      }
    }

    performTest("should layout node based on children main dimensions in reverse", root_node, root_layout);
  }

  public function testCase13()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 200;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 800;
      }
    }

    performTest("should layout node with just flex", root_node, root_layout);
  }

  public function testCase14()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 800;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 800;
      }
    }

    performTest("should layout node with just flex in reverse", root_node, root_layout);
  }

  public function testCase15()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.dimensions[DIMENSION_WIDTH] = 1000;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.flex = 1;
          node_2.style.dimensions[DIMENSION_WIDTH] = 1000;
          addChildren(node_2, 1);
          {
            var node_3;
            node_3 = node_2.getChildAt(0);
            node_3.style.flex = 1;
            node_3.style.dimensions[DIMENSION_WIDTH] = 1000;
          }
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 1000;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 1000;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 1000;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 1000;
          addChildren(node_2, 1);
          {
            var node_3;
            node_3 = node_2.getChildAt(0);
            node_3.layout.position[POSITION_TOP] = 0;
            node_3.layout.position[POSITION_LEFT] = 0;
            node_3.layout.dimensions[DIMENSION_WIDTH] = 1000;
            node_3.layout.dimensions[DIMENSION_HEIGHT] = 1000;
          }
        }
      }
    }

    performTest("should layout node with flex recursively", root_node, root_layout);
  }

  public function testCase16()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
        node_1.style.flex = 1;
        node_1.style.dimensions[DIMENSION_WIDTH] = 1000;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
          node_2.style.flex = 1;
          node_2.style.dimensions[DIMENSION_WIDTH] = 1000;
          addChildren(node_2, 1);
          {
            var node_3;
            node_3 = node_2.getChildAt(0);
            node_3.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
            node_3.style.flex = 1;
            node_3.style.dimensions[DIMENSION_WIDTH] = 1000;
          }
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 1000;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 1000;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 1000;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 1000;
          addChildren(node_2, 1);
          {
            var node_3;
            node_3 = node_2.getChildAt(0);
            node_3.layout.position[POSITION_TOP] = 0;
            node_3.layout.position[POSITION_LEFT] = 0;
            node_3.layout.dimensions[DIMENSION_WIDTH] = 1000;
            node_3.layout.dimensions[DIMENSION_HEIGHT] = 1000;
          }
        }
      }
    }

    performTest("should layout node with flex recursively in reverse", root_node, root_layout);
  }

  public function testCase17()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      node_0.setMargin(Spacing.LEFT, 5);
      node_0.setMargin(Spacing.TOP, 10);
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 15);
        node_1.setMargin(Spacing.TOP, 50);
        node_1.setMargin(Spacing.BOTTOM, 20);
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 30);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 10;
      node_0.layout.position[POSITION_LEFT] = 5;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 50;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 170;
        node_1.layout.position[POSITION_LEFT] = 30;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with targeted margin", root_node, root_layout);
  }

  public function testCase18()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      node_0.setMargin(Spacing.LEFT, 5);
      node_0.setMargin(Spacing.TOP, 10);
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 15);
        node_1.setMargin(Spacing.TOP, 50);
        node_1.setMargin(Spacing.BOTTOM, 20);
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 30);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 10;
      node_0.layout.position[POSITION_LEFT] = 5;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 880;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 730;
        node_1.layout.position[POSITION_LEFT] = 30;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with targeted margin in reverse", root_node, root_layout);
  }

  public function testCase19()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: flex-start", root_node, root_layout);
  }

  public function testCase20()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 800;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: flex-start in reverse", root_node, root_layout);
  }

  public function testCase21()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 800;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: flex-end", root_node, root_layout);
  }

  public function testCase22()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: flex-end in reverse", root_node, root_layout);
  }

  public function testCase23()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.SPACE_BETWEEN;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: space-between", root_node, root_layout);
  }

  public function testCase24()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.SPACE_BETWEEN;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: space-between in reverse", root_node, root_layout);
  }

  public function testCase25()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.SPACE_AROUND;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 200;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 700;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: space-around", root_node, root_layout);
  }

  public function testCase26()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.SPACE_AROUND;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 700;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 200;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: space-around in reverse", root_node, root_layout);
  }

  public function testCase27()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.CENTER;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 400;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 500;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: center", root_node, root_layout);
  }

  public function testCase28()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.CENTER;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 500;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 400;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with justifyContent: center in reverse", root_node, root_layout);
  }

  public function testCase29()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      }
    }

    performTest("should layout node with flex override height", root_node, root_layout);
  }

  public function testCase30()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItems: flex-start", root_node, root_layout);
  }

  public function testCase31()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignItems = CSSAlign.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 800;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItems: flex-start in reverse", root_node, root_layout);
  }

  public function testCase32()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.CENTER;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 400;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 450;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItems: center", root_node, root_layout);
  }

  public function testCase33()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignItems = CSSAlign.CENTER;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 400;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 800;
        node_1.layout.position[POSITION_LEFT] = 450;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItems: center in reverse", root_node, root_layout);
  }

  public function testCase34()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 800;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 900;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItems: flex-end", root_node, root_layout);
  }

  public function testCase35()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignItems = CSSAlign.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 800;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 800;
        node_1.layout.position[POSITION_LEFT] = 900;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItems: flex-end in reverse", root_node, root_layout);
  }

  public function testCase36()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.alignSelf = CSSAlign.CENTER;
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 800;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 450;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignSelf overrides alignItems", root_node, root_layout);
  }

  public function testCase37()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignItems = CSSAlign.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.alignSelf = CSSAlign.CENTER;
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 800;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 800;
        node_1.layout.position[POSITION_LEFT] = 450;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignSelf overrides alignItems in reverse", root_node, root_layout);
  }

  public function testCase38()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.STRETCH;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 1000;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItem: stretch", root_node, root_layout);
  }

  public function testCase39()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignItems = CSSAlign.STRETCH;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 1000;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout node with alignItem: stretch in reverse", root_node, root_layout);
  }

  public function testCase40()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout empty node", root_node, root_layout);
  }

  public function testCase41()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout empty node in reverse", root_node, root_layout);
  }

  public function testCase42()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.LEFT, 5);
        node_1.setMargin(Spacing.TOP, 5);
        node_1.setMargin(Spacing.RIGHT, 5);
        node_1.setMargin(Spacing.BOTTOM, 5);
        node_1.setMargin(Spacing.START, 5);
        node_1.setMargin(Spacing.END, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 10;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 5;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout child with margin", root_node, root_layout);
  }

  public function testCase43()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.LEFT, 5);
        node_1.setMargin(Spacing.TOP, 5);
        node_1.setMargin(Spacing.RIGHT, 5);
        node_1.setMargin(Spacing.BOTTOM, 5);
        node_1.setMargin(Spacing.START, 5);
        node_1.setMargin(Spacing.END, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 10;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 5;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout child with margin in reverse", root_node, root_layout);
  }

  public function testCase44()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should not shrink children if not enough space", root_node, root_layout);
  }

  public function testCase45()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = -200;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should not shrink children if not enough space in reverse", root_node, root_layout);
  }

  public function testCase46()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.CENTER;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
    }

    performTest("should layout for center", root_node, root_layout);
  }

  public function testCase47()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.FLEX_END;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.TOP, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout flex-end taking into account margin", root_node, root_layout);
  }

  public function testCase48()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.FLEX_END;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.TOP, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout flex-end taking into account margin in reverse", root_node, root_layout);
  }

  public function testCase49()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignItems = CSSAlign.FLEX_END;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMargin(Spacing.LEFT, 10);
          node_2.setMargin(Spacing.TOP, 10);
          node_2.setMargin(Spacing.RIGHT, 10);
          node_2.setMargin(Spacing.BOTTOM, 10);
          node_2.setMargin(Spacing.START, 10);
          node_2.setMargin(Spacing.END, 10);
          node_2 = node_1.getChildAt(1);
          node_2.style.dimensions[DIMENSION_HEIGHT] = 100;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 20;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 120;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 20;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 120;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 10;
          node_2.layout.position[POSITION_LEFT] = 10;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 0;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 0;
          node_2 = node_1.getChildAt(1);
          node_2.layout.position[POSITION_TOP] = 20;
          node_2.layout.position[POSITION_LEFT] = 20;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 0;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 100;
        }
      }
    }

    performTest("should layout alignItems with margin", root_node, root_layout);
  }

  public function testCase50()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
        node_1.style.alignItems = CSSAlign.FLEX_END;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMargin(Spacing.LEFT, 10);
          node_2.setMargin(Spacing.TOP, 10);
          node_2.setMargin(Spacing.RIGHT, 10);
          node_2.setMargin(Spacing.BOTTOM, 10);
          node_2.setMargin(Spacing.START, 10);
          node_2.setMargin(Spacing.END, 10);
          node_2 = node_1.getChildAt(1);
          node_2.style.dimensions[DIMENSION_HEIGHT] = 100;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 20;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 120;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 20;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 120;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 110;
          node_2.layout.position[POSITION_LEFT] = 10;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 0;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 0;
          node_2 = node_1.getChildAt(1);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 20;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 0;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 100;
        }
      }
    }

    performTest("should layout alignItems with margin in reverse", root_node, root_layout);
  }

  public function testCase51()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout flex inside of an empty element", root_node, root_layout);
  }

  public function testCase52()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.STRETCH;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.LEFT, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout alignItems stretch and margin", root_node, root_layout);
  }

  public function testCase53()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignItems = CSSAlign.STRETCH;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.LEFT, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout alignItems stretch and margin in reverse", root_node, root_layout);
  }

  public function testCase54()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setPadding(Spacing.LEFT, 5);
      node_0.setPadding(Spacing.TOP, 5);
      node_0.setPadding(Spacing.RIGHT, 5);
      node_0.setPadding(Spacing.BOTTOM, 5);
      node_0.setPadding(Spacing.START, 5);
      node_0.setPadding(Spacing.END, 5);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 10;
    }

    performTest("should layout node with padding", root_node, root_layout);
  }

  public function testCase55()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setPadding(Spacing.LEFT, 5);
      node_0.setPadding(Spacing.TOP, 5);
      node_0.setPadding(Spacing.RIGHT, 5);
      node_0.setPadding(Spacing.BOTTOM, 5);
      node_0.setPadding(Spacing.START, 5);
      node_0.setPadding(Spacing.END, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 10;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 5;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with padding and a child", root_node, root_layout);
  }

  public function testCase56()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setPadding(Spacing.LEFT, 5);
      node_0.setPadding(Spacing.TOP, 5);
      node_0.setPadding(Spacing.RIGHT, 5);
      node_0.setPadding(Spacing.BOTTOM, 5);
      node_0.setPadding(Spacing.START, 5);
      node_0.setPadding(Spacing.END, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.LEFT, 5);
        node_1.setMargin(Spacing.TOP, 5);
        node_1.setMargin(Spacing.RIGHT, 5);
        node_1.setMargin(Spacing.BOTTOM, 5);
        node_1.setMargin(Spacing.START, 5);
        node_1.setMargin(Spacing.END, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 20;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 20;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with padding and a child with margin", root_node, root_layout);
  }

  public function testCase57()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.STRETCH;
        node_1.setPadding(Spacing.LEFT, 10);
        node_1.setPadding(Spacing.TOP, 10);
        node_1.setPadding(Spacing.RIGHT, 10);
        node_1.setPadding(Spacing.BOTTOM, 10);
        node_1.setPadding(Spacing.START, 10);
        node_1.setPadding(Spacing.END, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 20;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 20;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 20;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 20;
      }
    }

    performTest("should layout node with padding and stretch", root_node, root_layout);
  }

  public function testCase58()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setPadding(Spacing.LEFT, 50);
      node_0.setPadding(Spacing.TOP, 50);
      node_0.setPadding(Spacing.RIGHT, 50);
      node_0.setPadding(Spacing.BOTTOM, 50);
      node_0.setPadding(Spacing.START, 50);
      node_0.setPadding(Spacing.END, 50);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.STRETCH;
        node_1.setPadding(Spacing.LEFT, 10);
        node_1.setPadding(Spacing.TOP, 10);
        node_1.setPadding(Spacing.RIGHT, 10);
        node_1.setPadding(Spacing.BOTTOM, 10);
        node_1.setPadding(Spacing.START, 10);
        node_1.setPadding(Spacing.END, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 120;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 120;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 50;
        node_1.layout.position[POSITION_LEFT] = 50;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 20;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 20;
      }
    }

    performTest("should layout node with inner & outer padding and stretch", root_node, root_layout);
  }

  public function testCase59()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.STRETCH;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMargin(Spacing.LEFT, 16);
          node_2.setMargin(Spacing.TOP, 16);
          node_2.setMargin(Spacing.RIGHT, 16);
          node_2.setMargin(Spacing.BOTTOM, 16);
          node_2.setMargin(Spacing.START, 16);
          node_2.setMargin(Spacing.END, 16);
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 32;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 32;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 32;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 32;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 16;
          node_2.layout.position[POSITION_LEFT] = 16;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 0;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 0;
        }
      }
    }

    performTest("should layout node with stretch and child with margin", root_node, root_layout);
  }

  public function testCase60()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.position[POSITION_LEFT] = 5;
      node_0.style.position[POSITION_TOP] = 5;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 5;
      node_0.layout.position[POSITION_LEFT] = 5;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
    }

    performTest("should layout node with top and left", root_node, root_layout);
  }

  public function testCase61()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.SPACE_AROUND;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 10;
      node_0.setPadding(Spacing.TOP, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 10;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 7.5;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with height, padding and space-around", root_node, root_layout);
  }

  public function testCase62()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.position[POSITION_BOTTOM] = 5;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = -5;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
    }

    performTest("should layout node with bottom", root_node, root_layout);
  }

  public function testCase63()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.position[POSITION_TOP] = 10;
      node_0.style.position[POSITION_BOTTOM] = 5;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 10;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
    }

    performTest("should layout node with both top and bottom", root_node, root_layout);
  }

  public function testCase64()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 500;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 500;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 250;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 250;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 250;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 250;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with position: absolute", root_node, root_layout);
  }

  public function testCase65()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.setMargin(Spacing.RIGHT, 15);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with child with position: absolute and margin", root_node, root_layout);
  }

  public function testCase66()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.CENTER;
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.setPadding(Spacing.RIGHT, 12);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 12;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with position: absolute, padding and alignSelf: center", root_node, root_layout);
  }

  public function testCase67()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 5;
      node_0.setPadding(Spacing.BOTTOM, 20);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 20;
    }

    performTest("should work with height smaller than paddingBottom", root_node, root_layout);
  }

  public function testCase68()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 5;
      node_0.setPadding(Spacing.LEFT, 20);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 20;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
    }

    performTest("should work with width smaller than paddingLeft", root_node, root_layout);
  }

  public function testCase69()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.dimensions[DIMENSION_WIDTH] = 400;
        }
        node_1 = node_0.getChildAt(1);
        node_1.style.alignSelf = CSSAlign.STRETCH;
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 400;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 400;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 400;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 0;
        }
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with specified width and stretch", root_node, root_layout);
  }

  public function testCase70()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setPadding(Spacing.LEFT, 5);
      node_0.setPadding(Spacing.TOP, 5);
      node_0.setPadding(Spacing.RIGHT, 5);
      node_0.setPadding(Spacing.BOTTOM, 5);
      node_0.setPadding(Spacing.START, 5);
      node_0.setPadding(Spacing.END, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 10;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 5;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with padding and child with position absolute", root_node, root_layout);
  }

  public function testCase71()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_LEFT] = 10;
        node_1.style.position[POSITION_TOP] = 10;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with position absolute, top and left", root_node, root_layout);
  }

  public function testCase72()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setPadding(Spacing.LEFT, 20);
      node_0.setPadding(Spacing.TOP, 20);
      node_0.setPadding(Spacing.RIGHT, 20);
      node_0.setPadding(Spacing.BOTTOM, 20);
      node_0.setPadding(Spacing.START, 20);
      node_0.setPadding(Spacing.END, 20);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_LEFT] = 5;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 40;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 40;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 20;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with padding and child position absolute, left", root_node, root_layout);
  }

  public function testCase73()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.setMargin(Spacing.TOP, 5);
        node_1.style.position[POSITION_TOP] = 5;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with position: absolute, top and marginTop", root_node, root_layout);
  }

  public function testCase74()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.setMargin(Spacing.LEFT, 5);
        node_1.style.position[POSITION_LEFT] = 5;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with position: absolute, left and marginLeft", root_node, root_layout);
  }

  public function testCase75()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.SPACE_AROUND;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1 = node_0.getChildAt(1);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with space-around and child position absolute", root_node, root_layout);
  }

  public function testCase76()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.SPACE_AROUND;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1 = node_0.getChildAt(1);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with space-around and child position absolute in reverse", root_node, root_layout);
  }

  public function testCase77()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 700;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.setMargin(Spacing.LEFT, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 700;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 695;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with flex and main margin", root_node, root_layout);
  }

  public function testCase78()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 700;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.setMargin(Spacing.RIGHT, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 700;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 695;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with flex and main margin in rtl", root_node, root_layout);
  }

  public function testCase79()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 700;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.setPadding(Spacing.RIGHT, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 700;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 347.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 347.5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 352.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with multiple flex and padding", root_node, root_layout);
  }

  public function testCase80()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 700;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.setPadding(Spacing.LEFT, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 700;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 352.5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 347.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 352.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with multiple flex and padding in rtl", root_node, root_layout);
  }

  public function testCase81()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 700;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.setMargin(Spacing.LEFT, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 700;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 347.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 352.5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 347.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with multiple flex and margin", root_node, root_layout);
  }

  public function testCase82()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 700;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.setMargin(Spacing.RIGHT, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 700;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 352.5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 347.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 347.5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with multiple flex and margin in rtl", root_node, root_layout);
  }

  public function testCase83()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 300;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 600;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 300;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 600;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 600;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with flex and overflow", root_node, root_layout);
  }

  public function testCase84()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 600;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 600;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with flex and position absolute", root_node, root_layout);
  }

  public function testCase85()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 600;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 600;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 600;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with flex and position absolute in rtl", root_node, root_layout);
  }

  public function testCase86()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 500;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 500;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 500;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 500;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with double flex and position absolute", root_node, root_layout);
  }

  public function testCase87()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setBorder(Spacing.LEFT, 5);
      node_0.setBorder(Spacing.TOP, 5);
      node_0.setBorder(Spacing.RIGHT, 5);
      node_0.setBorder(Spacing.BOTTOM, 5);
      node_0.setBorder(Spacing.START, 5);
      node_0.setBorder(Spacing.END, 5);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 10;
    }

    performTest("should layout node with borderWidth", root_node, root_layout);
  }

  public function testCase88()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setBorder(Spacing.TOP, 1);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_TOP] = -1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with borderWidth and position: absolute, top", root_node, root_layout);
  }

  public function testCase89()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setBorder(Spacing.LEFT, 1);
      node_0.setBorder(Spacing.TOP, 1);
      node_0.setBorder(Spacing.RIGHT, 1);
      node_0.setBorder(Spacing.BOTTOM, 1);
      node_0.setBorder(Spacing.START, 1);
      node_0.setBorder(Spacing.END, 1);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_LEFT] = 5;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 2;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 2;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 1;
        node_1.layout.position[POSITION_LEFT] = 6;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with borderWidth and position: absolute, top. cross axis", root_node, root_layout);
  }

  public function testCase90()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.STRETCH;
        node_1.setMargin(Spacing.LEFT, 20);
        node_1.setPadding(Spacing.LEFT, 20);
        node_1.setPadding(Spacing.TOP, 20);
        node_1.setPadding(Spacing.RIGHT, 20);
        node_1.setPadding(Spacing.BOTTOM, 20);
        node_1.setPadding(Spacing.START, 20);
        node_1.setPadding(Spacing.END, 20);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 50;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 40;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 20;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 40;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 40;
      }
    }

    performTest("should correctly take into account min padding for stretch", root_node, root_layout);
  }

  public function testCase91()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = -31;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setBorder(Spacing.RIGHT, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 5;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 5;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with negative width", root_node, root_layout);
  }

  public function testCase92()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.setBorder(Spacing.RIGHT, 1);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.RIGHT, -8);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should handle negative margin and min padding correctly", root_node, root_layout);
  }

  public function testCase93()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.setBorder(Spacing.LEFT, 1);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.LEFT, -8);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 1;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should handle negative margin and min padding correctly in rtl", root_node, root_layout);
  }

  public function testCase94()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setMeasureFunction(sTestMeasureFunction);
      node_0.context = "small";
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 35;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 18;
    }

    performTest("should layout node with just text", root_node, root_layout);
  }

  public function testCase95()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.setMeasureFunction(sTestMeasureFunction);
      node_0.context = "measureWithRatio2";
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
    }

    performTest("should layout node with fixed width and custom measure function", root_node, root_layout);
  }

  public function testCase96()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      node_0.context = "measureWithRatio2";
      node_0.setMeasureFunction(sTestMeasureFunction);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
    }

    performTest("should layout node with fixed height and custom measure function", root_node, root_layout);
  }

  public function testCase97()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      node_0.setMeasureFunction(sTestMeasureFunction);
      node_0.context = "measureWithRatio2";
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
    }

    performTest("should layout node with fixed height and fixed width, ignoring custom measure function", root_node, root_layout);
  }

  public function testCase98()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setMeasureFunction(sTestMeasureFunction);
      node_0.context = "measureWithRatio2";
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 99999;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 99999;
    }

    performTest("should layout node with no fixed dimension and custom measure function", root_node, root_layout);
  }

  public function testCase99()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN;
      node_0.style.dimensions[DIMENSION_WIDTH] = 320;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMeasureFunction(sTestMeasureFunction);
        node_1.context = "measureWithRatio2";
        node_1 = node_0.getChildAt(1);
        node_1.style.flexDirection = CSSFlexDirection.ROW;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "measureWithRatio2";
          node_2 = node_1.getChildAt(1);
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "measureWithRatio2";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 320;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 740;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 320;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 640;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 640;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 320;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 200;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 100;
          node_2 = node_1.getChildAt(1);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 200;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 200;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 100;
        }
      }
    }

    performTest("should layout node with nested stacks and custom measure function", root_node, root_layout);
  }

  public function testCase100()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 10;
      node_0.setMeasureFunction(sTestMeasureFunction);
      node_0.context = "small";
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 10;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 18;
    }

    performTest("should layout node with text and width", root_node, root_layout);
  }

  public function testCase101()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.setMeasureFunction(sTestMeasureFunction);
      node_0.context = "loooooooooong with space";
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 172;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 18;
    }

    performTest("should layout node with text, padding and margin", root_node, root_layout);
  }

  public function testCase102()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.STRETCH;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.alignSelf = CSSAlign.STRETCH;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 300;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 300;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 0;
        }
      }
    }

    performTest("should layout node with nested alignSelf: stretch", root_node, root_layout);
  }

  public function testCase103()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flexDirection = CSSFlexDirection.ROW;
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.flex = 1;
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 500;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 18;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 18;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 500;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 18;
        }
      }
    }

    performTest("should layout node with text and flex", root_node, root_layout);
  }

  public function testCase104()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.direction = CSSDirection.RTL;
        node_1.style.flexDirection = CSSFlexDirection.ROW;
        node_1.style.dimensions[DIMENSION_WIDTH] = 500;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.flex = 1;
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 500;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 18;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 18;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 500;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 18;
        }
      }
    }

    performTest("should layout node with text and flex in rtl", root_node, root_layout);
  }

  public function testCase105()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 130;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignItems = CSSAlign.STRETCH;
        node_1.style.alignSelf = CSSAlign.STRETCH;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 130;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 36;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 130;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 36;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 130;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 36;
        }
      }
    }

    performTest("should layout node with text and stretch", root_node, root_layout);
  }

  public function testCase106()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignItems = CSSAlign.STRETCH;
        node_1.style.alignSelf = CSSAlign.STRETCH;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.dimensions[DIMENSION_WIDTH] = 130;
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 36;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 36;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 130;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 36;
        }
      }
    }

    performTest("should layout node with text stretch and width", root_node, root_layout);
  }

  public function testCase107()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignSelf = CSSAlign.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.setMeasureFunction(sTestMeasureFunction);
        node_1.context = "loooooooooong with space";
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 36;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 36;
      }
    }

    performTest("should layout node with text bounded by parent", root_node, root_layout);
  }

  public function testCase108()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignSelf = CSSAlign.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.setPadding(Spacing.LEFT, 10);
      node_0.setPadding(Spacing.TOP, 10);
      node_0.setPadding(Spacing.RIGHT, 10);
      node_0.setPadding(Spacing.BOTTOM, 10);
      node_0.setPadding(Spacing.START, 10);
      node_0.setPadding(Spacing.END, 10);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 76;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 20;
        node_1.layout.position[POSITION_LEFT] = 20;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 36;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 100;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 36;
        }
      }
    }

    performTest("should layout node with text bounded by grand-parent", root_node, root_layout);
  }

  public function testCase109()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.SPACE_BETWEEN;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 900;
        node_1 = node_0.getChildAt(1);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 900;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 900;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout space-between when remaining space is negative", root_node, root_layout);
  }

  public function testCase110()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.justifyContent = CSSJustify.SPACE_BETWEEN;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 900;
        node_1 = node_0.getChildAt(1);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = -800;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 900;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = -800;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout space-between when remaining space is negative in reverse", root_node, root_layout);
  }

  public function testCase111()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.justifyContent = CSSJustify.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 900;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = -700;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 900;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout flex-end when remaining space is negative", root_node, root_layout);
  }

  public function testCase112()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.justifyContent = CSSJustify.FLEX_END;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 900;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 900;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout flex-end when remaining space is negative in rtl", root_node, root_layout);
  }

  public function testCase113()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flexDirection = CSSFlexDirection.ROW;
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMargin(Spacing.LEFT, 20);
          node_2.setMargin(Spacing.TOP, 20);
          node_2.setMargin(Spacing.RIGHT, 20);
          node_2.setMargin(Spacing.BOTTOM, 20);
          node_2.setMargin(Spacing.START, 20);
          node_2.setMargin(Spacing.END, 20);
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 58;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 58;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 20;
          node_2.layout.position[POSITION_LEFT] = 20;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 172;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 18;
        }
      }
    }

    performTest("should layout text with flexDirection row", root_node, root_layout);
  }

  public function testCase114()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flexDirection = CSSFlexDirection.ROW;
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMargin(Spacing.LEFT, 20);
          node_2.setMargin(Spacing.TOP, 20);
          node_2.setMargin(Spacing.RIGHT, 20);
          node_2.setMargin(Spacing.BOTTOM, 20);
          node_2.setMargin(Spacing.START, 20);
          node_2.setMargin(Spacing.END, 20);
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 58;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 58;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 20;
          node_2.layout.position[POSITION_LEFT] = 8;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 172;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 18;
        }
      }
    }

    performTest("should layout text with flexDirection row in rtl", root_node, root_layout);
  }

  public function testCase115()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.setMargin(Spacing.LEFT, 20);
          node_2.setMargin(Spacing.TOP, 20);
          node_2.setMargin(Spacing.RIGHT, 20);
          node_2.setMargin(Spacing.BOTTOM, 20);
          node_2.setMargin(Spacing.START, 20);
          node_2.setMargin(Spacing.END, 20);
          node_2.setMeasureFunction(sTestMeasureFunction);
          node_2.context = "loooooooooong with space";
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 76;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 76;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 20;
          node_2.layout.position[POSITION_LEFT] = 20;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 160;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 36;
        }
      }
    }

    performTest("should layout with text and margin", root_node, root_layout);
  }

  public function testCase116()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_LEFT] = 0;
        node_1.style.position[POSITION_TOP] = 0;
        node_1.style.position[POSITION_RIGHT] = 0;
        node_1.style.position[POSITION_BOTTOM] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should layout with position absolute, top, left, bottom, right", root_node, root_layout);
  }

  public function testCase117()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignSelf = CSSAlign.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.flex = 2.5;
        node_1 = node_0.getChildAt(1);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.flex = 7.5;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 25;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 25;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 75;
      }
    }

    performTest("should layout with arbitrary flex", root_node, root_layout);
  }

  public function testCase118()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignSelf = CSSAlign.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.flex = 2.5;
        node_1 = node_0.getChildAt(1);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.flex = 7.5;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 75;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 25;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 75;
      }
    }

    performTest("should layout with arbitrary flex in reverse", root_node, root_layout);
  }

  public function testCase119()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.COLUMN_REVERSE;
      node_0.style.alignSelf = CSSAlign.FLEX_START;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.flex = -2.5;
        node_1 = node_0.getChildAt(1);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.flex = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout with negative flex in reverse", root_node, root_layout);
  }

  public function testCase120()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_LEFT] = 0;
        node_1.style.position[POSITION_RIGHT] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 50;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout with position: absolute and another sibling", root_node, root_layout);
  }

  public function testCase121()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_TOP] = 0;
        node_1.style.position[POSITION_BOTTOM] = 20;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 80;
      }
    }

    performTest("should calculate height properly with position: absolute top and bottom", root_node, root_layout);
  }

  public function testCase122()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.justifyContent = CSSJustify.CENTER;
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_LEFT] = 0;
        node_1.style.position[POSITION_TOP] = 0;
        node_1.style.position[POSITION_RIGHT] = 0;
        node_1.style.position[POSITION_BOTTOM] = 0;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.dimensions[DIMENSION_WIDTH] = 100;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 100;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 50;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 100;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 100;
        }
      }
    }

    performTest("should layout with complicated position: absolute and justifyContent: center combo", root_node, root_layout);
  }

  public function testCase123()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_BOTTOM] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should calculate top properly with position: absolute bottom", root_node, root_layout);
  }

  public function testCase124()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.position[POSITION_RIGHT] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should calculate left properly with position: absolute right", root_node, root_layout);
  }

  public function testCase125()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
        node_1.style.position[POSITION_BOTTOM] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 90;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
      }
    }

    performTest("should calculate top properly with position: absolute bottom and height", root_node, root_layout);
  }

  public function testCase126()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.dimensions[DIMENSION_WIDTH] = 10;
        node_1.style.position[POSITION_RIGHT] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 90;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 10;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should calculate left properly with position: absolute right and width", root_node, root_layout);
  }

  public function testCase127()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
        node_1.style.position[POSITION_BOTTOM] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = -10;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
      }
    }

    performTest("should calculate top properly with position: absolute right, width, and no parent dimensions", root_node, root_layout);
  }

  public function testCase128()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.dimensions[DIMENSION_WIDTH] = 10;
        node_1.style.position[POSITION_RIGHT] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = -10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 10;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should calculate left properly with position: absolute right, width, and no parent dimensions", root_node, root_layout);
  }

  public function testCase129()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.SPACE_BETWEEN;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setBorder(Spacing.BOTTOM, 1);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 1;
      }
    }

    performTest("should layout border bottom inside of justify content space between container", root_node, root_layout);
  }

  public function testCase130()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.CENTER;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.TOP, -6);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = -3;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout negative margin top inside of justify content center container", root_node, root_layout);
  }

  public function testCase131()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.CENTER;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.setMargin(Spacing.TOP, 20);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 20;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 20;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout positive margin top inside of justify content center container", root_node, root_layout);
  }

  public function testCase132()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.justifyContent = CSSJustify.FLEX_END;
      node_0.setBorder(Spacing.BOTTOM, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 5;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout border bottom and flex end with an empty child", root_node, root_layout);
  }

  public function testCase133()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 800;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.position[POSITION_LEFT] = 5;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 800;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 800;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 800;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 0;
        }
      }
    }

    performTest("should layout with children of a contain with left", root_node, root_layout);
  }

  public function testCase134()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.flexWrap = CSSWrap.WRAP;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 40;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 40;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 40;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 20;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 40;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 40;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 40;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 40;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
      }
    }

    performTest("should layout flex-wrap", root_node, root_layout);
  }

  public function testCase135()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.flexWrap = CSSWrap.WRAP;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 40;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 40;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 40;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 10;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 20;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 60;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 40;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 20;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 40;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 60;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 40;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 10;
      }
    }

    performTest("should layout flex-wrap in rtl", root_node, root_layout);
  }

  public function testCase136()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexWrap = CSSWrap.WRAP;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 0;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should layout flex wrap with a line bigger than container", root_node, root_layout);
  }

  public function testCase137()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      node_0.style.maxWidth = 90;
      node_0.style.maxHeight = 190;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 90;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 190;
    }

    performTest("should use max bounds", root_node, root_layout);
  }

  public function testCase138()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      node_0.style.minWidth = 110;
      node_0.style.minHeight = 210;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 110;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 210;
    }

    performTest("should use min bounds", root_node, root_layout);
  }

  public function testCase139()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      node_0.style.maxWidth = 90;
      node_0.style.maxHeight = 190;
      node_0.style.minWidth = 110;
      node_0.style.minHeight = 210;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 110;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 210;
    }

    performTest("should use min bounds over max bounds", root_node, root_layout);
  }

  public function testCase140()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      node_0.style.maxWidth = 80;
      node_0.style.maxHeight = 180;
      node_0.style.minWidth = 90;
      node_0.style.minHeight = 190;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 90;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 190;
    }

    performTest("should use min bounds over max bounds and natural width", root_node, root_layout);
  }

  public function testCase141()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      node_0.style.minWidth = -10;
      node_0.style.minHeight = -20;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
    }

    performTest("should ignore negative min bounds", root_node, root_layout);
  }

  public function testCase142()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 100;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      node_0.style.maxWidth = -10;
      node_0.style.maxHeight = -20;
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
    }

    performTest("should ignore negative max bounds", root_node, root_layout);
  }

  public function testCase143()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.maxWidth = 30;
      node_0.style.maxHeight = 10;
      node_0.setPadding(Spacing.LEFT, 20);
      node_0.setPadding(Spacing.TOP, 15);
      node_0.setPadding(Spacing.RIGHT, 20);
      node_0.setPadding(Spacing.BOTTOM, 15);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 40;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 30;
    }

    performTest("should use padded size over max bounds", root_node, root_layout);
  }

  public function testCase144()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.minWidth = 50;
      node_0.style.minHeight = 40;
      node_0.setPadding(Spacing.LEFT, 20);
      node_0.setPadding(Spacing.TOP, 15);
      node_0.setPadding(Spacing.RIGHT, 20);
      node_0.setPadding(Spacing.BOTTOM, 15);
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 50;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 40;
    }

    performTest("should use min size over padded size", root_node, root_layout);
  }

  public function testCase145()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.minWidth = 200;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 50;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 250;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should override flex direction size with min bounds", root_node, root_layout);
  }

  public function testCase146()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.minWidth = 200;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 250;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 50;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should override flex direction size with min bounds in rtl", root_node, root_layout);
  }

  public function testCase147()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 110;
        node_1.style.minWidth = 90;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 200;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should not override flex direction size within bounds", root_node, root_layout);
  }

  public function testCase148()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 110;
        node_1.style.minWidth = 90;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 200;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should not override flex direction size within bounds in rtl", root_node, root_layout);
  }

  public function testCase149()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 120;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 180;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should override flex direction size with max bounds", root_node, root_layout);
  }

  public function testCase150()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 180;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 120;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should override flex direction size with max bounds in rtl", root_node, root_layout);
  }

  public function testCase151()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 60;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 120;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should ignore flex size if fully max bound", root_node, root_layout);
  }

  public function testCase152()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 60;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 240;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 180;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 120;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 60;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should ignore flex size if fully max bound in rtl", root_node, root_layout);
  }

  public function testCase153()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.minWidth = 120;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.minWidth = 120;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
        node_1.style.minWidth = 120;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 120;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 240;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should ignore flex size if fully min bound", root_node, root_layout);
  }

  public function testCase154()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.minWidth = 120;
        node_1 = node_0.getChildAt(1);
        node_1.style.flex = 1;
        node_1.style.minWidth = 120;
        node_1 = node_0.getChildAt(2);
        node_1.style.flex = 1;
        node_1.style.minWidth = 120;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 3);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 180;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 60;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = -60;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 120;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should ignore flex size if fully min bound in rtl", root_node, root_layout);
  }

  public function testCase155()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 310;
        node_1.style.minWidth = 290;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 300;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should pre-fill child size within bounds", root_node, root_layout);
  }

  public function testCase156()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.maxWidth = 290;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 290;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should pre-fill child size within max bound", root_node, root_layout);
  }

  public function testCase157()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.style.minWidth = 310;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 310;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
      }
    }

    performTest("should pre-fill child size within min bounds", root_node, root_layout);
  }

  public function testCase158()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.maxWidth = 300;
      node_0.style.maxHeight = 700;
      node_0.style.minWidth = 100;
      node_0.style.minHeight = 500;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 300;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 300;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 600;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 300;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 300;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 300;
      }
    }

    performTest("should set parents size based on bounded children", root_node, root_layout);
  }

  public function testCase159()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.maxWidth = 100;
      node_0.style.maxHeight = 500;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 300;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 300;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 100;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 500;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 300;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 300;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 300;
      }
    }

    performTest("should set parents size based on max bounded children", root_node, root_layout);
  }

  public function testCase160()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.minWidth = 300;
      node_0.style.minHeight = 700;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 300;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 200;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 300;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 700;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 300;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 300;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 300;
      }
    }

    performTest("should set parents size based on min bounded children", root_node, root_layout);
  }

  public function testCase161()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.STRETCH;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.style.maxWidth = 1100;
        node_1.style.maxHeight = 110;
        node_1.style.minWidth = 900;
        node_1.style.minHeight = 90;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 100;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 1000;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should keep stretched size within bounds", root_node, root_layout);
  }

  public function testCase162()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.STRETCH;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.style.maxWidth = 900;
        node_1.style.maxHeight = 90;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 90;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 900;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 90;
      }
    }

    performTest("should keep stretched size within max bounds", root_node, root_layout);
  }

  public function testCase163()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.alignItems = CSSAlign.STRETCH;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.style.minWidth = 1100;
        node_1.style.minHeight = 110;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 110;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 1100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 110;
      }
    }

    performTest("should keep stretched size within min bounds", root_node, root_layout);
  }

  public function testCase164()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.style.minWidth = 100;
        node_1.style.minHeight = 110;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 110;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 110;
      }
    }

    performTest("should keep cross axis size within min bounds", root_node, root_layout);
  }

  public function testCase165()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.style.minWidth = 100;
        node_1.style.minHeight = 110;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 110;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 900;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 110;
      }
    }

    performTest("should keep cross axis size within min bounds in rtl", root_node, root_layout);
  }

  public function testCase166()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.maxWidth = 500;
        node_1.style.maxHeight = 600;
        node_1.style.position[POSITION_LEFT] = 100;
        node_1.style.position[POSITION_TOP] = 100;
        node_1.style.position[POSITION_RIGHT] = 100;
        node_1.style.position[POSITION_BOTTOM] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 500;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 600;
      }
    }

    performTest("should layout node with position absolute, top and left and max bounds", root_node, root_layout);
  }

  public function testCase167()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.style.minWidth = 900;
        node_1.style.minHeight = 1000;
        node_1.style.position[POSITION_LEFT] = 100;
        node_1.style.position[POSITION_TOP] = 100;
        node_1.style.position[POSITION_RIGHT] = 100;
        node_1.style.position[POSITION_BOTTOM] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 1000;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 900;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 1000;
      }
    }

    performTest("should layout node with position absolute, top and left and min bounds", root_node, root_layout);
  }

  public function testCase168()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 400;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 400;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.setPadding(Spacing.LEFT, 10);
        node_1.setPadding(Spacing.TOP, 10);
        node_1.setPadding(Spacing.RIGHT, 10);
        node_1.setPadding(Spacing.BOTTOM, 10);
        node_1.setPadding(Spacing.START, 10);
        node_1.setPadding(Spacing.END, 10);
        node_1.style.position[POSITION_LEFT] = 100;
        node_1.style.position[POSITION_TOP] = 100;
        node_1.style.position[POSITION_RIGHT] = 100;
        node_1.style.position[POSITION_BOTTOM] = 100;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.positionType = CSSPositionType.ABSOLUTE;
          node_2.style.position[POSITION_LEFT] = 10;
          node_2.style.position[POSITION_TOP] = 10;
          node_2.style.position[POSITION_RIGHT] = 10;
          node_2.style.position[POSITION_BOTTOM] = 10;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 400;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 400;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 10;
          node_2.layout.position[POSITION_LEFT] = 10;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 180;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 180;
        }
      }
    }

    performTest("should layout absolutely positioned node with absolutely positioned padded parent", root_node, root_layout);
  }

  public function testCase169()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 400;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 400;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.positionType = CSSPositionType.ABSOLUTE;
        node_1.setPadding(Spacing.LEFT, 10);
        node_1.setPadding(Spacing.TOP, 10);
        node_1.setPadding(Spacing.RIGHT, 10);
        node_1.setPadding(Spacing.BOTTOM, 10);
        node_1.setPadding(Spacing.START, 10);
        node_1.setPadding(Spacing.END, 10);
        node_1.setBorder(Spacing.LEFT, 1);
        node_1.setBorder(Spacing.TOP, 1);
        node_1.setBorder(Spacing.RIGHT, 1);
        node_1.setBorder(Spacing.BOTTOM, 1);
        node_1.setBorder(Spacing.START, 1);
        node_1.setBorder(Spacing.END, 1);
        node_1.style.position[POSITION_LEFT] = 100;
        node_1.style.position[POSITION_TOP] = 100;
        node_1.style.position[POSITION_RIGHT] = 100;
        node_1.style.position[POSITION_BOTTOM] = 100;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.positionType = CSSPositionType.ABSOLUTE;
          node_2.style.position[POSITION_LEFT] = 10;
          node_2.style.position[POSITION_TOP] = 10;
          node_2.style.position[POSITION_RIGHT] = 10;
          node_2.style.position[POSITION_BOTTOM] = 10;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 400;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 400;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 100;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 200;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 11;
          node_2.layout.position[POSITION_LEFT] = 11;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 178;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 178;
        }
      }
    }

    performTest("should layout absolutely positioned node with absolutely positioned padded and bordered parent", root_node, root_layout);
  }

  public function testCase170()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 400;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 400;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flex = 1;
        node_1.setPadding(Spacing.LEFT, 10);
        node_1.setPadding(Spacing.TOP, 10);
        node_1.setPadding(Spacing.RIGHT, 10);
        node_1.setPadding(Spacing.BOTTOM, 10);
        node_1.setPadding(Spacing.START, 10);
        node_1.setPadding(Spacing.END, 10);
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.positionType = CSSPositionType.ABSOLUTE;
          node_2.style.position[POSITION_LEFT] = 10;
          node_2.style.position[POSITION_TOP] = 10;
          node_2.style.position[POSITION_RIGHT] = 10;
          node_2.style.position[POSITION_BOTTOM] = 10;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 400;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 400;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 400;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 400;
        addChildren(node_1, 1);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 10;
          node_2.layout.position[POSITION_LEFT] = 10;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 380;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 380;
        }
      }
    }

    performTest("should layout absolutely positioned node with padded flex 1 parent", root_node, root_layout);
  }

  public function testCase171()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.flexDirection = CSSFlexDirection.ROW;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.dimensions[DIMENSION_WIDTH] = 50;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 50;
          node_2 = node_1.getChildAt(1);
          node_2.style.dimensions[DIMENSION_WIDTH] = 50;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 50;
        }
        node_1 = node_0.getChildAt(1);
        node_1.style.direction = CSSDirection.LTR;
        node_1.style.flexDirection = CSSFlexDirection.ROW;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.style.dimensions[DIMENSION_WIDTH] = 50;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 50;
          node_2 = node_1.getChildAt(1);
          node_2.style.dimensions[DIMENSION_WIDTH] = 50;
          node_2.style.dimensions[DIMENSION_HEIGHT] = 50;
        }
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 2);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 150;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 50;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 50;
          node_2 = node_1.getChildAt(1);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 100;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 50;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 50;
        }
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 50;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 200;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        addChildren(node_1, 2);
        {
          var node_2;
          node_2 = node_1.getChildAt(0);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 0;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 50;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 50;
          node_2 = node_1.getChildAt(1);
          node_2.layout.position[POSITION_TOP] = 0;
          node_2.layout.position[POSITION_LEFT] = 50;
          node_2.layout.dimensions[DIMENSION_WIDTH] = 50;
          node_2.layout.dimensions[DIMENSION_HEIGHT] = 50;
        }
      }
    }

    performTest("should layout nested nodes with mixed directions", root_node, root_layout);
  }

  public function testCase172()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.justifyContent = CSSJustify.SPACE_BETWEEN;
      node_0.style.flexWrap = CSSWrap.WRAP;
      node_0.style.dimensions[DIMENSION_WIDTH] = 320;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 6);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(3);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(4);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(5);
        node_1.style.dimensions[DIMENSION_WIDTH] = 100;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 320;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 200;
      addChildren(node_0, 6);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 110;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 220;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(3);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(4);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 110;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(5);
        node_1.layout.position[POSITION_TOP] = 100;
        node_1.layout.position[POSITION_LEFT] = 220;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 100;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
      }
    }

    performTest("should correctly space wrapped nodes", root_node, root_layout);
  }

  public function testCase173()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.setPadding(Spacing.LEFT, 5);
      node_0.setPadding(Spacing.RIGHT, 5);
      node_0.setPadding(Spacing.START, 15);
      node_0.setPadding(Spacing.END, 15);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 170;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should give start/end padding precedence over left/right padding", root_node, root_layout);
  }

  public function testCase174()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 5);
        node_1.setMargin(Spacing.RIGHT, 5);
        node_1.setMargin(Spacing.START, 15);
        node_1.setMargin(Spacing.END, 15);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 170;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should give start/end margin precedence over left/right margin", root_node, root_layout);
  }

  public function testCase175()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.setBorder(Spacing.LEFT, 5);
      node_0.setBorder(Spacing.RIGHT, 5);
      node_0.setBorder(Spacing.START, 15);
      node_0.setBorder(Spacing.END, 15);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 170;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should give start/end border precedence over left/right border", root_node, root_layout);
  }

  public function testCase176()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.setPadding(Spacing.START, 15);
      node_0.setPadding(Spacing.END, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 180;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should layout node with correct start/end padding", root_node, root_layout);
  }

  public function testCase177()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.setPadding(Spacing.START, 15);
      node_0.setPadding(Spacing.END, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 180;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should layout node with correct start/end padding in rtl", root_node, root_layout);
  }

  public function testCase178()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.START, 15);
        node_1.setMargin(Spacing.END, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 180;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should layout node with correct start/end margin", root_node, root_layout);
  }

  public function testCase179()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.direction = CSSDirection.RTL;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.START, 15);
        node_1.setMargin(Spacing.END, 5);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 180;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should layout node with correct start/end margin in rtl", root_node, root_layout);
  }

  public function testCase180()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.setBorder(Spacing.START, 15);
      node_0.setBorder(Spacing.END, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 15;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 180;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should layout node with correct start/end border", root_node, root_layout);
  }

  public function testCase181()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.direction = CSSDirection.RTL;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      node_0.setBorder(Spacing.START, 15);
      node_0.setBorder(Spacing.END, 5);
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 50;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 5;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 180;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should layout node with correct start/end border in rtl", root_node, root_layout);
  }

  public function testCase182()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.dimensions[DIMENSION_WIDTH] = 200;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 0;
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 200;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 0;
      addChildren(node_0, 1);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 0;
        node_1.layout.position[POSITION_LEFT] = 0;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 0;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 0;
      }
    }

    performTest("should layout node with a 0 width", root_node, root_layout);
  }

  public function testCase183()
  {
    var root_node = new TestCSSNode();
    {
      var node_0 = root_node;
      node_0.style.flexDirection = CSSFlexDirection.ROW;
      node_0.style.alignContent = CSSAlign.STRETCH;
      node_0.style.alignItems = CSSAlign.FLEX_START;
      node_0.style.flexWrap = CSSWrap.WRAP;
      node_0.style.dimensions[DIMENSION_WIDTH] = 300;
      node_0.style.dimensions[DIMENSION_HEIGHT] = 380;
      addChildren(node_0, 15);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(1);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(2);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(3);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(4);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(5);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(6);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(7);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 100;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(8);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(9);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(10);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(11);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(12);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(13);
        node_1.style.alignSelf = CSSAlign.FLEX_START;
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
        node_1 = node_0.getChildAt(14);
        node_1.style.dimensions[DIMENSION_WIDTH] = 50;
        node_1.style.dimensions[DIMENSION_HEIGHT] = 50;
        node_1.setMargin(Spacing.LEFT, 10);
        node_1.setMargin(Spacing.TOP, 10);
        node_1.setMargin(Spacing.RIGHT, 10);
        node_1.setMargin(Spacing.BOTTOM, 10);
        node_1.setMargin(Spacing.START, 10);
        node_1.setMargin(Spacing.END, 10);
      }
    }

    var root_layout = new TestCSSNode();
    {
      var node_0 = root_layout;
      node_0.layout.position[POSITION_TOP] = 0;
      node_0.layout.position[POSITION_LEFT] = 0;
      node_0.layout.dimensions[DIMENSION_WIDTH] = 300;
      node_0.layout.dimensions[DIMENSION_HEIGHT] = 380;
      addChildren(node_0, 15);
      {
        var node_1;
        node_1 = node_0.getChildAt(0);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(1);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 80;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(2);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 150;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(3);
        node_1.layout.position[POSITION_TOP] = 10;
        node_1.layout.position[POSITION_LEFT] = 220;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(4);
        node_1.layout.position[POSITION_TOP] = 92.5;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(5);
        node_1.layout.position[POSITION_TOP] = 92.5;
        node_1.layout.position[POSITION_LEFT] = 80;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(6);
        node_1.layout.position[POSITION_TOP] = 92.5;
        node_1.layout.position[POSITION_LEFT] = 150;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(7);
        node_1.layout.position[POSITION_TOP] = 92.5;
        node_1.layout.position[POSITION_LEFT] = 220;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 100;
        node_1 = node_0.getChildAt(8);
        node_1.layout.position[POSITION_TOP] = 225;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(9);
        node_1.layout.position[POSITION_TOP] = 225;
        node_1.layout.position[POSITION_LEFT] = 80;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(10);
        node_1.layout.position[POSITION_TOP] = 225;
        node_1.layout.position[POSITION_LEFT] = 150;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(11);
        node_1.layout.position[POSITION_TOP] = 225;
        node_1.layout.position[POSITION_LEFT] = 220;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(12);
        node_1.layout.position[POSITION_TOP] = 307.5;
        node_1.layout.position[POSITION_LEFT] = 10;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(13);
        node_1.layout.position[POSITION_TOP] = 307.5;
        node_1.layout.position[POSITION_LEFT] = 80;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
        node_1 = node_0.getChildAt(14);
        node_1.layout.position[POSITION_TOP] = 307.5;
        node_1.layout.position[POSITION_LEFT] = 150;
        node_1.layout.dimensions[DIMENSION_WIDTH] = 50;
        node_1.layout.dimensions[DIMENSION_HEIGHT] = 50;
      }
    }

    performTest("should layout with alignContent: stretch, and alignItems: flex-start", root_node, root_layout);
  }
  /** END_GENERATED **/
}

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

/**
 * Tests for {@link CSSNode}.
 */
class CSSNodeTest extends TestCase {
  public function testAddChildGetParent() {
    var parent = new CSSNode();
    var child = new CSSNode();

    assertEquals(null, child.getParent());
    assertEquals(0, parent.getChildCount());

    parent.addChildAt(child, 0);

    assertEquals(1, parent.getChildCount());
    assertEquals(child, parent.getChildAt(0));
    assertEquals(parent, child.getParent());

    parent.removeChildAt(0);

    assertEquals(null, child.getParent());
    assertEquals(0, parent.getChildCount());
  }

  public function testCannotAddChildToMultipleParents() {
    var parent1 = new CSSNode();
    var parent2 = new CSSNode();
    var child = new CSSNode();

    parent1.addChildAt(child, 0);

    try {
      parent2.addChildAt(child, 0);
    } catch (e: String) {
      assertEquals(e, "Child already has a parent, it must be removed first.");
    }
  }
}

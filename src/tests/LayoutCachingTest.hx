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
import csslayout.CSSAlign;
import csslayout.Spacing;

/**
 * Tests for {@link LayoutEngine} and {@link CSSNode} to make sure layouts are only generated when
 * needed.
 */
class LayoutCachingTest extends TestCase {

  private function assertTreeHasNewLayout(expectedHasNewLayout: Bool, root: CSSNode) {
    assertEquals(expectedHasNewLayout, root.hasNewLayout());

    for (i in 0...root.getChildCount()) {
      assertTreeHasNewLayout(expectedHasNewLayout, root.getChildAt(i));
    }
  }

  private function markLayoutAppliedForTree(root: CSSNode) {
    root.markLayoutSeen();

    for (i in 0...root.getChildCount()) {
      markLayoutAppliedForTree(root.getChildAt(i));
    }
  }

  public function testCachesFullTree() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c0c0 = new CSSNode();

    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c0.addChildAt(c0c0, 0);

    root.calculateLayout();
    assertTreeHasNewLayout(true, root);
    markLayoutAppliedForTree(root);

    root.calculateLayout();
    assertTrue(root.hasNewLayout());
    assertTreeHasNewLayout(false, c0);
    assertTreeHasNewLayout(false, c1);
  }

  public function testInvalidatesCacheWhenChildAdded() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c0c0 = new CSSNode();
    var c0c1 = new CSSNode();
    var c1c0 = new CSSNode();

    c0c1.setStyleWidth(200);
    c0c1.setStyleHeight(200);
    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c0.addChildAt(c0c0, 0);
    c0c0.addChildAt(c1c0, 0);

    root.calculateLayout();
    markLayoutAppliedForTree(root);

    c0.addChildAt(c0c1, 1);

    root.calculateLayout();
    assertTrue(root.hasNewLayout());
    assertTrue(c0.hasNewLayout());
    assertTrue(c0c1.hasNewLayout());

    assertTrue(c0c0.hasNewLayout());
    assertTrue(c1.hasNewLayout());

    assertFalse(c1c0.hasNewLayout());
  }

  public function testInvalidatesCacheWhenEnumPropertyChanges() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c0c0 = new CSSNode();

    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c0.addChildAt(c0c0, 0);

    root.calculateLayout();
    markLayoutAppliedForTree(root);

    c1.setAlignSelf(CSSAlign.CENTER);
    root.calculateLayout();

    assertTrue(root.hasNewLayout());
    assertTrue(c1.hasNewLayout());

    assertTrue(c0.hasNewLayout());
    assertFalse(c0c0.hasNewLayout());
  }

  public function testInvalidatesCacheWhenFloatPropertyChanges() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c0c0 = new CSSNode();

    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c0.addChildAt(c0c0, 0);

    root.calculateLayout();
    markLayoutAppliedForTree(root);

    c1.setMargin(Spacing.LEFT, 10);
    root.calculateLayout();

    assertTrue(root.hasNewLayout());
    assertTrue(c1.hasNewLayout());

    assertTrue(c0.hasNewLayout());
    assertFalse(c0c0.hasNewLayout());
  }

  public function testInvalidatesFullTreeWhenParentWidthChanges() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c0c0 = new CSSNode();
    var c1c0 = new CSSNode();

    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c0.addChildAt(c0c0, 0);
    c1.addChildAt(c1c0, 0);

    root.calculateLayout();
    markLayoutAppliedForTree(root);

    c0.setStyleWidth(200);
    root.calculateLayout();

    assertTrue(root.hasNewLayout());
    assertTrue(c0.hasNewLayout());
    assertTrue(c0c0.hasNewLayout());

    assertTrue(c1.hasNewLayout());
    assertFalse(c1c0.hasNewLayout());
  }

  public function testDoesNotInvalidateCacheWhenPropertyIsTheSame() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c0c0 = new CSSNode();

    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c0.addChildAt(c0c0, 0);
    root.setStyleWidth(200);

    root.calculateLayout();
    markLayoutAppliedForTree(root);

    root.setStyleWidth(200);
    root.calculateLayout();

    assertTrue(root.hasNewLayout());
    assertTreeHasNewLayout(false, c0);
    assertTreeHasNewLayout(false, c1);
  }

  public function testInvalidateCacheWhenHeightChangesPosition() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c1c0 = new CSSNode();

    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c1.addChildAt(c1c0, 0);

    root.calculateLayout();
    markLayoutAppliedForTree(root);

    c0.setStyleHeight(100);
    root.calculateLayout();

    assertTrue(root.hasNewLayout());
    assertTrue(c0.hasNewLayout());
    assertTrue(c1.hasNewLayout());
    assertFalse(c1c0.hasNewLayout());
  }

  public function testInvalidatesOnNewMeasureFunction() {
    var root = new CSSNode();
    var c0 = new CSSNode();
    var c1 = new CSSNode();
    var c0c0 = new CSSNode();

    root.addChildAt(c0, 0);
    root.addChildAt(c1, 1);
    c0.addChildAt(c0c0, 0);

    root.calculateLayout();
    markLayoutAppliedForTree(root);

    c1.setMeasureFunction(function(node: CSSNode, width: Float, height: Float) {
      return [100, 20];
    });

    root.calculateLayout();

    assertTrue(root.hasNewLayout());
    assertTrue(c1.hasNewLayout());

    assertTrue(c0.hasNewLayout());
    assertFalse(c0c0.hasNewLayout());
  }
}

/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */
package csslayout;

import haxe.Json;

/**
 * Where the output of {@link LayoutEngine#layoutNode(CSSNode, float)} will go in the CSSNode.
 */
class CSSLayout {
  public static var POSITION_LEFT = 0;
  public static var POSITION_TOP = 1;
  public static var POSITION_RIGHT = 2;
  public static var POSITION_BOTTOM = 3;

  public static var DIMENSION_WIDTH = 0;
  public static var DIMENSION_HEIGHT = 1;

  public var position: Array<Float> = [0, 0, 0, 0];
  public var dimensions = [CSSConstants.UNDEFINED, CSSConstants.UNDEFINED];
  public var direction = CSSDirection.LTR;

  public function new() {}

  /**
   * This should always get called before calling {@link LayoutEngine#layoutNode(CSSNode, float)}
   */
  public function resetResult() {
    position = [0, 0, 0, 0];
    dimensions = [CSSConstants.UNDEFINED, CSSConstants.UNDEFINED];
    direction = CSSDirection.LTR;
  }

  public function copy(layout: CSSLayout) {
    position[POSITION_LEFT] = layout.position[POSITION_LEFT];
    position[POSITION_TOP] = layout.position[POSITION_TOP];
    position[POSITION_RIGHT] = layout.position[POSITION_RIGHT];
    position[POSITION_BOTTOM] = layout.position[POSITION_BOTTOM];
    dimensions[DIMENSION_WIDTH] = layout.dimensions[DIMENSION_WIDTH];
    dimensions[DIMENSION_HEIGHT] = layout.dimensions[DIMENSION_HEIGHT];
    direction = layout.direction;

    Assert.notNull(position[POSITION_LEFT]);
    Assert.notNull(position[POSITION_TOP]);
    Assert.notNull(position[POSITION_RIGHT]);
    Assert.notNull(position[POSITION_BOTTOM]);
    Assert.notNull(dimensions[DIMENSION_WIDTH]);
    Assert.notNull(dimensions[DIMENSION_HEIGHT]);
    Assert.notNull(dimensions);
  }

  public function toObject() {
    return {
      left: position[POSITION_LEFT],
      top: position[POSITION_TOP],
      width: dimensions[DIMENSION_WIDTH],
      height: dimensions[DIMENSION_HEIGHT],
      direction: direction
    };
  }

  public function toString() {
    return Json.stringify(toObject(), null, '  ');
  }
}

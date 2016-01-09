/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */
package csslayout;

/**
 * The CSS style definition for a {@link CSSNode}.
 */
class CSSStyle {

  public var direction: CSSDirection;
  public var flexDirection: CSSFlexDirection;
  public var justifyContent: CSSJustify;
  public var alignContent: CSSAlign;
  public var alignItems: CSSAlign;
  public var alignSelf: CSSAlign;
  public var positionType: CSSPositionType;
  public var flexWrap: CSSWrap;
  public var flex: Float;

  public var margin = new Spacing();
  public var padding = new Spacing();
  public var border = new Spacing();

  public var position = [CSSConstants.UNDEFINED, CSSConstants.UNDEFINED, CSSConstants.UNDEFINED, CSSConstants.UNDEFINED];
  public var dimensions = [CSSConstants.UNDEFINED, CSSConstants.UNDEFINED];

  public var minWidth = CSSConstants.UNDEFINED;
  public var minHeight = CSSConstants.UNDEFINED;

  public var maxWidth = CSSConstants.UNDEFINED;
  public var maxHeight = CSSConstants.UNDEFINED;

  public function new() {
    reset();
  }

  public function reset() {
    direction = CSSDirection.INHERIT;
    flexDirection = CSSFlexDirection.COLUMN;
    justifyContent = CSSJustify.FLEX_START;
    alignContent = CSSAlign.FLEX_START;
    alignItems = CSSAlign.STRETCH;
    alignSelf = CSSAlign.AUTO;
    positionType = CSSPositionType.RELATIVE;
    flexWrap = CSSWrap.NOWRAP;
    flex = 0;

    margin.reset();
    padding.reset();
    border.reset();

    minWidth = CSSConstants.UNDEFINED;
    minHeight = CSSConstants.UNDEFINED;

    maxWidth = CSSConstants.UNDEFINED;
    maxHeight = CSSConstants.UNDEFINED;
  }
}

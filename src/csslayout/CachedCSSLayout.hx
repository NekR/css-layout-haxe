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
 * CSSLayout with additional information about the conditions under which it was generated.
 * {@link #requestedWidth} and {@link #requestedHeight} are the width and height the parent set on
 * this node before calling layout visited us.
 */
class CachedCSSLayout extends CSSLayout {
  public var requestedWidth = CSSConstants.UNDEFINED;
  public var requestedHeight = CSSConstants.UNDEFINED;
  public var parentMaxWidth = CSSConstants.UNDEFINED;
  public var parentMaxHeight = CSSConstants.UNDEFINED;

  public function new() {
    super();
  }
}

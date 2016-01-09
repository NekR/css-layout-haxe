/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */
package csslayout;

class FloatUtil {
  private static var EPSILON = 0.00001;

  public static function floatsEqual(f1: Float, f2: Float): Bool {
    if (Math.isNaN(f1) || Math.isNaN(f2)) {
      return Math.isNaN(f1) && Math.isNaN(f2);
    }

    return Math.abs(f2 - f1) < EPSILON;
  }
}

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
 * Class representing CSS spacing (padding, margin, and borders). This is mostly necessary to
 * properly implement interactions and updates for properties like margin, marginLeft, and
 * marginHorizontal.
 */
class Spacing {

  /**
   * Spacing type that represents the left direction. E.g. {@code marginLeft}.
   */
  public static var LEFT = 0;
  /**
   * Spacing type that represents the top direction. E.g. {@code marginTop}.
   */
  public static var TOP = 1;
  /**
   * Spacing type that represents the right direction. E.g. {@code marginRight}.
   */
  public static var RIGHT = 2;
  /**
   * Spacing type that represents the bottom direction. E.g. {@code marginBottom}.
   */
  public static var BOTTOM = 3;
  /**
   * Spacing type that represents vertical direction (top and bottom). E.g. {@code marginVertical}.
   */
  public static var VERTICAL = 4;
  /**
   * Spacing type that represents horizontal direction (left and right). E.g.
   * {@code marginHorizontal}.
   */
  public static var HORIZONTAL = 5;
  /**
   * Spacing type that represents start direction e.g. left in left-to-right, right in right-to-left.
   */
  public static var START = 6;
  /**
   * Spacing type that represents end direction e.g. right in left-to-right, left in right-to-left.
   */
  public static var END = 7;
  /**
   * Spacing type that represents all directions (left, top, right, bottom). E.g. {@code margin}.
   */
  public static var ALL = 8;

  private static var sFlagsMap:Array<Int> = [
    1, /*LEFT*/
    2, /*TOP*/
    4, /*RIGHT*/
    8, /*BOTTOM*/
    16, /*VERTICAL*/
    32, /*HORIZONTAL*/
    64, /*START*/
    128, /*END*/
    256, /*ALL*/
  ];

  private var mSpacing: Array<Float> = newFullSpacingArray();
  private var mDefaultSpacing: Null<Array<Float>>;
  private var mValueFlags = 0;
  private var mHasAliasesSet:Bool;

  public function new() {}

  /**
   * Set a spacing value.
   *
   * @param spacingType one of {@link #LEFT}, {@link #TOP}, {@link #RIGHT}, {@link #BOTTOM},
   *        {@link #VERTICAL}, {@link #HORIZONTAL}, {@link #ALL}
   * @param value the value for this direction
   * @return {@code true} if the spacing has changed, or {@code false} if the same value was already
   *         set
   */
  public function set(spacingType: Int, value: Float): Bool {
    if (!FloatUtil.floatsEqual(mSpacing[spacingType], value)) {
      mSpacing[spacingType] = value;

      if (CSSConstants.isUndefined(value)) {
        mValueFlags &= ~sFlagsMap[spacingType];
      } else {
        mValueFlags |= sFlagsMap[spacingType];
      }

      mHasAliasesSet =
          (mValueFlags & sFlagsMap[ALL]) != 0 ||
          (mValueFlags & sFlagsMap[VERTICAL]) != 0 ||
          (mValueFlags & sFlagsMap[HORIZONTAL]) != 0;

      return true;
    }

    return false;
  }

  /**
   * Set a default spacing value. This is used as a fallback when no spacing has been set for a
   * particular direction.
   *
   * @param spacingType one of {@link #LEFT}, {@link #TOP}, {@link #RIGHT}, {@link #BOTTOM}
   * @param value the default value for this direction
   * @return
   */
  public function setDefault(spacingType: Int, value: Float): Bool {
    if (mDefaultSpacing == null) {
      mDefaultSpacing = newSpacingResultArray();
    }

    if (!FloatUtil.floatsEqual(mDefaultSpacing[spacingType], value)) {
      mDefaultSpacing[spacingType] = value;
      return true;
    }

    return false;
  }

  /**
   * Get the spacing for a direction. This takes into account any default values that have been set.
   *
   * @param spacingType one of {@link #LEFT}, {@link #TOP}, {@link #RIGHT}, {@link #BOTTOM}
   */
  public function get(spacingType: Int): Float {
    var defaultValue:Float = (mDefaultSpacing != null)
        ? mDefaultSpacing[spacingType]
        : (spacingType == START || spacingType == END ? CSSConstants.UNDEFINED : 0);

    if (mValueFlags == 0) {
      return defaultValue;
    }

    if ((mValueFlags & sFlagsMap[spacingType]) != 0) {
      return mSpacing[spacingType];
    }

    if (mHasAliasesSet) {
      var secondType: Int = spacingType == TOP || spacingType == BOTTOM ? VERTICAL : HORIZONTAL;
      if ((mValueFlags & sFlagsMap[secondType]) != 0) {
        return mSpacing[secondType];
      } else if ((mValueFlags & sFlagsMap[ALL]) != 0) {
        return mSpacing[ALL];
      }
    }

    return defaultValue;
  }

  /**
   * Get the raw value (that was set using {@link #set(int, float)}), without taking into account
   * any default values.
   *
   * @param spacingType one of {@link #LEFT}, {@link #TOP}, {@link #RIGHT}, {@link #BOTTOM},
   *        {@link #VERTICAL}, {@link #HORIZONTAL}, {@link #ALL}
   */
  public function getRaw(spacingType: Int): Float {
    return mSpacing[spacingType];
  }

  /**
   * Resets the spacing instance to its default state. This method is meant to be used when
   * recycling {@link Spacing} instances.
   */
  public function reset() {
    mSpacing = newFullSpacingArray();
    mDefaultSpacing = null;
    mHasAliasesSet = false;
    mValueFlags = 0;
  }

  /**
   * Try to get start value and fallback to given type if not defined. This is used privately
   * by the layout engine as a more efficient way to fetch direction-aware values by
   * avoid extra method invocations.
   */
  public function getWithFallback(spacingType: Int, fallbackType: Int) {
    return (mValueFlags & sFlagsMap[spacingType]) != 0
            ? mSpacing[spacingType]
            : get(fallbackType);
  }

  private static function newFullSpacingArray() {
    return [
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
    ];
  }

  private static function newSpacingResultArray(defaultValue: Float = 0) {
    return [
      defaultValue,
      defaultValue,
      defaultValue,
      defaultValue,
      defaultValue,
      defaultValue,
      CSSConstants.UNDEFINED,
      CSSConstants.UNDEFINED,
      defaultValue,
    ];
  }
}

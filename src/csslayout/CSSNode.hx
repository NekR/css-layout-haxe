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


enum LayoutState {
  /**
   * Some property of this node or its children has changes and the current values in
   * {@link #layout} are not valid.
   */
  DIRTY;

  /**
   * This node has a new layout relative to the last time {@link #markLayoutSeen()} was called.
   */
  HAS_NEW_LAYOUT;

  /**
   * {@link #layout} is valid for the node's properties and this layout has been marked as
   * having been seen.
   */
  UP_TO_DATE;
}

typedef MeasureFunction = CSSNode -> Float -> Float -> Array<Float>;
/**
 * A CSS Node. It has a style object you can manipulate at {@link #style}. After calling
 * {@link #calculateLayout()}, {@link #layout} will be filled with the results of the layout.
 */
class CSSNode {
  private static var DIMENSION_HEIGHT = CSSLayout.DIMENSION_HEIGHT;
  private static var DIMENSION_WIDTH = CSSLayout.DIMENSION_WIDTH;
  private static var POSITION_BOTTOM = CSSLayout.POSITION_BOTTOM;
  private static var POSITION_LEFT = CSSLayout.POSITION_LEFT;
  private static var POSITION_RIGHT = CSSLayout.POSITION_RIGHT;
  private static var POSITION_TOP = CSSLayout.POSITION_TOP;

  // VisibleForTesting
  public var style = new CSSStyle();
  public var layout = new CSSLayout();
  public var lastLayout = new CachedCSSLayout();

  public var lineIndex = 0;

  public var nextAbsoluteChild: Null<CSSNode> = null;
  public var nextFlexChild: Null<CSSNode> = null;

  private var mChildren = new Array<CSSNode>();
  private var mParent: Null<CSSNode> = null;
  private var mMeasureFunction: Null<MeasureFunction>;
  private var mLayoutState = LayoutState.DIRTY;

  public function new() {}

  public function getChildCount() {
    return mChildren == null ? 0 : mChildren.length;
  }

  public function getChildAt(i: Int): CSSNode {
    return mChildren[i];
  }

  public function addChildAt(child: CSSNode, i: Int) {
    if (child.mParent != null) {
      throw "Child already has a parent, it must be removed first.";
    }

    mChildren[i] = child;
    child.mParent = this;
    dirty();
  }

  public function removeChildAt(i: Int): CSSNode {
    var removed = mChildren.splice(i, 1)[0];
    removed.mParent = null;
    dirty();
    return removed;
  }

  public function getParent(): Null<CSSNode> {
    return mParent;
  }

  /**
   * @return the index of the given child, or -1 if the child doesn't exist in this node.
   */
  public function indexOf(child: CSSNode): Int {
    return mChildren.indexOf(child);
  }

  public function setMeasureFunction(measureFunction: MeasureFunction) {
    if (mMeasureFunction != measureFunction) {
      mMeasureFunction = measureFunction;
      dirty();
    }
  }

  public function isMeasureDefined(): Bool {
    return mMeasureFunction != null;
  }

  public function measure(width: Float, height: Float): Array<Float> {
    if (!isMeasureDefined()) {
      throw "Measure function isn't defined!";
    }

    var output = mMeasureFunction(this, width, height);

    // measureOutput.height = CSSConstants.UNDEFINED;
    // measureOutput.width = CSSConstants.UNDEFINED;

    return output;
  }

  /**
   * Performs the actual layout and saves the results in {@link #layout}
   */
  public function calculateLayout() {
    layout.resetResult();
    LayoutEngine.layoutNode(this, CSSConstants.UNDEFINED, CSSConstants.UNDEFINED, null);
  }

  /**
   * See {@link LayoutState#DIRTY}.
   */
  public function isDirty() {
    return mLayoutState == LayoutState.DIRTY;
  }

  /**
   * See {@link LayoutState#HAS_NEW_LAYOUT}.
   */
  public function hasNewLayout() {
    return mLayoutState == LayoutState.HAS_NEW_LAYOUT;
  }

  public function dirty() {
    if (mLayoutState == LayoutState.DIRTY) {
      return;
    } else if (mLayoutState == LayoutState.HAS_NEW_LAYOUT) {
      throw "Previous layout was ignored! markLayoutSeen() never called";
    }

    mLayoutState = LayoutState.DIRTY;

    if (mParent != null) {
      mParent.dirty();
    }
  }

  public function markHasNewLayout() {
    mLayoutState = LayoutState.HAS_NEW_LAYOUT;
  }

  /**
   * Tells the node that the current values in {@link #layout} have been seen. Subsequent calls
   * to {@link #hasNewLayout()} will return false until this node is laid out with new parameters.
   * You must call this each time the layout is generated if the node has a new layout.
   */
  public function markLayoutSeen() {
    if (!hasNewLayout()) {
      throw "Expected node to have a new layout to be seen!";
    }

    mLayoutState = LayoutState.UP_TO_DATE;
  }

  public function toObject(): Dynamic {
    return {
      layout: this.layout.toObject(),
      children: this.mChildren.map(function(node: CSSNode) {
        return node.toObject();
      })
    }
  }

  public function toString() {
    return Json.stringify(toObject(), null, '  ');
  }

  public function valuesEqual(f1: Float, f2: Float): Bool {
    return FloatUtil.floatsEqual(f1, f2);
  }

  /**
   * Get this node's direction, as defined in the style.
   */
  public function getStyleDirection(): CSSDirection {
    return style.direction;
  }

  public function setDirection(direction: CSSDirection) {
    if (style.direction != direction) {
      style.direction = direction;
      dirty();
    }
  }

  /**
   * Get this node's flex direction, as defined by style.
   */
  public function getFlexDirection(): CSSFlexDirection {
    return style.flexDirection;
  }

  public function setFlexDirection(flexDirection: CSSFlexDirection) {
    if (style.flexDirection != flexDirection) {
      style.flexDirection = flexDirection;
      dirty();
    }
  }

  /**
   * Get this node's justify content, as defined by style.
   */
  public function getJustifyContent(): CSSJustify {
    return style.justifyContent;
  }

  public function setJustifyContent(justifyContent: CSSJustify) {
    if (style.justifyContent != justifyContent) {
      style.justifyContent = justifyContent;
      dirty();
    }
  }

  /**
   * Get this node's align items, as defined by style.
   */
  public function getAlignItems(): CSSAlign {
    return style.alignItems;
  }

  public function setAlignItems(alignItems: CSSAlign) {
    if (style.alignItems != alignItems) {
      style.alignItems = alignItems;
      dirty();
    }
  }

  /**
   * Get this node's align items, as defined by style.
   */
  public function getAlignSelf(): CSSAlign {
    return style.alignSelf;
  }

  public function setAlignSelf(alignSelf: CSSAlign) {
    if (style.alignSelf != alignSelf) {
      style.alignSelf = alignSelf;
      dirty();
    }
  }

  /**
   * Get this node's position type, as defined by style.
   */
  public function getPositionType(): CSSPositionType {
    return style.positionType;
  }

  public function setPositionType(positionType: CSSPositionType) {
    if (style.positionType != positionType) {
      style.positionType = positionType;
      dirty();
    }
  }

  public function setWrap(flexWrap: CSSWrap) {
    if (style.flexWrap != flexWrap) {
      style.flexWrap = flexWrap;
      dirty();
    }
  }

  /**
   * Get this node's flex, as defined by style.
   */
  public function getFlex() {
    return style.flex;
  }

  public function setFlex(flex: Float) {
    if (!valuesEqual(style.flex, flex)) {
      style.flex = flex;
      dirty();
    }
  }

  /**
   * Get this node's margin, as defined by style + default margin.
   */
  public function getMargin() {
    return style.margin;
  }

  public function setMargin(spacingType: Int, margin: Float) {
    if (style.margin.set(spacingType, margin)) {
      dirty();
    }
  }

  /**
   * Get this node's padding, as defined by style + default padding.
   */
  public function getPadding() {
    return style.padding;
  }

  public function setPadding(spacingType: Int, padding: Float) {
    if (style.padding.set(spacingType, padding)) {
      dirty();
    }
  }

  /**
   * Get this node's border, as defined by style.
   */
  public function getBorder() {
    return style.border;
  }

  public function setBorder(spacingType: Int, border: Float) {
    if (style.border.set(spacingType, border)) {
      dirty();
    }
  }

  /**
   * Get this node's position top, as defined by style.
   */
  public function getPositionTop() {
    return style.position[POSITION_TOP];
  }

  public function setPositionTop(positionTop: Float) {
    if (!valuesEqual(style.position[POSITION_TOP], positionTop)) {
      style.position[POSITION_TOP] = positionTop;
      dirty();
    }
  }

  /**
   * Get this node's position bottom, as defined by style.
   */
  public function getPositionBottom() {
    return style.position[POSITION_BOTTOM];
  }

  public function setPositionBottom(positionBottom: Float) {
    if (!valuesEqual(style.position[POSITION_BOTTOM], positionBottom)) {
      style.position[POSITION_BOTTOM] = positionBottom;
      dirty();
    }
  }

  /**
   * Get this node's position left, as defined by style.
   */
  public function getPositionLeft() {
    return style.position[POSITION_LEFT];
  }

  public function setPositionLeft(positionLeft: Float) {
    if (!valuesEqual(style.position[POSITION_LEFT], positionLeft)) {
      style.position[POSITION_LEFT] = positionLeft;
      dirty();
    }
  }

  /**
   * Get this node's position right, as defined by style.
   */
  public function getPositionRight() {
    return style.position[POSITION_RIGHT];
  }

  public function setPositionRight(positionRight: Float) {
    if (!valuesEqual(style.position[POSITION_RIGHT], positionRight)) {
      style.position[POSITION_RIGHT] = positionRight;
      dirty();
    }
  }

  /**
   * Get this node's width, as defined in the style.
   */
  public function getStyleWidth() {
    return style.dimensions[DIMENSION_WIDTH];
  }

  public function setStyleWidth(width: Float) {
    if (!valuesEqual(style.dimensions[DIMENSION_WIDTH], width)) {
      style.dimensions[DIMENSION_WIDTH] = width;
      dirty();
    }
  }

  /**
   * Get this node's height, as defined in the style.
   */
  public function getStyleHeight() {
    return style.dimensions[DIMENSION_HEIGHT];
  }

  public function setStyleHeight(height: Float) {
    if (!valuesEqual(style.dimensions[DIMENSION_HEIGHT], height)) {
      style.dimensions[DIMENSION_HEIGHT] = height;
      dirty();
    }
  }

  public function getLayoutX() {
    return layout.position[POSITION_LEFT];
  }

  public function getLayoutY() {
    return layout.position[POSITION_TOP];
  }

  public function getLayoutWidth() {
    return layout.dimensions[DIMENSION_WIDTH];
  }

  public function getLayoutHeight() {
    return layout.dimensions[DIMENSION_HEIGHT];
  }

  public function getLayoutDirection() {
    return layout.direction;
  }

  /**
   * Set a default padding (left/top/right/bottom) for this node.
   */
  public function setDefaultPadding(spacingType: Int, padding: Float) {
    if (style.padding.setDefault(spacingType, padding)) {
      dirty();
    }
  }

  /**
   * Resets this instance to its default state. This method is meant to be used when
   * recycling {@link CSSNode} instances.
   */
  public function reset() {
    if (mParent != null || mChildren.length > 0) {
      throw "You should not reset an attached CSSNode";
    }

    style.reset();
    layout.resetResult();
    lineIndex = 0;
    mLayoutState = LayoutState.DIRTY;
  }
}

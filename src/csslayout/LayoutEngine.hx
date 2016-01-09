/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */
package csslayout;

/*import CSSLayout;
import CSSFlexDirection;
import CSSPositionType;
import CSSConstants;
import FloatUtil;*/

/**
 * Calculates layouts based on CSS style. See {@link #layoutNode(CSSNode, float, float)}.
 */
class LayoutEngine {

  private static var CSS_FLEX_DIRECTION_COLUMN = Type.enumIndex(CSSFlexDirection.COLUMN);
  private static var CSS_FLEX_DIRECTION_COLUMN_REVERSE = Type.enumIndex(CSSFlexDirection.COLUMN_REVERSE);
  private static var CSS_FLEX_DIRECTION_ROW = Type.enumIndex(CSSFlexDirection.ROW);
  private static var CSS_FLEX_DIRECTION_ROW_REVERSE = Type.enumIndex(CSSFlexDirection.ROW_REVERSE);

  private static var CSS_POSITION_RELATIVE = Type.enumIndex(CSSPositionType.RELATIVE);
  private static var CSS_POSITION_ABSOLUTE = Type.enumIndex(CSSPositionType.ABSOLUTE);

  private static var DIMENSION_HEIGHT = CSSLayout.DIMENSION_HEIGHT;
  private static var DIMENSION_WIDTH = CSSLayout.DIMENSION_WIDTH;
  private static var POSITION_BOTTOM = CSSLayout.POSITION_BOTTOM;
  private static var POSITION_LEFT = CSSLayout.POSITION_LEFT;
  private static var POSITION_RIGHT = CSSLayout.POSITION_RIGHT;
  private static var POSITION_TOP = CSSLayout.POSITION_TOP;

  private static var leading:Array<Int> = [
    POSITION_TOP,
    POSITION_BOTTOM,
    POSITION_LEFT,
    POSITION_RIGHT,
  ];

  private static var trailing:Array<Int> = [
    POSITION_BOTTOM,
    POSITION_TOP,
    POSITION_RIGHT,
    POSITION_LEFT,
  ];

  private static var pos:Array<Int> = [
    POSITION_TOP,
    POSITION_BOTTOM,
    POSITION_LEFT,
    POSITION_RIGHT,
  ];

  private static var dim:Array<Int> = [
    DIMENSION_HEIGHT,
    DIMENSION_HEIGHT,
    DIMENSION_WIDTH,
    DIMENSION_WIDTH,
  ];

  private static var leadingSpacing:Array<Int> = [
    Spacing.TOP,
    Spacing.BOTTOM,
    Spacing.START,
    Spacing.START
  ];

  private static var trailingSpacing:Array<Int> = [
    Spacing.BOTTOM,
    Spacing.TOP,
    Spacing.END,
    Spacing.END
  ];

  private static function boundAxis(node: CSSNode, axis: Int, value: Float): Float {
    var min = CSSConstants.UNDEFINED;
    var max = CSSConstants.UNDEFINED;

    if (axis == CSS_FLEX_DIRECTION_COLUMN ||
        axis == CSS_FLEX_DIRECTION_COLUMN_REVERSE) {
      min = node.style.minHeight;
      max = node.style.maxHeight;
    } else if (axis == CSS_FLEX_DIRECTION_ROW ||
               axis == CSS_FLEX_DIRECTION_ROW_REVERSE) {
      min = node.style.minWidth;
      max = node.style.maxWidth;
    }

    if (!Math.isNaN(max) && max >= 0.0 && value > max) {
      value = max;
    }
    if (!Math.isNaN(min) && min >= 0.0 && value < min) {
      value = min;
    }

    return value;
  }

  private static function setDimensionFromStyle(node: CSSNode, axis: Int) {
    // The parent already computed us a width or height. We just skip it
    if (!Math.isNaN(node.layout.dimensions[dim[axis]])) {
      return;
    }

    // We only run if there's a width or height defined
    if (Math.isNaN(node.style.dimensions[dim[axis]]) ||
        node.style.dimensions[dim[axis]] <= 0.0) {
      return;
    }

    // The dimensions can never be smaller than the padding and border
    var maxLayoutDimension = Math.max(
        boundAxis(node, axis, node.style.dimensions[dim[axis]]),
        node.style.padding.getWithFallback(leadingSpacing[axis], leading[axis]) +
            node.style.padding.getWithFallback(trailingSpacing[axis], trailing[axis]) +
            node.style.border.getWithFallback(leadingSpacing[axis], leading[axis]) +
            node.style.border.getWithFallback(trailingSpacing[axis], trailing[axis]));
    node.layout.dimensions[dim[axis]] = maxLayoutDimension;
  }

  private static function getRelativePosition(node: CSSNode, axis: Int): Float {
    var lead = node.style.position[leading[axis]];

    if (!Math.isNaN(lead)) {
      return lead;
    }

    var trailingPos = node.style.position[trailing[axis]];
    return Math.isNaN(trailingPos) ? 0 : -trailingPos;
  }

  private static function resolveAxis(axis: Int, direction: CSSDirection): Int {
    if (direction == CSSDirection.RTL) {
      if (axis == CSS_FLEX_DIRECTION_ROW) {
        return CSS_FLEX_DIRECTION_ROW_REVERSE;
      } else if (axis == CSS_FLEX_DIRECTION_ROW_REVERSE) {
        return CSS_FLEX_DIRECTION_ROW;
      }
    }

    return axis;
  }

  private static function resolveDirection(node: CSSNode, parentDirection: CSSDirection): CSSDirection {
    var direction: CSSDirection = node.style.direction;

    if (direction == CSSDirection.INHERIT) {
      direction = (parentDirection == null ? CSSDirection.LTR : parentDirection);
    }

    return direction;
  }

  private static function getFlexDirection(node: CSSNode): Int {
    return Type.enumIndex(node.style.flexDirection);
  }

  private static function getCrossFlexDirection(axis: Int, direction: CSSDirection): Int {
    if (axis == CSS_FLEX_DIRECTION_COLUMN ||
        axis == CSS_FLEX_DIRECTION_COLUMN_REVERSE) {
      return resolveAxis(CSS_FLEX_DIRECTION_ROW, direction);
    } else {
      return CSS_FLEX_DIRECTION_COLUMN;
    }
  }

  private static function getAlignItem(node: CSSNode, child: CSSNode): CSSAlign {
    if (child.style.alignSelf != CSSAlign.AUTO) {
      return child.style.alignSelf;
    }

    return node.style.alignItems;
  }

  private static function isMeasureDefined(node: CSSNode): Bool {
    return node.isMeasureDefined();
  }

  public static function needsRelayout(node: CSSNode, parentMaxWidth: Float, parentMaxHeight: Float): Bool {
    return node.isDirty() ||
        !FloatUtil.floatsEqual(
            node.lastLayout.requestedHeight,
            node.layout.dimensions[DIMENSION_HEIGHT]) ||
        !FloatUtil.floatsEqual(
            node.lastLayout.requestedWidth,
            node.layout.dimensions[DIMENSION_WIDTH]) ||
        !FloatUtil.floatsEqual(node.lastLayout.parentMaxWidth, parentMaxWidth) ||
        !FloatUtil.floatsEqual(node.lastLayout.parentMaxHeight, parentMaxHeight);
  }

  public static function layoutNode(
    node: CSSNode,
    parentMaxWidth: Float,
    parentMaxHeight: Float,
    parentDirection: CSSDirection
  ) {
    if (needsRelayout(node, parentMaxWidth, parentMaxHeight)) {
      node.lastLayout.requestedWidth = node.layout.dimensions[DIMENSION_WIDTH];
      node.lastLayout.requestedHeight = node.layout.dimensions[DIMENSION_HEIGHT];
      node.lastLayout.parentMaxWidth = parentMaxWidth;
      node.lastLayout.parentMaxHeight = parentMaxHeight;

      layoutNodeImpl(node, parentMaxWidth, parentMaxHeight, parentDirection);
      node.lastLayout.copy(node.layout);
    } else {
      node.layout.copy(node.lastLayout);
    }

    node.markHasNewLayout();
  }

  private static function layoutNodeImpl(
    node: CSSNode,
    parentMaxWidth: Float,
    parentMaxHeight: Float,
    parentDirection: CSSDirection
  ) {
    for (i in 0...node.getChildCount()) {
      node.getChildAt(i).layout.resetResult();
    }
    /** START_GENERATED **/

    var direction = resolveDirection(node, parentDirection);
    var mainAxis = resolveAxis(getFlexDirection(node), direction);
    var crossAxis = getCrossFlexDirection(mainAxis, direction);
    var resolvedRowAxis = resolveAxis(CSS_FLEX_DIRECTION_ROW, direction);

    // Handle width and height style attributes
    setDimensionFromStyle(node, mainAxis);
    setDimensionFromStyle(node, crossAxis);

    // Set the resolved resolution in the node's layout
    node.layout.direction = direction;

    // The position is set by the parent, but we need to complete it with a
    // delta composed of the margin and left/top/right/bottom
    node.layout.position[leading[mainAxis]] += node.style.margin.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) +
      getRelativePosition(node, mainAxis);
    node.layout.position[trailing[mainAxis]] += node.style.margin.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]) +
      getRelativePosition(node, mainAxis);
    node.layout.position[leading[crossAxis]] += node.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) +
      getRelativePosition(node, crossAxis);
    node.layout.position[trailing[crossAxis]] += node.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]) +
      getRelativePosition(node, crossAxis);

    // Inline immutable values from the target node to avoid excessive method
    // invocations during the layout calculation.
    var childCount = node.getChildCount();
    var paddingAndBorderAxisResolvedRow: Float = ((node.style.padding.getWithFallback(leadingSpacing[resolvedRowAxis], leading[resolvedRowAxis]) + node.style.border.getWithFallback(leadingSpacing[resolvedRowAxis], leading[resolvedRowAxis])) + (node.style.padding.getWithFallback(trailingSpacing[resolvedRowAxis], trailing[resolvedRowAxis]) + node.style.border.getWithFallback(trailingSpacing[resolvedRowAxis], trailing[resolvedRowAxis])));
    var paddingAndBorderAxisColumn: Float = ((node.style.padding.getWithFallback(leadingSpacing[CSS_FLEX_DIRECTION_COLUMN], leading[CSS_FLEX_DIRECTION_COLUMN]) + node.style.border.getWithFallback(leadingSpacing[CSS_FLEX_DIRECTION_COLUMN], leading[CSS_FLEX_DIRECTION_COLUMN])) + (node.style.padding.getWithFallback(trailingSpacing[CSS_FLEX_DIRECTION_COLUMN], trailing[CSS_FLEX_DIRECTION_COLUMN]) + node.style.border.getWithFallback(trailingSpacing[CSS_FLEX_DIRECTION_COLUMN], trailing[CSS_FLEX_DIRECTION_COLUMN])));

    if (isMeasureDefined(node)) {
      var isResolvedRowDimDefined = !Math.isNaN(node.layout.dimensions[dim[resolvedRowAxis]]);

      var width = CSSConstants.UNDEFINED;
      if ((!Math.isNaN(node.style.dimensions[dim[resolvedRowAxis]]) && node.style.dimensions[dim[resolvedRowAxis]] >= 0.0)) {
        width = node.style.dimensions[DIMENSION_WIDTH];
      } else if (isResolvedRowDimDefined) {
        width = node.layout.dimensions[dim[resolvedRowAxis]];
      } else {
        width = parentMaxWidth -
          (node.style.margin.getWithFallback(leadingSpacing[resolvedRowAxis], leading[resolvedRowAxis]) + node.style.margin.getWithFallback(trailingSpacing[resolvedRowAxis], trailing[resolvedRowAxis]));
      }
      width -= paddingAndBorderAxisResolvedRow;

      var height = CSSConstants.UNDEFINED;
      if ((!Math.isNaN(node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]]) && node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]] >= 0.0)) {
        height = node.style.dimensions[DIMENSION_HEIGHT];
      } else if (!Math.isNaN(node.layout.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]])) {
        height = node.layout.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]];
      } else {
        height = parentMaxHeight -
          (node.style.margin.getWithFallback(leadingSpacing[resolvedRowAxis], leading[resolvedRowAxis]) + node.style.margin.getWithFallback(trailingSpacing[resolvedRowAxis], trailing[resolvedRowAxis]));
      }
      height -= ((node.style.padding.getWithFallback(leadingSpacing[CSS_FLEX_DIRECTION_COLUMN], leading[CSS_FLEX_DIRECTION_COLUMN]) + node.style.border.getWithFallback(leadingSpacing[CSS_FLEX_DIRECTION_COLUMN], leading[CSS_FLEX_DIRECTION_COLUMN])) + (node.style.padding.getWithFallback(trailingSpacing[CSS_FLEX_DIRECTION_COLUMN], trailing[CSS_FLEX_DIRECTION_COLUMN]) + node.style.border.getWithFallback(trailingSpacing[CSS_FLEX_DIRECTION_COLUMN], trailing[CSS_FLEX_DIRECTION_COLUMN])));

      // We only need to give a dimension for the text if we haven't got any
      // for it computed yet. It can either be from the style attribute or because
      // the element is flexible.
      var isRowUndefined = !(!Math.isNaN(node.style.dimensions[dim[resolvedRowAxis]]) && node.style.dimensions[dim[resolvedRowAxis]] >= 0.0) && !isResolvedRowDimDefined;
      var isColumnUndefined = !(!Math.isNaN(node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]]) && node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]] >= 0.0) && Math.isNaN(node.layout.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]]);

      // Let's not measure the text if we already know both dimensions
      if (isRowUndefined || isColumnUndefined) {
        // [width. height] array
        var measureDim = node.measure(width, height);

        if (isRowUndefined) {
          node.layout.dimensions[DIMENSION_WIDTH] = measureDim[0] +
            paddingAndBorderAxisResolvedRow;
        }

        if (isColumnUndefined) {
          node.layout.dimensions[DIMENSION_HEIGHT] = measureDim[1] +
            paddingAndBorderAxisColumn;
        }
      }

      if (childCount == 0) {
        return;
      }
    }

    var isNodeFlexWrap = (node.style.flexWrap == CSSWrap.WRAP);
    var justifyContent = node.style.justifyContent;

    var leadingPaddingAndBorderMain: Float = (node.style.padding.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + node.style.border.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]));
    var leadingPaddingAndBorderCross: Float = (node.style.padding.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + node.style.border.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]));
    var paddingAndBorderAxisMain: Float = ((node.style.padding.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + node.style.border.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis])) + (node.style.padding.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]) + node.style.border.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis])));
    var paddingAndBorderAxisCross: Float = ((node.style.padding.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + node.style.border.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis])) + (node.style.padding.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]) + node.style.border.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis])));

    var isMainDimDefined = !Math.isNaN(node.layout.dimensions[dim[mainAxis]]);
    var isCrossDimDefined = !Math.isNaN(node.layout.dimensions[dim[crossAxis]]);
    var isMainRowDirection = (mainAxis == CSS_FLEX_DIRECTION_ROW || mainAxis == CSS_FLEX_DIRECTION_ROW_REVERSE);

    var child: Null<CSSNode> = null;
    var axis;

    var firstAbsoluteChild: Null<CSSNode> = null;
    var currentAbsoluteChild: Null<CSSNode> = null;

    var definedMainDim = CSSConstants.UNDEFINED;

    if (isMainDimDefined) {
      definedMainDim = node.layout.dimensions[dim[mainAxis]] - paddingAndBorderAxisMain;
    }

    // We want to execute the next two loops one per line with flex-wrap
    var startLine: Int = 0;
    var endLine: Int = 0;
    // var nextOffset: Int = 0;
    var alreadyComputedNextLayout: Int = 0;
    // We aggregate the total dimensions of the container in those two variables
    var linesCrossDim: Float = 0;
    var linesMainDim: Float = 0;
    var linesCount: Int = 0;

    while (endLine < childCount) {
      // <Loop A> Layout non flexible children and count children by type

      // mainContentDim is accumulation of the dimensions and margin of all the
      // non flexible children. This will be used in order to either set the
      // dimensions of the node if none already exist, or to compute the
      // remaining space left for the flexible children.
      var mainContentDim: Float = 0;

      // There are three kind of children, non flexible, flexible and absolute.
      // We need to know how many there are in order to distribute the space.
      var flexibleChildrenCount: Int = 0;
      var totalFlexible: Float = 0;
      var nonFlexibleChildrenCount: Int = 0;

      // Use the line loop to position children in the main axis for as long
      // as they are using a simple stacking behaviour. Children that are
      // immediately stacked in the initial loop will not be touched again
      // in <Loop C>.
      var isSimpleStackMain = (isMainDimDefined && justifyContent == CSSJustify.FLEX_START) ||
        (!isMainDimDefined && justifyContent != CSSJustify.CENTER);
      var firstComplexMain: Int = (isSimpleStackMain ? childCount : startLine);

      // Use the initial line loop to position children in the cross axis for
      // as long as they are relatively positioned with alignment STRETCH or
      // FLEX_START. Children that are immediately stacked in the initial loop
      // will not be touched again in <Loop D>.
      var isSimpleStackCross = true;
      var firstComplexCross = childCount;

      var firstFlexChild: Null<CSSNode> = null;
      var currentFlexChild: Null<CSSNode> = null;

      var mainDim: Float = leadingPaddingAndBorderMain;
      var crossDim: Float = 0;

      var maxWidth: Float;
      var maxHeight: Float;

      for (i in startLine...childCount) {
        child = node.getChildAt(i);
        child.lineIndex = linesCount;

        child.nextAbsoluteChild = null;
        child.nextFlexChild = null;

        var alignItem: CSSAlign = getAlignItem(node, child);

        // Pre-fill cross axis dimensions when the child is using stretch before
        // we call the recursive layout pass
        if (
          alignItem == CSSAlign.STRETCH &&
          child.style.positionType == CSSPositionType.RELATIVE &&
          isCrossDimDefined && !(
            !Math.isNaN(child.style.dimensions[dim[crossAxis]]) &&
            child.style.dimensions[dim[crossAxis]] >= 0.0
          )
        ) {
          child.layout.dimensions[dim[crossAxis]] = Math.max(
            boundAxis(child, crossAxis, node.layout.dimensions[dim[crossAxis]] -
              paddingAndBorderAxisCross - (child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]))),
            // You never want to go smaller than padding
            ((child.style.padding.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.border.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis])) + (child.style.padding.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]) + child.style.border.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis])))
          );
        } else if (child.style.positionType == CSSPositionType.ABSOLUTE) {
          // Store a private linked list of absolutely positioned children
          // so that we can efficiently traverse them later.
          if (firstAbsoluteChild == null) {
            firstAbsoluteChild = child;
          }

          if (currentAbsoluteChild != null) {
            currentAbsoluteChild.nextAbsoluteChild = child;
          }

          currentAbsoluteChild = child;

          // Pre-fill dimensions when using absolute position and both offsets for the axis are defined (either both
          // left and right or top and bottom).
          for (ii in 0...2) {
            axis = (ii != 0) ? CSS_FLEX_DIRECTION_ROW : CSS_FLEX_DIRECTION_COLUMN;
            if (!Math.isNaN(node.layout.dimensions[dim[axis]]) &&
                !(!Math.isNaN(child.style.dimensions[dim[axis]]) && child.style.dimensions[dim[axis]] >= 0.0) &&
                !Math.isNaN(child.style.position[leading[axis]]) &&
                !Math.isNaN(child.style.position[trailing[axis]])) {
              child.layout.dimensions[dim[axis]] = Math.max(
                boundAxis(child, axis, node.layout.dimensions[dim[axis]] -
                  ((node.style.padding.getWithFallback(leadingSpacing[axis], leading[axis]) + node.style.border.getWithFallback(leadingSpacing[axis], leading[axis])) + (node.style.padding.getWithFallback(trailingSpacing[axis], trailing[axis]) + node.style.border.getWithFallback(trailingSpacing[axis], trailing[axis]))) -
                  (child.style.margin.getWithFallback(leadingSpacing[axis], leading[axis]) + child.style.margin.getWithFallback(trailingSpacing[axis], trailing[axis])) -
                  (Math.isNaN(child.style.position[leading[axis]]) ?  0 : child.style.position[leading[axis]]) -
                  (Math.isNaN(child.style.position[trailing[axis]]) ?  0 : child.style.position[trailing[axis]])),
                // You never want to go smaller than padding
                ((child.style.padding.getWithFallback(leadingSpacing[axis], leading[axis]) + child.style.border.getWithFallback(leadingSpacing[axis], leading[axis])) + (child.style.padding.getWithFallback(trailingSpacing[axis], trailing[axis]) + child.style.border.getWithFallback(trailingSpacing[axis], trailing[axis])))
              );
            }
          }
        }

        var nextContentDim: Float = 0;

        // It only makes sense to consider a child flexible if we have a computed
        // dimension for the node.
        if (isMainDimDefined && (child.style.positionType == CSSPositionType.RELATIVE && child.style.flex > 0)) {
          flexibleChildrenCount++;
          totalFlexible += child.style.flex;

          // Store a private linked list of flexible children so that we can
          // efficiently traverse them later.
          if (firstFlexChild == null) {
            firstFlexChild = child;
          }
          if (currentFlexChild != null) {
            currentFlexChild.nextFlexChild = child;
          }
          currentFlexChild = child;

          // Even if we don't know its exact size yet, we already know the padding,
          // border and margin. We'll use this partial information, which represents
          // the smallest possible size for the child, to compute the remaining
          // available space.
          nextContentDim = ((child.style.padding.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + child.style.border.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis])) + (child.style.padding.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]) + child.style.border.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]))) +
            (child.style.margin.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + child.style.margin.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]));

        } else {
          maxWidth = CSSConstants.UNDEFINED;
          maxHeight = CSSConstants.UNDEFINED;

          if (!isMainRowDirection) {
            if ((!Math.isNaN(node.style.dimensions[dim[resolvedRowAxis]]) && node.style.dimensions[dim[resolvedRowAxis]] >= 0.0)) {
              maxWidth = node.layout.dimensions[dim[resolvedRowAxis]] -
                paddingAndBorderAxisResolvedRow;
            } else {
              maxWidth = parentMaxWidth -
                (node.style.margin.getWithFallback(leadingSpacing[resolvedRowAxis], leading[resolvedRowAxis]) + node.style.margin.getWithFallback(trailingSpacing[resolvedRowAxis], trailing[resolvedRowAxis])) -
                paddingAndBorderAxisResolvedRow;
            }
          } else {
            if ((!Math.isNaN(node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]]) && node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]] >= 0.0)) {
              maxHeight = node.layout.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]] -
                  paddingAndBorderAxisColumn;
            } else {
              maxHeight = parentMaxHeight -
                (node.style.margin.getWithFallback(leadingSpacing[CSS_FLEX_DIRECTION_COLUMN], leading[CSS_FLEX_DIRECTION_COLUMN]) + node.style.margin.getWithFallback(trailingSpacing[CSS_FLEX_DIRECTION_COLUMN], trailing[CSS_FLEX_DIRECTION_COLUMN])) -
                paddingAndBorderAxisColumn;
            }
          }

          // This is the main recursive call. We layout non flexible children.
          if (alreadyComputedNextLayout == 0) {
            layoutNode(child, maxWidth, maxHeight, direction);
          }

          // Absolute positioned elements do not take part of the layout, so we
          // don't use them to compute mainContentDim
          if (child.style.positionType == CSSPositionType.RELATIVE) {
            nonFlexibleChildrenCount++;
            // At this point we know the final size and margin of the element.
            nextContentDim = (child.layout.dimensions[dim[mainAxis]] + child.style.margin.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + child.style.margin.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]));
          }
        }

        // The element we are about to add would make us go to the next line
        if (
          isNodeFlexWrap && isMainDimDefined &&
          mainContentDim + nextContentDim > definedMainDim &&
          // If there's only one element, then it's bigger than the content
          // and needs its own line
          i != startLine
        ) {
          nonFlexibleChildrenCount--;
          alreadyComputedNextLayout = 1;
          break;
        }

        // Disable simple stacking in the main axis for the current line as
        // we found a non-trivial child. The remaining children will be laid out
        // in <Loop C>.
        if (
          isSimpleStackMain && (
            child.style.positionType != CSSPositionType.RELATIVE ||
            (child.style.positionType == CSSPositionType.RELATIVE && child.style.flex > 0)
          )
        ) {
          isSimpleStackMain = false;
          firstComplexMain = i;
        }

        // Disable simple stacking in the cross axis for the current line as
        // we found a non-trivial child. The remaining children will be laid out
        // in <Loop D>.
        if (
          isSimpleStackCross && (
            child.style.positionType != CSSPositionType.RELATIVE ||
            (alignItem != CSSAlign.STRETCH && alignItem != CSSAlign.FLEX_START) ||
            Math.isNaN(child.layout.dimensions[dim[crossAxis]])
          )
        ) {
          isSimpleStackCross = false;
          firstComplexCross = i;
        }

        if (isSimpleStackMain) {
          child.layout.position[pos[mainAxis]] += mainDim;

          if (isMainDimDefined) {
            child.layout.position[trailing[mainAxis]] = node.layout.dimensions[dim[mainAxis]] - child.layout.dimensions[dim[mainAxis]] - child.layout.position[pos[mainAxis]];
          }

          mainDim += (child.layout.dimensions[dim[mainAxis]] + child.style.margin.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + child.style.margin.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]));
          crossDim = Math.max(crossDim, boundAxis(child, crossAxis, (child.layout.dimensions[dim[crossAxis]] + child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]))));
        }

        if (isSimpleStackCross) {
          child.layout.position[pos[crossAxis]] += linesCrossDim + leadingPaddingAndBorderCross;

          if (isCrossDimDefined) {
            child.layout.position[trailing[crossAxis]] = node.layout.dimensions[dim[crossAxis]] - child.layout.dimensions[dim[crossAxis]] - child.layout.position[pos[crossAxis]];
          }
        }

        alreadyComputedNextLayout = 0;
        mainContentDim += nextContentDim;
        endLine = i + 1;
      }

      // <Loop B> Layout flexible children and allocate empty space

      // In order to position the elements in the main axis, we have two
      // controls. The space between the beginning and the first element
      // and the space between each two elements.
      var leadingMainDim: Float = 0;
      var betweenMainDim: Float = 0;

      // The remaining available space that needs to be allocated
      var remainingMainDim: Float = 0;
      if (isMainDimDefined) {
        remainingMainDim = definedMainDim - mainContentDim;
      } else {
        remainingMainDim = Math.max(mainContentDim, 0) - mainContentDim;
      }

      // If there are flexible children in the mix, they are going to fill the
      // remaining space
      if (flexibleChildrenCount != 0) {
        var flexibleMainDim: Float = remainingMainDim / totalFlexible;
        var baseMainDim: Float;
        var boundMainDim: Float;

        // If the flex share of remaining space doesn't meet min/max bounds,
        // remove this child from flex calculations.
        currentFlexChild = firstFlexChild;
        while (currentFlexChild != null) {
          baseMainDim = flexibleMainDim * currentFlexChild.style.flex +
              ((currentFlexChild.style.padding.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + currentFlexChild.style.border.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis])) + (currentFlexChild.style.padding.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]) + currentFlexChild.style.border.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis])));
          boundMainDim = boundAxis(currentFlexChild, mainAxis, baseMainDim);

          if (baseMainDim != boundMainDim) {
            remainingMainDim -= boundMainDim;
            totalFlexible -= currentFlexChild.style.flex;
          }

          currentFlexChild = currentFlexChild.nextFlexChild;
        }
        flexibleMainDim = remainingMainDim / totalFlexible;

        // The non flexible children can overflow the container, in this case
        // we should just assume that there is no space available.
        if (flexibleMainDim < 0) {
          flexibleMainDim = 0;
        }

        currentFlexChild = firstFlexChild;
        while (currentFlexChild != null) {
          // At this point we know the final size of the element in the main
          // dimension
          currentFlexChild.layout.dimensions[dim[mainAxis]] = boundAxis(currentFlexChild, mainAxis,
            flexibleMainDim * currentFlexChild.style.flex +
                ((currentFlexChild.style.padding.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + currentFlexChild.style.border.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis])) + (currentFlexChild.style.padding.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]) + currentFlexChild.style.border.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis])))
          );

          maxWidth = CSSConstants.UNDEFINED;
          if ((!Math.isNaN(node.style.dimensions[dim[resolvedRowAxis]]) && node.style.dimensions[dim[resolvedRowAxis]] >= 0.0)) {
            maxWidth = node.layout.dimensions[dim[resolvedRowAxis]] -
              paddingAndBorderAxisResolvedRow;
          } else if (!isMainRowDirection) {
            maxWidth = parentMaxWidth -
              (node.style.margin.getWithFallback(leadingSpacing[resolvedRowAxis], leading[resolvedRowAxis]) + node.style.margin.getWithFallback(trailingSpacing[resolvedRowAxis], trailing[resolvedRowAxis])) -
              paddingAndBorderAxisResolvedRow;
          }
          maxHeight = CSSConstants.UNDEFINED;
          if ((!Math.isNaN(node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]]) && node.style.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]] >= 0.0)) {
            maxHeight = node.layout.dimensions[dim[CSS_FLEX_DIRECTION_COLUMN]] -
              paddingAndBorderAxisColumn;
          } else if (isMainRowDirection) {
            maxHeight = parentMaxHeight -
              (node.style.margin.getWithFallback(leadingSpacing[CSS_FLEX_DIRECTION_COLUMN], leading[CSS_FLEX_DIRECTION_COLUMN]) + node.style.margin.getWithFallback(trailingSpacing[CSS_FLEX_DIRECTION_COLUMN], trailing[CSS_FLEX_DIRECTION_COLUMN])) -
              paddingAndBorderAxisColumn;
          }

          // And we recursively call the layout algorithm for this child
          layoutNode(currentFlexChild, maxWidth, maxHeight, direction);

          child = currentFlexChild;
          currentFlexChild = currentFlexChild.nextFlexChild;
          child.nextFlexChild = null;
        }

      // We use justifyContent to figure out how to allocate the remaining
      // space available
      } else if (justifyContent != CSSJustify.FLEX_START) {
        if (justifyContent == CSSJustify.CENTER) {
          leadingMainDim = remainingMainDim / 2;
        } else if (justifyContent == CSSJustify.FLEX_END) {
          leadingMainDim = remainingMainDim;
        } else if (justifyContent == CSSJustify.SPACE_BETWEEN) {
          remainingMainDim = Math.max(remainingMainDim, 0);
          if (flexibleChildrenCount + nonFlexibleChildrenCount - 1 != 0) {
            betweenMainDim = remainingMainDim /
              (flexibleChildrenCount + nonFlexibleChildrenCount - 1);
          } else {
            betweenMainDim = 0;
          }
        } else if (justifyContent == CSSJustify.SPACE_AROUND) {
          // Space on the edges is half of the space between elements
          betweenMainDim = remainingMainDim /
            (flexibleChildrenCount + nonFlexibleChildrenCount);
          leadingMainDim = betweenMainDim / 2;
        }
      }

      // <Loop C> Position elements in the main axis and compute dimensions

      // At this point, all the children have their dimensions set. We need to
      // find their position. In order to do that, we accumulate data in
      // variables that are also useful to compute the total dimensions of the
      // container!
      mainDim += leadingMainDim;

      for (i in firstComplexMain...endLine) {
        child = node.getChildAt(i);

        if (child.style.positionType == CSSPositionType.ABSOLUTE &&
            !Math.isNaN(child.style.position[leading[mainAxis]])) {
          // In case the child is position absolute and has left/top being
          // defined, we override the position to whatever the user said
          // (and margin/border).
          child.layout.position[pos[mainAxis]] = (Math.isNaN(child.style.position[leading[mainAxis]]) ?  0 : child.style.position[leading[mainAxis]]) +
            node.style.border.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) +
            child.style.margin.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]);
        } else {
          // If the child is position absolute (without top/left) or relative,
          // we put it at the current accumulated offset.
          child.layout.position[pos[mainAxis]] += mainDim;

          // Define the trailing position accordingly.
          if (isMainDimDefined) {
            child.layout.position[trailing[mainAxis]] = node.layout.dimensions[dim[mainAxis]] - child.layout.dimensions[dim[mainAxis]] - child.layout.position[pos[mainAxis]];
          }

          // Now that we placed the element, we need to update the variables
          // We only need to do that for relative elements. Absolute elements
          // do not take part in that phase.
          if (child.style.positionType == CSSPositionType.RELATIVE) {
            // The main dimension is the sum of all the elements dimension plus
            // the spacing.
            mainDim += betweenMainDim + (child.layout.dimensions[dim[mainAxis]] + child.style.margin.getWithFallback(leadingSpacing[mainAxis], leading[mainAxis]) + child.style.margin.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]));
            // The cross dimension is the max of the elements dimension since there
            // can only be one element in that cross dimension.
            crossDim = Math.max(crossDim, boundAxis(child, crossAxis, (child.layout.dimensions[dim[crossAxis]] + child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]))));
          }
        }
      }

      var containerCrossAxis: Float = node.layout.dimensions[dim[crossAxis]];
      if (!isCrossDimDefined) {
        containerCrossAxis = Math.max(
          // For the cross dim, we add both sides at the end because the value
          // is aggregate via a max function. Intermediate negative values
          // can mess this computation otherwise
          boundAxis(node, crossAxis, crossDim + paddingAndBorderAxisCross),
          paddingAndBorderAxisCross
        );
      }

      // <Loop D> Position elements in the cross axis
      for (i in firstComplexCross...endLine) {
        child = node.getChildAt(i);

        if (child.style.positionType == CSSPositionType.ABSOLUTE &&
            !Math.isNaN(child.style.position[leading[crossAxis]])) {
          // In case the child is absolutely positionned and has a
          // top/left/bottom/right being set, we override all the previously
          // computed positions to set it correctly.
          child.layout.position[pos[crossAxis]] = (Math.isNaN(child.style.position[leading[crossAxis]]) ?  0 : child.style.position[leading[crossAxis]]) +
            node.style.border.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) +
            child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]);

        } else {
          var leadingCrossDim: Float = leadingPaddingAndBorderCross;

          // For a relative children, we're either using alignItems (parent) or
          // alignSelf (child) in order to determine the position in the cross axis
          if (child.style.positionType == CSSPositionType.RELATIVE) {
            /*eslint-disable */
            // This variable is intentionally re-defined as the code is transpiled to a block scope language
            var alignItem: CSSAlign = getAlignItem(node, child);
            /*eslint-enable */
            if (alignItem == CSSAlign.STRETCH) {
              // You can only stretch if the dimension has not already been set
              // previously.
              if (Math.isNaN(child.layout.dimensions[dim[crossAxis]])) {
                child.layout.dimensions[dim[crossAxis]] = Math.max(
                  boundAxis(child, crossAxis, containerCrossAxis -
                    paddingAndBorderAxisCross - (child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]))),
                  // You never want to go smaller than padding
                  ((child.style.padding.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.border.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis])) + (child.style.padding.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]) + child.style.border.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis])))
                );
              }
            } else if (alignItem != CSSAlign.FLEX_START) {
              // The remaining space between the parent dimensions+padding and child
              // dimensions+margin.
              var remainingCrossDim: Float = containerCrossAxis -
                paddingAndBorderAxisCross - (child.layout.dimensions[dim[crossAxis]] + child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]));

              if (alignItem == CSSAlign.CENTER) {
                leadingCrossDim += remainingCrossDim / 2;
              } else { // CSSAlign.FLEX_END
                leadingCrossDim += remainingCrossDim;
              }
            }
          }

          // And we apply the position
          child.layout.position[pos[crossAxis]] += linesCrossDim + leadingCrossDim;

          // Define the trailing position accordingly.
          if (isCrossDimDefined) {
            child.layout.position[trailing[crossAxis]] = node.layout.dimensions[dim[crossAxis]] - child.layout.dimensions[dim[crossAxis]] - child.layout.position[pos[crossAxis]];
          }
        }
      }

      linesCrossDim += crossDim;
      linesMainDim = Math.max(linesMainDim, mainDim);
      linesCount += 1;
      startLine = endLine;
    }

    // <Loop E>
    //
    // Note(prenaux): More than one line, we need to layout the crossAxis
    // according to alignContent.
    //
    // Note that we could probably remove <Loop D> and handle the one line case
    // here too, but for the moment this is safer since it won't interfere with
    // previously working code.
    //
    // See specs:
    // http://www.w3.org/TR/2012/CR-css3-flexbox-20120918/#layout-algorithm
    // section 9.4
    //
    if (linesCount > 1 && isCrossDimDefined) {
      var nodeCrossAxisInnerSize: Float = node.layout.dimensions[dim[crossAxis]] -
          paddingAndBorderAxisCross;
      var remainingAlignContentDim: Float = nodeCrossAxisInnerSize - linesCrossDim;

      var crossDimLead: Float = 0;
      var currentLead: Float = leadingPaddingAndBorderCross;

      var alignContent: CSSAlign = node.style.alignContent;
      if (alignContent == CSSAlign.FLEX_END) {
        currentLead += remainingAlignContentDim;
      } else if (alignContent == CSSAlign.CENTER) {
        currentLead += remainingAlignContentDim / 2;
      } else if (alignContent == CSSAlign.STRETCH) {
        if (nodeCrossAxisInnerSize > linesCrossDim) {
          crossDimLead = (remainingAlignContentDim / linesCount);
        }
      }

      var endIndex: Int = 0;
      for (i in 0...linesCount) {
        var startIndex: Int = endIndex;

        // compute the line's height and find the endIndex
        var lineHeight: Float = 0;
        for (ii in startIndex...childCount) {
          endIndex = ii;

          child = node.getChildAt(ii);
          if (child.style.positionType != CSSPositionType.RELATIVE) {
            continue;
          }
          if (child.lineIndex != i) {
            break;
          }
          if (!Math.isNaN(child.layout.dimensions[dim[crossAxis]])) {
            lineHeight = Math.max(
              lineHeight,
              child.layout.dimensions[dim[crossAxis]] + (child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]) + child.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]))
            );
          }

          // TODO: Fix this loop to use while instead of for
          endIndex = ii + 1;
        }

        lineHeight += crossDimLead;

        for (ii in startIndex...endIndex) {
          child = node.getChildAt(ii);
          if (child.style.positionType != CSSPositionType.RELATIVE) {
            continue;
          }

          var alignContentAlignItem: CSSAlign = getAlignItem(node, child);
          if (alignContentAlignItem == CSSAlign.FLEX_START) {
            child.layout.position[pos[crossAxis]] = currentLead + child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]);
          } else if (alignContentAlignItem == CSSAlign.FLEX_END) {
            child.layout.position[pos[crossAxis]] = currentLead + lineHeight - child.style.margin.getWithFallback(trailingSpacing[crossAxis], trailing[crossAxis]) - child.layout.dimensions[dim[crossAxis]];
          } else if (alignContentAlignItem == CSSAlign.CENTER) {
            var childHeight: Float = child.layout.dimensions[dim[crossAxis]];
            child.layout.position[pos[crossAxis]] = currentLead + (lineHeight - childHeight) / 2;
          } else if (alignContentAlignItem == CSSAlign.STRETCH) {
            child.layout.position[pos[crossAxis]] = currentLead + child.style.margin.getWithFallback(leadingSpacing[crossAxis], leading[crossAxis]);
            // TODO(prenaux): Correctly set the height of items with undefined
            //                (auto) crossAxis dimension.
          }
        }

        currentLead += lineHeight;
      }
    }

    var needsMainTrailingPos = false;
    var needsCrossTrailingPos = false;

    // If the user didn't specify a width or height, and it has not been set
    // by the container, then we set it via the children.
    if (!isMainDimDefined) {
      node.layout.dimensions[dim[mainAxis]] = Math.max(
        // We're missing the last padding at this point to get the final
        // dimension
        boundAxis(node, mainAxis, linesMainDim + (node.style.padding.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]) + node.style.border.getWithFallback(trailingSpacing[mainAxis], trailing[mainAxis]))),
        // We can never assign a width smaller than the padding and borders
        paddingAndBorderAxisMain
      );

      if (mainAxis == CSS_FLEX_DIRECTION_ROW_REVERSE ||
          mainAxis == CSS_FLEX_DIRECTION_COLUMN_REVERSE) {
        needsMainTrailingPos = true;
      }
    }

    if (!isCrossDimDefined) {
      node.layout.dimensions[dim[crossAxis]] = Math.max(
        // For the cross dim, we add both sides at the end because the value
        // is aggregate via a max function. Intermediate negative values
        // can mess this computation otherwise
        boundAxis(node, crossAxis, linesCrossDim + paddingAndBorderAxisCross),
        paddingAndBorderAxisCross
      );

      if (crossAxis == CSS_FLEX_DIRECTION_ROW_REVERSE ||
          crossAxis == CSS_FLEX_DIRECTION_COLUMN_REVERSE) {
        needsCrossTrailingPos = true;
      }
    }

    // <Loop F> Set trailing position if necessary
    if (needsMainTrailingPos || needsCrossTrailingPos) {
      for (i in 0...childCount) {
        child = node.getChildAt(i);

        if (needsMainTrailingPos) {
          child.layout.position[trailing[mainAxis]] = node.layout.dimensions[dim[mainAxis]] - child.layout.dimensions[dim[mainAxis]] - child.layout.position[pos[mainAxis]];
        }

        if (needsCrossTrailingPos) {
          child.layout.position[trailing[crossAxis]] = node.layout.dimensions[dim[crossAxis]] - child.layout.dimensions[dim[crossAxis]] - child.layout.position[pos[crossAxis]];
        }
      }
    }

    // <Loop G> Calculate dimensions for absolutely positioned elements
    currentAbsoluteChild = firstAbsoluteChild;
    while (currentAbsoluteChild != null) {
      // Pre-fill dimensions when using absolute position and both offsets for
      // the axis are defined (either both left and right or top and bottom).
      for (ii in 0...2) {
        axis = (ii != 0) ? CSS_FLEX_DIRECTION_ROW : CSS_FLEX_DIRECTION_COLUMN;

        if (!Math.isNaN(node.layout.dimensions[dim[axis]]) &&
            !(!Math.isNaN(currentAbsoluteChild.style.dimensions[dim[axis]]) && currentAbsoluteChild.style.dimensions[dim[axis]] >= 0.0) &&
            !Math.isNaN(currentAbsoluteChild.style.position[leading[axis]]) &&
            !Math.isNaN(currentAbsoluteChild.style.position[trailing[axis]])) {
          currentAbsoluteChild.layout.dimensions[dim[axis]] = Math.max(
            boundAxis(currentAbsoluteChild, axis, node.layout.dimensions[dim[axis]] -
              (node.style.border.getWithFallback(leadingSpacing[axis], leading[axis]) + node.style.border.getWithFallback(trailingSpacing[axis], trailing[axis])) -
              (currentAbsoluteChild.style.margin.getWithFallback(leadingSpacing[axis], leading[axis]) + currentAbsoluteChild.style.margin.getWithFallback(trailingSpacing[axis], trailing[axis])) -
              (Math.isNaN(currentAbsoluteChild.style.position[leading[axis]]) ?  0 : currentAbsoluteChild.style.position[leading[axis]]) -
              (Math.isNaN(currentAbsoluteChild.style.position[trailing[axis]]) ?  0 : currentAbsoluteChild.style.position[trailing[axis]])
            ),
            // You never want to go smaller than padding
            ((currentAbsoluteChild.style.padding.getWithFallback(leadingSpacing[axis], leading[axis]) + currentAbsoluteChild.style.border.getWithFallback(leadingSpacing[axis], leading[axis])) + (currentAbsoluteChild.style.padding.getWithFallback(trailingSpacing[axis], trailing[axis]) + currentAbsoluteChild.style.border.getWithFallback(trailingSpacing[axis], trailing[axis])))
          );
        }

        if (!Math.isNaN(currentAbsoluteChild.style.position[trailing[axis]]) &&
            !!Math.isNaN(currentAbsoluteChild.style.position[leading[axis]])) {
          currentAbsoluteChild.layout.position[leading[axis]] =
            node.layout.dimensions[dim[axis]] -
            currentAbsoluteChild.layout.dimensions[dim[axis]] -
            (Math.isNaN(currentAbsoluteChild.style.position[trailing[axis]]) ?  0 : currentAbsoluteChild.style.position[trailing[axis]]);
        }
      }

      child = currentAbsoluteChild;
      currentAbsoluteChild = currentAbsoluteChild.nextAbsoluteChild;
      child.nextAbsoluteChild = null;
    }
    /** END_GENERATED **/
  }
}

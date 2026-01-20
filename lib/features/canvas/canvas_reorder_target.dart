import 'package:flutter/material.dart';

/// Data transferred during canvas reorder drag operations.
class ReorderDragData {
  /// Creates reorder drag data.
  const ReorderDragData({
    required this.nodeId,
    required this.parentId,
    required this.currentIndex,
  });

  /// The ID of the widget being dragged.
  final String nodeId;

  /// The parent ID containing the widget.
  final String parentId;

  /// The current index of the widget in its parent.
  final int currentIndex;
}

/// A widget that serves as a drag target for reordering within Row/Column.
///
/// Wraps a child widget and provides visual feedback and drop handling
/// for canvas-based widget reordering.
class CanvasReorderTarget extends StatefulWidget {
  /// Creates a canvas reorder target.
  const CanvasReorderTarget({
    required this.nodeId,
    required this.parentId,
    required this.currentIndex,
    required this.siblingCount,
    required this.axis,
    required this.onReorder,
    required this.child,
    super.key,
  });

  /// The ID of this widget.
  final String nodeId;

  /// The parent ID containing this widget.
  final String parentId;

  /// The current index of this widget in its parent.
  final int currentIndex;

  /// Total number of siblings including this widget.
  final int siblingCount;

  /// The axis of the parent (horizontal for Row, vertical for Column).
  final Axis axis;

  /// Callback when a reorder drop occurs.
  /// Parameters: sourceNodeId, fromIndex, toIndex
  final void Function(String sourceNodeId, int fromIndex, int toIndex)
      onReorder;

  /// The child widget to wrap.
  final Widget child;

  @override
  State<CanvasReorderTarget> createState() => _CanvasReorderTargetState();
}

class _CanvasReorderTargetState extends State<CanvasReorderTarget> {
  bool _isHovering = false;
  Offset? _hoverOffset;

  /// Validates whether the drag data can be accepted.
  bool _willAccept(ReorderDragData data) {
    // Can't drop on self
    if (data.nodeId == widget.nodeId) return false;

    // Can only reorder within same parent
    if (data.parentId != widget.parentId) return false;

    return true;
  }

  /// Handles the drop and calculates the target index.
  void _handleDrop(DragTargetDetails<ReorderDragData> details) {
    final data = details.data;

    // Calculate target index based on drop position
    final targetIndex = _calculateTargetIndex(details.offset);

    widget.onReorder(data.nodeId, data.currentIndex, targetIndex);
  }

  /// Calculates the target index based on drop offset.
  int _calculateTargetIndex(Offset globalOffset) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return widget.currentIndex;

    final localOffset = renderBox.globalToLocal(globalOffset);
    final size = renderBox.size;

    // Determine if dropping before or after based on position
    final isFirstHalf = widget.axis == Axis.horizontal
        ? localOffset.dx < size.width / 2
        : localOffset.dy < size.height / 2;

    if (isFirstHalf) {
      return widget.currentIndex;
    } else {
      return widget.currentIndex + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<ReorderDragData>(
      onWillAcceptWithDetails: (details) {
        final canAccept = _willAccept(details.data);
        if (canAccept) {
          setState(() {
            _isHovering = true;
            _hoverOffset = details.offset;
          });
        }
        return canAccept;
      },
      onLeave: (_) {
        setState(() {
          _isHovering = false;
          _hoverOffset = null;
        });
      },
      onAcceptWithDetails: (details) {
        setState(() {
          _isHovering = false;
          _hoverOffset = null;
        });
        _handleDrop(details);
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            widget.child,
            if (_isHovering && _hoverOffset != null)
              _buildInsertionIndicator(context),
          ],
        );
      },
    );
  }

  Widget _buildInsertionIndicator(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || _hoverOffset == null) {
      return const SizedBox.shrink();
    }

    final localOffset = renderBox.globalToLocal(_hoverOffset!);
    final size = renderBox.size;
    final isFirstHalf = widget.axis == Axis.horizontal
        ? localOffset.dx < size.width / 2
        : localOffset.dy < size.height / 2;

    final indicatorColor = Theme.of(context).colorScheme.primary;
    const indicatorThickness = 3.0;

    if (widget.axis == Axis.horizontal) {
      // Vertical line at left or right edge
      return Positioned(
        left: isFirstHalf ? 0 : null,
        right: isFirstHalf ? null : 0,
        top: 0,
        bottom: 0,
        child: Container(
          width: indicatorThickness,
          color: indicatorColor,
        ),
      );
    } else {
      // Horizontal line at top or bottom edge
      return Positioned(
        left: 0,
        right: 0,
        top: isFirstHalf ? 0 : null,
        bottom: isFirstHalf ? null : 0,
        child: Container(
          height: indicatorThickness,
          color: indicatorColor,
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';

/// Data transferred during tree item drag operations.
class TreeDragData {
  /// Creates drag data for a tree item.
  const TreeDragData({
    required this.nodeId,
    required this.parentId,
    required this.widgetType,
    required this.currentIndex,
  });

  /// The ID of the widget node being dragged.
  final String nodeId;

  /// The ID of the current parent (can be empty for root).
  final String? parentId;

  /// The type of widget being dragged.
  final String widgetType;

  /// The current index in the parent's children list.
  final int currentIndex;
}

/// Insertion position for drop indicator.
enum InsertionPosition {
  /// No insertion indicator shown.
  none,

  /// Insert before the target item.
  before,

  /// Insert after the target item.
  after,

  /// Insert as child of the target item.
  inside,
}

/// Result of drop target validation.
class DropValidation {
  /// Creates a drop validation result.
  const DropValidation({
    required this.isValid,
    this.rejectionReason,
    this.targetParentId,
    this.targetIndex,
  });

  /// Creates a valid drop result.
  factory DropValidation.valid({
    required String targetParentId,
    required int targetIndex,
  }) {
    return DropValidation(
      isValid: true,
      targetParentId: targetParentId,
      targetIndex: targetIndex,
    );
  }

  /// Creates an invalid drop result.
  factory DropValidation.invalid(String reason) {
    return DropValidation(
      isValid: false,
      rejectionReason: reason,
    );
  }

  /// Whether the drop is valid.
  final bool isValid;

  /// Reason for rejection (shown in tooltip).
  final String? rejectionReason;

  /// The target parent ID for the drop.
  final String? targetParentId;

  /// The target index within the parent.
  final int? targetIndex;
}

/// A draggable tree item widget that supports reordering.
class DraggableTreeItem extends StatefulWidget {
  /// Creates a draggable tree item.
  const DraggableTreeItem({
    required this.nodeId,
    required this.widgetType,
    required this.depth,
    required this.hasChildren,
    required this.isExpanded,
    required this.isSelected,
    required this.parentId,
    required this.currentIndex,
    required this.onDropValidation,
    required this.onDrop,
    this.onToggleExpanded,
    this.onTap,
    this.isDragTarget = false,
    this.isInvalidTarget = false,
    this.rejectionMessage,
    this.showInsertionIndicator = false,
    this.insertionPosition = InsertionPosition.none,
    super.key,
  });

  /// The ID of the widget node.
  final String nodeId;

  /// The widget type (e.g., 'Container', 'Text').
  final String widgetType;

  /// Depth level in the tree (0 = root).
  final int depth;

  /// Whether this node has children.
  final bool hasChildren;

  /// Whether the node is expanded (children visible).
  final bool isExpanded;

  /// Whether this node is currently selected.
  final bool isSelected;

  /// The parent node ID (null for root).
  final String? parentId;

  /// The current index in parent's children list.
  final int currentIndex;

  /// Callback to validate drop targets.
  final DropValidation Function(TreeDragData data, String targetId)
      onDropValidation;

  /// Callback when drop is accepted.
  final void Function(TreeDragData data, DropValidation validation) onDrop;

  /// Callback when expand/collapse is toggled.
  final VoidCallback? onToggleExpanded;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Whether this item is being hovered as a drop target.
  final bool isDragTarget;

  /// Whether this is an invalid drop target.
  final bool isInvalidTarget;

  /// Message to show when target is invalid.
  final String? rejectionMessage;

  /// Whether to show the insertion indicator.
  final bool showInsertionIndicator;

  /// Position of the insertion indicator.
  final InsertionPosition insertionPosition;

  /// Indentation per depth level in pixels.
  static const double indentPerLevel = 16;

  /// Drag threshold in pixels.
  static const double dragThreshold = 4;

  @override
  State<DraggableTreeItem> createState() => _DraggableTreeItemState();
}

class _DraggableTreeItemState extends State<DraggableTreeItem> {
  bool _isHovering = false;
  InsertionPosition _currentInsertionPosition = InsertionPosition.none;
  String? _validationMessage;
  bool _isValidTarget = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Insertion indicator before
        if (_currentInsertionPosition == InsertionPosition.before)
          _buildInsertionIndicator(context),
        // The draggable item
        LongPressDraggable<TreeDragData>(
          data: TreeDragData(
            nodeId: widget.nodeId,
            parentId: widget.parentId,
            widgetType: widget.widgetType,
            currentIndex: widget.currentIndex,
          ),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          delay: Duration.zero,
          feedback: _buildDragFeedback(context),
          childWhenDragging: Opacity(
            opacity: 0.3,
            child: _buildItemContent(context),
          ),
          child: DragTarget<TreeDragData>(
            onWillAcceptWithDetails: (details) {
              final validation = widget.onDropValidation(
                details.data,
                widget.nodeId,
              );
              setState(() {
                _isHovering = true;
                _isValidTarget = validation.isValid;
                _validationMessage = validation.rejectionReason;
                _currentInsertionPosition = _determineInsertionPosition(
                  details.offset,
                  context,
                );
              });
              return validation.isValid;
            },
            onLeave: (_) {
              setState(() {
                _isHovering = false;
                _isValidTarget = true;
                _validationMessage = null;
                _currentInsertionPosition = InsertionPosition.none;
              });
            },
            onAcceptWithDetails: (details) {
              final validation = widget.onDropValidation(
                details.data,
                widget.nodeId,
              );
              if (validation.isValid) {
                widget.onDrop(details.data, validation);
              }
              setState(() {
                _isHovering = false;
                _isValidTarget = true;
                _validationMessage = null;
                _currentInsertionPosition = InsertionPosition.none;
              });
            },
            builder: (context, candidateData, rejectedData) {
              final showRejection =
                  rejectedData.isNotEmpty || !_isValidTarget && _isHovering;
              return Stack(
                children: [
                  _buildItemContent(context),
                  // Valid drop target highlight
                  if (_isHovering && _isValidTarget)
                    Positioned.fill(
                      child: Container(
                        key: const Key('drop_target_highlight'),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  // Invalid drop target indicator
                  if (showRejection)
                    Positioned.fill(
                      child: Container(
                        key: const Key('invalid_drop_indicator'),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          border: Border.all(
                            color: theme.colorScheme.error,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  // Rejection tooltip
                  if (showRejection && _validationMessage != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            _validationMessage!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        // Insertion indicator after
        if (_currentInsertionPosition == InsertionPosition.after)
          _buildInsertionIndicator(context),
      ],
    );
  }

  Widget _buildItemContent(BuildContext context) {
    final theme = Theme.of(context);
    final indent = widget.depth * DraggableTreeItem.indentPerLevel;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 28,
        color: widget.isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
            : null,
        child: Padding(
          padding: EdgeInsets.only(left: indent),
          child: Row(
            children: [
              // Expand/collapse arrow
              SizedBox(
                width: 24,
                height: 24,
                child: widget.hasChildren
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: Icon(
                          widget.isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: widget.onToggleExpanded,
                      )
                    : null,
              ),
              // Widget icon
              Icon(
                _getIconForType(widget.widgetType),
                size: 16,
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              // Widget type name
              Expanded(
                child: Text(
                  widget.widgetType,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.isSelected
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                    fontWeight: widget.isSelected ? FontWeight.w600 : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragFeedback(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      key: const Key('drag_feedback'),
      elevation: 4,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        key: const Key('drag_indicator'),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForType(widget.widgetType),
              size: 16,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              widget.widgetType,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsertionIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: const Key('insertion_indicator'),
      height: 2,
      margin: EdgeInsets.only(
        left: widget.depth * DraggableTreeItem.indentPerLevel + 24,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  InsertionPosition _determineInsertionPosition(
    Offset globalPosition,
    BuildContext context,
  ) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return InsertionPosition.none;

    final localPosition = renderBox.globalToLocal(globalPosition);
    final height = renderBox.size.height;

    // Divide into thirds: top = before, middle = inside, bottom = after
    if (localPosition.dy < height * 0.25) {
      return InsertionPosition.before;
    } else if (localPosition.dy > height * 0.75) {
      return InsertionPosition.after;
    } else {
      return InsertionPosition.inside;
    }
  }

  /// Gets the appropriate icon for a widget type.
  IconData _getIconForType(String type) {
    switch (type) {
      case 'Container':
        return Icons.crop_square;
      case 'Text':
        return Icons.text_fields;
      case 'Row':
        return Icons.view_column;
      case 'Column':
        return Icons.view_agenda;
      case 'SizedBox':
        return Icons.crop_din;
      default:
        return Icons.widgets;
    }
  }
}

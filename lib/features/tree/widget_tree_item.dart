import 'package:flutter/material.dart';

/// A single item in the widget tree.
///
/// Displays the widget type name, icon, expand/collapse arrow,
/// and selection highlight.
class WidgetTreeItem extends StatelessWidget {
  const WidgetTreeItem({
    required this.nodeId,
    required this.widgetType,
    required this.depth,
    required this.hasChildren,
    required this.isExpanded,
    required this.isSelected,
    this.onToggleExpanded,
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

  /// Callback when expand/collapse is toggled.
  final VoidCallback? onToggleExpanded;

  /// Indentation per depth level in pixels.
  static const double indentPerLevel = 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
          : null,
      child: Padding(
        padding: EdgeInsets.only(left: depth * indentPerLevel),
        child: Row(
          children: [
            // Expand/collapse arrow
            SizedBox(
              width: 24,
              height: 24,
              child: hasChildren
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_right,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: onToggleExpanded,
                    )
                  : null,
            ),
            // Widget icon
            Icon(
              _getIconForType(widgetType),
              size: 16,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            // Widget type name
            Text(
              widgetType,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the appropriate icon for a widget type.
  IconData _getIconForType(String type) {
    // Map widget types to icons based on registry iconName values
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

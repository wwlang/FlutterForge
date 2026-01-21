import 'package:flutter/material.dart';

/// A draggable widget item in the palette.
///
/// Displays a widget name and icon that can be dragged onto the canvas.
class PaletteItem extends StatelessWidget {
  /// Creates a palette item.
  const PaletteItem({
    required this.widgetType,
    required this.displayName,
    required this.iconName,
    super.key,
  });

  /// Widget type identifier (e.g., 'Container', 'Text').
  final String widgetType;

  /// Human-readable display name.
  final String displayName;

  /// Optional icon name from Material Icons.
  final String? iconName;

  /// Maps icon name strings to Material Icons.
  static IconData _getIconData(String? iconName) {
    const iconMap = {
      // Phase 1 widgets
      'crop_square': Icons.crop_square,
      'text_fields': Icons.text_fields,
      'view_column': Icons.view_column,
      'view_agenda': Icons.view_agenda,
      'crop_din': Icons.crop_din,
      // Phase 2 Task 9: Layout widgets
      'layers': Icons.layers,
      'expand': Icons.expand,
      'swap_horiz': Icons.swap_horiz,
      'padding': Icons.padding,
      'center_focus_strong': Icons.center_focus_strong,
      'format_align_center': Icons.format_align_center,
      'space_bar': Icons.space_bar,
      // Phase 2 Task 10: Content widgets
      'star': Icons.star,
      'image': Icons.image,
      'horizontal_rule': Icons.horizontal_rule,
      'more_vert': Icons.more_vert,
      // Phase 2 Task 11: Input widgets
      'smart_button': Icons.smart_button,
      'touch_app': Icons.touch_app,
      'radio_button_checked': Icons.radio_button_checked,
      'crop_free': Icons.crop_free,
    };
    return iconMap[iconName] ?? Icons.widgets;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Draggable<String>(
      data: widgetType,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconData(iconName),
                size: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                displayName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildItemContent(context),
      ),
      child: _buildItemContent(context),
    );
  }

  Widget _buildItemContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(
            _getIconData(iconName),
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayName,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

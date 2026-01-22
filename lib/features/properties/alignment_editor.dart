import 'package:flutter/material.dart';

/// Editor widget for Alignment properties.
///
/// Displays a 3x3 grid picker similar to Figma's alignment control.
/// Supports all 9 standard alignments:
/// - topLeft, topCenter, topRight
/// - centerLeft, center, centerRight
/// - bottomLeft, bottomCenter, bottomRight
///
/// Journey: properties-panel.md
class AlignmentEditor extends StatelessWidget {
  /// Creates an Alignment editor.
  const AlignmentEditor({
    required this.propertyName,
    required this.displayName,
    required this.value,
    required this.onChanged,
    this.description,
    super.key,
  });

  /// Property key name.
  final String propertyName;

  /// Display label for the property.
  final String displayName;

  /// Current Alignment value.
  final Alignment? value;

  /// Callback when value changes.
  final void Function(Alignment?) onChanged;

  /// Optional description/tooltip.
  final String? description;

  /// The 9 standard alignment values in grid order.
  static const List<Alignment> _alignments = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          displayName,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // 3x3 grid picker
        _buildAlignmentGrid(context),

        // Description
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAlignmentGrid(BuildContext context) {
    final theme = Theme.of(context);
    // Total outer size including border
    const outerSize = 90.0;
    // Border width is 1px on each side (default), so inner size is 88
    const innerSize = outerSize - 2;
    const cellSize = innerSize / 3;

    return Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int row = 0; row < 3; row++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int col = 0; col < 3; col++)
                    _buildAlignmentCell(
                      context,
                      alignment: _alignments[row * 3 + col],
                      index: row * 3 + col,
                      cellSize: cellSize,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignmentCell(
    BuildContext context, {
    required Alignment alignment,
    required int index,
    required double cellSize,
  }) {
    final theme = Theme.of(context);
    final isSelected = _alignmentsEqual(value, alignment);

    // Calculate border radius for corner cells
    BorderRadius? borderRadius;
    if (index == 0) {
      borderRadius = const BorderRadius.only(topLeft: Radius.circular(6));
    } else if (index == 2) {
      borderRadius = const BorderRadius.only(topRight: Radius.circular(6));
    } else if (index == 6) {
      borderRadius = const BorderRadius.only(bottomLeft: Radius.circular(6));
    } else if (index == 8) {
      borderRadius = const BorderRadius.only(bottomRight: Radius.circular(6));
    }

    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: InkWell(
        onTap: () => onChanged(alignment),
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withAlpha(30)
                : Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(
              color: theme.colorScheme.outline.withAlpha(50),
              width: 0.5,
            ),
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withAlpha(100),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Compares two alignments for equality.
  bool _alignmentsEqual(Alignment? a, Alignment? b) {
    if (a == null || b == null) return false;
    return a.x == b.x && a.y == b.y;
  }
}

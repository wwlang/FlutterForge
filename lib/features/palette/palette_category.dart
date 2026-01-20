import 'package:flutter/material.dart';

/// A collapsible category in the widget palette.
///
/// Displays a category header with name and widget count,
/// and can be expanded/collapsed to show/hide child widgets.
class PaletteCategory extends StatelessWidget {
  /// Creates a palette category.
  const PaletteCategory({
    required this.name,
    required this.count,
    required this.isExpanded,
    required this.onToggle,
    required this.children,
    super.key,
  });

  /// Category name (e.g., 'Layout', 'Content').
  final String name;

  /// Number of widgets in this category.
  final int count;

  /// Whether the category is currently expanded.
  final bool isExpanded;

  /// Callback when the category header is tapped.
  final VoidCallback? onToggle;

  /// Widgets to display when expanded.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.expand_less,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
      ],
    );
  }
}

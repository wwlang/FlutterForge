import 'package:flutter/material.dart';

import 'package:flutter_forge/features/palette/palette_category.dart';
import 'package:flutter_forge/features/palette/palette_item.dart';
import 'package:flutter_forge/shared/registry/registry.dart';

/// The widget palette panel displaying categorized widgets for drag-and-drop.
///
/// Organizes widgets by category (Layout, Content, etc.) with collapsible
/// headers. Each widget can be dragged onto the canvas.
class WidgetPalette extends StatefulWidget {
  /// Creates a widget palette.
  const WidgetPalette({
    required this.registry,
    super.key,
  });

  /// Widget registry providing widget definitions.
  final WidgetRegistry registry;

  @override
  State<WidgetPalette> createState() => _WidgetPaletteState();
}

class _WidgetPaletteState extends State<WidgetPalette> {
  /// Tracks expansion state of each category.
  late Map<WidgetCategory, bool> _expandedState;

  @override
  void initState() {
    super.initState();
    _initializeExpansionState();
  }

  void _initializeExpansionState() {
    _expandedState = {
      for (final category in widget.registry.categories) category: true,
    };
  }

  void _toggleCategory(WidgetCategory category) {
    setState(() {
      _expandedState[category] = !(_expandedState[category] ?? false);
    });
  }

  /// Get display name for a category.
  String _getCategoryDisplayName(WidgetCategory category) {
    switch (category) {
      case WidgetCategory.layout:
        return 'Layout';
      case WidgetCategory.content:
        return 'Content';
      case WidgetCategory.input:
        return 'Input';
      case WidgetCategory.scrolling:
        return 'Scrolling';
      case WidgetCategory.structure:
        return 'Structure';
    }
  }

  /// Sort categories in display order.
  List<WidgetCategory> _getSortedCategories() {
    const displayOrder = [
      WidgetCategory.layout,
      WidgetCategory.content,
      WidgetCategory.input,
      WidgetCategory.scrolling,
      WidgetCategory.structure,
    ];

    final available = widget.registry.categories;
    return displayOrder.where(available.contains).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _getSortedCategories();

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final category in categories) _buildCategorySection(category),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(WidgetCategory category) {
    final widgets = widget.registry.byCategory(category);
    final isExpanded = _expandedState[category] ?? false;

    return PaletteCategory(
      name: _getCategoryDisplayName(category),
      count: widgets.length,
      isExpanded: isExpanded,
      onToggle: () => _toggleCategory(category),
      children: [
        for (final widgetDef in widgets)
          PaletteItem(
            widgetType: widgetDef.type,
            displayName: widgetDef.displayName,
            iconName: widgetDef.iconName,
          ),
      ],
    );
  }
}

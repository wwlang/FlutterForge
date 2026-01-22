import 'package:flutter/material.dart';

import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/properties/alignment_editor.dart';
import 'package:flutter_forge/features/properties/edge_insets_editor.dart';
import 'package:flutter_forge/features/properties/property_editors.dart';
import 'package:flutter_forge/shared/registry/registry.dart';

/// Panel for editing widget properties.
///
/// Displays property editors grouped by category for the selected widget.
class PropertiesPanel extends StatelessWidget {
  /// Creates a properties panel.
  const PropertiesPanel({
    required this.registry,
    required this.selectedNode,
    required this.onPropertyChanged,
    super.key,
  });

  /// Widget registry for type definitions.
  final WidgetRegistry registry;

  /// Currently selected widget node (null if none selected).
  final WidgetNode? selectedNode;

  /// Callback when a property value changes.
  final void Function(String propertyName, dynamic value) onPropertyChanged;

  @override
  Widget build(BuildContext context) {
    if (selectedNode == null) {
      return _buildEmptyState(context);
    }

    final definition = registry.get(selectedNode!.type);
    if (definition == null) {
      return _buildErrorState(context, 'Unknown widget type');
    }

    return _buildPropertyList(context, definition);
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No widget selected',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a widget on the canvas to edit its properties',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyList(BuildContext context, WidgetDefinition definition) {
    final theme = Theme.of(context);

    // Group properties by category
    final categorized = <String?, List<PropertyDefinition>>{};
    for (final prop in definition.properties) {
      categorized.putIfAbsent(prop.category, () => []).add(prop);
    }

    // Sort categories (non-null first, then null)
    final sortedCategories = categorized.keys.toList()
      ..sort((a, b) {
        if (a == null) return 1;
        if (b == null) return -1;
        return a.compareTo(b);
      });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget type header
          Row(
            children: [
              Icon(
                _getIconForType(definition.iconName),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                definition.displayName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (definition.description != null) ...[
            const SizedBox(height: 4),
            Text(
              definition.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Property categories
          for (final category in sortedCategories) ...[
            _buildCategorySection(
              context,
              category ?? 'Other',
              categorized[category]!,
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String category,
    List<PropertyDefinition> properties,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        for (final prop in properties) _buildEditor(prop),
      ],
    );
  }

  Widget _buildEditor(PropertyDefinition prop) {
    final value = selectedNode!.properties[prop.name];

    switch (prop.type) {
      case PropertyType.string:
        return StringEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: value as String? ?? prop.defaultValue as String?,
          description: prop.description,
          onChanged: (v) => onPropertyChanged(prop.name, v),
        );

      case PropertyType.double_:
        return DoubleEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: value as double?,
          min: prop.min,
          max: prop.max,
          description: prop.description,
          onChanged: (v) => onPropertyChanged(prop.name, v),
        );

      case PropertyType.int_:
        return IntEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: value as int?,
          min: prop.min?.toInt(),
          max: prop.max?.toInt(),
          description: prop.description,
          onChanged: (v) => onPropertyChanged(prop.name, v),
        );

      case PropertyType.bool_:
        return BoolEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: value as bool?,
          description: prop.description,
          onChanged: (v) => onPropertyChanged(prop.name, v),
        );

      case PropertyType.color:
        return ColorEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: value as int?,
          description: prop.description,
          onChanged: (v) => onPropertyChanged(prop.name, v),
        );

      case PropertyType.enum_:
        return EnumEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: value as String?,
          enumValues: prop.enumValues ?? [],
          description: prop.description,
          onChanged: (v) => onPropertyChanged(prop.name, v),
        );

      case PropertyType.edgeInsets:
        return EdgeInsetsEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: _parseEdgeInsets(value),
          description: prop.description,
          onChanged: (v) =>
              onPropertyChanged(prop.name, _serializeEdgeInsets(v)),
        );

      case PropertyType.alignment:
        return AlignmentEditor(
          propertyName: prop.name,
          displayName: prop.displayName,
          value: _parseAlignment(value),
          description: prop.description,
          onChanged: (v) =>
              onPropertyChanged(prop.name, _serializeAlignment(v)),
        );
    }
  }

  /// Parses an EdgeInsets from stored property value.
  EdgeInsets? _parseEdgeInsets(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return EdgeInsets.fromLTRB(
        (value['left'] as num?)?.toDouble() ?? 0,
        (value['top'] as num?)?.toDouble() ?? 0,
        (value['right'] as num?)?.toDouble() ?? 0,
        (value['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    if (value is num) {
      return EdgeInsets.all(value.toDouble());
    }
    return null;
  }

  /// Serializes EdgeInsets for storage.
  Map<String, double>? _serializeEdgeInsets(EdgeInsets? value) {
    if (value == null) return null;
    return {
      'left': value.left,
      'top': value.top,
      'right': value.right,
      'bottom': value.bottom,
    };
  }

  /// Parses an Alignment from stored property value.
  Alignment? _parseAlignment(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return Alignment(
        (value['x'] as num?)?.toDouble() ?? 0,
        (value['y'] as num?)?.toDouble() ?? 0,
      );
    }
    if (value is String) {
      // Handle named alignments
      switch (value) {
        case 'topLeft':
          return Alignment.topLeft;
        case 'topCenter':
          return Alignment.topCenter;
        case 'topRight':
          return Alignment.topRight;
        case 'centerLeft':
          return Alignment.centerLeft;
        case 'center':
          return Alignment.center;
        case 'centerRight':
          return Alignment.centerRight;
        case 'bottomLeft':
          return Alignment.bottomLeft;
        case 'bottomCenter':
          return Alignment.bottomCenter;
        case 'bottomRight':
          return Alignment.bottomRight;
      }
    }
    return null;
  }

  /// Serializes Alignment for storage.
  Map<String, double>? _serializeAlignment(Alignment? value) {
    if (value == null) return null;
    return {
      'x': value.x,
      'y': value.y,
    };
  }

  IconData _getIconForType(String? iconName) {
    switch (iconName) {
      case 'crop_square':
        return Icons.crop_square;
      case 'text_fields':
        return Icons.text_fields;
      case 'view_column':
        return Icons.view_column;
      case 'view_agenda':
        return Icons.view_agenda;
      case 'crop_din':
        return Icons.crop_din;
      default:
        return Icons.widgets;
    }
  }
}

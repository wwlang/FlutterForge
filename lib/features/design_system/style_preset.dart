import 'package:flutter/foundation.dart';
import 'package:flutter_forge/core/models/widget_node.dart';

/// Category of style preset.
enum PresetCategory {
  /// Button styles (ElevatedButton, TextButton, etc.)
  button,

  /// Container styles (Card, Container, etc.)
  container,

  /// Text styles (Text, RichText, etc.)
  text,

  /// Input styles (TextField, etc.)
  input,

  /// Layout styles (Row, Column, etc.)
  layout,
}

/// A reusable collection of property values that can be applied to widgets.
///
/// Style presets bundle multiple property values (including token bindings)
/// into a named, categorized unit that can be applied to widgets.
@immutable
class StylePreset {
  /// Creates a style preset.
  const StylePreset({
    required this.id,
    required this.name,
    required this.category,
    required this.properties,
    this.description,
  });

  /// Unique identifier for the preset.
  final String id;

  /// Display name of the preset.
  final String name;

  /// Category of widgets this preset applies to.
  final PresetCategory category;

  /// Map of property names to values (can include token bindings).
  final Map<String, dynamic> properties;

  /// Optional description of the preset.
  final String? description;

  /// Creates a copy with modified fields.
  StylePreset copyWith({
    String? id,
    String? name,
    PresetCategory? category,
    Map<String, dynamic>? properties,
    String? description,
  }) {
    return StylePreset(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      properties: properties ?? this.properties,
      description: description ?? this.description,
    );
  }

  /// Serializes the preset to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'properties': properties,
      if (description != null) 'description': description,
    };
  }

  /// Deserializes a preset from JSON.
  factory StylePreset.fromJson(Map<String, dynamic> json) {
    return StylePreset(
      id: json['id'] as String,
      name: json['name'] as String,
      category: PresetCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => PresetCategory.container,
      ),
      properties: Map<String, dynamic>.from(json['properties'] as Map),
      description: json['description'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StylePreset &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          category == other.category &&
          mapEquals(properties, other.properties) &&
          description == other.description;

  @override
  int get hashCode => Object.hash(id, name, category, description);
}

/// Applies a preset's properties to a widget node.
///
/// Returns a new node with the preset's properties merged in.
/// Preset properties override existing widget properties.
WidgetNode applyPresetToWidget(StylePreset preset, WidgetNode node) {
  final mergedProperties = Map<String, dynamic>.from(node.properties);

  for (final entry in preset.properties.entries) {
    mergedProperties[entry.key] = entry.value;
  }

  return node.copyWith(
    properties: mergedProperties,
    appliedPresetId: preset.id,
    propertyOverrides: <String>[],
  );
}

/// Overrides a specific preset property on a widget.
///
/// Tracks the override so it can be restored later.
WidgetNode overridePresetProperty(
  WidgetNode node,
  String propertyName,
  dynamic value,
) {
  final newProperties = Map<String, dynamic>.from(node.properties);
  newProperties[propertyName] = value;

  final newOverrides = List<String>.from(node.propertyOverrides);
  if (!newOverrides.contains(propertyName)) {
    newOverrides.add(propertyName);
  }

  return node.copyWith(
    properties: newProperties,
    propertyOverrides: newOverrides,
  );
}

/// Clears an override, restoring the preset's original value.
WidgetNode clearPropertyOverride(
  WidgetNode node,
  String propertyName,
  StylePreset preset,
) {
  final newProperties = Map<String, dynamic>.from(node.properties);

  // Restore preset value if it exists
  if (preset.properties.containsKey(propertyName)) {
    newProperties[propertyName] = preset.properties[propertyName];
  } else {
    newProperties.remove(propertyName);
  }

  final newOverrides = List<String>.from(node.propertyOverrides)
    ..remove(propertyName);

  return node.copyWith(
    properties: newProperties,
    propertyOverrides: newOverrides,
  );
}

/// Detaches a preset from a widget, keeping current values.
///
/// Removes preset tracking but retains all current property values.
WidgetNode detachPreset(WidgetNode node) {
  return node.copyWith(
    appliedPresetId: null,
    propertyOverrides: <String>[],
  );
}

/// Returns the built-in preset library.
List<StylePreset> getBuiltInPresets() {
  return [
    // Button presets
    StylePreset(
      id: 'builtin-primary-button',
      name: 'Primary Button',
      category: PresetCategory.button,
      description: 'Standard primary action button',
      properties: {
        'backgroundColor': {r'$token': 'primary'},
        'foregroundColor': {r'$token': 'onPrimary'},
        'borderRadius': {r'$token': 'radiusMedium'},
        'padding': 16.0,
      },
    ),
    StylePreset(
      id: 'builtin-secondary-button',
      name: 'Secondary Button',
      category: PresetCategory.button,
      description: 'Secondary action button',
      properties: {
        'backgroundColor': {r'$token': 'secondary'},
        'foregroundColor': {r'$token': 'onSecondary'},
        'borderRadius': {r'$token': 'radiusMedium'},
        'padding': 16.0,
      },
    ),
    StylePreset(
      id: 'builtin-outline-button',
      name: 'Outline Button',
      category: PresetCategory.button,
      description: 'Outlined button style',
      properties: {
        'backgroundColor': 0x00000000,
        'foregroundColor': {r'$token': 'primary'},
        'borderColor': {r'$token': 'primary'},
        'borderWidth': 1.0,
        'borderRadius': {r'$token': 'radiusMedium'},
        'padding': 16.0,
      },
    ),

    // Container presets
    StylePreset(
      id: 'builtin-card',
      name: 'Card',
      category: PresetCategory.container,
      description: 'Standard elevated card',
      properties: {
        'backgroundColor': {r'$token': 'surface'},
        'borderRadius': {r'$token': 'radiusLarge'},
        'elevation': 2.0,
        'padding': 16.0,
      },
    ),
    StylePreset(
      id: 'builtin-outlined-card',
      name: 'Outlined Card',
      category: PresetCategory.container,
      description: 'Card with border instead of elevation',
      properties: {
        'backgroundColor': {r'$token': 'surface'},
        'borderRadius': {r'$token': 'radiusLarge'},
        'borderColor': {r'$token': 'outline'},
        'borderWidth': 1.0,
        'padding': 16.0,
      },
    ),
    StylePreset(
      id: 'builtin-surface',
      name: 'Surface Container',
      category: PresetCategory.container,
      description: 'Subtle surface container',
      properties: {
        'backgroundColor': {r'$token': 'surfaceContainerLow'},
        'borderRadius': {r'$token': 'radiusMedium'},
        'padding': 12.0,
      },
    ),

    // Text presets
    StylePreset(
      id: 'builtin-heading',
      name: 'Heading',
      category: PresetCategory.text,
      description: 'Large heading text',
      properties: {
        'fontSize': 24.0,
        'fontWeight': 700,
        'color': {r'$token': 'onSurface'},
      },
    ),
    StylePreset(
      id: 'builtin-body-text',
      name: 'Body Text',
      category: PresetCategory.text,
      description: 'Standard body text',
      properties: {
        'fontSize': 16.0,
        'fontWeight': 400,
        'color': {r'$token': 'onSurface'},
        'lineHeight': 1.5,
      },
    ),
    StylePreset(
      id: 'builtin-caption',
      name: 'Caption',
      category: PresetCategory.text,
      description: 'Small caption text',
      properties: {
        'fontSize': 12.0,
        'fontWeight': 400,
        'color': {r'$token': 'onSurfaceVariant'},
      },
    ),

    // Input presets
    StylePreset(
      id: 'builtin-text-field',
      name: 'Text Field',
      category: PresetCategory.input,
      description: 'Standard text input',
      properties: {
        'borderRadius': {r'$token': 'radiusSmall'},
        'borderColor': {r'$token': 'outline'},
        'backgroundColor': {r'$token': 'surfaceContainerHighest'},
        'padding': 12.0,
      },
    ),
  ];
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_definition.freezed.dart';
part 'property_definition.g.dart';

/// Types of properties supported by the property editor.
@JsonEnum()
enum PropertyType {
  /// String property (e.g., text content).
  string,

  /// Double/floating point property (e.g., width, height).
  double_,

  /// Integer property (e.g., maxLines).
  int_,

  /// Boolean property (e.g., softWrap).
  bool_,

  /// Color property with picker support.
  color,

  /// Enum property with dropdown options.
  enum_,

  /// EdgeInsets property with 4-sided editor.
  edgeInsets,

  /// Alignment property with visual picker.
  alignment,
}

/// Definition of a widget property for the editor.
///
/// Describes the property name, type, display metadata, and constraints.
@freezed
class PropertyDefinition with _$PropertyDefinition {
  /// Creates a property definition.
  const factory PropertyDefinition({
    /// Property key matching the widget's parameter name.
    required String name,

    /// Type of the property for editor selection.
    required PropertyType type,

    /// Human-readable name for display in properties panel.
    required String displayName,

    /// Whether the property can be null/unset.
    required bool nullable,

    /// Default value when creating new widget.
    dynamic defaultValue,

    /// For enum_ type: list of valid enum values.
    List<String>? enumValues,

    /// Category grouping for properties panel organization.
    String? category,

    /// Description/tooltip text for the property.
    String? description,

    /// Minimum value for numeric properties.
    double? min,

    /// Maximum value for numeric properties.
    double? max,
  }) = _PropertyDefinition;

  const PropertyDefinition._();

  factory PropertyDefinition.fromJson(Map<String, dynamic> json) =>
      _$PropertyDefinitionFromJson(json);
}

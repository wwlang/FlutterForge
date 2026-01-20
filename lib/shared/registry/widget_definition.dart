import 'package:flutter_forge/shared/registry/property_definition.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_definition.freezed.dart';
part 'widget_definition.g.dart';

/// Categories of widgets in the palette.
@JsonEnum()
enum WidgetCategory {
  /// Layout widgets: Container, Row, Column, etc.
  layout,

  /// Content widgets: Text, Icon, Image, etc.
  content,

  /// Input widgets: Button, TextField, etc.
  input,

  /// Scrolling widgets: ListView, etc.
  scrolling,

  /// Structure widgets: Card, Scaffold, etc.
  structure,
}

/// Definition of a widget type for the registry.
///
/// Contains metadata, constraints, and property definitions
/// used by the palette, canvas, properties panel, and code generator.
@freezed
class WidgetDefinition with _$WidgetDefinition {
  /// Creates a widget definition.
  const factory WidgetDefinition({
    /// Unique widget type identifier (e.g., 'Container', 'Text').
    required String type,

    /// Category for palette organization.
    required WidgetCategory category,

    /// Human-readable name for display.
    required String displayName,

    /// Whether this widget can contain children.
    required bool acceptsChildren,

    /// Maximum number of children (null = unlimited).
    /// 0 for leaf widgets, 1 for single-child, null for multi-child.
    required int? maxChildren,

    /// Property definitions for this widget.
    required List<PropertyDefinition> properties,

    /// Optional icon name for palette display.
    String? iconName,

    /// Optional description for tooltip/preview.
    String? description,

    /// Import package for code generation (defaults to 'material').
    @Default('package:flutter/material.dart') String import_,

    /// Parent type constraint (e.g., 'Flex' for Expanded/Flexible).
    /// If set, this widget can only be a child of the specified parent type.
    String? parentConstraint,
  }) = _WidgetDefinition;

  const WidgetDefinition._();

  factory WidgetDefinition.fromJson(Map<String, dynamic> json) =>
      _$WidgetDefinitionFromJson(json);

  /// Whether this widget accepts multiple children.
  bool get isMultiChild => acceptsChildren && maxChildren == null;

  /// Whether this widget is a leaf (no children).
  bool get isLeaf => !acceptsChildren || maxChildren == 0;

  /// Whether this widget is a single-child container.
  bool get isSingleChild => acceptsChildren && maxChildren == 1;

  /// Whether this widget has a parent constraint.
  bool get hasParentConstraint => parentConstraint != null;
}

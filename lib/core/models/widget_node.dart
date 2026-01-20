import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_node.freezed.dart';
part 'widget_node.g.dart';

/// Represents a single widget in the design tree.
///
/// Uses normalized data model with childrenIds references instead of
/// recursive children objects for O(1) node access and efficient updates.
@freezed
class WidgetNode with _$WidgetNode {
  /// Creates a new widget node.
  ///
  /// The id must be a valid UUID.
  /// The type must match a registered widget definition
  /// (e.g., 'Container', 'Column').
  const factory WidgetNode({
    /// Unique identifier for this node (UUID).
    required String id,

    /// Widget type matching a registered definition.
    /// Examples: 'Container', 'Row', 'Column', 'Text'.
    required String type,

    /// Widget properties keyed by property name.
    /// Values are dynamic to support different property types.
    required Map<String, dynamic> properties,

    /// IDs of child nodes (normalized reference model).
    /// Empty for leaf widgets like Text or Icon.
    @Default(<String>[]) List<String> childrenIds,

    /// ID of parent node, null for root.
    String? parentId,
  }) = _WidgetNode;

  factory WidgetNode.fromJson(Map<String, dynamic> json) =>
      _$WidgetNodeFromJson(json);
}

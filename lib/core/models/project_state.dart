import 'dart:ui';

import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_state.freezed.dart';
part 'project_state.g.dart';

/// Custom JSON converter for Offset since it's not serializable by default.
class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    return Offset(
      (json['dx'] as num).toDouble(),
      (json['dy'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Offset offset) {
    return {'dx': offset.dx, 'dy': offset.dy};
  }
}

/// Normalized project state for efficient operations.
///
/// Uses a flat map of nodes for O(1) access instead of
/// recursive tree traversal.
@freezed
class ProjectState with _$ProjectState {
  const factory ProjectState({
    /// All widget nodes keyed by ID for O(1) lookup.
    required Map<String, WidgetNode> nodes,

    /// ID of the root node in the widget tree.
    required String rootNodeId,

    /// Currently selected node IDs.
    @Default(<String>{}) Set<String> selection,

    /// Current zoom level (1.0 = 100%).
    @Default(1.0) double zoomLevel,

    /// Current pan offset from origin.
    @OffsetConverter()
    @Default(Offset.zero)
    Offset panOffset,
  }) = _ProjectState;

  factory ProjectState.fromJson(Map<String, dynamic> json) =>
      _$ProjectStateFromJson(json);
}

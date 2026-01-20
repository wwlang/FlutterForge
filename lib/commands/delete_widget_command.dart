import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';

/// Command to delete a widget from the project.
///
/// This command stores all necessary data to restore the widget
/// and its descendants during undo, including the original
/// position in the parent's children list.
class DeleteWidgetCommand extends Command {
  DeleteWidgetCommand({
    required this.nodeId,
  });

  /// The ID of the widget to delete.
  final String nodeId;

  /// Stored data for undo.
  /// Contains the deleted node and all its descendants.
  Map<String, WidgetNode>? _deletedNodes;

  /// Original index in parent's children, for restoration.
  int? _originalIndex;

  /// The type of widget being deleted (for description).
  String? _widgetType;

  /// Whether the deleted node was a root node.
  bool? _wasRoot;

  @override
  String get description => 'Delete ${_widgetType ?? 'Widget'}';

  @override
  ProjectState execute(ProjectState state) {
    final node = state.nodes[nodeId];
    if (node == null) return state;

    _widgetType = node.type;
    _wasRoot = node.parentId == null;

    // Collect the node and all its descendants for potential restoration
    _deletedNodes = _collectNodeAndDescendants(nodeId, state);

    // Record original index in parent
    if (node.parentId != null) {
      final parent = state.nodes[node.parentId!];
      if (parent != null) {
        _originalIndex = parent.childrenIds.indexOf(nodeId);
      }
    } else {
      _originalIndex = state.rootIds.indexOf(nodeId);
    }

    // Build new state without the deleted nodes
    final newNodes = Map<String, WidgetNode>.from(state.nodes);
    for (final id in _deletedNodes!.keys) {
      newNodes.remove(id);
    }

    // Update parent's children if applicable
    if (node.parentId != null) {
      final parent = newNodes[node.parentId!];
      if (parent != null) {
        final newChildrenIds =
            parent.childrenIds.where((id) => id != nodeId).toList();
        newNodes[node.parentId!] = parent.copyWith(childrenIds: newChildrenIds);
      }
    }

    // Update root ids if applicable
    final newRootIds = state.rootIds.where((id) => id != nodeId).toList();

    return state.copyWith(
      nodes: newNodes,
      rootIds: newRootIds,
    );
  }

  @override
  ProjectState undo(ProjectState state) {
    if (_deletedNodes == null) return state;

    // Restore all deleted nodes
    final newNodes = Map<String, WidgetNode>.from(state.nodes)
      ..addAll(_deletedNodes!);

    // Restore to parent's children at original position
    final deletedNode = _deletedNodes![nodeId]!;
    if (deletedNode.parentId != null) {
      final parent = newNodes[deletedNode.parentId!];
      if (parent != null) {
        final newChildrenIds = List<String>.from(parent.childrenIds);
        if (_originalIndex != null &&
            _originalIndex! <= newChildrenIds.length) {
          newChildrenIds.insert(_originalIndex!, nodeId);
        } else {
          newChildrenIds.add(nodeId);
        }
        newNodes[deletedNode.parentId!] =
            parent.copyWith(childrenIds: newChildrenIds);
      }
    }

    // Restore to root ids at original position if applicable
    var newRootIds = state.rootIds;
    if (_wasRoot ?? false) {
      newRootIds = List<String>.from(state.rootIds);
      if (_originalIndex != null && _originalIndex! <= newRootIds.length) {
        newRootIds.insert(_originalIndex!, nodeId);
      } else {
        newRootIds.add(nodeId);
      }
    }

    return state.copyWith(
      nodes: newNodes,
      rootIds: newRootIds,
    );
  }

  /// Collects a node and all its descendants into a map.
  Map<String, WidgetNode> _collectNodeAndDescendants(
    String id,
    ProjectState state,
  ) {
    final result = <String, WidgetNode>{};
    final node = state.nodes[id];
    if (node == null) return result;

    result[id] = node;

    for (final childId in node.childrenIds) {
      result.addAll(_collectNodeAndDescendants(childId, state));
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'DeleteWidgetCommand',
      'nodeId': nodeId,
      'widgetType': _widgetType,
      'originalIndex': _originalIndex,
      'wasRoot': _wasRoot,
      // Note: _deletedNodes would need separate serialization
    };
  }
}

import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';

/// Command to move a widget to a new position or parent.
///
/// Handles both reordering within the same parent and
/// moving to a different parent container.
class MoveWidgetCommand extends Command {
  MoveWidgetCommand({
    required this.nodeId,
    required this.oldParentId,
    required this.newParentId,
    required this.oldIndex,
    required this.newIndex,
  });

  /// The ID of the widget being moved.
  final String nodeId;

  /// The ID of the original parent (may be same as newParentId for reorder).
  final String oldParentId;

  /// The ID of the new parent.
  final String newParentId;

  /// The original index in the old parent's children list.
  final int oldIndex;

  /// The target index in the new parent's children list.
  final int newIndex;

  /// The type of widget being moved (for description).
  String? _widgetType;

  @override
  String get description => 'Move ${_widgetType ?? 'Widget'}';

  @override
  ProjectState execute(ProjectState state) {
    final node = state.nodes[nodeId];
    if (node == null) return state;

    _widgetType = node.type;

    return _performMove(
      state,
      fromParentId: oldParentId,
      toParentId: newParentId,
      targetIndex: newIndex,
    );
  }

  @override
  ProjectState undo(ProjectState state) {
    return _performMove(
      state,
      fromParentId: newParentId,
      toParentId: oldParentId,
      targetIndex: oldIndex,
    );
  }

  ProjectState _performMove(
    ProjectState state, {
    required String fromParentId,
    required String toParentId,
    required int targetIndex,
  }) {
    final newNodes = Map<String, WidgetNode>.from(state.nodes);

    // Remove from old parent
    final oldParent = newNodes[fromParentId];
    if (oldParent != null) {
      final oldChildrenIds =
          oldParent.childrenIds.where((id) => id != nodeId).toList();
      newNodes[fromParentId] = oldParent.copyWith(childrenIds: oldChildrenIds);
    }

    // Add to new parent
    final newParent = newNodes[toParentId];
    if (newParent != null) {
      final newChildrenIds = List<String>.from(newParent.childrenIds);
      // If same parent, the list was already modified above
      if (fromParentId == toParentId) {
        // Use the already-modified list from the parent in newNodes
        final modifiedParent = newNodes[toParentId]!;
        final modifiedChildrenIds =
            List<String>.from(modifiedParent.childrenIds);
        final clampedIndex = targetIndex.clamp(0, modifiedChildrenIds.length);
        modifiedChildrenIds.insert(clampedIndex, nodeId);
        newNodes[toParentId] =
            modifiedParent.copyWith(childrenIds: modifiedChildrenIds);
      } else {
        final clampedIndex = targetIndex.clamp(0, newChildrenIds.length);
        newChildrenIds.insert(clampedIndex, nodeId);
        newNodes[toParentId] = newParent.copyWith(childrenIds: newChildrenIds);
      }
    }

    // Update the node's parentId if moving to different parent
    if (fromParentId != toParentId) {
      final movedNode = newNodes[nodeId];
      if (movedNode != null) {
        newNodes[nodeId] = movedNode.copyWith(parentId: toParentId);
      }
    }

    return state.copyWith(nodes: newNodes);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'MoveWidgetCommand',
      'nodeId': nodeId,
      'oldParentId': oldParentId,
      'newParentId': newParentId,
      'oldIndex': oldIndex,
      'newIndex': newIndex,
    };
  }
}

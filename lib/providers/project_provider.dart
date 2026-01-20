import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Provides the current project state.
final projectProvider = StateNotifierProvider<ProjectNotifier, ProjectState>(
  (ref) => ProjectNotifier(),
);

/// State notifier for managing project state.
class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier() : super(const ProjectState());

  static const _uuid = Uuid();

  /// Adds a widget to the project at the root level.
  void addWidget({
    required String type,
    Map<String, dynamic> properties = const {},
  }) {
    final id = _uuid.v4();
    final node = WidgetNode(
      id: id,
      type: type,
      properties: properties,
    );

    state = state.copyWith(
      nodes: {...state.nodes, id: node},
      rootIds: [...state.rootIds, id],
    );
  }

  /// Adds a widget as a child of another widget.
  void addChildWidget({
    required String parentId,
    required String type,
    Map<String, dynamic> properties = const {},
  }) {
    final parentNode = state.nodes[parentId];
    if (parentNode == null) return;

    final id = _uuid.v4();
    final node = WidgetNode(
      id: id,
      type: type,
      properties: properties,
      parentId: parentId,
    );

    final updatedParent = parentNode.copyWith(
      childrenIds: [...parentNode.childrenIds, id],
    );

    state = state.copyWith(
      nodes: {
        ...state.nodes,
        id: node,
        parentId: updatedParent,
      },
    );
  }

  /// Updates a property on a widget.
  void updateProperty({
    required String nodeId,
    required String propertyName,
    required dynamic value,
  }) {
    final node = state.nodes[nodeId];
    if (node == null) return;

    final updatedProperties = Map<String, dynamic>.from(node.properties);
    if (value == null) {
      updatedProperties.remove(propertyName);
    } else {
      updatedProperties[propertyName] = value;
    }

    final updatedNode = node.copyWith(properties: updatedProperties);
    state = state.copyWith(
      nodes: {...state.nodes, nodeId: updatedNode},
    );
  }

  /// Removes a widget from the project.
  void removeWidget(String nodeId) {
    final node = state.nodes[nodeId];
    if (node == null) return;

    // Remove from parent's children
    if (node.parentId != null) {
      final parent = state.nodes[node.parentId!];
      if (parent != null) {
        final updatedParent = parent.copyWith(
          childrenIds: parent.childrenIds.where((id) => id != nodeId).toList(),
        );
        state = state.copyWith(
          nodes: {...state.nodes, node.parentId!: updatedParent},
        );
      }
    }

    // Remove from root ids if present
    final updatedRootIds = state.rootIds.where((id) => id != nodeId).toList();

    // Remove the node and all its descendants
    final nodesToRemove = _collectDescendants(nodeId);
    final updatedNodes = Map<String, WidgetNode>.from(state.nodes)
      ..removeWhere((id, _) => nodesToRemove.contains(id));

    state = state.copyWith(
      nodes: updatedNodes,
      rootIds: updatedRootIds,
    );
  }

  Set<String> _collectDescendants(String nodeId) {
    final descendants = <String>{nodeId};
    final node = state.nodes[nodeId];
    if (node != null) {
      for (final childId in node.childrenIds) {
        descendants.addAll(_collectDescendants(childId));
      }
    }
    return descendants;
  }

  /// Clears the project.
  void clear() {
    state = const ProjectState();
  }
}

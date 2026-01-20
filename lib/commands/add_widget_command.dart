import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:uuid/uuid.dart';

/// Command to add a widget to the project.
///
/// This command handles both root-level widget addition
/// and adding a widget as a child of an existing widget.
/// It also supports adding pre-created nodes (for duplication).
class AddWidgetCommand extends Command {
  /// Creates a command to add a new widget by type.
  AddWidgetCommand({
    required this.widgetType,
    required this.properties,
    this.parentId,
    this.insertIndex,
  })  : nodeId = null,
        node = null;

  /// Creates a command to add a pre-created node (for duplication).
  AddWidgetCommand.withNode({
    required String this.nodeId,
    required WidgetNode this.node,
    this.parentId,
    this.insertIndex,
  })  : widgetType = node.type,
        properties = node.properties;

  static const _uuid = Uuid();

  /// The type of widget to add (e.g., 'Container', 'Text').
  final String widgetType;

  /// Initial properties for the widget.
  final Map<String, dynamic> properties;

  /// Parent widget ID, or null for root-level widgets.
  final String? parentId;

  /// Index at which to insert in parent's children.
  /// If null, appends to end.
  final int? insertIndex;

  /// Pre-specified node ID (for duplication).
  final String? nodeId;

  /// Pre-created node (for duplication).
  final WidgetNode? node;

  /// The ID of the widget that was created.
  /// Set after first execute() call and reused for redo.
  String? _createdNodeId;

  /// Gets the ID of the created node.
  String? get createdNodeId => _createdNodeId;

  @override
  String get description => 'Add $widgetType';

  @override
  ProjectState execute(ProjectState state) {
    // Generate ID on first execute, reuse for redo
    // Use provided nodeId for duplication operations
    _createdNodeId ??= nodeId ?? _uuid.v4();
    final nodeIdToUse = _createdNodeId!;

    // Use provided node or create a new one
    final widgetNode = node != null
        ? node!.copyWith(
            id: nodeIdToUse,
            parentId: parentId,
          )
        : WidgetNode(
            id: nodeIdToUse,
            type: widgetType,
            properties: Map<String, dynamic>.from(properties),
            parentId: parentId,
          );

    final newNodes = Map<String, WidgetNode>.from(state.nodes)
      ..[nodeIdToUse] = widgetNode;

    List<String> newRootIds;
    if (parentId == null) {
      // Root-level widget
      if (insertIndex != null && insertIndex! <= state.rootIds.length) {
        newRootIds = List<String>.from(state.rootIds)
          ..insert(insertIndex!, nodeIdToUse);
      } else {
        newRootIds = [...state.rootIds, nodeIdToUse];
      }
    } else {
      // Child widget - update parent
      newRootIds = state.rootIds;
      final parent = newNodes[parentId!];
      if (parent != null) {
        final newChildrenIds = List<String>.from(parent.childrenIds);
        if (insertIndex != null && insertIndex! <= newChildrenIds.length) {
          newChildrenIds.insert(insertIndex!, nodeIdToUse);
        } else {
          newChildrenIds.add(nodeIdToUse);
        }
        newNodes[parentId!] = parent.copyWith(childrenIds: newChildrenIds);
      }
    }

    return state.copyWith(
      nodes: newNodes,
      rootIds: newRootIds,
    );
  }

  @override
  ProjectState undo(ProjectState state) {
    if (_createdNodeId == null) return state;

    final newNodes = Map<String, WidgetNode>.from(state.nodes)
      ..remove(_createdNodeId);

    List<String> newRootIds;
    if (parentId == null) {
      // Remove from root ids
      newRootIds = state.rootIds.where((id) => id != _createdNodeId).toList();
    } else {
      // Remove from parent's children
      newRootIds = state.rootIds;
      final parent = newNodes[parentId!];
      if (parent != null) {
        final newChildrenIds =
            parent.childrenIds.where((id) => id != _createdNodeId).toList();
        newNodes[parentId!] = parent.copyWith(childrenIds: newChildrenIds);
      }
    }

    return state.copyWith(
      nodes: newNodes,
      rootIds: newRootIds,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'AddWidgetCommand',
      'widgetType': widgetType,
      'properties': properties,
      'parentId': parentId,
      'insertIndex': insertIndex,
      'createdNodeId': _createdNodeId,
    };
  }
}

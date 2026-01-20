import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:uuid/uuid.dart';

/// Command to add a widget to the project.
///
/// This command handles both root-level widget addition
/// and adding a widget as a child of an existing widget.
class AddWidgetCommand extends Command {
  AddWidgetCommand({
    required this.widgetType,
    required this.properties,
    this.parentId,
    this.insertIndex,
  });

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
    _createdNodeId ??= _uuid.v4();

    final node = WidgetNode(
      id: _createdNodeId!,
      type: widgetType,
      properties: Map<String, dynamic>.from(properties),
      parentId: parentId,
    );

    final newNodes = Map<String, WidgetNode>.from(state.nodes)
      ..[_createdNodeId!] = node;

    List<String> newRootIds;
    if (parentId == null) {
      // Root-level widget
      newRootIds = [...state.rootIds, _createdNodeId!];
    } else {
      // Child widget - update parent
      newRootIds = state.rootIds;
      final parent = newNodes[parentId!];
      if (parent != null) {
        final newChildrenIds = List<String>.from(parent.childrenIds);
        if (insertIndex != null && insertIndex! < newChildrenIds.length) {
          newChildrenIds.insert(insertIndex!, _createdNodeId!);
        } else {
          newChildrenIds.add(_createdNodeId!);
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

import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:uuid/uuid.dart';

/// Command to wrap an existing widget in a new wrapper widget.
///
/// This creates a new widget of the specified type and makes
/// the target widget its child, preserving the target's position
/// in the tree hierarchy.
class WrapWidgetCommand extends Command {
  WrapWidgetCommand({
    required this.targetId,
    required this.wrapperType,
    this.wrapperProperties = const {},
  });

  static const _uuid = Uuid();

  /// The ID of the widget to wrap.
  final String targetId;

  /// The type of wrapper widget to create.
  final String wrapperType;

  /// Properties for the wrapper widget.
  final Map<String, dynamic> wrapperProperties;

  /// The ID of the wrapper widget created.
  String? _wrapperId;

  /// The original parent ID of the target (for undo).
  String? _originalParentId;

  /// Whether the target was a root widget (for undo).
  bool? _wasRoot;

  @override
  String get description => 'Wrap in $wrapperType';

  @override
  ProjectState execute(ProjectState state) {
    final target = state.nodes[targetId];
    if (target == null) return state;

    // Generate wrapper ID on first execute
    _wrapperId ??= _uuid.v4();

    // Store original position for undo
    _originalParentId = target.parentId;
    _wasRoot = target.parentId == null;

    // Create wrapper node
    final wrapper = WidgetNode(
      id: _wrapperId!,
      type: wrapperType,
      properties: Map<String, dynamic>.from(wrapperProperties),
      parentId: _originalParentId,
      childrenIds: [targetId],
    );

    // Update target to point to wrapper as parent
    final updatedTarget = target.copyWith(parentId: _wrapperId);

    // Build new nodes map
    final newNodes = Map<String, WidgetNode>.from(state.nodes)
      ..[_wrapperId!] = wrapper
      ..[targetId] = updatedTarget;

    // Update parent's children or root ids
    List<String> newRootIds;
    if (_wasRoot ?? false) {
      // Replace target with wrapper in root ids
      newRootIds = List<String>.from(state.rootIds);
      final index = newRootIds.indexOf(targetId);
      if (index >= 0) {
        newRootIds[index] = _wrapperId!;
      }
    } else {
      // Replace target with wrapper in parent's children
      newRootIds = state.rootIds;
      final parent = newNodes[_originalParentId!];
      if (parent != null) {
        final newChildrenIds = List<String>.from(parent.childrenIds);
        final index = newChildrenIds.indexOf(targetId);
        if (index >= 0) {
          newChildrenIds[index] = _wrapperId!;
        }
        newNodes[_originalParentId!] =
            parent.copyWith(childrenIds: newChildrenIds);
      }
    }

    return state.copyWith(
      nodes: newNodes,
      rootIds: newRootIds,
    );
  }

  @override
  ProjectState undo(ProjectState state) {
    if (_wrapperId == null) return state;

    final target = state.nodes[targetId];
    if (target == null) return state;

    // Restore target's original parent
    final restoredTarget = target.copyWith(parentId: _originalParentId);

    // Build new nodes map without wrapper
    final newNodes = Map<String, WidgetNode>.from(state.nodes)
      ..remove(_wrapperId)
      ..[targetId] = restoredTarget;

    // Restore parent's children or root ids
    List<String> newRootIds;
    if (_wasRoot ?? false) {
      // Replace wrapper with target in root ids
      newRootIds = List<String>.from(state.rootIds);
      final index = newRootIds.indexOf(_wrapperId!);
      if (index >= 0) {
        newRootIds[index] = targetId;
      }
    } else {
      // Replace wrapper with target in parent's children
      newRootIds = state.rootIds;
      final parent = newNodes[_originalParentId!];
      if (parent != null) {
        final newChildrenIds = List<String>.from(parent.childrenIds);
        final index = newChildrenIds.indexOf(_wrapperId!);
        if (index >= 0) {
          newChildrenIds[index] = targetId;
        }
        newNodes[_originalParentId!] =
            parent.copyWith(childrenIds: newChildrenIds);
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
      'type': 'WrapWidgetCommand',
      'targetId': targetId,
      'wrapperType': wrapperType,
      'wrapperProperties': wrapperProperties,
      'wrapperId': _wrapperId,
    };
  }
}

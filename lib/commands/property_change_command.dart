import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';

/// Command to change a property value on a widget.
///
/// Stores both the old and new values to enable undo/redo.
/// If oldValue is null, the property didn't exist before.
/// If newValue is null, the property is being removed.
class PropertyChangeCommand extends Command {
  PropertyChangeCommand({
    required this.nodeId,
    required this.propertyName,
    required this.oldValue,
    required this.newValue,
  });

  /// The ID of the widget whose property is being changed.
  final String nodeId;

  /// The name of the property being changed.
  final String propertyName;

  /// The previous value of the property (null if property didn't exist).
  final dynamic oldValue;

  /// The new value of the property (null to remove).
  final dynamic newValue;

  @override
  String get description => 'Change $propertyName';

  @override
  ProjectState execute(ProjectState state) {
    return _applyValue(state, newValue);
  }

  @override
  ProjectState undo(ProjectState state) {
    return _applyValue(state, oldValue);
  }

  ProjectState _applyValue(ProjectState state, dynamic value) {
    final node = state.nodes[nodeId];
    if (node == null) return state;

    final newProperties = Map<String, dynamic>.from(node.properties);
    if (value == null) {
      newProperties.remove(propertyName);
    } else {
      newProperties[propertyName] = value;
    }

    final updatedNode = node.copyWith(properties: newProperties);
    final newNodes = Map<String, WidgetNode>.from(state.nodes);
    newNodes[nodeId] = updatedNode;

    return state.copyWith(nodes: newNodes);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'PropertyChangeCommand',
      'nodeId': nodeId,
      'propertyName': propertyName,
      'oldValue': oldValue,
      'newValue': newValue,
    };
  }
}

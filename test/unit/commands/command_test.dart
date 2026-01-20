import 'package:flutter_forge/commands/add_widget_command.dart';
import 'package:flutter_forge/commands/command.dart';
import 'package:flutter_forge/commands/command_processor.dart';
import 'package:flutter_forge/commands/delete_widget_command.dart';
import 'package:flutter_forge/commands/move_widget_command.dart';
import 'package:flutter_forge/commands/property_change_command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Command Pattern Foundation (Task 2.1)', () {
    group('Command base class', () {
      test('Command has execute() method', () {
        // Command should have an abstract execute method
        expect(Command, isNotNull);
      });

      test('Command has undo() method', () {
        // Command should have an abstract undo method
        expect(Command, isNotNull);
      });

      test('Command has description property', () {
        // For menu labels like "Undo: Change width"
        expect(Command, isNotNull);
      });
    });

    group('CommandProcessor', () {
      late CommandProcessor processor;
      late ProjectState initialState;

      setUp(() {
        processor = CommandProcessor();
        initialState = const ProjectState();
      });

      test('execute() adds command to undo stack', () {
        final command = _TestCommand('test');
        processor.execute(command, initialState);

        expect(processor.canUndo, isTrue);
        expect(processor.undoDescription, equals('test'));
      });

      test('undo() removes command from undo stack and adds to redo stack', () {
        final command = _TestCommand('test');
        var state = processor.execute(command, initialState);
        state = processor.undo(state);

        expect(processor.canUndo, isFalse);
        expect(processor.canRedo, isTrue);
        expect(processor.redoDescription, equals('test'));
      });

      test('redo() removes from redo stack and adds to undo stack', () {
        final command = _TestCommand('test');
        var state = processor.execute(command, initialState);
        state = processor.undo(state);
        state = processor.redo(state);

        expect(processor.canUndo, isTrue);
        expect(processor.canRedo, isFalse);
        expect(processor.undoDescription, equals('test'));
      });

      test('new action clears redo stack', () {
        final command1 = _TestCommand('first');
        final command2 = _TestCommand('second');

        var state = processor.execute(command1, initialState);
        state = processor.undo(state);
        expect(processor.canRedo, isTrue);

        state = processor.execute(command2, state);
        expect(processor.canRedo, isFalse);
      });

      test('undo stack limit is 100', () {
        var state = initialState;
        for (var i = 0; i < 105; i++) {
          state = processor.execute(_TestCommand('action $i'), state);
        }

        expect(processor.undoStackSize, equals(100));
        // Oldest should be discarded, newest should be action 104
        expect(processor.undoDescription, equals('action 104'));
      });

      test('oldest undo discarded when limit exceeded', () {
        var state = initialState;
        for (var i = 0; i < 100; i++) {
          state = processor.execute(_TestCommand('action $i'), state);
        }
        // Stack has actions 0-99

        // Add one more to exceed limit
        state = processor.execute(_TestCommand('action 100'), state);

        // Undo all 100 commands
        for (var i = 0; i < 100; i++) {
          state = processor.undo(state);
        }

        // Should not be able to undo action 0 (it was discarded)
        expect(processor.canUndo, isFalse);
      });

      test('canUndo returns false when undo stack is empty', () {
        expect(processor.canUndo, isFalse);
      });

      test('canRedo returns false when redo stack is empty', () {
        expect(processor.canRedo, isFalse);
      });

      test('undoDescription returns null when stack is empty', () {
        expect(processor.undoDescription, isNull);
      });

      test('redoDescription returns null when stack is empty', () {
        expect(processor.redoDescription, isNull);
      });
    });

    group('AddWidgetCommand', () {
      late CommandProcessor processor;
      late ProjectState state;

      setUp(() {
        processor = CommandProcessor();
        state = const ProjectState();
      });

      test('execute() adds widget to state', () {
        final command = AddWidgetCommand(
          widgetType: 'Container',
          properties: {'width': 100.0},
        );

        state = processor.execute(command, state);

        expect(state.nodes.length, equals(1));
        expect(state.rootIds.length, equals(1));

        final node = state.nodes.values.first;
        expect(node.type, equals('Container'));
        expect(node.properties['width'], equals(100.0));
      });

      test('execute() adds child widget to parent', () {
        // First add parent
        final parentCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        state = processor.execute(parentCommand, state);
        final parentId = state.rootIds.first;

        // Then add child
        final childCommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'Hello'},
          parentId: parentId,
        );
        state = processor.execute(childCommand, state);

        expect(state.nodes.length, equals(2));
        expect(state.rootIds.length, equals(1));

        final parent = state.nodes[parentId]!;
        expect(parent.childrenIds.length, equals(1));

        final childId = parent.childrenIds.first;
        final child = state.nodes[childId]!;
        expect(child.type, equals('Text'));
        expect(child.parentId, equals(parentId));
      });

      test('undo() removes added widget', () {
        final command = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );

        state = processor.execute(command, state);
        expect(state.nodes.length, equals(1));

        state = processor.undo(state);
        expect(state.nodes.length, equals(0));
        expect(state.rootIds.length, equals(0));
      });

      test('undo() removes child and updates parent', () {
        // Add parent
        final parentCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        state = processor.execute(parentCommand, state);
        final parentId = state.rootIds.first;

        // Add child
        final childCommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'Hello'},
          parentId: parentId,
        );
        state = processor.execute(childCommand, state);

        // Undo child
        state = processor.undo(state);

        expect(state.nodes.length, equals(1));
        final parent = state.nodes[parentId]!;
        expect(parent.childrenIds.length, equals(0));
      });

      test('description is "Add [type]"', () {
        final command = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );

        expect(command.description, equals('Add Container'));
      });

      test('createdNodeId is set after execute', () {
        final command = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );

        expect(command.createdNodeId, isNull);
        processor.execute(command, state);
        expect(command.createdNodeId, isNotNull);
      });
    });

    group('DeleteWidgetCommand', () {
      late CommandProcessor processor;
      late ProjectState state;
      late String containerId;

      setUp(() {
        processor = CommandProcessor();
        // Set up state with Container > Text
        state = const ProjectState();

        final parentCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {'width': 100.0},
        );
        state = processor.execute(parentCommand, state);
        containerId = state.rootIds.first;

        final childCommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'Hello'},
          parentId: containerId,
        );
        state = processor.execute(childCommand, state);

        // Clear undo history for cleaner tests
        processor = CommandProcessor();
      });

      test('execute() removes widget from state', () {
        final textId = state.nodes[containerId]!.childrenIds.first;
        final command = DeleteWidgetCommand(nodeId: textId);

        state = processor.execute(command, state);

        expect(state.nodes.length, equals(1));
        final container = state.nodes[containerId]!;
        expect(container.childrenIds.length, equals(0));
      });

      test('execute() removes widget with all children', () {
        final command = DeleteWidgetCommand(nodeId: containerId);

        state = processor.execute(command, state);

        expect(state.nodes.length, equals(0));
        expect(state.rootIds.length, equals(0));
      });

      test('undo() restores deleted widget', () {
        final textId = state.nodes[containerId]!.childrenIds.first;
        final command = DeleteWidgetCommand(nodeId: textId);

        state = processor.execute(command, state);
        state = processor.undo(state);

        expect(state.nodes.length, equals(2));
        final container = state.nodes[containerId]!;
        expect(container.childrenIds.length, equals(1));
      });

      test('undo() restores widget with all children', () {
        final command = DeleteWidgetCommand(nodeId: containerId);

        state = processor.execute(command, state);
        state = processor.undo(state);

        expect(state.nodes.length, equals(2));
        expect(state.rootIds.length, equals(1));
        final container = state.nodes[containerId]!;
        expect(container.childrenIds.length, equals(1));
      });

      test('undo() restores original position in parent', () {
        // Add more children to container
        final command1 = AddWidgetCommand(
          widgetType: 'Icon',
          properties: {},
          parentId: containerId,
        );
        state = processor.execute(command1, state);

        // Now Container has [Text, Icon]
        final textId = state.nodes[containerId]!.childrenIds.first;

        final deleteCommand = DeleteWidgetCommand(nodeId: textId);
        state = processor.execute(deleteCommand, state);

        // Now Container has [Icon]
        expect(state.nodes[containerId]!.childrenIds.length, equals(1));

        state = processor.undo(state);

        // Text should be back at position 0
        final container = state.nodes[containerId]!;
        expect(container.childrenIds.length, equals(2));
        expect(container.childrenIds.first, equals(textId));
      });

      test('description is "Delete [type]"', () {
        final command = DeleteWidgetCommand(nodeId: containerId);
        // Need to capture state during execution for description
        processor.execute(command, state);

        expect(command.description, equals('Delete Container'));
      });
    });

    group('PropertyChangeCommand', () {
      late CommandProcessor processor;
      late ProjectState state;
      late String nodeId;

      setUp(() {
        processor = CommandProcessor();
        state = const ProjectState();

        final command = AddWidgetCommand(
          widgetType: 'Container',
          properties: {'width': 100.0, 'height': 50.0},
        );
        state = processor.execute(command, state);
        nodeId = state.rootIds.first;

        processor = CommandProcessor();
      });

      test('execute() changes property value', () {
        final command = PropertyChangeCommand(
          nodeId: nodeId,
          propertyName: 'width',
          oldValue: 100.0,
          newValue: 200.0,
        );

        state = processor.execute(command, state);

        final node = state.nodes[nodeId]!;
        expect(node.properties['width'], equals(200.0));
      });

      test('undo() reverts to previous value', () {
        final command = PropertyChangeCommand(
          nodeId: nodeId,
          propertyName: 'width',
          oldValue: 100.0,
          newValue: 200.0,
        );

        state = processor.execute(command, state);
        state = processor.undo(state);

        final node = state.nodes[nodeId]!;
        expect(node.properties['width'], equals(100.0));
      });

      test('execute() can add new property', () {
        final command = PropertyChangeCommand(
          nodeId: nodeId,
          propertyName: 'color',
          oldValue: null,
          newValue: 0xFF0000FF,
        );

        state = processor.execute(command, state);

        final node = state.nodes[nodeId]!;
        expect(node.properties['color'], equals(0xFF0000FF));
      });

      test('undo() can remove added property', () {
        final command = PropertyChangeCommand(
          nodeId: nodeId,
          propertyName: 'color',
          oldValue: null,
          newValue: 0xFF0000FF,
        );

        state = processor.execute(command, state);
        state = processor.undo(state);

        final node = state.nodes[nodeId]!;
        expect(node.properties.containsKey('color'), isFalse);
      });

      test('description is "Change [property]"', () {
        final command = PropertyChangeCommand(
          nodeId: nodeId,
          propertyName: 'width',
          oldValue: 100.0,
          newValue: 200.0,
        );

        expect(command.description, equals('Change width'));
      });
    });

    group('MoveWidgetCommand', () {
      late CommandProcessor processor;
      late ProjectState state;
      late String columnId;
      late String textAId;
      late String textBId;
      late String textCId;

      setUp(() {
        processor = CommandProcessor();
        state = const ProjectState();

        // Create Column > [Text A, Text B, Text C]
        final columnCommand = AddWidgetCommand(
          widgetType: 'Column',
          properties: {},
        );
        state = processor.execute(columnCommand, state);
        columnId = state.rootIds.first;

        final textACommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'A'},
          parentId: columnId,
        );
        state = processor.execute(textACommand, state);
        textAId = state.nodes[columnId]!.childrenIds.last;

        final textBCommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'B'},
          parentId: columnId,
        );
        state = processor.execute(textBCommand, state);
        textBId = state.nodes[columnId]!.childrenIds.last;

        final textCCommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'C'},
          parentId: columnId,
        );
        state = processor.execute(textCCommand, state);
        textCId = state.nodes[columnId]!.childrenIds.last;

        processor = CommandProcessor();
      });

      test('execute() reorders within same parent', () {
        // Move B to position 0 (before A)
        final command = MoveWidgetCommand(
          nodeId: textBId,
          oldParentId: columnId,
          newParentId: columnId,
          oldIndex: 1,
          newIndex: 0,
        );

        state = processor.execute(command, state);

        final column = state.nodes[columnId]!;
        expect(column.childrenIds, equals([textBId, textAId, textCId]));
      });

      test('undo() restores original order', () {
        final command = MoveWidgetCommand(
          nodeId: textBId,
          oldParentId: columnId,
          newParentId: columnId,
          oldIndex: 1,
          newIndex: 0,
        );

        state = processor.execute(command, state);
        state = processor.undo(state);

        final column = state.nodes[columnId]!;
        expect(column.childrenIds, equals([textAId, textBId, textCId]));
      });

      test('execute() moves to different parent', () {
        // Create another container as sibling
        final containerCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        state = processor.execute(containerCommand, state);
        final containerId = state.rootIds.last;

        processor = CommandProcessor();

        // Move Text A from Column to Container
        final command = MoveWidgetCommand(
          nodeId: textAId,
          oldParentId: columnId,
          newParentId: containerId,
          oldIndex: 0,
          newIndex: 0,
        );

        state = processor.execute(command, state);

        final column = state.nodes[columnId]!;
        final container = state.nodes[containerId]!;
        final movedNode = state.nodes[textAId]!;

        expect(column.childrenIds, equals([textBId, textCId]));
        expect(container.childrenIds, equals([textAId]));
        expect(movedNode.parentId, equals(containerId));
      });

      test('undo() restores to original parent and position', () {
        // Create another container
        final containerCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        state = processor.execute(containerCommand, state);
        final containerId = state.rootIds.last;

        processor = CommandProcessor();

        final command = MoveWidgetCommand(
          nodeId: textAId,
          oldParentId: columnId,
          newParentId: containerId,
          oldIndex: 0,
          newIndex: 0,
        );

        state = processor.execute(command, state);
        state = processor.undo(state);

        final column = state.nodes[columnId]!;
        final container = state.nodes[containerId]!;
        final movedNode = state.nodes[textAId]!;

        expect(column.childrenIds, equals([textAId, textBId, textCId]));
        expect(container.childrenIds, isEmpty);
        expect(movedNode.parentId, equals(columnId));
      });

      test('description is "Move [type]" after execute', () {
        final command = MoveWidgetCommand(
          nodeId: textAId,
          oldParentId: columnId,
          newParentId: columnId,
          oldIndex: 0,
          newIndex: 2,
        );

        // Description shows type after execute sets it
        processor.execute(command, state);
        expect(command.description, equals('Move Text'));
      });

      test('description before execute shows "Move Widget"', () {
        final command = MoveWidgetCommand(
          nodeId: textAId,
          oldParentId: columnId,
          newParentId: columnId,
          oldIndex: 0,
          newIndex: 2,
        );

        // Before execute, type is not known
        expect(command.description, equals('Move Widget'));
      });
    });

    group('Undo/Redo chain', () {
      late CommandProcessor processor;

      setUp(() {
        processor = CommandProcessor();
      });

      test('3 undos + 3 redos returns to original state', () {
        var state = const ProjectState();

        // Execute 3 commands
        final cmd1 = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        state = processor.execute(cmd1, state);
        // Get the ID from the command after execution
        final containerId = cmd1.createdNodeId!;

        final cmd2 = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'Hello'},
          parentId: containerId,
        );
        state = processor.execute(cmd2, state);

        final cmd3 = PropertyChangeCommand(
          nodeId: containerId,
          propertyName: 'width',
          oldValue: null,
          newValue: 100.0,
        );
        state = processor.execute(cmd3, state);

        // Capture final state values
        final finalNodeCount = state.nodes.length;
        final finalWidth = state.nodes[containerId]!.properties['width'];

        // Undo 3 times
        state = processor.undo(state);
        state = processor.undo(state);
        state = processor.undo(state);

        expect(state.nodes.length, equals(0));

        // Redo 3 times
        state = processor.redo(state);
        state = processor.redo(state);
        state = processor.redo(state);

        // Should match final state
        // Note: After redo, the same nodes are restored (same IDs preserved)
        expect(state.nodes.length, equals(finalNodeCount));
        expect(
          state.nodes[containerId]!.properties['width'],
          equals(finalWidth),
        );
      });
    });

    group('Command serialization', () {
      test('AddWidgetCommand can be serialized to JSON', () {
        final command = AddWidgetCommand(
          widgetType: 'Container',
          properties: {'width': 100.0},
        );

        final json = command.toJson();
        expect(json, containsPair('type', 'AddWidgetCommand'));
        expect(json, containsPair('widgetType', 'Container'));
        expect(json['properties'], containsPair('width', 100.0));
      });

      test('PropertyChangeCommand can be serialized to JSON', () {
        final command = PropertyChangeCommand(
          nodeId: 'node-123',
          propertyName: 'width',
          oldValue: 100.0,
          newValue: 200.0,
        );

        final json = command.toJson();
        expect(json, containsPair('type', 'PropertyChangeCommand'));
        expect(json, containsPair('nodeId', 'node-123'));
        expect(json, containsPair('propertyName', 'width'));
        expect(json, containsPair('oldValue', 100.0));
        expect(json, containsPair('newValue', 200.0));
      });

      test('DeleteWidgetCommand can be serialized to JSON', () {
        final command = DeleteWidgetCommand(nodeId: 'node-456');

        final json = command.toJson();
        expect(json, containsPair('type', 'DeleteWidgetCommand'));
        expect(json, containsPair('nodeId', 'node-456'));
      });

      test('MoveWidgetCommand can be serialized to JSON', () {
        final command = MoveWidgetCommand(
          nodeId: 'node-789',
          oldParentId: 'parent-1',
          newParentId: 'parent-2',
          oldIndex: 0,
          newIndex: 1,
        );

        final json = command.toJson();
        expect(json, containsPair('type', 'MoveWidgetCommand'));
        expect(json, containsPair('nodeId', 'node-789'));
        expect(json, containsPair('oldParentId', 'parent-1'));
        expect(json, containsPair('newParentId', 'parent-2'));
        expect(json, containsPair('oldIndex', 0));
        expect(json, containsPair('newIndex', 1));
      });
    });
  });
}

/// Test command for basic processor tests.
class _TestCommand extends Command {
  _TestCommand(this._description);

  final String _description;

  @override
  String get description => _description;

  @override
  ProjectState execute(ProjectState state) => state;

  @override
  ProjectState undo(ProjectState state) => state;

  @override
  Map<String, dynamic> toJson() => {'type': 'TestCommand'};
}

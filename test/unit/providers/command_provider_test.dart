import 'package:flutter_forge/commands/commands.dart';
import 'package:flutter_forge/providers/command_provider.dart';
import 'package:flutter_forge/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Undo/Redo Provider Integration (Task 2.2)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('CommandProvider', () {
      test('initial state has no undo/redo available', () {
        final commandNotifier = container.read(commandProvider.notifier);

        expect(commandNotifier.canUndo, isFalse);
        expect(commandNotifier.canRedo, isFalse);
      });

      test('undoDescription returns null when stack is empty', () {
        final commandNotifier = container.read(commandProvider.notifier);

        expect(commandNotifier.undoDescription, isNull);
      });

      test('redoDescription returns null when stack is empty', () {
        final commandNotifier = container.read(commandProvider.notifier);

        expect(commandNotifier.redoDescription, isNull);
      });
    });

    group('Execute Command', () {
      test('executes AddWidgetCommand and updates project state', () {
        final commandNotifier = container.read(commandProvider.notifier);
        final command = AddWidgetCommand(
          widgetType: 'Container',
          properties: {'padding': 8.0},
        );

        commandNotifier.execute(command);

        final projectState = container.read(projectProvider);
        expect(projectState.nodes.length, equals(1));
        expect(projectState.nodes.values.first.type, equals('Container'));
        expect(commandNotifier.canUndo, isTrue);
      });

      test('executes PropertyChangeCommand and updates widget', () {
        final commandNotifier = container.read(commandProvider.notifier);

        // First add a widget
        final addCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {'padding': 8.0},
        );
        commandNotifier.execute(addCommand);

        final projectState = container.read(projectProvider);
        final nodeId = projectState.nodes.keys.first;

        // Now change property
        final changeCommand = PropertyChangeCommand(
          nodeId: nodeId,
          propertyName: 'padding',
          oldValue: 8.0,
          newValue: 16.0,
        );
        commandNotifier.execute(changeCommand);

        final updatedState = container.read(projectProvider);
        expect(
          updatedState.nodes[nodeId]?.properties['padding'],
          equals(16.0),
        );
      });

      test('executes DeleteWidgetCommand and removes widget', () {
        final commandNotifier = container.read(commandProvider.notifier);

        // First add a widget
        final addCommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'Hello'},
        );
        commandNotifier.execute(addCommand);

        final projectState = container.read(projectProvider);
        final nodeId = projectState.nodes.keys.first;

        // Now delete it
        final deleteCommand = DeleteWidgetCommand(nodeId: nodeId);
        commandNotifier.execute(deleteCommand);

        final updatedState = container.read(projectProvider);
        expect(updatedState.nodes, isEmpty);
        expect(updatedState.rootIds, isEmpty);
      });

      test('clears redo stack when new command is executed', () {
        final commandNotifier = container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          )
          ..undo();

        expect(commandNotifier.canRedo, isTrue);

        // Execute new command - should clear redo
        commandNotifier.execute(
          AddWidgetCommand(widgetType: 'Text', properties: {}),
        );

        expect(commandNotifier.canRedo, isFalse);
      });
    });

    group('Undo Operations', () {
      test('undo property change reverts to previous value', () {
        final commandNotifier = container.read(commandProvider.notifier);

        // Add a widget
        final addCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {'padding': 8.0},
        );
        commandNotifier.execute(addCommand);

        final projectState = container.read(projectProvider);
        final nodeId = projectState.nodes.keys.first;

        // Change property
        final changeCommand = PropertyChangeCommand(
          nodeId: nodeId,
          propertyName: 'padding',
          oldValue: 8.0,
          newValue: 16.0,
        );
        commandNotifier
          ..execute(changeCommand)
          // Undo the property change
          ..undo();

        final undoneState = container.read(projectProvider);
        expect(undoneState.nodes[nodeId]?.properties['padding'], equals(8.0));
      });

      test('undo widget add removes widget', () {
        final commandNotifier = container.read(commandProvider.notifier);

        final addCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        commandNotifier.execute(addCommand);

        expect(container.read(projectProvider).nodes.length, equals(1));

        commandNotifier.undo();

        expect(container.read(projectProvider).nodes, isEmpty);
      });

      test('undo widget delete restores widget', () {
        final commandNotifier = container.read(commandProvider.notifier);

        // Add a widget
        final addCommand = AddWidgetCommand(
          widgetType: 'Text',
          properties: {'data': 'Test'},
        );
        commandNotifier.execute(addCommand);

        final projectState = container.read(projectProvider);
        final nodeId = projectState.nodes.keys.first;

        // Delete it
        final deleteCommand = DeleteWidgetCommand(nodeId: nodeId);
        commandNotifier.execute(deleteCommand);

        expect(container.read(projectProvider).nodes, isEmpty);

        // Undo the delete
        commandNotifier.undo();

        final restoredState = container.read(projectProvider);
        expect(restoredState.nodes.length, equals(1));
        expect(restoredState.nodes[nodeId]?.type, equals('Text'));
        expect(
          restoredState.nodes[nodeId]?.properties['data'],
          equals('Test'),
        );
      });

      test('undo widget delete restores widget with children', () {
        final commandNotifier = container.read(commandProvider.notifier);

        // Add parent widget
        final addParent = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        commandNotifier.execute(addParent);

        final parentId = container.read(projectProvider).nodes.keys.first;

        // Add child widget
        final addChild = AddWidgetCommand(
          widgetType: 'Text',
          parentId: parentId,
          properties: {'data': 'Child'},
        );
        commandNotifier.execute(addChild);

        final stateWithChild = container.read(projectProvider);
        final childId = stateWithChild.nodes.keys.firstWhere(
          (id) => id != parentId,
        );

        // Delete parent (should also delete child)
        final deleteCommand = DeleteWidgetCommand(nodeId: parentId);
        commandNotifier.execute(deleteCommand);

        expect(container.read(projectProvider).nodes, isEmpty);

        // Undo - should restore parent and child
        commandNotifier.undo();

        final restoredState = container.read(projectProvider);
        expect(restoredState.nodes.length, equals(2));
        expect(restoredState.nodes[parentId], isNotNull);
        expect(restoredState.nodes[childId], isNotNull);
      });

      test('undo move restores original position', () {
        final commandNotifier = container.read(commandProvider.notifier);

        // Create a column with multiple children
        final addColumn = AddWidgetCommand(
          widgetType: 'Column',
          properties: {},
        );
        commandNotifier.execute(addColumn);
        final columnId = container.read(projectProvider).nodes.keys.first;

        final addChild1 = AddWidgetCommand(
          widgetType: 'Text',
          parentId: columnId,
          properties: {},
        );
        commandNotifier.execute(addChild1);
        final child1Id = container.read(projectProvider).nodes.keys.firstWhere(
              (id) => id != columnId,
            );

        final addChild2 = AddWidgetCommand(
          widgetType: 'Text',
          parentId: columnId,
          properties: {},
        );
        commandNotifier.execute(addChild2);
        final child2Id = container.read(projectProvider).nodes.keys.firstWhere(
              (id) => id != columnId && id != child1Id,
            );

        // Original order: [child1, child2]
        var state = container.read(projectProvider);
        expect(
          state.nodes[columnId]?.childrenIds,
          equals([child1Id, child2Id]),
        );

        // Move child2 to position 0
        final moveCommand = MoveWidgetCommand(
          nodeId: child2Id,
          oldParentId: columnId,
          newParentId: columnId,
          oldIndex: 1,
          newIndex: 0,
        );
        commandNotifier.execute(moveCommand);

        // New order: [child2, child1]
        state = container.read(projectProvider);
        expect(
          state.nodes[columnId]?.childrenIds,
          equals([child2Id, child1Id]),
        );

        // Undo - should restore original order
        commandNotifier.undo();

        state = container.read(projectProvider);
        expect(
          state.nodes[columnId]?.childrenIds,
          equals([child1Id, child2Id]),
        );
      });

      test('undo does nothing when stack is empty', () {
        final commandNotifier = container.read(commandProvider.notifier);
        final initialState = container.read(projectProvider);

        commandNotifier.undo();

        final stateAfterUndo = container.read(projectProvider);
        expect(stateAfterUndo, equals(initialState));
      });
    });

    group('Redo Operations', () {
      test('redo restores undone change', () {
        final commandNotifier = container.read(commandProvider.notifier);

        final addCommand = AddWidgetCommand(
          widgetType: 'Container',
          properties: {},
        );
        commandNotifier
          ..execute(addCommand)
          ..undo();
        expect(container.read(projectProvider).nodes, isEmpty);

        commandNotifier.redo();
        expect(container.read(projectProvider).nodes.length, equals(1));
      });

      test('redo chain: 3 undos + 3 redos returns to original state', () {
        final commandNotifier = container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          );
        final containerId = container.read(projectProvider).nodes.keys.first;

        commandNotifier.execute(
          AddWidgetCommand(
            widgetType: 'Text',
            parentId: containerId,
            properties: {},
          ),
        );
        final textId = container.read(projectProvider).nodes.keys.firstWhere(
              (id) => id != containerId,
            );

        commandNotifier.execute(
          PropertyChangeCommand(
            nodeId: textId,
            propertyName: 'data',
            oldValue: null,
            newValue: 'Hello',
          ),
        );

        // Capture final state
        final finalState = container.read(projectProvider);
        expect(finalState.nodes.length, equals(2));
        expect(finalState.nodes[textId]?.properties['data'], equals('Hello'));

        // Undo all 3
        commandNotifier
          ..undo()
          ..undo()
          ..undo();

        expect(container.read(projectProvider).nodes, isEmpty);

        // Redo all 3
        commandNotifier
          ..redo()
          ..redo()
          ..redo();

        // Should be back to final state
        final restoredState = container.read(projectProvider);
        expect(restoredState.nodes.length, equals(2));
        expect(
          restoredState.nodes[textId]?.properties['data'],
          equals('Hello'),
        );
      });

      test('new action clears redo stack', () {
        final commandNotifier = container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          )
          ..undo();

        expect(commandNotifier.canRedo, isTrue);

        // New action should clear redo
        commandNotifier.execute(
          AddWidgetCommand(widgetType: 'Text', properties: {}),
        );

        expect(commandNotifier.canRedo, isFalse);
      });

      test('redo does nothing when stack is empty', () {
        final commandNotifier = container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          );
        final stateBeforeRedo = container.read(projectProvider);

        // No undo has been done, so redo stack is empty
        commandNotifier.redo();

        final stateAfterRedo = container.read(projectProvider);
        expect(
          stateAfterRedo.nodes.length,
          equals(stateBeforeRedo.nodes.length),
        );
      });
    });

    group('Undo/Redo Labels', () {
      test('undoDescription shows command description', () {
        final commandNotifier = container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          );

        expect(commandNotifier.undoDescription, contains('Container'));
      });

      test('redoDescription shows undone command description', () {
        final commandNotifier = container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          )
          ..undo();

        expect(commandNotifier.redoDescription, contains('Container'));
      });
    });

    group('Provider State Updates', () {
      test('commandStateProvider updates on execute', () {
        final commandNotifier = container.read(commandProvider.notifier);

        var state = container.read(commandProvider);
        expect(state.canUndo, isFalse);

        commandNotifier.execute(
          AddWidgetCommand(widgetType: 'Container', properties: {}),
        );

        state = container.read(commandProvider);
        expect(state.canUndo, isTrue);
        expect(state.canRedo, isFalse);
      });

      test('commandStateProvider updates on undo', () {
        container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          )
          ..undo();

        final state = container.read(commandProvider);
        expect(state.canUndo, isFalse);
        expect(state.canRedo, isTrue);
      });

      test('commandStateProvider updates on redo', () {
        container.read(commandProvider.notifier)
          ..execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          )
          ..undo()
          ..redo();

        final state = container.read(commandProvider);
        expect(state.canUndo, isTrue);
        expect(state.canRedo, isFalse);
      });
    });

    group('Stack Limits', () {
      test('enforces 100 command limit on undo stack', () {
        final commandNotifier = container.read(commandProvider.notifier);

        // Execute 105 commands
        for (var i = 0; i < 105; i++) {
          commandNotifier.execute(
            AddWidgetCommand(widgetType: 'Container', properties: {}),
          );
        }

        // Should only be able to undo 100 times
        var undoCount = 0;
        while (commandNotifier.canUndo) {
          commandNotifier.undo();
          undoCount++;
        }

        expect(undoCount, equals(100));
      });
    });
  });
}

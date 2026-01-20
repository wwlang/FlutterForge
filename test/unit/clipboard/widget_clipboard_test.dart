import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/services/widget_clipboard_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Clipboard (Task 4.9)', () {
    late WidgetClipboardService clipboard;

    setUp(() {
      clipboard = WidgetClipboardService();
    });

    group('Copy', () {
      test('copies single widget', () {
        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {'color': '#FF0000'},
        );

        clipboard.copy(node: node, allNodes: {'node-1': node});

        expect(clipboard.hasContent, true);
      });

      test('copies widget with children', () {
        final child = const WidgetNode(
          id: 'child-1',
          type: 'Text',
          properties: {'text': 'Hello'},
          parentId: 'parent-1',
        );

        final parent = const WidgetNode(
          id: 'parent-1',
          type: 'Column',
          properties: {},
          childrenIds: ['child-1'],
        );

        clipboard.copy(
          node: parent,
          allNodes: {'parent-1': parent, 'child-1': child},
        );

        final content = clipboard.getContent()!;
        expect(content.nodes.length, 2);
      });

      test('copies deeply nested widgets', () {
        final grandchild = const WidgetNode(
          id: 'grandchild-1',
          type: 'Text',
          properties: {'text': 'Hello'},
          parentId: 'child-1',
        );

        final child = const WidgetNode(
          id: 'child-1',
          type: 'Row',
          properties: {},
          childrenIds: ['grandchild-1'],
          parentId: 'parent-1',
        );

        final parent = const WidgetNode(
          id: 'parent-1',
          type: 'Column',
          properties: {},
          childrenIds: ['child-1'],
        );

        clipboard.copy(
          node: parent,
          allNodes: {
            'parent-1': parent,
            'child-1': child,
            'grandchild-1': grandchild,
          },
        );

        final content = clipboard.getContent()!;
        expect(content.nodes.length, 3);
      });

      test('preserves all properties', () {
        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {
            'color': '#FF0000',
            'padding': 16.0,
            'width': 100.0,
            'height': 200.0,
          },
        );

        clipboard.copy(node: node, allNodes: {'node-1': node});

        final content = clipboard.getContent()!;
        final copied = content.nodes['node-1']!;
        expect(copied.properties['color'], '#FF0000');
        expect(copied.properties['padding'], 16.0);
        expect(copied.properties['width'], 100.0);
        expect(copied.properties['height'], 200.0);
      });
    });

    group('Paste', () {
      test('generates new IDs on paste', () {
        final node = const WidgetNode(
          id: 'original-id',
          type: 'Container',
          properties: {},
        );

        clipboard.copy(node: node, allNodes: {'original-id': node});

        final pasted = clipboard.paste();
        expect(pasted, isNotNull);
        expect(pasted!.nodes.keys.first, isNot('original-id'));
      });

      test('maintains hierarchy on paste', () {
        final child = const WidgetNode(
          id: 'child-1',
          type: 'Text',
          properties: {},
          parentId: 'parent-1',
        );

        final parent = const WidgetNode(
          id: 'parent-1',
          type: 'Column',
          properties: {},
          childrenIds: ['child-1'],
        );

        clipboard.copy(
          node: parent,
          allNodes: {'parent-1': parent, 'child-1': child},
        );

        final pasted = clipboard.paste()!;
        final pastedParent = pasted.nodes[pasted.rootId]!;
        expect(pastedParent.childrenIds.length, 1);

        final pastedChild = pasted.nodes[pastedParent.childrenIds.first]!;
        expect(pastedChild.parentId, pasted.rootId);
      });

      test('returns null when empty', () {
        expect(clipboard.paste(), isNull);
      });

      test('preserves properties on paste', () {
        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {'padding': 24.0},
        );

        clipboard.copy(node: node, allNodes: {'node-1': node});

        final pasted = clipboard.paste()!;
        final pastedNode = pasted.nodes[pasted.rootId]!;
        expect(pastedNode.properties['padding'], 24.0);
      });

      test('can paste multiple times', () {
        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {},
        );

        clipboard.copy(node: node, allNodes: {'node-1': node});

        final paste1 = clipboard.paste()!;
        final paste2 = clipboard.paste()!;

        expect(paste1.rootId, isNot(paste2.rootId));
      });
    });

    group('Cut', () {
      test('copy returns content for cut operation', () {
        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {},
        );

        clipboard.copy(node: node, allNodes: {'node-1': node});

        expect(clipboard.hasContent, true);
        // The actual deletion is handled by the command, not the clipboard
      });
    });

    group('Clear', () {
      test('clears clipboard content', () {
        final node = const WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {},
        );

        clipboard.copy(node: node, allNodes: {'node-1': node});
        expect(clipboard.hasContent, true);

        clipboard.clear();
        expect(clipboard.hasContent, false);
      });
    });
  });
}

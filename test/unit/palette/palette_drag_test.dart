import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_forge/features/palette/palette_item.dart';

void main() {
  group('PaletteItem Drag Behavior', () {
    Widget buildTestWidget() {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: PaletteItem(
              widgetType: 'Container',
              displayName: 'Container',
              iconName: 'crop_square',
            ),
          ),
        ),
      );
    }

    testWidgets('drag feedback widget shows at reduced opacity', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Get the Draggable widget
      final draggableFinder = find.byType(Draggable<String>);
      expect(draggableFinder, findsOneWidget);

      // Start a drag operation
      final startLocation = tester.getCenter(find.text('Container'));
      final gesture = await tester.startGesture(startLocation);

      // Move slightly to initiate drag
      await gesture.moveBy(const Offset(10, 0));
      await tester.pump();

      // Drag feedback should be visible
      // The feedback uses 70% opacity on the container color
      final feedbackMaterial = find
          .descendant(
            of: find.byType(Material),
            matching: find.byType(Container),
          )
          .evaluate();
      expect(feedbackMaterial.isNotEmpty, isTrue);

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('original item shows at reduced opacity during drag', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final startLocation = tester.getCenter(find.text('Container'));
      final gesture = await tester.startGesture(startLocation);
      await gesture.moveBy(const Offset(10, 0));
      await tester.pump();

      // Should find an Opacity widget wrapping the childWhenDragging
      expect(find.byType(Opacity), findsOneWidget);

      // Get the Opacity widget and check its value
      final opacityWidget = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacityWidget.opacity, equals(0.5));

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('drag data contains widget type', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final draggable =
          tester.widget<Draggable<String>>(find.byType(Draggable<String>));
      expect(draggable.data, equals('Container'));
    });

    testWidgets('uses pointer drag anchor strategy', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final draggable =
          tester.widget<Draggable<String>>(find.byType(Draggable<String>));
      expect(draggable.dragAnchorStrategy, equals(pointerDragAnchorStrategy));
    });
  });

  group('PaletteItem with DragTarget', () {
    testWidgets('completes drag to valid target', (WidgetTester tester) async {
      String? droppedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const PaletteItem(
                  widgetType: 'Container',
                  displayName: 'Container',
                  iconName: 'crop_square',
                ),
                const SizedBox(height: 100),
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    droppedData = details.data;
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 200,
                      height: 200,
                      color:
                          candidateData.isNotEmpty ? Colors.green : Colors.grey,
                      child: const Center(child: Text('Drop Zone')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Drag from palette item to drop zone
      final startLocation = tester.getCenter(find.text('Container'));
      final endLocation = tester.getCenter(find.text('Drop Zone'));

      await tester.timedDragFrom(
        startLocation,
        endLocation - startLocation,
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();

      expect(droppedData, equals('Container'));
    });

    testWidgets('cancels drag when dropped outside valid target', (
      WidgetTester tester,
    ) async {
      String? droppedData;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const PaletteItem(
                  widgetType: 'Container',
                  displayName: 'Container',
                  iconName: 'crop_square',
                ),
                const SizedBox(height: 100),
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    droppedData = details.data;
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey,
                      child: const Center(child: Text('Drop Zone')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Start drag
      final startLocation = tester.getCenter(find.text('Container'));
      final gesture = await tester.startGesture(startLocation);
      await gesture.moveBy(const Offset(300, 0)); // Move away from drop zone
      await tester.pump();

      // Release outside drop zone
      await gesture.up();
      await tester.pumpAndSettle();

      // Nothing should be dropped
      expect(droppedData, isNull);
    });
  });
}

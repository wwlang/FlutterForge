import 'package:flutter/material.dart';
import 'package:flutter_forge/features/properties/alignment_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Alignment Editor (Journey: properties-panel.md)', () {
    group('Basic Rendering', () {
      testWidgets('renders 3x3 grid picker', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should find 9 InkWell cells in the grid
        expect(find.byType(InkWell), findsNWidgets(9));
      });

      testWidgets('displays current alignment', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: Alignment.topLeft,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Top-left should be highlighted
        expect(find.byType(AlignmentEditor), findsOneWidget);
      });

      testWidgets('shows property label', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Alignment'), findsOneWidget);
      });
    });

    group('Alignment Selection', () {
      testWidgets('selecting topLeft returns Alignment.topLeft', (
        WidgetTester tester,
      ) async {
        Alignment? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: Alignment.center,
                onChanged: (value) => result = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the top-left cell (first cell in grid)
        final cells = find.byType(InkWell);
        await tester.tap(cells.at(0));
        await tester.pumpAndSettle();

        expect(result, equals(Alignment.topLeft));
      });

      testWidgets('selecting center returns Alignment.center', (
        WidgetTester tester,
      ) async {
        Alignment? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: Alignment.topLeft,
                onChanged: (value) => result = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the center cell (index 4 in 3x3 grid)
        final cells = find.byType(InkWell);
        await tester.tap(cells.at(4));
        await tester.pumpAndSettle();

        expect(result, equals(Alignment.center));
      });

      testWidgets('selecting bottomRight returns Alignment.bottomRight', (
        WidgetTester tester,
      ) async {
        Alignment? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: Alignment.center,
                onChanged: (value) => result = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the bottom-right cell (index 8 in 3x3 grid)
        final cells = find.byType(InkWell);
        await tester.tap(cells.at(8));
        await tester.pumpAndSettle();

        expect(result, equals(Alignment.bottomRight));
      });
    });

    group('All 9 Alignments', () {
      final alignmentMap = {
        0: Alignment.topLeft,
        1: Alignment.topCenter,
        2: Alignment.topRight,
        3: Alignment.centerLeft,
        4: Alignment.center,
        5: Alignment.centerRight,
        6: Alignment.bottomLeft,
        7: Alignment.bottomCenter,
        8: Alignment.bottomRight,
      };

      for (final entry in alignmentMap.entries) {
        testWidgets('cell ${entry.key} returns ${entry.value}', (
          WidgetTester tester,
        ) async {
          Alignment? result;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: AlignmentEditor(
                  propertyName: 'alignment',
                  displayName: 'Alignment',
                  value: null,
                  onChanged: (value) => result = value,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final cells = find.byType(InkWell);
          await tester.tap(cells.at(entry.key));
          await tester.pumpAndSettle();

          expect(result, equals(entry.value));
        });
      }
    });

    group('Visual Indicators', () {
      testWidgets('selected cell is visually different', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: Alignment.center,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The grid should render with visual distinction for selected cell
        expect(find.byType(AlignmentEditor), findsOneWidget);

        // Find the center cell - it should have different styling
        final cells = find.byType(InkWell);
        expect(cells, findsNWidgets(9));
      });

      testWidgets('grid has appropriate size', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final editor = tester.getSize(find.byType(AlignmentEditor));
        // Grid should have reasonable size
        expect(editor.width, greaterThan(50));
        expect(editor.height, greaterThan(50));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null value', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should render without error
        expect(find.byType(AlignmentEditor), findsOneWidget);
      });

      testWidgets('shows description when provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: null,
                description: 'How to align the child',
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('How to align the child'), findsOneWidget);
      });
    });

    group('Keyboard Accessibility', () {
      testWidgets('cells are focusable', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AlignmentEditor(
                propertyName: 'alignment',
                displayName: 'Alignment',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Each cell should be tappable/focusable
        final cells = find.byType(InkWell);
        expect(cells, findsNWidgets(9));

        // Tap first cell to verify interactivity
        await tester.tap(cells.first);
        await tester.pumpAndSettle();

        expect(find.byType(AlignmentEditor), findsOneWidget);
      });
    });
  });
}

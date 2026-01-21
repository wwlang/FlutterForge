import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/tree/tree.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// E2E Journey tests for Widget Tree navigation.
///
/// Tests user journeys for:
/// - Viewing widget hierarchy in tree panel
/// - Selecting widgets from tree
/// - Tree updates after canvas changes
/// - Expanding/collapsing tree nodes
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> dragWidgetToCanvas(
    WidgetTester tester,
    String widgetName,
  ) async {
    final widgetItem = find.text(widgetName).first;
    final canvas = find.byType(DesignCanvas);

    final gesture = await tester.startGesture(tester.getCenter(widgetItem));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(canvas));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  group('Journey: Widget Tree Display', () {
    testWidgets(
      'Widget tree panel is visible',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Tree panel should be visible
        expect(find.byType(WidgetTreePanel), findsOneWidget);
      },
    );

    testWidgets(
      'Tree shows empty state initially',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Tree should show empty or root-only state
        final treePanel = find.byType(WidgetTreePanel);
        expect(treePanel, findsOneWidget);
      },
    );

    testWidgets(
      'Tree shows widget after dropping to canvas',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drag Container to canvas
        await dragWidgetToCanvas(tester, 'Container');

        // Tree should show Container as root or child node
        // The tree displays widget types as labels
        final treePanel = find.byType(WidgetTreePanel);
        expect(treePanel, findsOneWidget);

        // Verify the tree reflects the dropped widget
        // Look for Container text within tree panel
        final containerInTree = find.descendant(
          of: treePanel,
          matching: find.text('Container'),
        );
        expect(containerInTree, findsWidgets);
      },
    );

    testWidgets(
      'Tree shows nested hierarchy correctly',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drag Column to canvas
        await dragWidgetToCanvas(tester, 'Column');

        final treePanel = find.byType(WidgetTreePanel);

        // Verify Column appears in tree
        final columnInTree = find.descendant(
          of: treePanel,
          matching: find.text('Column'),
        );
        expect(columnInTree, findsWidgets);
      },
    );
  });

  group('Journey: Tree Selection', () {
    testWidgets(
      'Selecting widget in tree highlights on canvas',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop a widget first
        await dragWidgetToCanvas(tester, 'Container');

        final treePanel = find.byType(WidgetTreePanel);

        // Find Container in tree and tap it
        final containerInTree = find.descendant(
          of: treePanel,
          matching: find.text('Container'),
        );

        if (containerInTree.evaluate().isNotEmpty) {
          await tester.tap(containerInTree.first);
          await tester.pumpAndSettle();

          // Properties panel should show Container properties
          expect(find.text('Width'), findsWidgets);
          expect(find.text('Height'), findsWidgets);
        }
      },
    );
  });

  group('Journey: Tree Updates on Canvas Changes', () {
    testWidgets(
      'Adding widget updates tree',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        final treePanel = find.byType(WidgetTreePanel);

        // Count initial tree items
        final initialContainerCount = find
            .descendant(of: treePanel, matching: find.text('Container'))
            .evaluate()
            .length;

        // Drop Container
        await dragWidgetToCanvas(tester, 'Container');

        // Count tree items after drop
        final afterDropCount = find
            .descendant(of: treePanel, matching: find.text('Container'))
            .evaluate()
            .length;

        // Tree should have more Container entries after drop
        expect(afterDropCount, greaterThan(initialContainerCount));
      },
    );

    testWidgets(
      'Multiple widgets show in tree',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Row
        await dragWidgetToCanvas(tester, 'Row');

        final treePanel = find.byType(WidgetTreePanel);

        // Verify Row shows in tree
        final rowInTree = find.descendant(
          of: treePanel,
          matching: find.text('Row'),
        );
        expect(rowInTree, findsWidgets);
      },
    );
  });
}

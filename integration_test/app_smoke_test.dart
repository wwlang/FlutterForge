import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/palette/palette.dart';
import 'package:flutter_forge/features/properties/properties.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// App smoke test - G5 validation gate requirement.
///
/// Verifies:
/// - App launches successfully
/// - Main workbench UI is visible
/// - All three panels are rendered
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Smoke Test (G5 Validation)', () {
    testWidgets('App launches and shows workbench with 3 panels', (
      WidgetTester tester,
    ) async {
      // Launch actual app
      await tester.pumpWidget(
        const ProviderScope(child: FlutterForgeApp()),
      );

      // Wait for app to settle (handles any splash/loading)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify past any splash screen - workbench visible
      expect(find.byType(Workbench), findsOneWidget);

      // Verify all 3 main panels are visible
      expect(find.byType(WidgetPalette), findsOneWidget);
      expect(find.byType(DesignCanvas), findsOneWidget);
      expect(find.byType(PropertiesPanel), findsOneWidget);
    });

    testWidgets('Widget palette shows categories', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: FlutterForgeApp()),
      );
      await tester.pumpAndSettle();

      // Verify at least one widget category is visible
      expect(find.text('Layout'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('Canvas shows empty state initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: FlutterForgeApp()),
      );
      await tester.pumpAndSettle();

      // Verify empty state message
      expect(find.text('Drop widgets here'), findsOneWidget);
    });
  });
}

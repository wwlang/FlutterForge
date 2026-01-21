import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/palette/palette.dart';
import 'package:flutter_forge/features/properties/properties.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_forge/app.dart';

void main() {
  testWidgets('FlutterForge app renders workbench with 3 panels',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FlutterForgeApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify 3-panel layout
    expect(find.byType(WidgetPalette), findsOneWidget);
    expect(find.byType(DesignCanvas), findsOneWidget);
    expect(find.byType(PropertiesPanel), findsOneWidget);
  });
}

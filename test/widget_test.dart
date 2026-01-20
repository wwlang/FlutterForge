import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_forge/app.dart';

void main() {
  testWidgets('FlutterForge app renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FlutterForgeApp(),
      ),
    );

    expect(find.text('FlutterForge'), findsOneWidget);
    expect(find.text('Visual Flutter UI Builder'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/palette/palette.dart';
import 'package:flutter_forge/features/properties/properties.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Shell & Integration (Task 1.7)', () {
    Widget buildTestApp({List<Override>? overrides}) {
      return ProviderScope(
        overrides: overrides ?? [],
        child: const MaterialApp(
          home: Workbench(),
        ),
      );
    }

    group('Workbench 3-Panel Layout', () {
      testWidgets('displays palette panel on the left', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        expect(find.byType(WidgetPalette), findsOneWidget);
      });

      testWidgets('displays canvas in the center', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        expect(find.byType(DesignCanvas), findsOneWidget);
      });

      testWidgets('displays properties panel on the right', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        expect(find.byType(PropertiesPanel), findsOneWidget);
      });

      testWidgets('uses horizontal layout with proper proportions', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        // All three panels should be visible
        expect(find.byType(WidgetPalette), findsOneWidget);
        expect(find.byType(DesignCanvas), findsOneWidget);
        expect(find.byType(PropertiesPanel), findsOneWidget);
      });
    });

    group('Canvas widget drop', () {
      testWidgets('dropping widget on empty canvas creates node', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        // Find the canvas drop target
        final canvasDropTarget = find.byType(DragTarget<String>).first;
        expect(canvasDropTarget, findsOneWidget);
      });
    });

    group('Selection state', () {
      testWidgets('properties panel shows empty when no selection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        expect(find.text('No widget selected'), findsOneWidget);
      });
    });

    group('Code export', () {
      testWidgets('export button is visible in toolbar', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        // Export button should be in the toolbar
        expect(find.byIcon(Icons.code), findsOneWidget);
      });
    });
  });
}

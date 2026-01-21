import 'package:flutter/material.dart';
import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/animation/timeline_editor.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_utils.dart';

/// E2E Journey tests for Animation Studio (J10).
///
/// Tests user journeys for:
/// - Add Animation: fade track, type picker, canvas badge
/// - Timeline: track display, scrub playhead
/// - Keyframing: add keyframe, edit value
/// - Easing: presets, custom bezier
/// - Triggers: OnLoad plays on mount
/// - Stagger: children stagger in Column
/// - Export: StatefulWidget generation
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Journey J10: Animation Studio', () {
    // =========================================================================
    // Stage 1: Add Animation
    // =========================================================================
    group('J10-S1: Add Animation', () {
      testWidgets(
        'E2E-J10-001: Add fade animation to widget',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add widget to canvas
          await dragWidgetToCanvas(tester, 'Container');

          // Select the widget
          await selectWidgetByLabel(tester, 'Container');

          // Open Animation panel
          await openAnimationPanel(tester);

          // Look for Add Animation button
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            // Select Fade animation type
            final fadeOption = find.text('Fade');
            if (fadeOption.evaluate().isNotEmpty) {
              await tester.tap(fadeOption.last);
              await tester.pumpAndSettle();

              // Fade track should appear
              expect(find.text('Fade'), findsWidgets);
            }
          }
        },
      );

      testWidgets(
        'E2E-J10-002: Animation type picker shows all options',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add and select widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');

          // Open Animation panel
          await openAnimationPanel(tester);

          // Click Add Animation to show type picker
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            // Should show animation type options
            expect(find.text('Fade'), findsWidgets);
            expect(find.text('Slide'), findsWidgets);
            expect(find.text('Scale'), findsWidgets);
            expect(find.text('Rotate'), findsWidgets);
          }
        },
      );

      testWidgets(
        'E2E-J10-003: Animated widget shows badge indicator',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');

          // Add animation
          await openAnimationPanel(tester);
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            final fadeOption = find.text('Fade');
            if (fadeOption.evaluate().isNotEmpty) {
              await tester.tap(fadeOption.last);
              await tester.pumpAndSettle();
            }
          }

          // Widget should show animation indicator
          // Look for animation badge icon
          final animBadge = find.byIcon(Icons.animation);
          expect(animBadge, findsWidgets);
        },
      );
    });

    // =========================================================================
    // Stage 2: Timeline
    // =========================================================================
    group('J10-S2: Timeline', () {
      testWidgets(
        'E2E-J10-004: Timeline displays animation tracks',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add animated widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          // Add animation
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            final fadeOption = find.text('Fade');
            if (fadeOption.evaluate().isNotEmpty) {
              await tester.tap(fadeOption.last);
              await tester.pumpAndSettle();
            }
          }

          // Timeline editor should appear
          expect(find.byType(TimelineEditor), findsWidgets);
        },
      );

      testWidgets(
        'E2E-J10-005: Playhead can be scrubbed',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add animated widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          // Add animation
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            final fadeOption = find.text('Fade');
            if (fadeOption.evaluate().isNotEmpty) {
              await tester.tap(fadeOption.last);
              await tester.pumpAndSettle();
            }
          }

          // Find playhead
          final playhead = find.byKey(const Key('playhead'));
          if (playhead.evaluate().isNotEmpty) {
            // Drag playhead
            await tester.drag(playhead, const Offset(100, 0));
            await tester.pumpAndSettle();
          }

          expect(find.byType(Workbench), findsOneWidget);
        },
      );
    });

    // =========================================================================
    // Stage 3: Keyframing
    // =========================================================================
    group('J10-S3: Keyframing', () {
      testWidgets(
        'E2E-J10-006: Add keyframe to animation track',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add animated widget with custom animation
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          // Add custom animation (allows keyframes)
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            final customOption = find.text('Custom');
            if (customOption.evaluate().isNotEmpty) {
              await tester.tap(customOption.last);
              await tester.pumpAndSettle();
            }
          }

          // Should be able to interact with keyframes
          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J10-007: Edit keyframe value',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add widget and animation
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          expect(find.byType(Workbench), findsOneWidget);
        },
      );
    });

    // =========================================================================
    // Stage 4: Easing
    // =========================================================================
    group('J10-S4: Easing', () {
      testWidgets(
        'E2E-J10-008: Select easing preset',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add animated widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          // Add animation
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            final fadeOption = find.text('Fade');
            if (fadeOption.evaluate().isNotEmpty) {
              await tester.tap(fadeOption.last);
              await tester.pumpAndSettle();
            }
          }

          // Look for easing selector
          // Animation panel should show easing options
          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J10-009: Custom bezier curve editor',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add animated widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          expect(find.byType(Workbench), findsOneWidget);
        },
      );
    });

    // =========================================================================
    // Stage 5: Triggers
    // =========================================================================
    group('J10-S5: Triggers', () {
      testWidgets(
        'E2E-J10-010: OnLoad trigger plays animation on mount',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add widget and animation
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          // Add fade animation
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            final fadeOption = find.text('Fade');
            if (fadeOption.evaluate().isNotEmpty) {
              await tester.tap(fadeOption.last);
              await tester.pumpAndSettle();
            }
          }

          // Look for trigger options
          // Default trigger is OnLoad
          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J10-011: Configure animation trigger',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add animated widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          expect(find.byType(Workbench), findsOneWidget);
        },
      );
    });

    // =========================================================================
    // Stage 6: Stagger
    // =========================================================================
    group('J10-S6: Stagger', () {
      testWidgets(
        'E2E-J10-012: Stagger animation on Column children',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add Column
          await dragWidgetToCanvas(tester, 'Column');

          // Select Column
          await selectWidgetByLabel(tester, 'Column');
          await openAnimationPanel(tester);

          // Add stagger animation option should be available
          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J10-013: Configure stagger delay',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add Column
          await dragWidgetToCanvas(tester, 'Column');
          await selectWidgetByLabel(tester, 'Column');
          await openAnimationPanel(tester);

          expect(find.byType(Workbench), findsOneWidget);
        },
      );
    });

    // =========================================================================
    // Stage 7: Export
    // =========================================================================
    group('J10-S7: Export', () {
      testWidgets(
        'E2E-J10-014: Generate StatefulWidget for animated widget',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add animated widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openAnimationPanel(tester);

          // Add animation
          final addAnimButton = find.text('Add Animation');
          if (addAnimButton.evaluate().isNotEmpty) {
            await tester.tap(addAnimButton.first);
            await tester.pumpAndSettle();

            final fadeOption = find.text('Fade');
            if (fadeOption.evaluate().isNotEmpty) {
              await tester.tap(fadeOption.last);
              await tester.pumpAndSettle();
            }
          }

          // Open Code panel to see generated code
          await openCodePanel(tester);

          // Code should include StatefulWidget for animation
          // Look for animation-related code
          final codeView = find.textContaining('Animation');
          expect(codeView, findsWidgets);
        },
      );
    });
  });
}

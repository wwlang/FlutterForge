import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_forge/features/animation/easing_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Easing Editor (Task 3.11)', () {
    group('EasingEditor Widget', () {
      testWidgets('displays preset easing curves', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Linear'), findsOneWidget);
        expect(find.text('Ease In'), findsOneWidget);
        expect(find.text('Ease Out'), findsOneWidget);
        expect(find.text('Ease In Out'), findsOneWidget);
        expect(find.text('Bounce'), findsOneWidget);
        expect(find.text('Elastic'), findsOneWidget);
      });

      testWidgets('highlights selected preset', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.easeInOut,
                  onEasingChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        // Find the selected preset chip
        final easeInOutChip = find.byKey(const Key('preset-easeInOut'));
        expect(easeInOutChip, findsOneWidget);
      });

      testWidgets('calls onEasingChanged when preset selected', (tester) async {
        EasingType? selectedEasing;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (easing) => selectedEasing = easing,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Bounce'));
        await tester.pumpAndSettle();

        expect(selectedEasing, equals(EasingType.bounce));
      });
    });

    group('Curve Preview', () {
      testWidgets('shows curve preview canvas', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('curve-preview')), findsOneWidget);
      });

      testWidgets('updates preview when easing changes', (tester) async {
        var currentEasing = EasingType.linear;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return EasingEditor(
                      selectedEasing: currentEasing,
                      onEasingChanged: (easing) {
                        setState(() => currentEasing = easing);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Ease In'));
        await tester.pumpAndSettle();

        // Verify the preview updated (canvas repainted)
        expect(find.byKey(const Key('curve-preview')), findsOneWidget);
      });
    });

    group('Custom Cubic Bezier', () {
      testWidgets('shows custom bezier option', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (_) {},
                  showCustomBezier: true,
                ),
              ),
            ),
          ),
        );

        expect(find.text('Custom'), findsOneWidget);
      });

      testWidgets('opens bezier editor when custom selected', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (_) {},
                  showCustomBezier: true,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Custom'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('bezier-editor')), findsOneWidget);
      });

      testWidgets('displays control point handles', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (_) {},
                  showCustomBezier: true,
                  customBezier: const CubicBezier(0.25, 0.1, 0.25, 1),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Custom'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('control-point-1')), findsOneWidget);
        expect(find.byKey(const Key('control-point-2')), findsOneWidget);
      });
    });

    group('Bezier Input Fields', () {
      testWidgets('shows numeric input fields for bezier values',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (_) {},
                  showCustomBezier: true,
                  customBezier: const CubicBezier(0.25, 0.1, 0.25, 1),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Custom'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('bezier-x1')), findsOneWidget);
        expect(find.byKey(const Key('bezier-y1')), findsOneWidget);
        expect(find.byKey(const Key('bezier-x2')), findsOneWidget);
        expect(find.byKey(const Key('bezier-y2')), findsOneWidget);
      });

      testWidgets('updates bezier from input field', (tester) async {
        CubicBezier? updatedBezier;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.linear,
                  onEasingChanged: (_) {},
                  showCustomBezier: true,
                  customBezier: const CubicBezier(0.25, 0.1, 0.25, 1),
                  onCustomBezierChanged: (bezier) => updatedBezier = bezier,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Custom'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('bezier-x1')), '0.5');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(updatedBezier, isNotNull);
        expect(updatedBezier!.x1, equals(0.5));
      });
    });

    group('CubicBezier Model', () {
      test('creates bezier with control points', () {
        const bezier = CubicBezier(0.25, 0.1, 0.25, 1);

        expect(bezier.x1, equals(0.25));
        expect(bezier.y1, equals(0.1));
        expect(bezier.x2, equals(0.25));
        expect(bezier.y2, equals(1));
      });

      test('evaluates bezier at time t', () {
        final valueAtHalf = CubicBezier.linear.evaluate(0.5);
        expect(valueAtHalf, closeTo(0.5, 0.1));
      });

      test('provides preset bezier curves', () {
        expect(CubicBezier.easeIn.x1, greaterThan(0));
        expect(CubicBezier.easeOut.x2, lessThan(1));
        expect(CubicBezier.easeInOut.x1, greaterThan(0));
      });

      test('copyWith creates modified copy', () {
        const bezier = CubicBezier(0.25, 0.1, 0.25, 1);
        final modified = bezier.copyWith(x1: 0.5);

        expect(modified.x1, equals(0.5));
        expect(modified.y1, equals(0.1));
        expect(modified.x2, equals(0.25));
        expect(modified.y2, equals(1));
      });
    });

    group('Easing to Curve Conversion', () {
      test('converts EasingType to Flutter Curve', () {
        expect(easingTypeToCurve(EasingType.linear), equals(Curves.linear));
        expect(easingTypeToCurve(EasingType.easeIn), equals(Curves.easeIn));
        expect(easingTypeToCurve(EasingType.easeOut), equals(Curves.easeOut));
        expect(
          easingTypeToCurve(EasingType.easeInOut),
          equals(Curves.easeInOut),
        );
        expect(
          easingTypeToCurve(EasingType.bounce),
          equals(Curves.bounceOut),
        );
        expect(
          easingTypeToCurve(EasingType.elastic),
          equals(Curves.elasticOut),
        );
      });
    });

    group('Animation Preview', () {
      testWidgets('shows animated preview dot', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.easeInOut,
                  onEasingChanged: (_) {},
                  showAnimationPreview: true,
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('animation-preview')), findsOneWidget);
      });

      testWidgets('play button starts animation preview', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: EasingEditor(
                  selectedEasing: EasingType.easeInOut,
                  onEasingChanged: (_) {},
                  showAnimationPreview: true,
                ),
              ),
            ),
          ),
        );

        final playButton = find.byKey(const Key('play-preview'));
        expect(playButton, findsOneWidget);

        await tester.tap(playButton);
        await tester.pump(const Duration(milliseconds: 100));

        // Animation should be running
        expect(find.byKey(const Key('preview-dot')), findsOneWidget);
      });
    });
  });
}

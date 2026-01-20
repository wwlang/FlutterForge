import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_forge/features/animation/keyframe_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Property Keyframing (Task 3.10)', () {
    group('KeyframeEditor Widget', () {
      testWidgets('displays keyframe list for animation', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                      Keyframe(
                        id: 'kf-2',
                        timeMs: 1000,
                        property: 'opacity',
                        value: 1.0,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('0ms'), findsOneWidget);
        expect(find.text('1000ms'), findsOneWidget);
      });

      testWidgets('shows add keyframe button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Add Keyframe'), findsOneWidget);
      });

      testWidgets('shows property editor when keyframe selected',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.5,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        // Tap on keyframe to select it
        await tester.tap(find.byKey(const Key('keyframe-item-kf-1')));
        await tester.pumpAndSettle();

        // Should show property editor
        expect(find.text('Time (ms)'), findsOneWidget);
        expect(find.text('Property'), findsOneWidget);
        expect(find.text('Value'), findsOneWidget);
      });
    });

    group('Add Keyframe', () {
      testWidgets('opens add keyframe dialog', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Keyframe'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('New Keyframe'), findsOneWidget);
      });

      testWidgets('adds keyframe with specified values', (tester) async {
        Keyframe? addedKeyframe;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                  ),
                  onKeyframeAdded: (kf) => addedKeyframe = kf,
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Add Keyframe'));
        await tester.pumpAndSettle();

        // Enter time
        await tester.enterText(
          find.byKey(const Key('keyframe-time-input')),
          '500',
        );
        // Enter property
        await tester.enterText(
          find.byKey(const Key('keyframe-property-input')),
          'opacity',
        );
        // Enter value
        await tester.enterText(
          find.byKey(const Key('keyframe-value-input')),
          '0.5',
        );

        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();

        expect(addedKeyframe, isNotNull);
        expect(addedKeyframe!.timeMs, equals(500));
        expect(addedKeyframe!.property, equals('opacity'));
        expect(addedKeyframe!.value, equals(0.5));
      });
    });

    group('Edit Keyframe', () {
      testWidgets('updates keyframe time', (tester) async {
        Keyframe? updatedKeyframe;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (kf) => updatedKeyframe = kf,
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        // Select keyframe
        await tester.tap(find.byKey(const Key('keyframe-item-kf-1')));
        await tester.pumpAndSettle();

        // Clear and enter new time
        final timeField = find.byKey(const Key('edit-time-input'));
        await tester.enterText(timeField, '200');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(updatedKeyframe, isNotNull);
        expect(updatedKeyframe!.timeMs, equals(200));
      });

      testWidgets('updates keyframe value', (tester) async {
        Keyframe? updatedKeyframe;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (kf) => updatedKeyframe = kf,
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        // Select keyframe
        await tester.tap(find.byKey(const Key('keyframe-item-kf-1')));
        await tester.pumpAndSettle();

        // Change value
        final valueField = find.byKey(const Key('edit-value-input'));
        await tester.enterText(valueField, '0.75');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(updatedKeyframe, isNotNull);
        expect(updatedKeyframe!.value, equals(0.75));
      });
    });

    group('Delete Keyframe', () {
      testWidgets('shows delete button for selected keyframe', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        // Select keyframe
        await tester.tap(find.byKey(const Key('keyframe-item-kf-1')));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('deletes keyframe when delete pressed', (tester) async {
        String? deletedId;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (id) => deletedId = id,
                ),
              ),
            ),
          ),
        );

        // Select keyframe
        await tester.tap(find.byKey(const Key('keyframe-item-kf-1')));
        await tester.pumpAndSettle();

        // Delete
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(deletedId, equals('kf-1'));
      });
    });

    group('Interpolation Preview', () {
      testWidgets('shows interpolated value at playhead position',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                      Keyframe(
                        id: 'kf-2',
                        timeMs: 1000,
                        property: 'opacity',
                        value: 1.0,
                      ),
                    ],
                  ),
                  playheadMs: 500,
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        // At 500ms between 0->1000ms, opacity should be 0.5
        expect(find.text('Current: 0.5'), findsOneWidget);
      });
    });

    group('Easing per Keyframe', () {
      testWidgets('shows easing dropdown for keyframe', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (_) {},
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        // Select keyframe
        await tester.tap(find.byKey(const Key('keyframe-item-kf-1')));
        await tester.pumpAndSettle();

        expect(find.text('Easing'), findsOneWidget);
      });

      testWidgets('updates keyframe easing', (tester) async {
        Keyframe? updatedKeyframe;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: KeyframeEditor(
                  animation: const WidgetAnimation(
                    id: 'anim-1',
                    widgetId: 'widget-1',
                    type: AnimationType.custom,
                    durationMs: 1000,
                    keyframes: [
                      Keyframe(
                        id: 'kf-1',
                        timeMs: 0,
                        property: 'opacity',
                        value: 0.0,
                      ),
                    ],
                  ),
                  onKeyframeAdded: (_) {},
                  onKeyframeUpdated: (kf) => updatedKeyframe = kf,
                  onKeyframeDeleted: (_) {},
                ),
              ),
            ),
          ),
        );

        // Select keyframe
        await tester.tap(find.byKey(const Key('keyframe-item-kf-1')));
        await tester.pumpAndSettle();

        // Open easing dropdown
        await tester.tap(find.byKey(const Key('easing-dropdown')));
        await tester.pumpAndSettle();

        // Select easeInOut
        await tester.tap(find.text('easeInOut').last);
        await tester.pumpAndSettle();

        expect(updatedKeyframe, isNotNull);
        expect(updatedKeyframe!.easing, equals(EasingType.easeInOut));
      });
    });

    group('Keyframe Interpolation Logic', () {
      test('interpolates linear between two keyframes', () {
        const keyframes = [
          Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
          Keyframe(id: 'kf-2', timeMs: 1000, property: 'opacity', value: 1.0),
        ];

        final value = interpolateKeyframes(keyframes, 'opacity', 500);
        expect(value, equals(0.5));
      });

      test('returns exact value at keyframe time', () {
        const keyframes = [
          Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
          Keyframe(id: 'kf-2', timeMs: 1000, property: 'opacity', value: 1.0),
        ];

        final valueAtStart = interpolateKeyframes(keyframes, 'opacity', 0);
        final valueAtEnd = interpolateKeyframes(keyframes, 'opacity', 1000);

        expect(valueAtStart, equals(0.0));
        expect(valueAtEnd, equals(1.0));
      });

      test('returns null for missing property', () {
        const keyframes = [
          Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
        ];

        final value = interpolateKeyframes(keyframes, 'scale', 500);
        expect(value, isNull);
      });

      test('clamps to first keyframe before start', () {
        const keyframes = [
          Keyframe(id: 'kf-1', timeMs: 100, property: 'opacity', value: 0.5),
          Keyframe(id: 'kf-2', timeMs: 1000, property: 'opacity', value: 1.0),
        ];

        final value = interpolateKeyframes(keyframes, 'opacity', 0);
        expect(value, equals(0.5));
      });

      test('clamps to last keyframe after end', () {
        const keyframes = [
          Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
          Keyframe(id: 'kf-2', timeMs: 500, property: 'opacity', value: 1.0),
        ];

        final value = interpolateKeyframes(keyframes, 'opacity', 1000);
        expect(value, equals(1.0));
      });
    });
  });
}

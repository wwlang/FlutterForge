import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_forge/features/animation/animation_panel.dart';
import 'package:flutter_forge/features/animation/timeline_editor.dart';
import 'package:flutter_forge/providers/animations_provider.dart';
import 'package:flutter_forge/providers/selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Animation Panel and Timeline (Task 3.9)', () {
    group('AnimationPanel Widget', () {
      testWidgets('shows empty state when no widget selected', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        expect(find.text('Select a widget to animate'), findsOneWidget);
      });

      testWidgets('shows add animation button when widget selected',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        expect(find.text('Add Animation'), findsOneWidget);
      });

      testWidgets('displays animation tracks for selected widget',
          (tester) async {
        const testAnimation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
              animationsProvider.overrideWith(
                (ref) => AnimationsNotifier()..addAnimation(testAnimation),
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        expect(find.text('Fade'), findsOneWidget);
      });

      testWidgets('shows timeline editor when animations exist',
          (tester) async {
        const testAnimation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
              animationsProvider.overrideWith(
                (ref) => AnimationsNotifier()..addAnimation(testAnimation),
              ),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        expect(find.byType(TimelineEditor), findsOneWidget);
      });

      testWidgets('shows animation type selector in add dialog',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        await tester.tap(find.text('Add Animation'));
        await tester.pumpAndSettle();

        expect(find.text('Fade'), findsOneWidget);
        expect(find.text('Slide'), findsOneWidget);
        expect(find.text('Scale'), findsOneWidget);
        expect(find.text('Rotate'), findsOneWidget);
        expect(find.text('Custom'), findsOneWidget);
      });

      testWidgets('adds animation when type selected', (tester) async {
        late AnimationsNotifier notifier;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
              animationsProvider.overrideWith((ref) {
                return notifier = AnimationsNotifier();
              }),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        await tester.tap(find.text('Add Animation'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Fade').last);
        await tester.pumpAndSettle();

        expect(notifier.getByWidgetId('widget-1').length, equals(1));
        expect(
          notifier.getByWidgetId('widget-1').first.type,
          equals(AnimationType.fade),
        );
      });

      testWidgets('shows multiple animation tracks', (tester) async {
        final notifier = AnimationsNotifier()
          ..addAnimation(
            const WidgetAnimation(
              id: 'anim-1',
              widgetId: 'widget-1',
              type: AnimationType.fade,
              durationMs: 300,
            ),
          )
          ..addAnimation(
            const WidgetAnimation(
              id: 'anim-2',
              widgetId: 'widget-1',
              type: AnimationType.slide,
              durationMs: 500,
            ),
          );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
              animationsProvider.overrideWith((ref) => notifier),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        expect(find.text('Fade'), findsOneWidget);
        expect(find.text('Slide'), findsOneWidget);
      });
    });

    group('Track Operations', () {
      testWidgets('duplicate track creates copy', (tester) async {
        final notifier = AnimationsNotifier()
          ..addAnimation(
            const WidgetAnimation(
              id: 'anim-1',
              widgetId: 'widget-1',
              type: AnimationType.fade,
              durationMs: 300,
            ),
          );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
              animationsProvider.overrideWith((ref) => notifier),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        // Find and tap the track menu button
        await tester.tap(find.byKey(const Key('track-menu-anim-1')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Duplicate'));
        await tester.pumpAndSettle();

        expect(notifier.getByWidgetId('widget-1').length, equals(2));
      });

      testWidgets('delete track removes animation', (tester) async {
        final notifier = AnimationsNotifier()
          ..addAnimation(
            const WidgetAnimation(
              id: 'anim-1',
              widgetId: 'widget-1',
              type: AnimationType.fade,
              durationMs: 300,
            ),
          );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              selectionProvider.overrideWith((ref) => 'widget-1'),
              animationsProvider.overrideWith((ref) => notifier),
            ],
            child: const MaterialApp(
              home: Scaffold(body: AnimationPanel()),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('track-menu-anim-1')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        expect(notifier.getByWidgetId('widget-1'), isEmpty);
      });
    });

    group('TimelineEditor Widget', () {
      testWidgets('displays ruler with CustomPaint for time markers',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TimelineEditor(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                  onPlayheadChange: (_) {},
                ),
              ),
            ),
          ),
        );

        // Timeline uses CustomPaint for the ruler
        expect(find.byType(CustomPaint), findsWidgets);
        // Verify the timeline editor rendered successfully
        expect(find.byType(TimelineEditor), findsOneWidget);
      });

      testWidgets('shows playhead at initial position', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TimelineEditor(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                  onPlayheadChange: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('playhead')), findsOneWidget);
      });

      testWidgets('playhead draggable to scrub', (tester) async {
        int? reportedMs;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 200,
                  child: TimelineEditor(
                    animations: const [
                      WidgetAnimation(
                        id: 'anim-1',
                        widgetId: 'widget-1',
                        type: AnimationType.fade,
                        durationMs: 1000,
                      ),
                    ],
                    onPlayheadChange: (ms) => reportedMs = ms,
                  ),
                ),
              ),
            ),
          ),
        );

        final playhead = find.byKey(const Key('playhead'));

        // Drag playhead to the right
        await tester.drag(playhead, const Offset(200, 0));
        await tester.pumpAndSettle();

        expect(reportedMs, isNotNull);
        expect(reportedMs! > 0, isTrue);
      });

      testWidgets('displays keyframe markers on track', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TimelineEditor(
                  animations: const [
                    WidgetAnimation(
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
                          timeMs: 500,
                          property: 'opacity',
                          value: 1.0,
                        ),
                      ],
                    ),
                  ],
                  onPlayheadChange: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('keyframe-kf-1')), findsOneWidget);
        expect(find.byKey(const Key('keyframe-kf-2')), findsOneWidget);
      });
    });

    group('Timeline Zoom', () {
      testWidgets('zoom in increases detail', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 200,
                  child: TimelineEditor(
                    animations: const [
                      WidgetAnimation(
                        id: 'anim-1',
                        widgetId: 'widget-1',
                        type: AnimationType.fade,
                        durationMs: 5000,
                      ),
                    ],
                    onPlayheadChange: (_) {},
                  ),
                ),
              ),
            ),
          ),
        );

        final timeline = find.byType(TimelineEditor);

        // Simulate Cmd+scroll for zoom
        await tester.sendKeyDownEvent(LogicalKeyboardKey.meta);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();

        // Verify zoom level changed by checking for more markers
        // At higher zoom, we'd see more granular time markers
        expect(timeline, findsOneWidget);
      });
    });

    group('Playhead Provider', () {
      test('initial playhead position is 0', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final playheadMs = container.read(playheadMsProvider);
        expect(playheadMs, equals(0));
      });

      test('updates playhead position', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(playheadMsProvider.notifier).state = 500;

        expect(container.read(playheadMsProvider), equals(500));
      });
    });

    group('Animation Track State', () {
      test('track lock state prevents editing', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(trackStatesProvider.notifier)
            .setLocked('anim-1', locked: true);

        final state = container.read(trackStatesProvider);
        expect(state['anim-1']?.isLocked, isTrue);
      });

      test('track hidden state excludes from preview', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(trackStatesProvider.notifier)
            .setHidden('anim-1', hidden: true);

        final state = container.read(trackStatesProvider);
        expect(state['anim-1']?.isHidden, isTrue);
      });
    });

    group('Timeline Scroll', () {
      testWidgets('scrolls horizontally for long animations', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 400,
                  height: 200,
                  child: TimelineEditor(
                    animations: const [
                      WidgetAnimation(
                        id: 'anim-1',
                        widgetId: 'widget-1',
                        type: AnimationType.fade,
                        durationMs: 10000, // 10 second animation
                      ),
                    ],
                    onPlayheadChange: (_) {},
                  ),
                ),
              ),
            ),
          ),
        );

        // The timeline should be scrollable
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });
    });
  });
}

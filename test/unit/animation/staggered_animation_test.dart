import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_forge/features/animation/staggered_animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Staggered Animation and Preview (Task 3.13)', () {
    group('StaggerConfig Model', () {
      test('creates config with delay and overlap', () {
        const config = StaggerConfig(
          delayMs: 100,
          overlap: 0.5,
        );

        expect(config.delayMs, equals(100));
        expect(config.overlap, equals(0.5));
      });

      test('calculates child delay correctly', () {
        const config = StaggerConfig(
          delayMs: 100,
          overlap: 0.0,
        );

        expect(config.getChildDelay(0), equals(0));
        expect(config.getChildDelay(1), equals(100));
        expect(config.getChildDelay(2), equals(200));
      });

      test('calculates child delay with overlap', () {
        const config = StaggerConfig(
          delayMs: 100,
          overlap: 0.5,
        );

        expect(config.getChildDelay(0), equals(0));
        expect(config.getChildDelay(1), equals(50));
        expect(config.getChildDelay(2), equals(100));
      });
    });

    group('StaggerConfigPanel Widget', () {
      testWidgets('shows delay input', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: StaggerConfigPanel(
                  config: const StaggerConfig(delayMs: 100),
                  onConfigChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Stagger Delay (ms)'), findsOneWidget);
      });

      testWidgets('shows overlap slider', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: StaggerConfigPanel(
                  config: const StaggerConfig(delayMs: 100),
                  onConfigChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Overlap'), findsOneWidget);
        expect(find.byType(Slider), findsOneWidget);
      });

      testWidgets('updates delay when changed', (tester) async {
        StaggerConfig? updatedConfig;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: StaggerConfigPanel(
                  config: const StaggerConfig(delayMs: 100),
                  onConfigChanged: (config) => updatedConfig = config,
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byKey(const Key('stagger-delay')), '200');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(updatedConfig, isNotNull);
        expect(updatedConfig!.delayMs, equals(200));
      });
    });

    group('AnimationPreview Widget', () {
      testWidgets('shows play button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AnimationPreview(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      });

      testWidgets('shows pause button when playing', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AnimationPreview(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.play_arrow));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byIcon(Icons.pause), findsOneWidget);
      });

      testWidgets('shows reset button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AnimationPreview(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.replay), findsOneWidget);
      });

      testWidgets('displays preview area', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: AnimationPreview(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.byKey(const Key('preview-area')), findsOneWidget);
      });
    });

    group('AnimationCodeExport', () {
      test('generates Flutter animation code for fade', () {
        const animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 1000,
        );

        final code = generateAnimationCode(animation);

        expect(code, contains('FadeTransition'));
        expect(code, contains('1000'));
      });

      test('generates Flutter animation code for slide', () {
        const animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.slide,
          durationMs: 500,
        );

        final code = generateAnimationCode(animation);

        expect(code, contains('SlideTransition'));
        expect(code, contains('500'));
      });

      test('generates Flutter animation code for scale', () {
        const animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.scale,
          durationMs: 300,
        );

        final code = generateAnimationCode(animation);

        expect(code, contains('ScaleTransition'));
        expect(code, contains('300'));
      });

      test('generates Flutter animation code for rotate', () {
        const animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.rotate,
          durationMs: 800,
        );

        final code = generateAnimationCode(animation);

        expect(code, contains('RotationTransition'));
        expect(code, contains('800'));
      });

      test('includes easing in generated code', () {
        const animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 1000,
          easing: EasingType.easeInOut,
        );

        final code = generateAnimationCode(animation);

        expect(code, contains('Curves.easeInOut'));
      });

      test('includes delay in generated code', () {
        const animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 1000,
          delayMs: 500,
        );

        final code = generateAnimationCode(animation);

        expect(code, contains('delay'));
        expect(code, contains('500'));
      });
    });

    group('CodeExportPanel Widget', () {
      testWidgets('shows export button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: CodeExportPanel(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Export Code'), findsOneWidget);
      });

      testWidgets('shows code preview when expanded', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: CodeExportPanel(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Export Code'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('code-preview')), findsOneWidget);
      });

      testWidgets('shows copy button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: CodeExportPanel(
                  animations: const [
                    WidgetAnimation(
                      id: 'anim-1',
                      widgetId: 'widget-1',
                      type: AnimationType.fade,
                      durationMs: 1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Export Code'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.copy), findsOneWidget);
      });
    });

    group('StaggeredAnimationOrchestrator', () {
      test('orchestrates multiple animations with stagger', () {
        final orchestrator = StaggeredAnimationOrchestrator(
          animations: const [
            WidgetAnimation(
              id: 'anim-1',
              widgetId: 'widget-1',
              type: AnimationType.fade,
              durationMs: 500,
            ),
            WidgetAnimation(
              id: 'anim-2',
              widgetId: 'widget-2',
              type: AnimationType.fade,
              durationMs: 500,
            ),
          ],
          staggerConfig: const StaggerConfig(delayMs: 100),
        );

        expect(orchestrator.getStartTime('anim-1'), equals(0));
        expect(orchestrator.getStartTime('anim-2'), equals(100));
      });

      test('calculates total duration with stagger', () {
        final orchestrator = StaggeredAnimationOrchestrator(
          animations: const [
            WidgetAnimation(
              id: 'anim-1',
              widgetId: 'widget-1',
              type: AnimationType.fade,
              durationMs: 500,
            ),
            WidgetAnimation(
              id: 'anim-2',
              widgetId: 'widget-2',
              type: AnimationType.fade,
              durationMs: 500,
            ),
          ],
          staggerConfig: const StaggerConfig(delayMs: 100),
        );

        // Second animation starts at 100ms and runs for 500ms
        expect(orchestrator.totalDurationMs, equals(600));
      });

      test('handles empty animations', () {
        final orchestrator = StaggeredAnimationOrchestrator(
          animations: const [],
          staggerConfig: const StaggerConfig(delayMs: 100),
        );

        expect(orchestrator.totalDurationMs, equals(0));
      });
    });
  });
}

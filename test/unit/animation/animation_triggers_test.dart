import 'package:flutter/material.dart';
import 'package:flutter_forge/features/animation/animation_triggers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Animation Triggers (Task 3.12)', () {
    group('TriggerType Enum', () {
      test('has all required trigger types', () {
        expect(TriggerType.values, contains(TriggerType.onLoad));
        expect(TriggerType.values, contains(TriggerType.onTap));
        expect(TriggerType.values, contains(TriggerType.onVisible));
        expect(TriggerType.values, contains(TriggerType.onScroll));
      });
    });

    group('AnimationTrigger Model', () {
      test('creates trigger with type and animation id', () {
        const trigger = AnimationTrigger(
          id: 'trigger-1',
          type: TriggerType.onTap,
          animationId: 'anim-1',
        );

        expect(trigger.id, equals('trigger-1'));
        expect(trigger.type, equals(TriggerType.onTap));
        expect(trigger.animationId, equals('anim-1'));
      });

      test('creates trigger with optional delay', () {
        const trigger = AnimationTrigger(
          id: 'trigger-1',
          type: TriggerType.onLoad,
          animationId: 'anim-1',
          delayMs: 500,
        );

        expect(trigger.delayMs, equals(500));
      });

      test('creates scroll trigger with threshold', () {
        const trigger = AnimationTrigger(
          id: 'trigger-1',
          type: TriggerType.onScroll,
          animationId: 'anim-1',
          scrollThreshold: 0.5,
        );

        expect(trigger.scrollThreshold, equals(0.5));
      });
    });

    group('TriggerSelector Widget', () {
      testWidgets('displays all trigger types', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TriggerSelector(
                  selectedTrigger: TriggerType.onLoad,
                  onTriggerChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('On Load'), findsOneWidget);
        expect(find.text('On Tap'), findsOneWidget);
        expect(find.text('On Visible'), findsOneWidget);
        expect(find.text('On Scroll'), findsOneWidget);
      });

      testWidgets('highlights selected trigger', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TriggerSelector(
                  selectedTrigger: TriggerType.onTap,
                  onTriggerChanged: (_) {},
                ),
              ),
            ),
          ),
        );

        final onTapChip = find.byKey(const Key('trigger-onTap'));
        expect(onTapChip, findsOneWidget);
      });

      testWidgets('calls onTriggerChanged when trigger selected',
          (tester) async {
        TriggerType? selectedTrigger;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TriggerSelector(
                  selectedTrigger: TriggerType.onLoad,
                  onTriggerChanged: (trigger) => selectedTrigger = trigger,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('On Tap'));
        await tester.pumpAndSettle();

        expect(selectedTrigger, equals(TriggerType.onTap));
      });
    });

    group('TriggerConfigPanel Widget', () {
      testWidgets('shows delay input for all triggers', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TriggerConfigPanel(
                  trigger: const AnimationTrigger(
                    id: 'trigger-1',
                    type: TriggerType.onLoad,
                    animationId: 'anim-1',
                  ),
                  onTriggerUpdated: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Delay (ms)'), findsOneWidget);
      });

      testWidgets('shows scroll threshold for scroll trigger', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TriggerConfigPanel(
                  trigger: const AnimationTrigger(
                    id: 'trigger-1',
                    type: TriggerType.onScroll,
                    animationId: 'anim-1',
                  ),
                  onTriggerUpdated: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Scroll Threshold'), findsOneWidget);
      });

      testWidgets('hides scroll threshold for non-scroll triggers',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TriggerConfigPanel(
                  trigger: const AnimationTrigger(
                    id: 'trigger-1',
                    type: TriggerType.onTap,
                    animationId: 'anim-1',
                  ),
                  onTriggerUpdated: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Scroll Threshold'), findsNothing);
      });

      testWidgets('updates delay when entered', (tester) async {
        AnimationTrigger? updatedTrigger;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: TriggerConfigPanel(
                  trigger: const AnimationTrigger(
                    id: 'trigger-1',
                    type: TriggerType.onLoad,
                    animationId: 'anim-1',
                  ),
                  onTriggerUpdated: (trigger) => updatedTrigger = trigger,
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byKey(const Key('delay-input')), '300');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(updatedTrigger, isNotNull);
        expect(updatedTrigger!.delayMs, equals(300));
      });
    });

    group('TriggersProvider', () {
      test('adds trigger', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(triggersProvider.notifier).addTrigger(
              const AnimationTrigger(
                id: 'trigger-1',
                type: TriggerType.onTap,
                animationId: 'anim-1',
              ),
            );

        final triggers = container.read(triggersProvider);
        expect(triggers.length, equals(1));
        expect(triggers.first.type, equals(TriggerType.onTap));
      });

      test('removes trigger', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(triggersProvider.notifier)
          ..addTrigger(
            const AnimationTrigger(
              id: 'trigger-1',
              type: TriggerType.onTap,
              animationId: 'anim-1',
            ),
          )
          ..removeTrigger('trigger-1');

        expect(container.read(triggersProvider), isEmpty);
      });

      test('updates trigger', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(triggersProvider.notifier)
          ..addTrigger(
            const AnimationTrigger(
              id: 'trigger-1',
              type: TriggerType.onTap,
              animationId: 'anim-1',
            ),
          )
          ..updateTrigger(
            const AnimationTrigger(
              id: 'trigger-1',
              type: TriggerType.onLoad,
              animationId: 'anim-1',
              delayMs: 200,
            ),
          );

        final triggers = container.read(triggersProvider);
        expect(triggers.first.type, equals(TriggerType.onLoad));
        expect(triggers.first.delayMs, equals(200));
      });

      test('gets triggers by animation id', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(triggersProvider.notifier)
          ..addTrigger(
            const AnimationTrigger(
              id: 'trigger-1',
              type: TriggerType.onTap,
              animationId: 'anim-1',
            ),
          )
          ..addTrigger(
            const AnimationTrigger(
              id: 'trigger-2',
              type: TriggerType.onLoad,
              animationId: 'anim-2',
            ),
          );

        final triggers = container
            .read(triggersProvider.notifier)
            .getByAnimationId('anim-1');
        expect(triggers.length, equals(1));
        expect(triggers.first.id, equals('trigger-1'));
      });
    });

    group('Trigger Display Names', () {
      test('provides human readable names', () {
        expect(triggerDisplayName(TriggerType.onLoad), equals('On Load'));
        expect(triggerDisplayName(TriggerType.onTap), equals('On Tap'));
        expect(triggerDisplayName(TriggerType.onVisible), equals('On Visible'));
        expect(triggerDisplayName(TriggerType.onScroll), equals('On Scroll'));
      });
    });

    group('Trigger Icons', () {
      test('provides icons for each trigger type', () {
        expect(triggerIcon(TriggerType.onLoad), equals(Icons.play_arrow));
        expect(triggerIcon(TriggerType.onTap), equals(Icons.touch_app));
        expect(triggerIcon(TriggerType.onVisible), equals(Icons.visibility));
        expect(triggerIcon(TriggerType.onScroll), equals(Icons.swap_vert));
      });
    });
  });
}

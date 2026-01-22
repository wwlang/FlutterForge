import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/features/onboarding/tutorial_overlay.dart';
import 'package:flutter_forge/features/onboarding/tutorial_state.dart';
import 'package:flutter_forge/features/onboarding/tutorial_steps.dart';

/// Tests for Interactive Tutorial (Task 8.5)
///
/// Journey: J18 S2 - Interactive Tutorial
void main() {
  group('Interactive Tutorial (Task 8.5)', () {
    group('TutorialStep', () {
      test('has required properties', () {
        const step = TutorialStep(
          id: 'drag-container',
          title: 'Drag a Container',
          description: 'Drag a Container widget from the palette to the canvas',
          targetKey: Key('widget-palette-container'),
          action: TutorialAction.drag,
        );

        expect(step.id, equals('drag-container'));
        expect(step.title, equals('Drag a Container'));
        expect(step.action, equals(TutorialAction.drag));
      });

      test('all required tutorial steps exist', () {
        final steps = TutorialSteps.allSteps;
        final ids = steps.map((s) => s.id).toList();

        // Per J18 S2 acceptance criteria
        expect(ids, contains('drag-container'));
        expect(ids, contains('select-widget'));
        expect(ids, contains('change-property'));
        expect(ids, contains('add-child'));
        expect(ids, contains('edit-text'));
        expect(ids, contains('export-code'));
        expect(ids, contains('save-project'));
      });

      test('steps are in correct order', () {
        final steps = TutorialSteps.allSteps;
        expect(steps[0].id, equals('drag-container'));
        expect(steps[1].id, equals('select-widget'));
        expect(steps[2].id, equals('change-property'));
        expect(steps.last.id, equals('save-project'));
      });
    });

    group('TutorialState', () {
      test('initial state is not active', () {
        const state = TutorialState();
        expect(state.isActive, isFalse);
        expect(state.currentStepIndex, equals(0));
        expect(state.completedSteps, isEmpty);
      });

      test('start activates tutorial at first step', () {
        const state = TutorialState();
        final started = state.start();
        expect(started.isActive, isTrue);
        expect(started.currentStepIndex, equals(0));
      });

      test('completeCurrentStep advances to next step', () {
        const state = TutorialState(isActive: true, currentStepIndex: 0);
        final completed = state.completeCurrentStep();
        expect(completed.currentStepIndex, equals(1));
        expect(completed.completedSteps, contains(0));
      });

      test('skipCurrentStep advances without completing', () {
        const state = TutorialState(isActive: true, currentStepIndex: 0);
        final skipped = state.skipCurrentStep();
        expect(skipped.currentStepIndex, equals(1));
        expect(skipped.skippedSteps, contains(0));
        expect(skipped.completedSteps, isEmpty);
      });

      test('exit deactivates tutorial', () {
        const state = TutorialState(isActive: true, currentStepIndex: 3);
        final exited = state.exit();
        expect(exited.isActive, isFalse);
        expect(exited.currentStepIndex, equals(3)); // Preserves progress
      });

      test('resume continues from saved step', () {
        const state = TutorialState(
          isActive: false,
          currentStepIndex: 3,
          completedSteps: {0, 1, 2},
        );
        final resumed = state.start();
        expect(resumed.isActive, isTrue);
        expect(resumed.currentStepIndex, equals(3));
      });

      test('reset clears all progress', () {
        const state = TutorialState(
          isActive: true,
          currentStepIndex: 5,
          completedSteps: {0, 1, 2, 3, 4},
        );
        final reset = state.reset();
        expect(reset.isActive, isFalse);
        expect(reset.currentStepIndex, equals(0));
        expect(reset.completedSteps, isEmpty);
      });

      test('currentStep returns correct TutorialStep', () {
        const state = TutorialState(isActive: true, currentStepIndex: 2);
        final step = state.currentStep;
        expect(step, isNotNull);
        expect(step!.id, equals(TutorialSteps.allSteps[2].id));
      });

      test('isComplete returns true when all steps done', () {
        final state = TutorialState(
          isActive: true,
          currentStepIndex: TutorialSteps.allSteps.length,
          completedSteps:
              Set.from(List.generate(TutorialSteps.allSteps.length, (i) => i)),
        );
        expect(state.isComplete, isTrue);
      });

      test('progress returns correct ratio', () {
        const state = TutorialState(
          isActive: true,
          currentStepIndex: 3,
          completedSteps: {0, 1, 2},
        );
        final totalSteps = TutorialSteps.allSteps.length;
        expect(state.progress, equals(3 / totalSteps));
      });
    });

    group('TutorialOverlay widget', () {
      testWidgets('displays current step info', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    const Scaffold(body: Center(child: Text('App Content'))),
                    TutorialOverlay(
                      step: TutorialSteps.allSteps.first,
                      stepIndex: 0,
                      totalSteps: 7,
                      onComplete: () {},
                      onSkip: () {},
                      onExit: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Drag a Container'), findsOneWidget);
        expect(find.text('1 of 7'), findsOneWidget);
      });

      testWidgets('displays Skip button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    const Scaffold(body: Center(child: Text('App Content'))),
                    TutorialOverlay(
                      step: TutorialSteps.allSteps.first,
                      stepIndex: 0,
                      totalSteps: 7,
                      onComplete: () {},
                      onSkip: () {},
                      onExit: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Skip this step'), findsOneWidget);
      });

      testWidgets('displays Exit button', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    const Scaffold(body: Center(child: Text('App Content'))),
                    TutorialOverlay(
                      step: TutorialSteps.allSteps.first,
                      stepIndex: 0,
                      totalSteps: 7,
                      onComplete: () {},
                      onSkip: () {},
                      onExit: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('Exit Tutorial'), findsOneWidget);
      });

      testWidgets('Skip button triggers onSkip callback', (tester) async {
        var skipCalled = false;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    const Scaffold(body: Center(child: Text('App Content'))),
                    TutorialOverlay(
                      step: TutorialSteps.allSteps.first,
                      stepIndex: 0,
                      totalSteps: 7,
                      onComplete: () {},
                      onSkip: () => skipCalled = true,
                      onExit: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Skip this step'));
        await tester.pumpAndSettle();

        expect(skipCalled, isTrue);
      });

      testWidgets('Exit button shows confirmation dialog', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    const Scaffold(body: Center(child: Text('App Content'))),
                    TutorialOverlay(
                      step: TutorialSteps.allSteps.first,
                      stepIndex: 0,
                      totalSteps: 7,
                      onComplete: () {},
                      onSkip: () {},
                      onExit: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Exit Tutorial'));
        await tester.pumpAndSettle();

        expect(find.text('Exit tutorial?'), findsOneWidget);
        expect(find.text('Your progress will be saved.'), findsOneWidget);
      });

      testWidgets('progress indicator updates with step', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    const Scaffold(body: Center(child: Text('App Content'))),
                    TutorialOverlay(
                      step: TutorialSteps.allSteps[3],
                      stepIndex: 3,
                      totalSteps: 7,
                      onComplete: () {},
                      onSkip: () {},
                      onExit: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(find.text('4 of 7'), findsOneWidget);
      });
    });

    group('Tutorial completion (J18 S2)', () {
      testWidgets('completion screen shows on finish', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 900,
                child: TutorialCompletionScreen(
                  onContinue: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Congratulations!'), findsOneWidget);
        expect(find.text("You've completed the FlutterForge tutorial"),
            findsOneWidget);
      });

      testWidgets('completion screen has next steps', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: SizedBox(
                width: 800,
                height: 900,
                child: TutorialCompletionScreen(
                  onContinue: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Explore templates'), findsOneWidget);
        expect(find.text('Read documentation'), findsOneWidget);
      });
    });
  });
}

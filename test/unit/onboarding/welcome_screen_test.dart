import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/features/onboarding/welcome_screen.dart';
import 'package:flutter_forge/features/onboarding/onboarding_state.dart';

/// Tests for Welcome Screen (Task 8.4)
///
/// Journey: J18 S1 - First-Run Welcome Screen
void main() {
  group('Welcome Screen (Task 8.4)', () {
    Widget createTestWidget({
      VoidCallback? onClose,
      VoidCallback? onStartTutorial,
      VoidCallback? onCreateProject,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: SizedBox(
            width: 800,
            height: 800,
            child: WelcomeScreen(
              onClose: onClose,
              onStartTutorial: onStartTutorial,
              onCreateProject: onCreateProject,
            ),
          ),
        ),
      );
    }

    group('WelcomeScreen widget', () {
      testWidgets('displays logo and headline', (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Check for FlutterForge branding
        expect(find.text('FlutterForge'), findsOneWidget);
        expect(find.text('Design Flutter UIs visually'), findsOneWidget);
      });

      testWidgets('displays action buttons', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text('Start Tutorial'), findsOneWidget);
        expect(find.text('Create Project'), findsOneWidget);
        expect(find.text('Skip'), findsOneWidget);
      });

      testWidgets('Skip button closes welcome screen', (tester) async {
        var wasClosed = false;

        await tester.pumpWidget(createTestWidget(
          onClose: () => wasClosed = true,
        ));

        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();

        expect(wasClosed, isTrue);
      });

      testWidgets('Start Tutorial triggers tutorial callback', (tester) async {
        var tutorialStarted = false;

        await tester.pumpWidget(createTestWidget(
          onStartTutorial: () => tutorialStarted = true,
        ));

        await tester.tap(find.text('Start Tutorial'));
        await tester.pumpAndSettle();

        expect(tutorialStarted, isTrue);
      });

      testWidgets('Create Project triggers create callback', (tester) async {
        var projectCreated = false;

        await tester.pumpWidget(createTestWidget(
          onCreateProject: () => projectCreated = true,
        ));

        await tester.tap(find.text('Create Project'));
        await tester.pumpAndSettle();

        expect(projectCreated, isTrue);
      });

      testWidgets('displays "Don\'t show again" checkbox', (tester) async {
        await tester.pumpWidget(createTestWidget());

        expect(find.text("Don't show again"), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('Escape key closes welcome screen', (tester) async {
        var wasClosed = false;

        await tester.pumpWidget(createTestWidget(
          onClose: () => wasClosed = true,
        ));

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(wasClosed, isTrue);
      });
    });

    group('OnboardingState', () {
      test('initial state has showWelcome true for first run', () {
        const state = OnboardingState();
        expect(state.showWelcomeOnStartup, isTrue);
        expect(state.hasCompletedTutorial, isFalse);
        expect(state.isFirstRun, isTrue);
      });

      test('copyWith updates showWelcomeOnStartup', () {
        const state = OnboardingState();
        final updated = state.copyWith(showWelcomeOnStartup: false);
        expect(updated.showWelcomeOnStartup, isFalse);
        expect(updated.isFirstRun, isTrue); // unchanged
      });

      test('copyWith updates hasCompletedTutorial', () {
        const state = OnboardingState();
        final updated = state.copyWith(hasCompletedTutorial: true);
        expect(updated.hasCompletedTutorial, isTrue);
      });

      test('markFirstRunComplete sets isFirstRun to false', () {
        const state = OnboardingState();
        final updated = state.copyWith(isFirstRun: false);
        expect(updated.isFirstRun, isFalse);
      });
    });

    group('First-run detection (J18 S1)', () {
      test('shouldShowWelcome returns true on first run', () {
        const state = OnboardingState(
          isFirstRun: true,
          showWelcomeOnStartup: true,
        );
        expect(state.shouldShowWelcome, isTrue);
      });

      test('shouldShowWelcome returns false after dismissal', () {
        const state = OnboardingState(
          isFirstRun: false,
          showWelcomeOnStartup: false,
        );
        expect(state.shouldShowWelcome, isFalse);
      });

      test('shouldShowWelcome returns true if re-enabled in preferences', () {
        const state = OnboardingState(
          isFirstRun: false,
          showWelcomeOnStartup: true,
        );
        expect(state.shouldShowWelcome, isTrue);
      });
    });
  });
}

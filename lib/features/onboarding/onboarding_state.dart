import 'package:flutter/foundation.dart';

/// State for managing onboarding and welcome screen visibility.
///
/// Tracks first-run detection and user preferences for showing
/// the welcome screen on startup.
@immutable
class OnboardingState {
  const OnboardingState({
    this.isFirstRun = true,
    this.showWelcomeOnStartup = true,
    this.hasCompletedTutorial = false,
  });

  /// Whether this is the user's first time running the app.
  final bool isFirstRun;

  /// Whether to show the welcome screen on startup.
  /// Can be toggled in preferences.
  final bool showWelcomeOnStartup;

  /// Whether the user has completed the interactive tutorial.
  final bool hasCompletedTutorial;

  /// Whether the welcome screen should be shown.
  ///
  /// Returns true if either:
  /// - It's the first run, or
  /// - The user has enabled showing welcome on startup
  bool get shouldShowWelcome => isFirstRun || showWelcomeOnStartup;

  /// Creates a copy with updated values.
  OnboardingState copyWith({
    bool? isFirstRun,
    bool? showWelcomeOnStartup,
    bool? hasCompletedTutorial,
  }) {
    return OnboardingState(
      isFirstRun: isFirstRun ?? this.isFirstRun,
      showWelcomeOnStartup: showWelcomeOnStartup ?? this.showWelcomeOnStartup,
      hasCompletedTutorial: hasCompletedTutorial ?? this.hasCompletedTutorial,
    );
  }

  /// Serializes to JSON for persistence.
  Map<String, dynamic> toJson() => {
        'isFirstRun': isFirstRun,
        'showWelcomeOnStartup': showWelcomeOnStartup,
        'hasCompletedTutorial': hasCompletedTutorial,
      };

  /// Deserializes from JSON.
  factory OnboardingState.fromJson(Map<String, dynamic> json) {
    return OnboardingState(
      isFirstRun: json['isFirstRun'] as bool? ?? true,
      showWelcomeOnStartup: json['showWelcomeOnStartup'] as bool? ?? true,
      hasCompletedTutorial: json['hasCompletedTutorial'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingState &&
          runtimeType == other.runtimeType &&
          isFirstRun == other.isFirstRun &&
          showWelcomeOnStartup == other.showWelcomeOnStartup &&
          hasCompletedTutorial == other.hasCompletedTutorial;

  @override
  int get hashCode =>
      isFirstRun.hashCode ^
      showWelcomeOnStartup.hashCode ^
      hasCompletedTutorial.hashCode;
}

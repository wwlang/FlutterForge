import 'package:flutter/foundation.dart';
import 'package:flutter_forge/features/onboarding/tutorial_steps.dart';

/// State for managing the interactive tutorial.
///
/// Tracks which step the user is on, which steps have been
/// completed or skipped, and whether the tutorial is active.
@immutable
class TutorialState {
  const TutorialState({
    this.isActive = false,
    this.currentStepIndex = 0,
    this.completedSteps = const {},
    this.skippedSteps = const {},
  });

  /// Deserializes from JSON.
  factory TutorialState.fromJson(Map<String, dynamic> json) {
    return TutorialState(
      isActive: json['isActive'] as bool? ?? false,
      currentStepIndex: json['currentStepIndex'] as int? ?? 0,
      completedSteps:
          (json['completedSteps'] as List<dynamic>?)?.cast<int>().toSet() ??
              const {},
      skippedSteps:
          (json['skippedSteps'] as List<dynamic>?)?.cast<int>().toSet() ??
              const {},
    );
  }

  /// Whether the tutorial is currently active.
  final bool isActive;

  /// Index of the current step in [TutorialSteps.allSteps].
  final int currentStepIndex;

  /// Set of step indices that have been completed.
  final Set<int> completedSteps;

  /// Set of step indices that have been skipped.
  final Set<int> skippedSteps;

  /// The current tutorial step, or null if past the end.
  TutorialStep? get currentStep {
    if (currentStepIndex >= TutorialSteps.allSteps.length) {
      return null;
    }
    return TutorialSteps.allSteps[currentStepIndex];
  }

  /// Whether all steps have been completed.
  bool get isComplete => currentStepIndex >= TutorialSteps.allSteps.length;

  /// Progress ratio from 0.0 to 1.0.
  double get progress {
    final total = TutorialSteps.allSteps.length;
    if (total == 0) return 1;
    return completedSteps.length / total;
  }

  /// Total number of steps.
  int get totalSteps => TutorialSteps.allSteps.length;

  /// Starts or resumes the tutorial.
  TutorialState start() {
    return TutorialState(
      isActive: true,
      currentStepIndex: currentStepIndex,
      completedSteps: completedSteps,
      skippedSteps: skippedSteps,
    );
  }

  /// Completes the current step and advances to the next.
  TutorialState completeCurrentStep() {
    return TutorialState(
      isActive: isActive,
      currentStepIndex: currentStepIndex + 1,
      completedSteps: {...completedSteps, currentStepIndex},
      skippedSteps: skippedSteps,
    );
  }

  /// Skips the current step and advances to the next.
  TutorialState skipCurrentStep() {
    return TutorialState(
      isActive: isActive,
      currentStepIndex: currentStepIndex + 1,
      completedSteps: completedSteps,
      skippedSteps: {...skippedSteps, currentStepIndex},
    );
  }

  /// Exits the tutorial, preserving progress.
  TutorialState exit() {
    return TutorialState(
      currentStepIndex: currentStepIndex,
      completedSteps: completedSteps,
      skippedSteps: skippedSteps,
    );
  }

  /// Resets the tutorial to the beginning.
  TutorialState reset() {
    return const TutorialState();
  }

  /// Creates a copy with updated values.
  TutorialState copyWith({
    bool? isActive,
    int? currentStepIndex,
    Set<int>? completedSteps,
    Set<int>? skippedSteps,
  }) {
    return TutorialState(
      isActive: isActive ?? this.isActive,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      completedSteps: completedSteps ?? this.completedSteps,
      skippedSteps: skippedSteps ?? this.skippedSteps,
    );
  }

  /// Serializes to JSON for persistence.
  Map<String, dynamic> toJson() => {
        'isActive': isActive,
        'currentStepIndex': currentStepIndex,
        'completedSteps': completedSteps.toList(),
        'skippedSteps': skippedSteps.toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TutorialState &&
          runtimeType == other.runtimeType &&
          isActive == other.isActive &&
          currentStepIndex == other.currentStepIndex &&
          setEquals(completedSteps, other.completedSteps) &&
          setEquals(skippedSteps, other.skippedSteps);

  @override
  int get hashCode =>
      isActive.hashCode ^
      currentStepIndex.hashCode ^
      completedSteps.hashCode ^
      skippedSteps.hashCode;
}

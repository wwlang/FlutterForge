import 'package:flutter/material.dart';
import 'package:flutter_forge/features/onboarding/tutorial_steps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Overlay widget that displays tutorial step information.
///
/// Shows the current step title, description, progress indicator,
/// and action buttons for skipping or exiting.
///
/// Journey: J18 S2 - Interactive Tutorial
class TutorialOverlay extends ConsumerWidget {
  const TutorialOverlay({
    required this.step,
    required this.stepIndex,
    required this.totalSteps,
    required this.onComplete,
    required this.onSkip,
    required this.onExit,
    super.key,
  });

  /// The current tutorial step.
  final TutorialStep step;

  /// Current step index (0-based).
  final int stepIndex;

  /// Total number of steps.
  final int totalSteps;

  /// Called when the step is completed.
  final VoidCallback onComplete;

  /// Called when the user skips this step.
  final VoidCallback onSkip;

  /// Called when the user exits the tutorial.
  final VoidCallback onExit;

  Future<void> _showExitConfirmation(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => const TutorialExitDialog(),
    );

    if (shouldExit ?? false) {
      onExit();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // Dimmed background
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // Absorb taps
            ),
          ),

          // Tutorial panel at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (stepIndex + 1) / totalSteps,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation(
                              colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${stepIndex + 1} of $totalSteps',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Step title
                    Text(
                      step.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Step description
                    Text(
                      step.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    // Hint if available
                    if (step.hint != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: colorScheme.tertiary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              step.hint!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.tertiary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => _showExitConfirmation(context),
                          child: const Text('Exit Tutorial'),
                        ),
                        TextButton(
                          onPressed: onSkip,
                          child: const Text('Skip this step'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confirmation dialog for exiting the tutorial.
class TutorialExitDialog extends StatelessWidget {
  const TutorialExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit tutorial?'),
      content: const Text('Your progress will be saved.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Continue'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Exit'),
        ),
      ],
    );
  }
}

/// Screen shown when the tutorial is completed.
///
/// Congratulates the user and suggests next steps.
class TutorialCompletionScreen extends StatelessWidget {
  const TutorialCompletionScreen({
    required this.onContinue,
    super.key,
  });

  /// Called when the user dismisses the completion screen.
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.celebration,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Congratulations
                Text(
                  'Congratulations!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "You've completed the FlutterForge tutorial",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // What you learned
                Text(
                  "You've learned how to:",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                ...[
                  'Add widgets to the canvas',
                  'Customize widget properties',
                  'Build nested widget trees',
                  'Export production-ready code',
                  'Save your projects',
                ].map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Next steps
                Text(
                  'Next steps:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.dashboard),
                      label: const Text('Explore templates'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Read documentation'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                FilledButton(
                  onPressed: onContinue,
                  child: const Text('Start Building'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

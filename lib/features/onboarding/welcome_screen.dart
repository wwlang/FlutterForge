import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Welcome screen shown on first launch of FlutterForge.
///
/// Displays app branding and offers quick actions:
/// - Start Tutorial
/// - Create Project
/// - Skip (close)
///
/// Journey: J18 S1 - First-Run Welcome Screen
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({
    super.key,
    this.onClose,
    this.onStartTutorial,
    this.onCreateProject,
  });

  /// Called when the user closes the welcome screen.
  final VoidCallback? onClose;

  /// Called when the user starts the tutorial.
  final VoidCallback? onStartTutorial;

  /// Called when the user creates a new project.
  final VoidCallback? onCreateProject;

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _dontShowAgain = false;

  void _handleClose() {
    widget.onClose?.call();
  }

  void _handleStartTutorial() {
    widget.onStartTutorial?.call();
  }

  void _handleCreateProject() {
    widget.onCreateProject?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          _handleClose();
        }
      },
      child: Material(
        color: colorScheme.surface.withValues(alpha: 0.95),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.auto_fix_high,
                      size: 48,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'FlutterForge',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Design Flutter UIs visually',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Create beautiful Flutter interfaces with drag-and-drop, '
                    'then export clean, production-ready code.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: _handleStartTutorial,
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Start Tutorial'),
                      ),
                      FilledButton.tonal(
                        onPressed: _handleCreateProject,
                        child: const Text('Create Project'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Skip button
                  TextButton(
                    onPressed: _handleClose,
                    child: const Text('Skip'),
                  ),
                  const SizedBox(height: 24),

                  // Don't show again checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _dontShowAgain,
                        onChanged: (value) {
                          setState(() {
                            _dontShowAgain = value ?? false;
                          });
                        },
                      ),
                      const Text("Don't show again"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

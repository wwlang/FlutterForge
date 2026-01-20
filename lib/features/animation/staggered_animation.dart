import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Configuration for staggered animations.
class StaggerConfig {
  const StaggerConfig({
    this.delayMs = 100,
    this.overlap = 0.0,
  });

  final int delayMs;
  final double overlap;

  /// Calculate delay for a child at given index.
  int getChildDelay(int index) {
    final effectiveDelay = delayMs * (1 - overlap);
    return (index * effectiveDelay).round();
  }

  StaggerConfig copyWith({
    int? delayMs,
    double? overlap,
  }) {
    return StaggerConfig(
      delayMs: delayMs ?? this.delayMs,
      overlap: overlap ?? this.overlap,
    );
  }
}

/// Panel for configuring stagger settings.
class StaggerConfigPanel extends StatelessWidget {
  const StaggerConfigPanel({
    required this.config,
    required this.onConfigChanged,
    super.key,
  });

  final StaggerConfig config;
  final void Function(StaggerConfig config) onConfigChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Stagger Configuration', style: theme.textTheme.titleSmall),
        const SizedBox(height: 16),
        Text('Stagger Delay (ms)', style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        TextField(
          key: const Key('stagger-delay'),
          controller: TextEditingController(text: config.delayMs.toString()),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onSubmitted: (value) {
            final delay = int.tryParse(value) ?? 100;
            onConfigChanged(config.copyWith(delayMs: delay));
          },
        ),
        const SizedBox(height: 16),
        Text('Overlap', style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Slider(
          value: config.overlap,
          onChanged: (value) {
            onConfigChanged(config.copyWith(overlap: value));
          },
        ),
        Text(
          '${(config.overlap * 100).round()}%',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Widget for previewing animations.
class AnimationPreview extends ConsumerStatefulWidget {
  const AnimationPreview({
    required this.animations,
    this.staggerConfig = const StaggerConfig(),
    super.key,
  });

  final List<WidgetAnimation> animations;
  final StaggerConfig staggerConfig;

  @override
  ConsumerState<AnimationPreview> createState() => _AnimationPreviewState();
}

class _AnimationPreviewState extends ConsumerState<AnimationPreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play() {
    setState(() => _isPlaying = true);
    _controller.forward();
  }

  void _pause() {
    setState(() => _isPlaying = false);
    _controller.stop();
  }

  void _reset() {
    setState(() => _isPlaying = false);
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: _isPlaying ? _pause : _play,
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: _reset,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            key: const Key('preview-area'),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.animations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final animation = entry.value;
                      final delay =
                          widget.staggerConfig.getChildDelay(index) / 1000;
                      final progress = (_controller.value - delay)
                          .clamp(0.0, animation.durationMs / 1000);
                      final normalizedProgress =
                          progress / (animation.durationMs / 1000);

                      return Opacity(
                        opacity: normalizedProgress.clamp(0.0, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Generates Flutter animation code for an animation.
String generateAnimationCode(WidgetAnimation animation) {
  final type = animation.type;
  final duration = animation.durationMs;
  final easing = animation.easing;
  final delay = animation.delayMs;

  final transitionWidget = switch (type) {
    AnimationType.fade => 'FadeTransition',
    AnimationType.slide => 'SlideTransition',
    AnimationType.scale => 'ScaleTransition',
    AnimationType.rotate => 'RotationTransition',
    AnimationType.custom => 'AnimatedBuilder',
  };

  final curve = switch (easing) {
    EasingType.linear => 'Curves.linear',
    EasingType.easeIn => 'Curves.easeIn',
    EasingType.easeOut => 'Curves.easeOut',
    EasingType.easeInOut => 'Curves.easeInOut',
    EasingType.bounce => 'Curves.bounceOut',
    EasingType.elastic => 'Curves.elasticOut',
  };

  final buffer = StringBuffer()
    ..writeln('// Animation: ${type.name}')
    ..writeln('final _controller = AnimationController(')
    ..writeln('  vsync: this,')
    ..writeln('  duration: const Duration(milliseconds: $duration),')
    ..writeln(');')
    ..writeln()
    ..writeln('final _animation = CurvedAnimation(')
    ..writeln('  parent: _controller,')
    ..writeln('  curve: $curve,')
    ..writeln(');');

  if (delay > 0) {
    buffer
      ..writeln()
      ..writeln('// delay: ${delay}ms')
      ..writeln('Future.delayed(const Duration(milliseconds: $delay), () {')
      ..writeln('  _controller.forward();')
      ..writeln('});');
  }

  buffer
    ..writeln()
    ..writeln('// Widget')
    ..writeln('$transitionWidget(');

  switch (type) {
    case AnimationType.fade:
      buffer.writeln('  opacity: _animation,');
    case AnimationType.slide:
      buffer
        ..writeln('  position: Tween<Offset>(')
        ..writeln('    begin: const Offset(-1, 0),')
        ..writeln('    end: Offset.zero,')
        ..writeln('  ).animate(_animation),');
    case AnimationType.scale:
      buffer.writeln('  scale: _animation,');
    case AnimationType.rotate:
      buffer.writeln('  turns: _animation,');
    case AnimationType.custom:
      buffer.writeln('  animation: _animation,');
  }

  buffer
    ..writeln('  child: YourWidget(),')
    ..writeln(')');

  return buffer.toString();
}

/// Panel for exporting animation code.
class CodeExportPanel extends StatefulWidget {
  const CodeExportPanel({
    required this.animations,
    super.key,
  });

  final List<WidgetAnimation> animations;

  @override
  State<CodeExportPanel> createState() => _CodeExportPanelState();
}

class _CodeExportPanelState extends State<CodeExportPanel> {
  bool _expanded = false;

  String get _generatedCode {
    if (widget.animations.isEmpty) {
      return '// No animations to export';
    }

    final buffer = StringBuffer()
      ..writeln('// Generated Animation Code')
      ..writeln('// Created with FlutterForge')
      ..writeln();

    for (final animation in widget.animations) {
      buffer
        ..writeln(generateAnimationCode(animation))
        ..writeln();
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => setState(() => _expanded = !_expanded),
          icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
          label: const Text('Export Code'),
        ),
        if (_expanded) ...[
          const SizedBox(height: 12),
          Container(
            key: const Key('code-preview'),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _generatedCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Code copied!')),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  _generatedCode,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Orchestrates multiple animations with staggering.
class StaggeredAnimationOrchestrator {
  StaggeredAnimationOrchestrator({
    required this.animations,
    required this.staggerConfig,
  });

  final List<WidgetAnimation> animations;
  final StaggerConfig staggerConfig;

  /// Get start time for animation with given ID.
  int getStartTime(String animationId) {
    final index = animations.indexWhere((a) => a.id == animationId);
    if (index == -1) return 0;
    return staggerConfig.getChildDelay(index);
  }

  /// Get total duration including all staggered animations.
  int get totalDurationMs {
    if (animations.isEmpty) return 0;

    var maxEndTime = 0;
    for (var i = 0; i < animations.length; i++) {
      final startTime = staggerConfig.getChildDelay(i);
      final endTime = startTime + animations[i].durationMs;
      if (endTime > maxEndTime) maxEndTime = endTime;
    }
    return maxEndTime;
  }
}

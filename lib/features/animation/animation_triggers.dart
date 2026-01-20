import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trigger types for animations.
enum TriggerType {
  onLoad,
  onTap,
  onVisible,
  onScroll,
}

/// Returns human-readable display name for trigger type.
String triggerDisplayName(TriggerType type) {
  switch (type) {
    case TriggerType.onLoad:
      return 'On Load';
    case TriggerType.onTap:
      return 'On Tap';
    case TriggerType.onVisible:
      return 'On Visible';
    case TriggerType.onScroll:
      return 'On Scroll';
  }
}

/// Returns icon for trigger type.
IconData triggerIcon(TriggerType type) {
  switch (type) {
    case TriggerType.onLoad:
      return Icons.play_arrow;
    case TriggerType.onTap:
      return Icons.touch_app;
    case TriggerType.onVisible:
      return Icons.visibility;
    case TriggerType.onScroll:
      return Icons.swap_vert;
  }
}

/// Animation trigger configuration.
class AnimationTrigger {
  const AnimationTrigger({
    required this.id,
    required this.type,
    required this.animationId,
    this.delayMs = 0,
    this.scrollThreshold,
  });

  final String id;
  final TriggerType type;
  final String animationId;
  final int delayMs;
  final double? scrollThreshold;

  AnimationTrigger copyWith({
    String? id,
    TriggerType? type,
    String? animationId,
    int? delayMs,
    double? scrollThreshold,
  }) {
    return AnimationTrigger(
      id: id ?? this.id,
      type: type ?? this.type,
      animationId: animationId ?? this.animationId,
      delayMs: delayMs ?? this.delayMs,
      scrollThreshold: scrollThreshold ?? this.scrollThreshold,
    );
  }
}

/// Provider for animation triggers.
final triggersProvider =
    StateNotifierProvider<TriggersNotifier, List<AnimationTrigger>>(
  (ref) => TriggersNotifier(),
);

/// Notifier for managing animation triggers.
class TriggersNotifier extends StateNotifier<List<AnimationTrigger>> {
  TriggersNotifier() : super([]);

  void addTrigger(AnimationTrigger trigger) {
    state = [...state, trigger];
  }

  void removeTrigger(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void updateTrigger(AnimationTrigger trigger) {
    state = state.map((t) => t.id == trigger.id ? trigger : t).toList();
  }

  List<AnimationTrigger> getByAnimationId(String animationId) {
    return state.where((t) => t.animationId == animationId).toList();
  }
}

/// Widget for selecting trigger type.
class TriggerSelector extends StatelessWidget {
  const TriggerSelector({
    required this.selectedTrigger,
    required this.onTriggerChanged,
    super.key,
  });

  final TriggerType selectedTrigger;
  final void Function(TriggerType trigger) onTriggerChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TriggerType.values.map((type) {
        final isSelected = selectedTrigger == type;
        return FilterChip(
          key: Key('trigger-${type.name}'),
          avatar: Icon(
            triggerIcon(type),
            size: 18,
          ),
          label: Text(triggerDisplayName(type)),
          selected: isSelected,
          onSelected: (_) => onTriggerChanged(type),
        );
      }).toList(),
    );
  }
}

/// Panel for configuring trigger settings.
class TriggerConfigPanel extends StatelessWidget {
  const TriggerConfigPanel({
    required this.trigger,
    required this.onTriggerUpdated,
    super.key,
  });

  final AnimationTrigger trigger;
  final void Function(AnimationTrigger trigger) onTriggerUpdated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Trigger Configuration', style: theme.textTheme.titleSmall),
        const SizedBox(height: 16),
        Text('Delay (ms)', style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        TextField(
          key: const Key('delay-input'),
          controller: TextEditingController(text: trigger.delayMs.toString()),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onSubmitted: (value) {
            final delay = int.tryParse(value) ?? 0;
            onTriggerUpdated(trigger.copyWith(delayMs: delay));
          },
        ),
        if (trigger.type == TriggerType.onScroll) ...[
          const SizedBox(height: 16),
          Text('Scroll Threshold', style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          Slider(
            key: const Key('scroll-threshold-slider'),
            value: trigger.scrollThreshold ?? 0.5,
            onChanged: (value) {
              onTriggerUpdated(trigger.copyWith(scrollThreshold: value));
            },
          ),
          Text(
            '${((trigger.scrollThreshold ?? 0.5) * 100).round()}%',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

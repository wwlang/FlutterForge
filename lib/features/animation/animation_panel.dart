import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_forge/features/animation/timeline_editor.dart';
import 'package:flutter_forge/providers/animations_provider.dart';
import 'package:flutter_forge/providers/selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Playhead position provider in milliseconds.
final playheadMsProvider = StateProvider<int>((ref) => 0);

/// Track state for lock/hide functionality.
class TrackState {
  const TrackState({
    this.isLocked = false,
    this.isHidden = false,
  });

  final bool isLocked;
  final bool isHidden;

  TrackState copyWith({bool? isLocked, bool? isHidden}) {
    return TrackState(
      isLocked: isLocked ?? this.isLocked,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}

/// Notifier for managing track states.
class TrackStatesNotifier extends StateNotifier<Map<String, TrackState>> {
  TrackStatesNotifier() : super({});

  void setLocked(String trackId, {required bool locked}) {
    final currentState = state[trackId] ?? const TrackState();
    state = {...state, trackId: currentState.copyWith(isLocked: locked)};
  }

  void setHidden(String trackId, {required bool hidden}) {
    final currentState = state[trackId] ?? const TrackState();
    state = {...state, trackId: currentState.copyWith(isHidden: hidden)};
  }

  void removeTrack(String trackId) {
    state = Map.from(state)..remove(trackId);
  }
}

/// Provider for track states.
final trackStatesProvider =
    StateNotifierProvider<TrackStatesNotifier, Map<String, TrackState>>((ref) {
  return TrackStatesNotifier();
});

/// Animation panel for managing widget animations.
class AnimationPanel extends ConsumerWidget {
  const AnimationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWidgetId = ref.watch(selectionProvider);
    final allAnimations = ref.watch(animationsProvider);

    if (selectedWidgetId == null || selectedWidgetId.isEmpty) {
      return _buildEmptyState(context);
    }

    final widgetAnimations =
        allAnimations.where((a) => a.widgetId == selectedWidgetId).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, ref, selectedWidgetId),
        if (widgetAnimations.isEmpty)
          _buildNoAnimationsState(context)
        else
          Expanded(
            child: Column(
              children: [
                _buildTrackList(context, ref, widgetAnimations),
                const Divider(height: 1),
                Expanded(
                  child: TimelineEditor(
                    animations: widgetAnimations,
                    onPlayheadChange: (ms) {
                      ref.read(playheadMsProvider.notifier).state = ms;
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.animation,
            size: 48,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a widget to animate',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoAnimationsState(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No animations yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click "Add Animation" to get started',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, String widgetId) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Animations',
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: FilledButton.icon(
              onPressed: () => _showAddAnimationDialog(context, ref, widgetId),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Animation'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackList(
    BuildContext context,
    WidgetRef ref,
    List<WidgetAnimation> animations,
  ) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        itemCount: animations.length,
        itemBuilder: (context, index) {
          final animation = animations[index];
          return _AnimationTrackItem(
            animation: animation,
            onDuplicate: () => _duplicateAnimation(ref, animation),
            onDelete: () => _deleteAnimation(ref, animation),
          );
        },
      ),
    );
  }

  void _showAddAnimationDialog(
    BuildContext context,
    WidgetRef ref,
    String widgetId,
  ) {
    showDialog<AnimationType>(
      context: context,
      builder: (context) => const _AddAnimationDialog(),
    ).then((type) {
      if (type != null) {
        _addAnimation(ref, widgetId, type);
      }
    });
  }

  void _addAnimation(WidgetRef ref, String widgetId, AnimationType type) {
    final animation = WidgetAnimation(
      id: const Uuid().v4(),
      widgetId: widgetId,
      type: type,
      durationMs: 300,
    );
    ref.read(animationsProvider.notifier).addAnimation(animation);
  }

  void _duplicateAnimation(WidgetRef ref, WidgetAnimation animation) {
    final duplicate = WidgetAnimation(
      id: const Uuid().v4(),
      widgetId: animation.widgetId,
      type: animation.type,
      durationMs: animation.durationMs,
      delayMs: animation.delayMs,
      easing: animation.easing,
      keyframes: animation.keyframes,
    );
    ref.read(animationsProvider.notifier).addAnimation(duplicate);
  }

  void _deleteAnimation(WidgetRef ref, WidgetAnimation animation) {
    ref.read(animationsProvider.notifier).removeAnimation(animation.id);
    ref.read(trackStatesProvider.notifier).removeTrack(animation.id);
  }
}

/// Individual track item in the animation panel.
class _AnimationTrackItem extends StatelessWidget {
  const _AnimationTrackItem({
    required this.animation,
    required this.onDuplicate,
    required this.onDelete,
  });

  final WidgetAnimation animation;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  String get _typeLabel {
    switch (animation.type) {
      case AnimationType.fade:
        return 'Fade';
      case AnimationType.slide:
        return 'Slide';
      case AnimationType.scale:
        return 'Scale';
      case AnimationType.rotate:
        return 'Rotate';
      case AnimationType.custom:
        return 'Custom';
    }
  }

  IconData get _typeIcon {
    switch (animation.type) {
      case AnimationType.fade:
        return Icons.opacity;
      case AnimationType.slide:
        return Icons.swap_horiz;
      case AnimationType.scale:
        return Icons.zoom_out_map;
      case AnimationType.rotate:
        return Icons.rotate_right;
      case AnimationType.custom:
        return Icons.tune;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Icon(_typeIcon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _typeLabel,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${animation.durationMs}ms',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          PopupMenuButton<String>(
            key: Key('track-menu-${animation.id}'),
            icon: const Icon(Icons.more_vert, size: 18),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              PopupMenuItem(value: 'lock', child: Text('Lock')),
              PopupMenuItem(value: 'hide', child: Text('Hide')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
            onSelected: (value) {
              switch (value) {
                case 'duplicate':
                  onDuplicate();
                case 'delete':
                  onDelete();
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Dialog for selecting animation type.
class _AddAnimationDialog extends StatelessWidget {
  const _AddAnimationDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Animation'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimationTypeOption(
              type: AnimationType.fade,
              label: 'Fade',
              description: 'Animate opacity',
              icon: Icons.opacity,
              onTap: () => Navigator.pop(context, AnimationType.fade),
            ),
            _AnimationTypeOption(
              type: AnimationType.slide,
              label: 'Slide',
              description: 'Animate position',
              icon: Icons.swap_horiz,
              onTap: () => Navigator.pop(context, AnimationType.slide),
            ),
            _AnimationTypeOption(
              type: AnimationType.scale,
              label: 'Scale',
              description: 'Animate size',
              icon: Icons.zoom_out_map,
              onTap: () => Navigator.pop(context, AnimationType.scale),
            ),
            _AnimationTypeOption(
              type: AnimationType.rotate,
              label: 'Rotate',
              description: 'Animate rotation',
              icon: Icons.rotate_right,
              onTap: () => Navigator.pop(context, AnimationType.rotate),
            ),
            _AnimationTypeOption(
              type: AnimationType.custom,
              label: 'Custom',
              description: 'Keyframe any property',
              icon: Icons.tune,
              onTap: () => Navigator.pop(context, AnimationType.custom),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Option for animation type in the add dialog.
class _AnimationTypeOption extends StatelessWidget {
  const _AnimationTypeOption({
    required this.type,
    required this.label,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  final AnimationType type;
  final String label;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.bodyMedium),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

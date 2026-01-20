import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing widget animations.
final animationsProvider =
    StateNotifierProvider<AnimationsNotifier, List<WidgetAnimation>>((ref) {
  return AnimationsNotifier();
});

/// Provider to check if a widget has animations.
final widgetHasAnimationsProvider =
    Provider.family<bool, String>((ref, widgetId) {
  final animations = ref.watch(animationsProvider);
  return animations.any((a) => a.widgetId == widgetId);
});

/// Provider to get animations for a specific widget.
final widgetAnimationsProvider =
    Provider.family<List<WidgetAnimation>, String>((ref, widgetId) {
  final animations = ref.watch(animationsProvider);
  return animations.where((a) => a.widgetId == widgetId).toList();
});

/// Notifier for widget animation state management.
class AnimationsNotifier extends StateNotifier<List<WidgetAnimation>> {
  /// Creates an animations notifier.
  AnimationsNotifier() : super([]);

  /// Adds a new animation.
  void addAnimation(WidgetAnimation animation) {
    state = [...state, animation];
  }

  /// Removes an animation by ID.
  void removeAnimation(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  /// Updates an existing animation.
  void updateAnimation(WidgetAnimation animation) {
    state = [
      for (final a in state)
        if (a.id == animation.id) animation else a,
    ];
  }

  /// Gets an animation by ID.
  WidgetAnimation? getById(String id) {
    try {
      return state.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Gets all animations for a widget.
  List<WidgetAnimation> getByWidgetId(String widgetId) {
    return state.where((a) => a.widgetId == widgetId).toList();
  }

  /// Removes all animations for a widget.
  void removeAnimationsForWidget(String widgetId) {
    state = state.where((a) => a.widgetId != widgetId).toList();
  }

  /// Adds a keyframe to an animation.
  void addKeyframe(String animationId, Keyframe keyframe) {
    state = [
      for (final a in state)
        if (a.id == animationId)
          a.copyWith(keyframes: [...a.keyframes, keyframe])
        else
          a,
    ];
  }

  /// Removes a keyframe from an animation.
  void removeKeyframe(String animationId, String keyframeId) {
    state = [
      for (final a in state)
        if (a.id == animationId)
          a.copyWith(
            keyframes: a.keyframes.where((k) => k.id != keyframeId).toList(),
          )
        else
          a,
    ];
  }

  /// Updates a keyframe in an animation.
  void updateKeyframe(String animationId, Keyframe keyframe) {
    state = [
      for (final a in state)
        if (a.id == animationId)
          a.copyWith(
            keyframes: [
              for (final k in a.keyframes)
                if (k.id == keyframe.id) keyframe else k,
            ],
          )
        else
          a,
    ];
  }

  /// Exports all animations to JSON.
  List<Map<String, dynamic>> toJson() {
    return state.map((a) => a.toJson()).toList();
  }

  /// Loads animations from JSON.
  void loadFromJson(List<dynamic> jsonList) {
    state = jsonList
        .map((json) => WidgetAnimation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Clears all animations.
  void clear() {
    state = [];
  }
}

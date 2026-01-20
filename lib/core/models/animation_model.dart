import 'package:freezed_annotation/freezed_annotation.dart';

part 'animation_model.freezed.dart';
part 'animation_model.g.dart';

/// Type of animation effect.
enum AnimationType {
  /// Opacity transition from 0 to 1 or 1 to 0.
  fade,

  /// Position transition (translateX, translateY).
  slide,

  /// Size transition (scale).
  scale,

  /// Rotation transition.
  rotate,

  /// Custom property animation with keyframes.
  custom,
}

/// Easing curve type for animations.
enum EasingType {
  /// Linear progression.
  linear,

  /// Starts slow, accelerates.
  easeIn,

  /// Starts fast, decelerates.
  easeOut,

  /// Slow start and end.
  easeInOut,

  /// Bouncing effect at end.
  bounce,

  /// Elastic/spring effect.
  elastic,
}

/// A single keyframe in an animation.
@freezed
class Keyframe with _$Keyframe {
  /// Creates a keyframe.
  const factory Keyframe({
    /// Unique identifier for this keyframe.
    required String id,

    /// Time position in milliseconds.
    required int timeMs,

    /// Property being animated (e.g., 'opacity', 'x', 'scale').
    required String property,

    /// Value at this keyframe.
    required dynamic value,

    /// Easing to this keyframe (null = inherit from animation).
    EasingType? easing,
  }) = _Keyframe;

  factory Keyframe.fromJson(Map<String, dynamic> json) =>
      _$KeyframeFromJson(json);
}

/// Represents an animation attached to a widget.
@freezed
class WidgetAnimation with _$WidgetAnimation {
  /// Creates a widget animation.
  const factory WidgetAnimation({
    /// Unique identifier for this animation.
    required String id,

    /// ID of the widget this animation is attached to.
    required String widgetId,

    /// Type of animation effect.
    required AnimationType type,

    /// Duration in milliseconds.
    required int durationMs,

    /// Delay before animation starts in milliseconds.
    @Default(0) int delayMs,

    /// Easing curve for the animation.
    @Default(EasingType.linear) EasingType easing,

    /// Keyframes for custom animations.
    @Default(<Keyframe>[]) List<Keyframe> keyframes,
  }) = _WidgetAnimation;

  factory WidgetAnimation.fromJson(Map<String, dynamic> json) =>
      _$WidgetAnimationFromJson(json);
}

/// Converts EasingType to/from JSON string.
class EasingTypeConverter implements JsonConverter<EasingType, String> {
  const EasingTypeConverter();

  @override
  EasingType fromJson(String json) {
    return EasingType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EasingType.linear,
    );
  }

  @override
  String toJson(EasingType object) => object.name;
}

/// Converts AnimationType to/from JSON string.
class AnimationTypeConverter implements JsonConverter<AnimationType, String> {
  const AnimationTypeConverter();

  @override
  AnimationType fromJson(String json) {
    return AnimationType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => AnimationType.custom,
    );
  }

  @override
  String toJson(AnimationType object) => object.name;
}

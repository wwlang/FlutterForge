// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'animation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Keyframe _$KeyframeFromJson(Map<String, dynamic> json) {
  return _Keyframe.fromJson(json);
}

/// @nodoc
mixin _$Keyframe {
  /// Unique identifier for this keyframe.
  String get id => throw _privateConstructorUsedError;

  /// Time position in milliseconds.
  int get timeMs => throw _privateConstructorUsedError;

  /// Property being animated (e.g., 'opacity', 'x', 'scale').
  String get property => throw _privateConstructorUsedError;

  /// Value at this keyframe.
  dynamic get value => throw _privateConstructorUsedError;

  /// Easing to this keyframe (null = inherit from animation).
  EasingType? get easing => throw _privateConstructorUsedError;

  /// Serializes this Keyframe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Keyframe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KeyframeCopyWith<Keyframe> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeyframeCopyWith<$Res> {
  factory $KeyframeCopyWith(Keyframe value, $Res Function(Keyframe) then) =
      _$KeyframeCopyWithImpl<$Res, Keyframe>;
  @useResult
  $Res call(
      {String id,
      int timeMs,
      String property,
      dynamic value,
      EasingType? easing});
}

/// @nodoc
class _$KeyframeCopyWithImpl<$Res, $Val extends Keyframe>
    implements $KeyframeCopyWith<$Res> {
  _$KeyframeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Keyframe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timeMs = null,
    Object? property = null,
    Object? value = freezed,
    Object? easing = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timeMs: null == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int,
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      easing: freezed == easing
          ? _value.easing
          : easing // ignore: cast_nullable_to_non_nullable
              as EasingType?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$KeyframeImplCopyWith<$Res>
    implements $KeyframeCopyWith<$Res> {
  factory _$$KeyframeImplCopyWith(
          _$KeyframeImpl value, $Res Function(_$KeyframeImpl) then) =
      __$$KeyframeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int timeMs,
      String property,
      dynamic value,
      EasingType? easing});
}

/// @nodoc
class __$$KeyframeImplCopyWithImpl<$Res>
    extends _$KeyframeCopyWithImpl<$Res, _$KeyframeImpl>
    implements _$$KeyframeImplCopyWith<$Res> {
  __$$KeyframeImplCopyWithImpl(
      _$KeyframeImpl _value, $Res Function(_$KeyframeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Keyframe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timeMs = null,
    Object? property = null,
    Object? value = freezed,
    Object? easing = freezed,
  }) {
    return _then(_$KeyframeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timeMs: null == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int,
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      easing: freezed == easing
          ? _value.easing
          : easing // ignore: cast_nullable_to_non_nullable
              as EasingType?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$KeyframeImpl implements _Keyframe {
  const _$KeyframeImpl(
      {required this.id,
      required this.timeMs,
      required this.property,
      required this.value,
      this.easing});

  factory _$KeyframeImpl.fromJson(Map<String, dynamic> json) =>
      _$$KeyframeImplFromJson(json);

  /// Unique identifier for this keyframe.
  @override
  final String id;

  /// Time position in milliseconds.
  @override
  final int timeMs;

  /// Property being animated (e.g., 'opacity', 'x', 'scale').
  @override
  final String property;

  /// Value at this keyframe.
  @override
  final dynamic value;

  /// Easing to this keyframe (null = inherit from animation).
  @override
  final EasingType? easing;

  @override
  String toString() {
    return 'Keyframe(id: $id, timeMs: $timeMs, property: $property, value: $value, easing: $easing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeyframeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timeMs, timeMs) || other.timeMs == timeMs) &&
            (identical(other.property, property) ||
                other.property == property) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.easing, easing) || other.easing == easing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, timeMs, property,
      const DeepCollectionEquality().hash(value), easing);

  /// Create a copy of Keyframe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KeyframeImplCopyWith<_$KeyframeImpl> get copyWith =>
      __$$KeyframeImplCopyWithImpl<_$KeyframeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KeyframeImplToJson(
      this,
    );
  }
}

abstract class _Keyframe implements Keyframe {
  const factory _Keyframe(
      {required final String id,
      required final int timeMs,
      required final String property,
      required final dynamic value,
      final EasingType? easing}) = _$KeyframeImpl;

  factory _Keyframe.fromJson(Map<String, dynamic> json) =
      _$KeyframeImpl.fromJson;

  /// Unique identifier for this keyframe.
  @override
  String get id;

  /// Time position in milliseconds.
  @override
  int get timeMs;

  /// Property being animated (e.g., 'opacity', 'x', 'scale').
  @override
  String get property;

  /// Value at this keyframe.
  @override
  dynamic get value;

  /// Easing to this keyframe (null = inherit from animation).
  @override
  EasingType? get easing;

  /// Create a copy of Keyframe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KeyframeImplCopyWith<_$KeyframeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WidgetAnimation _$WidgetAnimationFromJson(Map<String, dynamic> json) {
  return _WidgetAnimation.fromJson(json);
}

/// @nodoc
mixin _$WidgetAnimation {
  /// Unique identifier for this animation.
  String get id => throw _privateConstructorUsedError;

  /// ID of the widget this animation is attached to.
  String get widgetId => throw _privateConstructorUsedError;

  /// Type of animation effect.
  AnimationType get type => throw _privateConstructorUsedError;

  /// Duration in milliseconds.
  int get durationMs => throw _privateConstructorUsedError;

  /// Delay before animation starts in milliseconds.
  int get delayMs => throw _privateConstructorUsedError;

  /// Easing curve for the animation.
  EasingType get easing => throw _privateConstructorUsedError;

  /// Keyframes for custom animations.
  List<Keyframe> get keyframes => throw _privateConstructorUsedError;

  /// Serializes this WidgetAnimation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WidgetAnimation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WidgetAnimationCopyWith<WidgetAnimation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WidgetAnimationCopyWith<$Res> {
  factory $WidgetAnimationCopyWith(
          WidgetAnimation value, $Res Function(WidgetAnimation) then) =
      _$WidgetAnimationCopyWithImpl<$Res, WidgetAnimation>;
  @useResult
  $Res call(
      {String id,
      String widgetId,
      AnimationType type,
      int durationMs,
      int delayMs,
      EasingType easing,
      List<Keyframe> keyframes});
}

/// @nodoc
class _$WidgetAnimationCopyWithImpl<$Res, $Val extends WidgetAnimation>
    implements $WidgetAnimationCopyWith<$Res> {
  _$WidgetAnimationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WidgetAnimation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? widgetId = null,
    Object? type = null,
    Object? durationMs = null,
    Object? delayMs = null,
    Object? easing = null,
    Object? keyframes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      widgetId: null == widgetId
          ? _value.widgetId
          : widgetId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AnimationType,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      delayMs: null == delayMs
          ? _value.delayMs
          : delayMs // ignore: cast_nullable_to_non_nullable
              as int,
      easing: null == easing
          ? _value.easing
          : easing // ignore: cast_nullable_to_non_nullable
              as EasingType,
      keyframes: null == keyframes
          ? _value.keyframes
          : keyframes // ignore: cast_nullable_to_non_nullable
              as List<Keyframe>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WidgetAnimationImplCopyWith<$Res>
    implements $WidgetAnimationCopyWith<$Res> {
  factory _$$WidgetAnimationImplCopyWith(_$WidgetAnimationImpl value,
          $Res Function(_$WidgetAnimationImpl) then) =
      __$$WidgetAnimationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String widgetId,
      AnimationType type,
      int durationMs,
      int delayMs,
      EasingType easing,
      List<Keyframe> keyframes});
}

/// @nodoc
class __$$WidgetAnimationImplCopyWithImpl<$Res>
    extends _$WidgetAnimationCopyWithImpl<$Res, _$WidgetAnimationImpl>
    implements _$$WidgetAnimationImplCopyWith<$Res> {
  __$$WidgetAnimationImplCopyWithImpl(
      _$WidgetAnimationImpl _value, $Res Function(_$WidgetAnimationImpl) _then)
      : super(_value, _then);

  /// Create a copy of WidgetAnimation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? widgetId = null,
    Object? type = null,
    Object? durationMs = null,
    Object? delayMs = null,
    Object? easing = null,
    Object? keyframes = null,
  }) {
    return _then(_$WidgetAnimationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      widgetId: null == widgetId
          ? _value.widgetId
          : widgetId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AnimationType,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      delayMs: null == delayMs
          ? _value.delayMs
          : delayMs // ignore: cast_nullable_to_non_nullable
              as int,
      easing: null == easing
          ? _value.easing
          : easing // ignore: cast_nullable_to_non_nullable
              as EasingType,
      keyframes: null == keyframes
          ? _value._keyframes
          : keyframes // ignore: cast_nullable_to_non_nullable
              as List<Keyframe>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WidgetAnimationImpl implements _WidgetAnimation {
  const _$WidgetAnimationImpl(
      {required this.id,
      required this.widgetId,
      required this.type,
      required this.durationMs,
      this.delayMs = 0,
      this.easing = EasingType.linear,
      final List<Keyframe> keyframes = const <Keyframe>[]})
      : _keyframes = keyframes;

  factory _$WidgetAnimationImpl.fromJson(Map<String, dynamic> json) =>
      _$$WidgetAnimationImplFromJson(json);

  /// Unique identifier for this animation.
  @override
  final String id;

  /// ID of the widget this animation is attached to.
  @override
  final String widgetId;

  /// Type of animation effect.
  @override
  final AnimationType type;

  /// Duration in milliseconds.
  @override
  final int durationMs;

  /// Delay before animation starts in milliseconds.
  @override
  @JsonKey()
  final int delayMs;

  /// Easing curve for the animation.
  @override
  @JsonKey()
  final EasingType easing;

  /// Keyframes for custom animations.
  final List<Keyframe> _keyframes;

  /// Keyframes for custom animations.
  @override
  @JsonKey()
  List<Keyframe> get keyframes {
    if (_keyframes is EqualUnmodifiableListView) return _keyframes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keyframes);
  }

  @override
  String toString() {
    return 'WidgetAnimation(id: $id, widgetId: $widgetId, type: $type, durationMs: $durationMs, delayMs: $delayMs, easing: $easing, keyframes: $keyframes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WidgetAnimationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.widgetId, widgetId) ||
                other.widgetId == widgetId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.delayMs, delayMs) || other.delayMs == delayMs) &&
            (identical(other.easing, easing) || other.easing == easing) &&
            const DeepCollectionEquality()
                .equals(other._keyframes, _keyframes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, widgetId, type, durationMs,
      delayMs, easing, const DeepCollectionEquality().hash(_keyframes));

  /// Create a copy of WidgetAnimation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WidgetAnimationImplCopyWith<_$WidgetAnimationImpl> get copyWith =>
      __$$WidgetAnimationImplCopyWithImpl<_$WidgetAnimationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WidgetAnimationImplToJson(
      this,
    );
  }
}

abstract class _WidgetAnimation implements WidgetAnimation {
  const factory _WidgetAnimation(
      {required final String id,
      required final String widgetId,
      required final AnimationType type,
      required final int durationMs,
      final int delayMs,
      final EasingType easing,
      final List<Keyframe> keyframes}) = _$WidgetAnimationImpl;

  factory _WidgetAnimation.fromJson(Map<String, dynamic> json) =
      _$WidgetAnimationImpl.fromJson;

  /// Unique identifier for this animation.
  @override
  String get id;

  /// ID of the widget this animation is attached to.
  @override
  String get widgetId;

  /// Type of animation effect.
  @override
  AnimationType get type;

  /// Duration in milliseconds.
  @override
  int get durationMs;

  /// Delay before animation starts in milliseconds.
  @override
  int get delayMs;

  /// Easing curve for the animation.
  @override
  EasingType get easing;

  /// Keyframes for custom animations.
  @override
  List<Keyframe> get keyframes;

  /// Create a copy of WidgetAnimation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WidgetAnimationImplCopyWith<_$WidgetAnimationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

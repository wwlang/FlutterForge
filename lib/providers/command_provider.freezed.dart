// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommandState {
  bool get canUndo => throw _privateConstructorUsedError;
  bool get canRedo => throw _privateConstructorUsedError;
  String? get undoDescription => throw _privateConstructorUsedError;
  String? get redoDescription => throw _privateConstructorUsedError;

  /// Create a copy of CommandState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommandStateCopyWith<CommandState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommandStateCopyWith<$Res> {
  factory $CommandStateCopyWith(
          CommandState value, $Res Function(CommandState) then) =
      _$CommandStateCopyWithImpl<$Res, CommandState>;
  @useResult
  $Res call(
      {bool canUndo,
      bool canRedo,
      String? undoDescription,
      String? redoDescription});
}

/// @nodoc
class _$CommandStateCopyWithImpl<$Res, $Val extends CommandState>
    implements $CommandStateCopyWith<$Res> {
  _$CommandStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommandState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canUndo = null,
    Object? canRedo = null,
    Object? undoDescription = freezed,
    Object? redoDescription = freezed,
  }) {
    return _then(_value.copyWith(
      canUndo: null == canUndo
          ? _value.canUndo
          : canUndo // ignore: cast_nullable_to_non_nullable
              as bool,
      canRedo: null == canRedo
          ? _value.canRedo
          : canRedo // ignore: cast_nullable_to_non_nullable
              as bool,
      undoDescription: freezed == undoDescription
          ? _value.undoDescription
          : undoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      redoDescription: freezed == redoDescription
          ? _value.redoDescription
          : redoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommandStateImplCopyWith<$Res>
    implements $CommandStateCopyWith<$Res> {
  factory _$$CommandStateImplCopyWith(
          _$CommandStateImpl value, $Res Function(_$CommandStateImpl) then) =
      __$$CommandStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool canUndo,
      bool canRedo,
      String? undoDescription,
      String? redoDescription});
}

/// @nodoc
class __$$CommandStateImplCopyWithImpl<$Res>
    extends _$CommandStateCopyWithImpl<$Res, _$CommandStateImpl>
    implements _$$CommandStateImplCopyWith<$Res> {
  __$$CommandStateImplCopyWithImpl(
      _$CommandStateImpl _value, $Res Function(_$CommandStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommandState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canUndo = null,
    Object? canRedo = null,
    Object? undoDescription = freezed,
    Object? redoDescription = freezed,
  }) {
    return _then(_$CommandStateImpl(
      canUndo: null == canUndo
          ? _value.canUndo
          : canUndo // ignore: cast_nullable_to_non_nullable
              as bool,
      canRedo: null == canRedo
          ? _value.canRedo
          : canRedo // ignore: cast_nullable_to_non_nullable
              as bool,
      undoDescription: freezed == undoDescription
          ? _value.undoDescription
          : undoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      redoDescription: freezed == redoDescription
          ? _value.redoDescription
          : redoDescription // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CommandStateImpl implements _CommandState {
  const _$CommandStateImpl(
      {this.canUndo = false,
      this.canRedo = false,
      this.undoDescription,
      this.redoDescription});

  @override
  @JsonKey()
  final bool canUndo;
  @override
  @JsonKey()
  final bool canRedo;
  @override
  final String? undoDescription;
  @override
  final String? redoDescription;

  @override
  String toString() {
    return 'CommandState(canUndo: $canUndo, canRedo: $canRedo, undoDescription: $undoDescription, redoDescription: $redoDescription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommandStateImpl &&
            (identical(other.canUndo, canUndo) || other.canUndo == canUndo) &&
            (identical(other.canRedo, canRedo) || other.canRedo == canRedo) &&
            (identical(other.undoDescription, undoDescription) ||
                other.undoDescription == undoDescription) &&
            (identical(other.redoDescription, redoDescription) ||
                other.redoDescription == redoDescription));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, canUndo, canRedo, undoDescription, redoDescription);

  /// Create a copy of CommandState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommandStateImplCopyWith<_$CommandStateImpl> get copyWith =>
      __$$CommandStateImplCopyWithImpl<_$CommandStateImpl>(this, _$identity);
}

abstract class _CommandState implements CommandState {
  const factory _CommandState(
      {final bool canUndo,
      final bool canRedo,
      final String? undoDescription,
      final String? redoDescription}) = _$CommandStateImpl;

  @override
  bool get canUndo;
  @override
  bool get canRedo;
  @override
  String? get undoDescription;
  @override
  String? get redoDescription;

  /// Create a copy of CommandState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommandStateImplCopyWith<_$CommandStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

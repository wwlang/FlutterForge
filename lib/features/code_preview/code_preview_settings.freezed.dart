// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'code_preview_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CodeSettings _$CodeSettingsFromJson(Map<String, dynamic> json) {
  return _CodeSettings.fromJson(json);
}

/// @nodoc
mixin _$CodeSettings {
  /// Target Dart version for generated code.
  DartVersion get dartVersion => throw _privateConstructorUsedError;

  /// Whether to use dot shorthand syntax (Dart 3.10+).
  ///
  /// Automatically false for Dart 3.9, but can be manually
  /// disabled for Dart 3.10+ if desired.
  bool get useDotShorthand => throw _privateConstructorUsedError;

  /// Serializes this CodeSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CodeSettingsCopyWith<CodeSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CodeSettingsCopyWith<$Res> {
  factory $CodeSettingsCopyWith(
          CodeSettings value, $Res Function(CodeSettings) then) =
      _$CodeSettingsCopyWithImpl<$Res, CodeSettings>;
  @useResult
  $Res call({DartVersion dartVersion, bool useDotShorthand});
}

/// @nodoc
class _$CodeSettingsCopyWithImpl<$Res, $Val extends CodeSettings>
    implements $CodeSettingsCopyWith<$Res> {
  _$CodeSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dartVersion = null,
    Object? useDotShorthand = null,
  }) {
    return _then(_value.copyWith(
      dartVersion: null == dartVersion
          ? _value.dartVersion
          : dartVersion // ignore: cast_nullable_to_non_nullable
              as DartVersion,
      useDotShorthand: null == useDotShorthand
          ? _value.useDotShorthand
          : useDotShorthand // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CodeSettingsImplCopyWith<$Res>
    implements $CodeSettingsCopyWith<$Res> {
  factory _$$CodeSettingsImplCopyWith(
          _$CodeSettingsImpl value, $Res Function(_$CodeSettingsImpl) then) =
      __$$CodeSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DartVersion dartVersion, bool useDotShorthand});
}

/// @nodoc
class __$$CodeSettingsImplCopyWithImpl<$Res>
    extends _$CodeSettingsCopyWithImpl<$Res, _$CodeSettingsImpl>
    implements _$$CodeSettingsImplCopyWith<$Res> {
  __$$CodeSettingsImplCopyWithImpl(
      _$CodeSettingsImpl _value, $Res Function(_$CodeSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dartVersion = null,
    Object? useDotShorthand = null,
  }) {
    return _then(_$CodeSettingsImpl(
      dartVersion: null == dartVersion
          ? _value.dartVersion
          : dartVersion // ignore: cast_nullable_to_non_nullable
              as DartVersion,
      useDotShorthand: null == useDotShorthand
          ? _value.useDotShorthand
          : useDotShorthand // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CodeSettingsImpl extends _CodeSettings {
  const _$CodeSettingsImpl(
      {this.dartVersion = DartVersion.dart310, this.useDotShorthand = true})
      : super._();

  factory _$CodeSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CodeSettingsImplFromJson(json);

  /// Target Dart version for generated code.
  @override
  @JsonKey()
  final DartVersion dartVersion;

  /// Whether to use dot shorthand syntax (Dart 3.10+).
  ///
  /// Automatically false for Dart 3.9, but can be manually
  /// disabled for Dart 3.10+ if desired.
  @override
  @JsonKey()
  final bool useDotShorthand;

  @override
  String toString() {
    return 'CodeSettings(dartVersion: $dartVersion, useDotShorthand: $useDotShorthand)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CodeSettingsImpl &&
            (identical(other.dartVersion, dartVersion) ||
                other.dartVersion == dartVersion) &&
            (identical(other.useDotShorthand, useDotShorthand) ||
                other.useDotShorthand == useDotShorthand));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dartVersion, useDotShorthand);

  /// Create a copy of CodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CodeSettingsImplCopyWith<_$CodeSettingsImpl> get copyWith =>
      __$$CodeSettingsImplCopyWithImpl<_$CodeSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CodeSettingsImplToJson(
      this,
    );
  }
}

abstract class _CodeSettings extends CodeSettings {
  const factory _CodeSettings(
      {final DartVersion dartVersion,
      final bool useDotShorthand}) = _$CodeSettingsImpl;
  const _CodeSettings._() : super._();

  factory _CodeSettings.fromJson(Map<String, dynamic> json) =
      _$CodeSettingsImpl.fromJson;

  /// Target Dart version for generated code.
  @override
  DartVersion get dartVersion;

  /// Whether to use dot shorthand syntax (Dart 3.10+).
  ///
  /// Automatically false for Dart 3.9, but can be manually
  /// disabled for Dart 3.10+ if desired.
  @override
  bool get useDotShorthand;

  /// Create a copy of CodeSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CodeSettingsImplCopyWith<_$CodeSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

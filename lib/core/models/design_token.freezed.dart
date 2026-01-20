// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'design_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TypographyValue _$TypographyValueFromJson(Map<String, dynamic> json) {
  return _TypographyValue.fromJson(json);
}

/// @nodoc
mixin _$TypographyValue {
  /// Font family name.
  String? get fontFamily => throw _privateConstructorUsedError;

  /// Font size in logical pixels.
  double get fontSize => throw _privateConstructorUsedError;

  /// Font weight (100-900).
  int get fontWeight => throw _privateConstructorUsedError;

  /// Line height multiplier.
  double get lineHeight => throw _privateConstructorUsedError;

  /// Letter spacing in logical pixels.
  double get letterSpacing => throw _privateConstructorUsedError;

  /// Serializes this TypographyValue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TypographyValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TypographyValueCopyWith<TypographyValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypographyValueCopyWith<$Res> {
  factory $TypographyValueCopyWith(
          TypographyValue value, $Res Function(TypographyValue) then) =
      _$TypographyValueCopyWithImpl<$Res, TypographyValue>;
  @useResult
  $Res call(
      {String? fontFamily,
      double fontSize,
      int fontWeight,
      double lineHeight,
      double letterSpacing});
}

/// @nodoc
class _$TypographyValueCopyWithImpl<$Res, $Val extends TypographyValue>
    implements $TypographyValueCopyWith<$Res> {
  _$TypographyValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TypographyValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontFamily = freezed,
    Object? fontSize = null,
    Object? fontWeight = null,
    Object? lineHeight = null,
    Object? letterSpacing = null,
  }) {
    return _then(_value.copyWith(
      fontFamily: freezed == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      fontWeight: null == fontWeight
          ? _value.fontWeight
          : fontWeight // ignore: cast_nullable_to_non_nullable
              as int,
      lineHeight: null == lineHeight
          ? _value.lineHeight
          : lineHeight // ignore: cast_nullable_to_non_nullable
              as double,
      letterSpacing: null == letterSpacing
          ? _value.letterSpacing
          : letterSpacing // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypographyValueImplCopyWith<$Res>
    implements $TypographyValueCopyWith<$Res> {
  factory _$$TypographyValueImplCopyWith(_$TypographyValueImpl value,
          $Res Function(_$TypographyValueImpl) then) =
      __$$TypographyValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? fontFamily,
      double fontSize,
      int fontWeight,
      double lineHeight,
      double letterSpacing});
}

/// @nodoc
class __$$TypographyValueImplCopyWithImpl<$Res>
    extends _$TypographyValueCopyWithImpl<$Res, _$TypographyValueImpl>
    implements _$$TypographyValueImplCopyWith<$Res> {
  __$$TypographyValueImplCopyWithImpl(
      _$TypographyValueImpl _value, $Res Function(_$TypographyValueImpl) _then)
      : super(_value, _then);

  /// Create a copy of TypographyValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fontFamily = freezed,
    Object? fontSize = null,
    Object? fontWeight = null,
    Object? lineHeight = null,
    Object? letterSpacing = null,
  }) {
    return _then(_$TypographyValueImpl(
      fontFamily: freezed == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String?,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      fontWeight: null == fontWeight
          ? _value.fontWeight
          : fontWeight // ignore: cast_nullable_to_non_nullable
              as int,
      lineHeight: null == lineHeight
          ? _value.lineHeight
          : lineHeight // ignore: cast_nullable_to_non_nullable
              as double,
      letterSpacing: null == letterSpacing
          ? _value.letterSpacing
          : letterSpacing // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypographyValueImpl implements _TypographyValue {
  const _$TypographyValueImpl(
      {this.fontFamily,
      this.fontSize = 14.0,
      this.fontWeight = 400,
      this.lineHeight = 1.5,
      this.letterSpacing = 0.0});

  factory _$TypographyValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypographyValueImplFromJson(json);

  /// Font family name.
  @override
  final String? fontFamily;

  /// Font size in logical pixels.
  @override
  @JsonKey()
  final double fontSize;

  /// Font weight (100-900).
  @override
  @JsonKey()
  final int fontWeight;

  /// Line height multiplier.
  @override
  @JsonKey()
  final double lineHeight;

  /// Letter spacing in logical pixels.
  @override
  @JsonKey()
  final double letterSpacing;

  @override
  String toString() {
    return 'TypographyValue(fontFamily: $fontFamily, fontSize: $fontSize, fontWeight: $fontWeight, lineHeight: $lineHeight, letterSpacing: $letterSpacing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypographyValueImpl &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.fontWeight, fontWeight) ||
                other.fontWeight == fontWeight) &&
            (identical(other.lineHeight, lineHeight) ||
                other.lineHeight == lineHeight) &&
            (identical(other.letterSpacing, letterSpacing) ||
                other.letterSpacing == letterSpacing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, fontFamily, fontSize, fontWeight, lineHeight, letterSpacing);

  /// Create a copy of TypographyValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TypographyValueImplCopyWith<_$TypographyValueImpl> get copyWith =>
      __$$TypographyValueImplCopyWithImpl<_$TypographyValueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypographyValueImplToJson(
      this,
    );
  }
}

abstract class _TypographyValue implements TypographyValue {
  const factory _TypographyValue(
      {final String? fontFamily,
      final double fontSize,
      final int fontWeight,
      final double lineHeight,
      final double letterSpacing}) = _$TypographyValueImpl;

  factory _TypographyValue.fromJson(Map<String, dynamic> json) =
      _$TypographyValueImpl.fromJson;

  /// Font family name.
  @override
  String? get fontFamily;

  /// Font size in logical pixels.
  @override
  double get fontSize;

  /// Font weight (100-900).
  @override
  int get fontWeight;

  /// Line height multiplier.
  @override
  double get lineHeight;

  /// Letter spacing in logical pixels.
  @override
  double get letterSpacing;

  /// Create a copy of TypographyValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TypographyValueImplCopyWith<_$TypographyValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DesignToken _$DesignTokenFromJson(Map<String, dynamic> json) {
  return _DesignToken.fromJson(json);
}

/// @nodoc
mixin _$DesignToken {
  /// Unique token identifier (UUID).
  String get id => throw _privateConstructorUsedError;

  /// Token name (e.g., 'primaryColor', 'bodyText').
  String get name => throw _privateConstructorUsedError;

  /// Token type category.
  TokenType get type => throw _privateConstructorUsedError;

  /// Value for light theme mode (int for color, double for spacing/radius).
  dynamic get lightValue => throw _privateConstructorUsedError;

  /// Value for dark theme mode (int for color).
  dynamic get darkValue => throw _privateConstructorUsedError;

  /// Typography value for typography tokens.
  TypographyValue? get typography => throw _privateConstructorUsedError;

  /// Reference to another token name if this is an alias.
  String? get aliasOf => throw _privateConstructorUsedError;

  /// Serializes this DesignToken to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DesignToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DesignTokenCopyWith<DesignToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignTokenCopyWith<$Res> {
  factory $DesignTokenCopyWith(
          DesignToken value, $Res Function(DesignToken) then) =
      _$DesignTokenCopyWithImpl<$Res, DesignToken>;
  @useResult
  $Res call(
      {String id,
      String name,
      TokenType type,
      dynamic lightValue,
      dynamic darkValue,
      TypographyValue? typography,
      String? aliasOf});

  $TypographyValueCopyWith<$Res>? get typography;
}

/// @nodoc
class _$DesignTokenCopyWithImpl<$Res, $Val extends DesignToken>
    implements $DesignTokenCopyWith<$Res> {
  _$DesignTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DesignToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? lightValue = freezed,
    Object? darkValue = freezed,
    Object? typography = freezed,
    Object? aliasOf = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TokenType,
      lightValue: freezed == lightValue
          ? _value.lightValue
          : lightValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      darkValue: freezed == darkValue
          ? _value.darkValue
          : darkValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      typography: freezed == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as TypographyValue?,
      aliasOf: freezed == aliasOf
          ? _value.aliasOf
          : aliasOf // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of DesignToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TypographyValueCopyWith<$Res>? get typography {
    if (_value.typography == null) {
      return null;
    }

    return $TypographyValueCopyWith<$Res>(_value.typography!, (value) {
      return _then(_value.copyWith(typography: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DesignTokenImplCopyWith<$Res>
    implements $DesignTokenCopyWith<$Res> {
  factory _$$DesignTokenImplCopyWith(
          _$DesignTokenImpl value, $Res Function(_$DesignTokenImpl) then) =
      __$$DesignTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      TokenType type,
      dynamic lightValue,
      dynamic darkValue,
      TypographyValue? typography,
      String? aliasOf});

  @override
  $TypographyValueCopyWith<$Res>? get typography;
}

/// @nodoc
class __$$DesignTokenImplCopyWithImpl<$Res>
    extends _$DesignTokenCopyWithImpl<$Res, _$DesignTokenImpl>
    implements _$$DesignTokenImplCopyWith<$Res> {
  __$$DesignTokenImplCopyWithImpl(
      _$DesignTokenImpl _value, $Res Function(_$DesignTokenImpl) _then)
      : super(_value, _then);

  /// Create a copy of DesignToken
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? lightValue = freezed,
    Object? darkValue = freezed,
    Object? typography = freezed,
    Object? aliasOf = freezed,
  }) {
    return _then(_$DesignTokenImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TokenType,
      lightValue: freezed == lightValue
          ? _value.lightValue
          : lightValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      darkValue: freezed == darkValue
          ? _value.darkValue
          : darkValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      typography: freezed == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as TypographyValue?,
      aliasOf: freezed == aliasOf
          ? _value.aliasOf
          : aliasOf // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DesignTokenImpl extends _DesignToken {
  const _$DesignTokenImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.lightValue,
      this.darkValue,
      this.typography,
      this.aliasOf})
      : super._();

  factory _$DesignTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$DesignTokenImplFromJson(json);

  /// Unique token identifier (UUID).
  @override
  final String id;

  /// Token name (e.g., 'primaryColor', 'bodyText').
  @override
  final String name;

  /// Token type category.
  @override
  final TokenType type;

  /// Value for light theme mode (int for color, double for spacing/radius).
  @override
  final dynamic lightValue;

  /// Value for dark theme mode (int for color).
  @override
  final dynamic darkValue;

  /// Typography value for typography tokens.
  @override
  final TypographyValue? typography;

  /// Reference to another token name if this is an alias.
  @override
  final String? aliasOf;

  @override
  String toString() {
    return 'DesignToken(id: $id, name: $name, type: $type, lightValue: $lightValue, darkValue: $darkValue, typography: $typography, aliasOf: $aliasOf)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DesignTokenImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.lightValue, lightValue) &&
            const DeepCollectionEquality().equals(other.darkValue, darkValue) &&
            (identical(other.typography, typography) ||
                other.typography == typography) &&
            (identical(other.aliasOf, aliasOf) || other.aliasOf == aliasOf));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      const DeepCollectionEquality().hash(lightValue),
      const DeepCollectionEquality().hash(darkValue),
      typography,
      aliasOf);

  /// Create a copy of DesignToken
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DesignTokenImplCopyWith<_$DesignTokenImpl> get copyWith =>
      __$$DesignTokenImplCopyWithImpl<_$DesignTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DesignTokenImplToJson(
      this,
    );
  }
}

abstract class _DesignToken extends DesignToken {
  const factory _DesignToken(
      {required final String id,
      required final String name,
      required final TokenType type,
      final dynamic lightValue,
      final dynamic darkValue,
      final TypographyValue? typography,
      final String? aliasOf}) = _$DesignTokenImpl;
  const _DesignToken._() : super._();

  factory _DesignToken.fromJson(Map<String, dynamic> json) =
      _$DesignTokenImpl.fromJson;

  /// Unique token identifier (UUID).
  @override
  String get id;

  /// Token name (e.g., 'primaryColor', 'bodyText').
  @override
  String get name;

  /// Token type category.
  @override
  TokenType get type;

  /// Value for light theme mode (int for color, double for spacing/radius).
  @override
  dynamic get lightValue;

  /// Value for dark theme mode (int for color).
  @override
  dynamic get darkValue;

  /// Typography value for typography tokens.
  @override
  TypographyValue? get typography;

  /// Reference to another token name if this is an alias.
  @override
  String? get aliasOf;

  /// Create a copy of DesignToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DesignTokenImplCopyWith<_$DesignTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

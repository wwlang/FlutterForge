// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PropertyDefinition _$PropertyDefinitionFromJson(Map<String, dynamic> json) {
  return _PropertyDefinition.fromJson(json);
}

/// @nodoc
mixin _$PropertyDefinition {
  /// Property key matching the widget's parameter name.
  String get name => throw _privateConstructorUsedError;

  /// Type of the property for editor selection.
  PropertyType get type => throw _privateConstructorUsedError;

  /// Human-readable name for display in properties panel.
  String get displayName => throw _privateConstructorUsedError;

  /// Whether the property can be null/unset.
  bool get nullable => throw _privateConstructorUsedError;

  /// Default value when creating new widget.
  dynamic get defaultValue => throw _privateConstructorUsedError;

  /// For enum_ type: list of valid enum values.
  List<String>? get enumValues => throw _privateConstructorUsedError;

  /// Category grouping for properties panel organization.
  String? get category => throw _privateConstructorUsedError;

  /// Description/tooltip text for the property.
  String? get description => throw _privateConstructorUsedError;

  /// Minimum value for numeric properties.
  double? get min => throw _privateConstructorUsedError;

  /// Maximum value for numeric properties.
  double? get max => throw _privateConstructorUsedError;

  /// Serializes this PropertyDefinition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyDefinitionCopyWith<PropertyDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyDefinitionCopyWith<$Res> {
  factory $PropertyDefinitionCopyWith(
          PropertyDefinition value, $Res Function(PropertyDefinition) then) =
      _$PropertyDefinitionCopyWithImpl<$Res, PropertyDefinition>;
  @useResult
  $Res call(
      {String name,
      PropertyType type,
      String displayName,
      bool nullable,
      dynamic defaultValue,
      List<String>? enumValues,
      String? category,
      String? description,
      double? min,
      double? max});
}

/// @nodoc
class _$PropertyDefinitionCopyWithImpl<$Res, $Val extends PropertyDefinition>
    implements $PropertyDefinitionCopyWith<$Res> {
  _$PropertyDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? displayName = null,
    Object? nullable = null,
    Object? defaultValue = freezed,
    Object? enumValues = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? min = freezed,
    Object? max = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PropertyType,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      nullable: null == nullable
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      enumValues: freezed == enumValues
          ? _value.enumValues
          : enumValues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PropertyDefinitionImplCopyWith<$Res>
    implements $PropertyDefinitionCopyWith<$Res> {
  factory _$$PropertyDefinitionImplCopyWith(_$PropertyDefinitionImpl value,
          $Res Function(_$PropertyDefinitionImpl) then) =
      __$$PropertyDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      PropertyType type,
      String displayName,
      bool nullable,
      dynamic defaultValue,
      List<String>? enumValues,
      String? category,
      String? description,
      double? min,
      double? max});
}

/// @nodoc
class __$$PropertyDefinitionImplCopyWithImpl<$Res>
    extends _$PropertyDefinitionCopyWithImpl<$Res, _$PropertyDefinitionImpl>
    implements _$$PropertyDefinitionImplCopyWith<$Res> {
  __$$PropertyDefinitionImplCopyWithImpl(_$PropertyDefinitionImpl _value,
      $Res Function(_$PropertyDefinitionImpl) _then)
      : super(_value, _then);

  /// Create a copy of PropertyDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? displayName = null,
    Object? nullable = null,
    Object? defaultValue = freezed,
    Object? enumValues = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? min = freezed,
    Object? max = freezed,
  }) {
    return _then(_$PropertyDefinitionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PropertyType,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      nullable: null == nullable
          ? _value.nullable
          : nullable // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as dynamic,
      enumValues: freezed == enumValues
          ? _value._enumValues
          : enumValues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      min: freezed == min
          ? _value.min
          : min // ignore: cast_nullable_to_non_nullable
              as double?,
      max: freezed == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyDefinitionImpl extends _PropertyDefinition {
  const _$PropertyDefinitionImpl(
      {required this.name,
      required this.type,
      required this.displayName,
      required this.nullable,
      this.defaultValue,
      final List<String>? enumValues,
      this.category,
      this.description,
      this.min,
      this.max})
      : _enumValues = enumValues,
        super._();

  factory _$PropertyDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyDefinitionImplFromJson(json);

  /// Property key matching the widget's parameter name.
  @override
  final String name;

  /// Type of the property for editor selection.
  @override
  final PropertyType type;

  /// Human-readable name for display in properties panel.
  @override
  final String displayName;

  /// Whether the property can be null/unset.
  @override
  final bool nullable;

  /// Default value when creating new widget.
  @override
  final dynamic defaultValue;

  /// For enum_ type: list of valid enum values.
  final List<String>? _enumValues;

  /// For enum_ type: list of valid enum values.
  @override
  List<String>? get enumValues {
    final value = _enumValues;
    if (value == null) return null;
    if (_enumValues is EqualUnmodifiableListView) return _enumValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Category grouping for properties panel organization.
  @override
  final String? category;

  /// Description/tooltip text for the property.
  @override
  final String? description;

  /// Minimum value for numeric properties.
  @override
  final double? min;

  /// Maximum value for numeric properties.
  @override
  final double? max;

  @override
  String toString() {
    return 'PropertyDefinition(name: $name, type: $type, displayName: $displayName, nullable: $nullable, defaultValue: $defaultValue, enumValues: $enumValues, category: $category, description: $description, min: $min, max: $max)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyDefinitionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.nullable, nullable) ||
                other.nullable == nullable) &&
            const DeepCollectionEquality()
                .equals(other.defaultValue, defaultValue) &&
            const DeepCollectionEquality()
                .equals(other._enumValues, _enumValues) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      type,
      displayName,
      nullable,
      const DeepCollectionEquality().hash(defaultValue),
      const DeepCollectionEquality().hash(_enumValues),
      category,
      description,
      min,
      max);

  /// Create a copy of PropertyDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyDefinitionImplCopyWith<_$PropertyDefinitionImpl> get copyWith =>
      __$$PropertyDefinitionImplCopyWithImpl<_$PropertyDefinitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyDefinitionImplToJson(
      this,
    );
  }
}

abstract class _PropertyDefinition extends PropertyDefinition {
  const factory _PropertyDefinition(
      {required final String name,
      required final PropertyType type,
      required final String displayName,
      required final bool nullable,
      final dynamic defaultValue,
      final List<String>? enumValues,
      final String? category,
      final String? description,
      final double? min,
      final double? max}) = _$PropertyDefinitionImpl;
  const _PropertyDefinition._() : super._();

  factory _PropertyDefinition.fromJson(Map<String, dynamic> json) =
      _$PropertyDefinitionImpl.fromJson;

  /// Property key matching the widget's parameter name.
  @override
  String get name;

  /// Type of the property for editor selection.
  @override
  PropertyType get type;

  /// Human-readable name for display in properties panel.
  @override
  String get displayName;

  /// Whether the property can be null/unset.
  @override
  bool get nullable;

  /// Default value when creating new widget.
  @override
  dynamic get defaultValue;

  /// For enum_ type: list of valid enum values.
  @override
  List<String>? get enumValues;

  /// Category grouping for properties panel organization.
  @override
  String? get category;

  /// Description/tooltip text for the property.
  @override
  String? get description;

  /// Minimum value for numeric properties.
  @override
  double? get min;

  /// Maximum value for numeric properties.
  @override
  double? get max;

  /// Create a copy of PropertyDefinition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyDefinitionImplCopyWith<_$PropertyDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

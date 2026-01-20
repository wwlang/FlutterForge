// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WidgetDefinition _$WidgetDefinitionFromJson(Map<String, dynamic> json) {
  return _WidgetDefinition.fromJson(json);
}

/// @nodoc
mixin _$WidgetDefinition {
  /// Unique widget type identifier (e.g., 'Container', 'Text').
  String get type => throw _privateConstructorUsedError;

  /// Category for palette organization.
  WidgetCategory get category => throw _privateConstructorUsedError;

  /// Human-readable name for display.
  String get displayName => throw _privateConstructorUsedError;

  /// Whether this widget can contain children.
  bool get acceptsChildren => throw _privateConstructorUsedError;

  /// Maximum number of children (null = unlimited).
  /// 0 for leaf widgets, 1 for single-child, null for multi-child.
  int? get maxChildren => throw _privateConstructorUsedError;

  /// Property definitions for this widget.
  List<PropertyDefinition> get properties => throw _privateConstructorUsedError;

  /// Optional icon name for palette display.
  String? get iconName => throw _privateConstructorUsedError;

  /// Optional description for tooltip/preview.
  String? get description => throw _privateConstructorUsedError;

  /// Import package for code generation (defaults to 'material').
  String get import_ => throw _privateConstructorUsedError;

  /// Serializes this WidgetDefinition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WidgetDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WidgetDefinitionCopyWith<WidgetDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WidgetDefinitionCopyWith<$Res> {
  factory $WidgetDefinitionCopyWith(
          WidgetDefinition value, $Res Function(WidgetDefinition) then) =
      _$WidgetDefinitionCopyWithImpl<$Res, WidgetDefinition>;
  @useResult
  $Res call(
      {String type,
      WidgetCategory category,
      String displayName,
      bool acceptsChildren,
      int? maxChildren,
      List<PropertyDefinition> properties,
      String? iconName,
      String? description,
      String import_});
}

/// @nodoc
class _$WidgetDefinitionCopyWithImpl<$Res, $Val extends WidgetDefinition>
    implements $WidgetDefinitionCopyWith<$Res> {
  _$WidgetDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WidgetDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? category = null,
    Object? displayName = null,
    Object? acceptsChildren = null,
    Object? maxChildren = freezed,
    Object? properties = null,
    Object? iconName = freezed,
    Object? description = freezed,
    Object? import_ = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as WidgetCategory,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      acceptsChildren: null == acceptsChildren
          ? _value.acceptsChildren
          : acceptsChildren // ignore: cast_nullable_to_non_nullable
              as bool,
      maxChildren: freezed == maxChildren
          ? _value.maxChildren
          : maxChildren // ignore: cast_nullable_to_non_nullable
              as int?,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as List<PropertyDefinition>,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      import_: null == import_
          ? _value.import_
          : import_ // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WidgetDefinitionImplCopyWith<$Res>
    implements $WidgetDefinitionCopyWith<$Res> {
  factory _$$WidgetDefinitionImplCopyWith(_$WidgetDefinitionImpl value,
          $Res Function(_$WidgetDefinitionImpl) then) =
      __$$WidgetDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      WidgetCategory category,
      String displayName,
      bool acceptsChildren,
      int? maxChildren,
      List<PropertyDefinition> properties,
      String? iconName,
      String? description,
      String import_});
}

/// @nodoc
class __$$WidgetDefinitionImplCopyWithImpl<$Res>
    extends _$WidgetDefinitionCopyWithImpl<$Res, _$WidgetDefinitionImpl>
    implements _$$WidgetDefinitionImplCopyWith<$Res> {
  __$$WidgetDefinitionImplCopyWithImpl(_$WidgetDefinitionImpl _value,
      $Res Function(_$WidgetDefinitionImpl) _then)
      : super(_value, _then);

  /// Create a copy of WidgetDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? category = null,
    Object? displayName = null,
    Object? acceptsChildren = null,
    Object? maxChildren = freezed,
    Object? properties = null,
    Object? iconName = freezed,
    Object? description = freezed,
    Object? import_ = null,
  }) {
    return _then(_$WidgetDefinitionImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as WidgetCategory,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      acceptsChildren: null == acceptsChildren
          ? _value.acceptsChildren
          : acceptsChildren // ignore: cast_nullable_to_non_nullable
              as bool,
      maxChildren: freezed == maxChildren
          ? _value.maxChildren
          : maxChildren // ignore: cast_nullable_to_non_nullable
              as int?,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as List<PropertyDefinition>,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      import_: null == import_
          ? _value.import_
          : import_ // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WidgetDefinitionImpl extends _WidgetDefinition {
  const _$WidgetDefinitionImpl(
      {required this.type,
      required this.category,
      required this.displayName,
      required this.acceptsChildren,
      required this.maxChildren,
      required final List<PropertyDefinition> properties,
      this.iconName,
      this.description,
      this.import_ = 'package:flutter/material.dart'})
      : _properties = properties,
        super._();

  factory _$WidgetDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$WidgetDefinitionImplFromJson(json);

  /// Unique widget type identifier (e.g., 'Container', 'Text').
  @override
  final String type;

  /// Category for palette organization.
  @override
  final WidgetCategory category;

  /// Human-readable name for display.
  @override
  final String displayName;

  /// Whether this widget can contain children.
  @override
  final bool acceptsChildren;

  /// Maximum number of children (null = unlimited).
  /// 0 for leaf widgets, 1 for single-child, null for multi-child.
  @override
  final int? maxChildren;

  /// Property definitions for this widget.
  final List<PropertyDefinition> _properties;

  /// Property definitions for this widget.
  @override
  List<PropertyDefinition> get properties {
    if (_properties is EqualUnmodifiableListView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_properties);
  }

  /// Optional icon name for palette display.
  @override
  final String? iconName;

  /// Optional description for tooltip/preview.
  @override
  final String? description;

  /// Import package for code generation (defaults to 'material').
  @override
  @JsonKey()
  final String import_;

  @override
  String toString() {
    return 'WidgetDefinition(type: $type, category: $category, displayName: $displayName, acceptsChildren: $acceptsChildren, maxChildren: $maxChildren, properties: $properties, iconName: $iconName, description: $description, import_: $import_)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WidgetDefinitionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.acceptsChildren, acceptsChildren) ||
                other.acceptsChildren == acceptsChildren) &&
            (identical(other.maxChildren, maxChildren) ||
                other.maxChildren == maxChildren) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.import_, import_) || other.import_ == import_));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      category,
      displayName,
      acceptsChildren,
      maxChildren,
      const DeepCollectionEquality().hash(_properties),
      iconName,
      description,
      import_);

  /// Create a copy of WidgetDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WidgetDefinitionImplCopyWith<_$WidgetDefinitionImpl> get copyWith =>
      __$$WidgetDefinitionImplCopyWithImpl<_$WidgetDefinitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WidgetDefinitionImplToJson(
      this,
    );
  }
}

abstract class _WidgetDefinition extends WidgetDefinition {
  const factory _WidgetDefinition(
      {required final String type,
      required final WidgetCategory category,
      required final String displayName,
      required final bool acceptsChildren,
      required final int? maxChildren,
      required final List<PropertyDefinition> properties,
      final String? iconName,
      final String? description,
      final String import_}) = _$WidgetDefinitionImpl;
  const _WidgetDefinition._() : super._();

  factory _WidgetDefinition.fromJson(Map<String, dynamic> json) =
      _$WidgetDefinitionImpl.fromJson;

  /// Unique widget type identifier (e.g., 'Container', 'Text').
  @override
  String get type;

  /// Category for palette organization.
  @override
  WidgetCategory get category;

  /// Human-readable name for display.
  @override
  String get displayName;

  /// Whether this widget can contain children.
  @override
  bool get acceptsChildren;

  /// Maximum number of children (null = unlimited).
  /// 0 for leaf widgets, 1 for single-child, null for multi-child.
  @override
  int? get maxChildren;

  /// Property definitions for this widget.
  @override
  List<PropertyDefinition> get properties;

  /// Optional icon name for palette display.
  @override
  String? get iconName;

  /// Optional description for tooltip/preview.
  @override
  String? get description;

  /// Import package for code generation (defaults to 'material').
  @override
  String get import_;

  /// Create a copy of WidgetDefinition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WidgetDefinitionImplCopyWith<_$WidgetDefinitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

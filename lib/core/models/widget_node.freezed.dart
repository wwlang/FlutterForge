// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WidgetNode _$WidgetNodeFromJson(Map<String, dynamic> json) {
  return _WidgetNode.fromJson(json);
}

/// @nodoc
mixin _$WidgetNode {
  /// Unique identifier for this node (UUID).
  String get id => throw _privateConstructorUsedError;

  /// Widget type matching a registered definition.
  /// Examples: 'Container', 'Row', 'Column', 'Text'.
  String get type => throw _privateConstructorUsedError;

  /// Widget properties keyed by property name.
  /// Values are dynamic to support different property types.
  Map<String, dynamic> get properties => throw _privateConstructorUsedError;

  /// IDs of child nodes (normalized reference model).
  /// Empty for leaf widgets like Text or Icon.
  List<String> get childrenIds => throw _privateConstructorUsedError;

  /// ID of parent node, null for root.
  String? get parentId => throw _privateConstructorUsedError;

  /// ID of the style preset applied to this widget.
  /// Null if no preset is applied.
  String? get appliedPresetId => throw _privateConstructorUsedError;

  /// List of property names that have been overridden from the preset.
  /// Only meaningful when appliedPresetId is set.
  List<String> get propertyOverrides => throw _privateConstructorUsedError;

  /// Serializes this WidgetNode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WidgetNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WidgetNodeCopyWith<WidgetNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WidgetNodeCopyWith<$Res> {
  factory $WidgetNodeCopyWith(
          WidgetNode value, $Res Function(WidgetNode) then) =
      _$WidgetNodeCopyWithImpl<$Res, WidgetNode>;
  @useResult
  $Res call(
      {String id,
      String type,
      Map<String, dynamic> properties,
      List<String> childrenIds,
      String? parentId,
      String? appliedPresetId,
      List<String> propertyOverrides});
}

/// @nodoc
class _$WidgetNodeCopyWithImpl<$Res, $Val extends WidgetNode>
    implements $WidgetNodeCopyWith<$Res> {
  _$WidgetNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WidgetNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? properties = null,
    Object? childrenIds = null,
    Object? parentId = freezed,
    Object? appliedPresetId = freezed,
    Object? propertyOverrides = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      childrenIds: null == childrenIds
          ? _value.childrenIds
          : childrenIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedPresetId: freezed == appliedPresetId
          ? _value.appliedPresetId
          : appliedPresetId // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyOverrides: null == propertyOverrides
          ? _value.propertyOverrides
          : propertyOverrides // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WidgetNodeImplCopyWith<$Res>
    implements $WidgetNodeCopyWith<$Res> {
  factory _$$WidgetNodeImplCopyWith(
          _$WidgetNodeImpl value, $Res Function(_$WidgetNodeImpl) then) =
      __$$WidgetNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      Map<String, dynamic> properties,
      List<String> childrenIds,
      String? parentId,
      String? appliedPresetId,
      List<String> propertyOverrides});
}

/// @nodoc
class __$$WidgetNodeImplCopyWithImpl<$Res>
    extends _$WidgetNodeCopyWithImpl<$Res, _$WidgetNodeImpl>
    implements _$$WidgetNodeImplCopyWith<$Res> {
  __$$WidgetNodeImplCopyWithImpl(
      _$WidgetNodeImpl _value, $Res Function(_$WidgetNodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of WidgetNode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? properties = null,
    Object? childrenIds = null,
    Object? parentId = freezed,
    Object? appliedPresetId = freezed,
    Object? propertyOverrides = null,
  }) {
    return _then(_$WidgetNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      childrenIds: null == childrenIds
          ? _value._childrenIds
          : childrenIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      appliedPresetId: freezed == appliedPresetId
          ? _value.appliedPresetId
          : appliedPresetId // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyOverrides: null == propertyOverrides
          ? _value._propertyOverrides
          : propertyOverrides // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WidgetNodeImpl implements _WidgetNode {
  const _$WidgetNodeImpl(
      {required this.id,
      required this.type,
      required final Map<String, dynamic> properties,
      final List<String> childrenIds = const <String>[],
      this.parentId,
      this.appliedPresetId,
      final List<String> propertyOverrides = const <String>[]})
      : _properties = properties,
        _childrenIds = childrenIds,
        _propertyOverrides = propertyOverrides;

  factory _$WidgetNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$WidgetNodeImplFromJson(json);

  /// Unique identifier for this node (UUID).
  @override
  final String id;

  /// Widget type matching a registered definition.
  /// Examples: 'Container', 'Row', 'Column', 'Text'.
  @override
  final String type;

  /// Widget properties keyed by property name.
  /// Values are dynamic to support different property types.
  final Map<String, dynamic> _properties;

  /// Widget properties keyed by property name.
  /// Values are dynamic to support different property types.
  @override
  Map<String, dynamic> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

  /// IDs of child nodes (normalized reference model).
  /// Empty for leaf widgets like Text or Icon.
  final List<String> _childrenIds;

  /// IDs of child nodes (normalized reference model).
  /// Empty for leaf widgets like Text or Icon.
  @override
  @JsonKey()
  List<String> get childrenIds {
    if (_childrenIds is EqualUnmodifiableListView) return _childrenIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childrenIds);
  }

  /// ID of parent node, null for root.
  @override
  final String? parentId;

  /// ID of the style preset applied to this widget.
  /// Null if no preset is applied.
  @override
  final String? appliedPresetId;

  /// List of property names that have been overridden from the preset.
  /// Only meaningful when appliedPresetId is set.
  final List<String> _propertyOverrides;

  /// List of property names that have been overridden from the preset.
  /// Only meaningful when appliedPresetId is set.
  @override
  @JsonKey()
  List<String> get propertyOverrides {
    if (_propertyOverrides is EqualUnmodifiableListView)
      return _propertyOverrides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_propertyOverrides);
  }

  @override
  String toString() {
    return 'WidgetNode(id: $id, type: $type, properties: $properties, childrenIds: $childrenIds, parentId: $parentId, appliedPresetId: $appliedPresetId, propertyOverrides: $propertyOverrides)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WidgetNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            const DeepCollectionEquality()
                .equals(other._childrenIds, _childrenIds) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.appliedPresetId, appliedPresetId) ||
                other.appliedPresetId == appliedPresetId) &&
            const DeepCollectionEquality()
                .equals(other._propertyOverrides, _propertyOverrides));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      const DeepCollectionEquality().hash(_properties),
      const DeepCollectionEquality().hash(_childrenIds),
      parentId,
      appliedPresetId,
      const DeepCollectionEquality().hash(_propertyOverrides));

  /// Create a copy of WidgetNode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WidgetNodeImplCopyWith<_$WidgetNodeImpl> get copyWith =>
      __$$WidgetNodeImplCopyWithImpl<_$WidgetNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WidgetNodeImplToJson(
      this,
    );
  }
}

abstract class _WidgetNode implements WidgetNode {
  const factory _WidgetNode(
      {required final String id,
      required final String type,
      required final Map<String, dynamic> properties,
      final List<String> childrenIds,
      final String? parentId,
      final String? appliedPresetId,
      final List<String> propertyOverrides}) = _$WidgetNodeImpl;

  factory _WidgetNode.fromJson(Map<String, dynamic> json) =
      _$WidgetNodeImpl.fromJson;

  /// Unique identifier for this node (UUID).
  @override
  String get id;

  /// Widget type matching a registered definition.
  /// Examples: 'Container', 'Row', 'Column', 'Text'.
  @override
  String get type;

  /// Widget properties keyed by property name.
  /// Values are dynamic to support different property types.
  @override
  Map<String, dynamic> get properties;

  /// IDs of child nodes (normalized reference model).
  /// Empty for leaf widgets like Text or Icon.
  @override
  List<String> get childrenIds;

  /// ID of parent node, null for root.
  @override
  String? get parentId;

  /// ID of the style preset applied to this widget.
  /// Null if no preset is applied.
  @override
  String? get appliedPresetId;

  /// List of property names that have been overridden from the preset.
  /// Only meaningful when appliedPresetId is set.
  @override
  List<String> get propertyOverrides;

  /// Create a copy of WidgetNode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WidgetNodeImplCopyWith<_$WidgetNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

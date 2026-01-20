// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectState _$ProjectStateFromJson(Map<String, dynamic> json) {
  return _ProjectState.fromJson(json);
}

/// @nodoc
mixin _$ProjectState {
  /// All widget nodes keyed by ID for O(1) lookup.
  Map<String, WidgetNode> get nodes => throw _privateConstructorUsedError;

  /// IDs of root-level nodes in the widget tree.
  /// Supports multiple root widgets for Phase 1 simplicity.
  List<String> get rootIds => throw _privateConstructorUsedError;

  /// Currently selected node IDs.
  Set<String> get selection => throw _privateConstructorUsedError;

  /// Current zoom level (1.0 = 100%).
  double get zoomLevel => throw _privateConstructorUsedError;

  /// Current pan offset from origin.
  @OffsetConverter()
  Offset get panOffset => throw _privateConstructorUsedError;

  /// Serializes this ProjectState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectStateCopyWith<ProjectState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectStateCopyWith<$Res> {
  factory $ProjectStateCopyWith(
          ProjectState value, $Res Function(ProjectState) then) =
      _$ProjectStateCopyWithImpl<$Res, ProjectState>;
  @useResult
  $Res call(
      {Map<String, WidgetNode> nodes,
      List<String> rootIds,
      Set<String> selection,
      double zoomLevel,
      @OffsetConverter() Offset panOffset});
}

/// @nodoc
class _$ProjectStateCopyWithImpl<$Res, $Val extends ProjectState>
    implements $ProjectStateCopyWith<$Res> {
  _$ProjectStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? rootIds = null,
    Object? selection = null,
    Object? zoomLevel = null,
    Object? panOffset = null,
  }) {
    return _then(_value.copyWith(
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, WidgetNode>,
      rootIds: null == rootIds
          ? _value.rootIds
          : rootIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selection: null == selection
          ? _value.selection
          : selection // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _value.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectStateImplCopyWith<$Res>
    implements $ProjectStateCopyWith<$Res> {
  factory _$$ProjectStateImplCopyWith(
          _$ProjectStateImpl value, $Res Function(_$ProjectStateImpl) then) =
      __$$ProjectStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, WidgetNode> nodes,
      List<String> rootIds,
      Set<String> selection,
      double zoomLevel,
      @OffsetConverter() Offset panOffset});
}

/// @nodoc
class __$$ProjectStateImplCopyWithImpl<$Res>
    extends _$ProjectStateCopyWithImpl<$Res, _$ProjectStateImpl>
    implements _$$ProjectStateImplCopyWith<$Res> {
  __$$ProjectStateImplCopyWithImpl(
      _$ProjectStateImpl _value, $Res Function(_$ProjectStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nodes = null,
    Object? rootIds = null,
    Object? selection = null,
    Object? zoomLevel = null,
    Object? panOffset = null,
  }) {
    return _then(_$ProjectStateImpl(
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, WidgetNode>,
      rootIds: null == rootIds
          ? _value._rootIds
          : rootIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selection: null == selection
          ? _value._selection
          : selection // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _value.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectStateImpl implements _ProjectState {
  const _$ProjectStateImpl(
      {final Map<String, WidgetNode> nodes = const <String, WidgetNode>{},
      final List<String> rootIds = const <String>[],
      final Set<String> selection = const <String>{},
      this.zoomLevel = 1.0,
      @OffsetConverter() this.panOffset = Offset.zero})
      : _nodes = nodes,
        _rootIds = rootIds,
        _selection = selection;

  factory _$ProjectStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectStateImplFromJson(json);

  /// All widget nodes keyed by ID for O(1) lookup.
  final Map<String, WidgetNode> _nodes;

  /// All widget nodes keyed by ID for O(1) lookup.
  @override
  @JsonKey()
  Map<String, WidgetNode> get nodes {
    if (_nodes is EqualUnmodifiableMapView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nodes);
  }

  /// IDs of root-level nodes in the widget tree.
  /// Supports multiple root widgets for Phase 1 simplicity.
  final List<String> _rootIds;

  /// IDs of root-level nodes in the widget tree.
  /// Supports multiple root widgets for Phase 1 simplicity.
  @override
  @JsonKey()
  List<String> get rootIds {
    if (_rootIds is EqualUnmodifiableListView) return _rootIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rootIds);
  }

  /// Currently selected node IDs.
  final Set<String> _selection;

  /// Currently selected node IDs.
  @override
  @JsonKey()
  Set<String> get selection {
    if (_selection is EqualUnmodifiableSetView) return _selection;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selection);
  }

  /// Current zoom level (1.0 = 100%).
  @override
  @JsonKey()
  final double zoomLevel;

  /// Current pan offset from origin.
  @override
  @JsonKey()
  @OffsetConverter()
  final Offset panOffset;

  @override
  String toString() {
    return 'ProjectState(nodes: $nodes, rootIds: $rootIds, selection: $selection, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectStateImpl &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._rootIds, _rootIds) &&
            const DeepCollectionEquality()
                .equals(other._selection, _selection) &&
            (identical(other.zoomLevel, zoomLevel) ||
                other.zoomLevel == zoomLevel) &&
            (identical(other.panOffset, panOffset) ||
                other.panOffset == panOffset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_rootIds),
      const DeepCollectionEquality().hash(_selection),
      zoomLevel,
      panOffset);

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectStateImplCopyWith<_$ProjectStateImpl> get copyWith =>
      __$$ProjectStateImplCopyWithImpl<_$ProjectStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectStateImplToJson(
      this,
    );
  }
}

abstract class _ProjectState implements ProjectState {
  const factory _ProjectState(
      {final Map<String, WidgetNode> nodes,
      final List<String> rootIds,
      final Set<String> selection,
      final double zoomLevel,
      @OffsetConverter() final Offset panOffset}) = _$ProjectStateImpl;

  factory _ProjectState.fromJson(Map<String, dynamic> json) =
      _$ProjectStateImpl.fromJson;

  /// All widget nodes keyed by ID for O(1) lookup.
  @override
  Map<String, WidgetNode> get nodes;

  /// IDs of root-level nodes in the widget tree.
  /// Supports multiple root widgets for Phase 1 simplicity.
  @override
  List<String> get rootIds;

  /// Currently selected node IDs.
  @override
  Set<String> get selection;

  /// Current zoom level (1.0 = 100%).
  @override
  double get zoomLevel;

  /// Current pan offset from origin.
  @override
  @OffsetConverter()
  Offset get panOffset;

  /// Create a copy of ProjectState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectStateImplCopyWith<_$ProjectStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forge_project.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForgeProject _$ForgeProjectFromJson(Map<String, dynamic> json) {
  return _ForgeProject.fromJson(json);
}

/// @nodoc
mixin _$ForgeProject {
  /// Unique project identifier (UUID).
  String get id => throw _privateConstructorUsedError;

  /// User-provided project name.
  String get name => throw _privateConstructorUsedError;

  /// List of screen definitions in this project.
  List<ScreenDefinition> get screens => throw _privateConstructorUsedError;

  /// Project metadata (creation date, version, etc.).
  ProjectMetadata get metadata => throw _privateConstructorUsedError;

  /// Design tokens for theming (colors, typography, spacing).
  List<DesignToken> get designTokens => throw _privateConstructorUsedError;

  /// Serializes this ForgeProject to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgeProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgeProjectCopyWith<ForgeProject> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgeProjectCopyWith<$Res> {
  factory $ForgeProjectCopyWith(
          ForgeProject value, $Res Function(ForgeProject) then) =
      _$ForgeProjectCopyWithImpl<$Res, ForgeProject>;
  @useResult
  $Res call(
      {String id,
      String name,
      List<ScreenDefinition> screens,
      ProjectMetadata metadata,
      List<DesignToken> designTokens});

  $ProjectMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$ForgeProjectCopyWithImpl<$Res, $Val extends ForgeProject>
    implements $ForgeProjectCopyWith<$Res> {
  _$ForgeProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgeProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? screens = null,
    Object? metadata = null,
    Object? designTokens = null,
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
      screens: null == screens
          ? _value.screens
          : screens // ignore: cast_nullable_to_non_nullable
              as List<ScreenDefinition>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ProjectMetadata,
      designTokens: null == designTokens
          ? _value.designTokens
          : designTokens // ignore: cast_nullable_to_non_nullable
              as List<DesignToken>,
    ) as $Val);
  }

  /// Create a copy of ForgeProject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectMetadataCopyWith<$Res> get metadata {
    return $ProjectMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ForgeProjectImplCopyWith<$Res>
    implements $ForgeProjectCopyWith<$Res> {
  factory _$$ForgeProjectImplCopyWith(
          _$ForgeProjectImpl value, $Res Function(_$ForgeProjectImpl) then) =
      __$$ForgeProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      List<ScreenDefinition> screens,
      ProjectMetadata metadata,
      List<DesignToken> designTokens});

  @override
  $ProjectMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$ForgeProjectImplCopyWithImpl<$Res>
    extends _$ForgeProjectCopyWithImpl<$Res, _$ForgeProjectImpl>
    implements _$$ForgeProjectImplCopyWith<$Res> {
  __$$ForgeProjectImplCopyWithImpl(
      _$ForgeProjectImpl _value, $Res Function(_$ForgeProjectImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgeProject
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? screens = null,
    Object? metadata = null,
    Object? designTokens = null,
  }) {
    return _then(_$ForgeProjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      screens: null == screens
          ? _value._screens
          : screens // ignore: cast_nullable_to_non_nullable
              as List<ScreenDefinition>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as ProjectMetadata,
      designTokens: null == designTokens
          ? _value._designTokens
          : designTokens // ignore: cast_nullable_to_non_nullable
              as List<DesignToken>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgeProjectImpl implements _ForgeProject {
  const _$ForgeProjectImpl(
      {required this.id,
      required this.name,
      required final List<ScreenDefinition> screens,
      required this.metadata,
      final List<DesignToken> designTokens = const <DesignToken>[]})
      : _screens = screens,
        _designTokens = designTokens;

  factory _$ForgeProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgeProjectImplFromJson(json);

  /// Unique project identifier (UUID).
  @override
  final String id;

  /// User-provided project name.
  @override
  final String name;

  /// List of screen definitions in this project.
  final List<ScreenDefinition> _screens;

  /// List of screen definitions in this project.
  @override
  List<ScreenDefinition> get screens {
    if (_screens is EqualUnmodifiableListView) return _screens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_screens);
  }

  /// Project metadata (creation date, version, etc.).
  @override
  final ProjectMetadata metadata;

  /// Design tokens for theming (colors, typography, spacing).
  final List<DesignToken> _designTokens;

  /// Design tokens for theming (colors, typography, spacing).
  @override
  @JsonKey()
  List<DesignToken> get designTokens {
    if (_designTokens is EqualUnmodifiableListView) return _designTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_designTokens);
  }

  @override
  String toString() {
    return 'ForgeProject(id: $id, name: $name, screens: $screens, metadata: $metadata, designTokens: $designTokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgeProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._screens, _screens) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            const DeepCollectionEquality()
                .equals(other._designTokens, _designTokens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_screens),
      metadata,
      const DeepCollectionEquality().hash(_designTokens));

  /// Create a copy of ForgeProject
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgeProjectImplCopyWith<_$ForgeProjectImpl> get copyWith =>
      __$$ForgeProjectImplCopyWithImpl<_$ForgeProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgeProjectImplToJson(
      this,
    );
  }
}

abstract class _ForgeProject implements ForgeProject {
  const factory _ForgeProject(
      {required final String id,
      required final String name,
      required final List<ScreenDefinition> screens,
      required final ProjectMetadata metadata,
      final List<DesignToken> designTokens}) = _$ForgeProjectImpl;

  factory _ForgeProject.fromJson(Map<String, dynamic> json) =
      _$ForgeProjectImpl.fromJson;

  /// Unique project identifier (UUID).
  @override
  String get id;

  /// User-provided project name.
  @override
  String get name;

  /// List of screen definitions in this project.
  @override
  List<ScreenDefinition> get screens;

  /// Project metadata (creation date, version, etc.).
  @override
  ProjectMetadata get metadata;

  /// Design tokens for theming (colors, typography, spacing).
  @override
  List<DesignToken> get designTokens;

  /// Create a copy of ForgeProject
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgeProjectImplCopyWith<_$ForgeProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScreenDefinition _$ScreenDefinitionFromJson(Map<String, dynamic> json) {
  return _ScreenDefinition.fromJson(json);
}

/// @nodoc
mixin _$ScreenDefinition {
  /// Unique screen identifier (UUID).
  String get id => throw _privateConstructorUsedError;

  /// Screen name used for generated class name.
  String get name => throw _privateConstructorUsedError;

  /// ID of the root widget node for this screen.
  String get rootNodeId => throw _privateConstructorUsedError;

  /// All widget nodes for this screen, keyed by ID.
  /// Normalized map for O(1) access.
  Map<String, dynamic> get nodes => throw _privateConstructorUsedError;

  /// Serializes this ScreenDefinition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScreenDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScreenDefinitionCopyWith<ScreenDefinition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenDefinitionCopyWith<$Res> {
  factory $ScreenDefinitionCopyWith(
          ScreenDefinition value, $Res Function(ScreenDefinition) then) =
      _$ScreenDefinitionCopyWithImpl<$Res, ScreenDefinition>;
  @useResult
  $Res call(
      {String id, String name, String rootNodeId, Map<String, dynamic> nodes});
}

/// @nodoc
class _$ScreenDefinitionCopyWithImpl<$Res, $Val extends ScreenDefinition>
    implements $ScreenDefinitionCopyWith<$Res> {
  _$ScreenDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScreenDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rootNodeId = null,
    Object? nodes = null,
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
      rootNodeId: null == rootNodeId
          ? _value.rootNodeId
          : rootNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScreenDefinitionImplCopyWith<$Res>
    implements $ScreenDefinitionCopyWith<$Res> {
  factory _$$ScreenDefinitionImplCopyWith(_$ScreenDefinitionImpl value,
          $Res Function(_$ScreenDefinitionImpl) then) =
      __$$ScreenDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, String rootNodeId, Map<String, dynamic> nodes});
}

/// @nodoc
class __$$ScreenDefinitionImplCopyWithImpl<$Res>
    extends _$ScreenDefinitionCopyWithImpl<$Res, _$ScreenDefinitionImpl>
    implements _$$ScreenDefinitionImplCopyWith<$Res> {
  __$$ScreenDefinitionImplCopyWithImpl(_$ScreenDefinitionImpl _value,
      $Res Function(_$ScreenDefinitionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScreenDefinition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rootNodeId = null,
    Object? nodes = null,
  }) {
    return _then(_$ScreenDefinitionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      rootNodeId: null == rootNodeId
          ? _value.rootNodeId
          : rootNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScreenDefinitionImpl implements _ScreenDefinition {
  const _$ScreenDefinitionImpl(
      {required this.id,
      required this.name,
      required this.rootNodeId,
      required final Map<String, dynamic> nodes})
      : _nodes = nodes;

  factory _$ScreenDefinitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScreenDefinitionImplFromJson(json);

  /// Unique screen identifier (UUID).
  @override
  final String id;

  /// Screen name used for generated class name.
  @override
  final String name;

  /// ID of the root widget node for this screen.
  @override
  final String rootNodeId;

  /// All widget nodes for this screen, keyed by ID.
  /// Normalized map for O(1) access.
  final Map<String, dynamic> _nodes;

  /// All widget nodes for this screen, keyed by ID.
  /// Normalized map for O(1) access.
  @override
  Map<String, dynamic> get nodes {
    if (_nodes is EqualUnmodifiableMapView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nodes);
  }

  @override
  String toString() {
    return 'ScreenDefinition(id: $id, name: $name, rootNodeId: $rootNodeId, nodes: $nodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScreenDefinitionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rootNodeId, rootNodeId) ||
                other.rootNodeId == rootNodeId) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, rootNodeId,
      const DeepCollectionEquality().hash(_nodes));

  /// Create a copy of ScreenDefinition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScreenDefinitionImplCopyWith<_$ScreenDefinitionImpl> get copyWith =>
      __$$ScreenDefinitionImplCopyWithImpl<_$ScreenDefinitionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScreenDefinitionImplToJson(
      this,
    );
  }
}

abstract class _ScreenDefinition implements ScreenDefinition {
  const factory _ScreenDefinition(
      {required final String id,
      required final String name,
      required final String rootNodeId,
      required final Map<String, dynamic> nodes}) = _$ScreenDefinitionImpl;

  factory _ScreenDefinition.fromJson(Map<String, dynamic> json) =
      _$ScreenDefinitionImpl.fromJson;

  /// Unique screen identifier (UUID).
  @override
  String get id;

  /// Screen name used for generated class name.
  @override
  String get name;

  /// ID of the root widget node for this screen.
  @override
  String get rootNodeId;

  /// All widget nodes for this screen, keyed by ID.
  /// Normalized map for O(1) access.
  @override
  Map<String, dynamic> get nodes;

  /// Create a copy of ScreenDefinition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScreenDefinitionImplCopyWith<_$ScreenDefinitionImpl> get copyWith =>
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

  /// Value for light theme mode.
  dynamic get valueLight => throw _privateConstructorUsedError;

  /// Value for dark theme mode.
  dynamic get valueDark => throw _privateConstructorUsedError;

  /// Optional semantic alias (e.g., 'blue-500' -> 'primaryBrand').
  String? get alias => throw _privateConstructorUsedError;

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
      dynamic valueLight,
      dynamic valueDark,
      String? alias});
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
    Object? valueLight = freezed,
    Object? valueDark = freezed,
    Object? alias = freezed,
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
      valueLight: freezed == valueLight
          ? _value.valueLight
          : valueLight // ignore: cast_nullable_to_non_nullable
              as dynamic,
      valueDark: freezed == valueDark
          ? _value.valueDark
          : valueDark // ignore: cast_nullable_to_non_nullable
              as dynamic,
      alias: freezed == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
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
      dynamic valueLight,
      dynamic valueDark,
      String? alias});
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
    Object? valueLight = freezed,
    Object? valueDark = freezed,
    Object? alias = freezed,
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
      valueLight: freezed == valueLight
          ? _value.valueLight
          : valueLight // ignore: cast_nullable_to_non_nullable
              as dynamic,
      valueDark: freezed == valueDark
          ? _value.valueDark
          : valueDark // ignore: cast_nullable_to_non_nullable
              as dynamic,
      alias: freezed == alias
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DesignTokenImpl implements _DesignToken {
  const _$DesignTokenImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.valueLight,
      required this.valueDark,
      this.alias});

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

  /// Value for light theme mode.
  @override
  final dynamic valueLight;

  /// Value for dark theme mode.
  @override
  final dynamic valueDark;

  /// Optional semantic alias (e.g., 'blue-500' -> 'primaryBrand').
  @override
  final String? alias;

  @override
  String toString() {
    return 'DesignToken(id: $id, name: $name, type: $type, valueLight: $valueLight, valueDark: $valueDark, alias: $alias)';
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
                .equals(other.valueLight, valueLight) &&
            const DeepCollectionEquality().equals(other.valueDark, valueDark) &&
            (identical(other.alias, alias) || other.alias == alias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      const DeepCollectionEquality().hash(valueLight),
      const DeepCollectionEquality().hash(valueDark),
      alias);

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

abstract class _DesignToken implements DesignToken {
  const factory _DesignToken(
      {required final String id,
      required final String name,
      required final TokenType type,
      required final dynamic valueLight,
      required final dynamic valueDark,
      final String? alias}) = _$DesignTokenImpl;

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

  /// Value for light theme mode.
  @override
  dynamic get valueLight;

  /// Value for dark theme mode.
  @override
  dynamic get valueDark;

  /// Optional semantic alias (e.g., 'blue-500' -> 'primaryBrand').
  @override
  String? get alias;

  /// Create a copy of DesignToken
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DesignTokenImplCopyWith<_$DesignTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectMetadata _$ProjectMetadataFromJson(Map<String, dynamic> json) {
  return _ProjectMetadata.fromJson(json);
}

/// @nodoc
mixin _$ProjectMetadata {
  /// Project creation timestamp.
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last modification timestamp.
  DateTime get modifiedAt => throw _privateConstructorUsedError;

  /// FlutterForge version used to create/edit this project.
  String get forgeVersion => throw _privateConstructorUsedError;

  /// Optional project description.
  String? get description => throw _privateConstructorUsedError;

  /// Target Flutter SDK version for generated code.
  String get flutterSdkVersion => throw _privateConstructorUsedError;

  /// Serializes this ProjectMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectMetadataCopyWith<ProjectMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectMetadataCopyWith<$Res> {
  factory $ProjectMetadataCopyWith(
          ProjectMetadata value, $Res Function(ProjectMetadata) then) =
      _$ProjectMetadataCopyWithImpl<$Res, ProjectMetadata>;
  @useResult
  $Res call(
      {DateTime createdAt,
      DateTime modifiedAt,
      String forgeVersion,
      String? description,
      String flutterSdkVersion});
}

/// @nodoc
class _$ProjectMetadataCopyWithImpl<$Res, $Val extends ProjectMetadata>
    implements $ProjectMetadataCopyWith<$Res> {
  _$ProjectMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? modifiedAt = null,
    Object? forgeVersion = null,
    Object? description = freezed,
    Object? flutterSdkVersion = null,
  }) {
    return _then(_value.copyWith(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: null == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      forgeVersion: null == forgeVersion
          ? _value.forgeVersion
          : forgeVersion // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      flutterSdkVersion: null == flutterSdkVersion
          ? _value.flutterSdkVersion
          : flutterSdkVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectMetadataImplCopyWith<$Res>
    implements $ProjectMetadataCopyWith<$Res> {
  factory _$$ProjectMetadataImplCopyWith(_$ProjectMetadataImpl value,
          $Res Function(_$ProjectMetadataImpl) then) =
      __$$ProjectMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime createdAt,
      DateTime modifiedAt,
      String forgeVersion,
      String? description,
      String flutterSdkVersion});
}

/// @nodoc
class __$$ProjectMetadataImplCopyWithImpl<$Res>
    extends _$ProjectMetadataCopyWithImpl<$Res, _$ProjectMetadataImpl>
    implements _$$ProjectMetadataImplCopyWith<$Res> {
  __$$ProjectMetadataImplCopyWithImpl(
      _$ProjectMetadataImpl _value, $Res Function(_$ProjectMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? modifiedAt = null,
    Object? forgeVersion = null,
    Object? description = freezed,
    Object? flutterSdkVersion = null,
  }) {
    return _then(_$ProjectMetadataImpl(
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      modifiedAt: null == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      forgeVersion: null == forgeVersion
          ? _value.forgeVersion
          : forgeVersion // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      flutterSdkVersion: null == flutterSdkVersion
          ? _value.flutterSdkVersion
          : flutterSdkVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectMetadataImpl implements _ProjectMetadata {
  const _$ProjectMetadataImpl(
      {required this.createdAt,
      required this.modifiedAt,
      required this.forgeVersion,
      this.description,
      this.flutterSdkVersion = '3.19.0'});

  factory _$ProjectMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectMetadataImplFromJson(json);

  /// Project creation timestamp.
  @override
  final DateTime createdAt;

  /// Last modification timestamp.
  @override
  final DateTime modifiedAt;

  /// FlutterForge version used to create/edit this project.
  @override
  final String forgeVersion;

  /// Optional project description.
  @override
  final String? description;

  /// Target Flutter SDK version for generated code.
  @override
  @JsonKey()
  final String flutterSdkVersion;

  @override
  String toString() {
    return 'ProjectMetadata(createdAt: $createdAt, modifiedAt: $modifiedAt, forgeVersion: $forgeVersion, description: $description, flutterSdkVersion: $flutterSdkVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMetadataImpl &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt) &&
            (identical(other.forgeVersion, forgeVersion) ||
                other.forgeVersion == forgeVersion) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.flutterSdkVersion, flutterSdkVersion) ||
                other.flutterSdkVersion == flutterSdkVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, createdAt, modifiedAt,
      forgeVersion, description, flutterSdkVersion);

  /// Create a copy of ProjectMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectMetadataImplCopyWith<_$ProjectMetadataImpl> get copyWith =>
      __$$ProjectMetadataImplCopyWithImpl<_$ProjectMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectMetadataImplToJson(
      this,
    );
  }
}

abstract class _ProjectMetadata implements ProjectMetadata {
  const factory _ProjectMetadata(
      {required final DateTime createdAt,
      required final DateTime modifiedAt,
      required final String forgeVersion,
      final String? description,
      final String flutterSdkVersion}) = _$ProjectMetadataImpl;

  factory _ProjectMetadata.fromJson(Map<String, dynamic> json) =
      _$ProjectMetadataImpl.fromJson;

  /// Project creation timestamp.
  @override
  DateTime get createdAt;

  /// Last modification timestamp.
  @override
  DateTime get modifiedAt;

  /// FlutterForge version used to create/edit this project.
  @override
  String get forgeVersion;

  /// Optional project description.
  @override
  String? get description;

  /// Target Flutter SDK version for generated code.
  @override
  String get flutterSdkVersion;

  /// Create a copy of ProjectMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectMetadataImplCopyWith<_$ProjectMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

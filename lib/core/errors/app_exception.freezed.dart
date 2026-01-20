// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppException {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
          AppException value, $Res Function(AppException) then) =
      _$AppExceptionCopyWithImpl<$Res, AppException>;
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res, $Val extends AppException>
    implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FileNotFoundExceptionImplCopyWith<$Res> {
  factory _$$FileNotFoundExceptionImplCopyWith(
          _$FileNotFoundExceptionImpl value,
          $Res Function(_$FileNotFoundExceptionImpl) then) =
      __$$FileNotFoundExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String path});
}

/// @nodoc
class __$$FileNotFoundExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$FileNotFoundExceptionImpl>
    implements _$$FileNotFoundExceptionImplCopyWith<$Res> {
  __$$FileNotFoundExceptionImplCopyWithImpl(_$FileNotFoundExceptionImpl _value,
      $Res Function(_$FileNotFoundExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
  }) {
    return _then(_$FileNotFoundExceptionImpl(
      null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FileNotFoundExceptionImpl implements FileNotFoundException {
  const _$FileNotFoundExceptionImpl(this.path);

  @override
  final String path;

  @override
  String toString() {
    return 'AppException.fileNotFound(path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileNotFoundExceptionImpl &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileNotFoundExceptionImplCopyWith<_$FileNotFoundExceptionImpl>
      get copyWith => __$$FileNotFoundExceptionImplCopyWithImpl<
          _$FileNotFoundExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) {
    return fileNotFound(path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) {
    return fileNotFound?.call(path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) {
    if (fileNotFound != null) {
      return fileNotFound(path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) {
    return fileNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) {
    return fileNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) {
    if (fileNotFound != null) {
      return fileNotFound(this);
    }
    return orElse();
  }
}

abstract class FileNotFoundException implements AppException {
  const factory FileNotFoundException(final String path) =
      _$FileNotFoundExceptionImpl;

  String get path;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileNotFoundExceptionImplCopyWith<_$FileNotFoundExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilePermissionExceptionImplCopyWith<$Res> {
  factory _$$FilePermissionExceptionImplCopyWith(
          _$FilePermissionExceptionImpl value,
          $Res Function(_$FilePermissionExceptionImpl) then) =
      __$$FilePermissionExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String path});
}

/// @nodoc
class __$$FilePermissionExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$FilePermissionExceptionImpl>
    implements _$$FilePermissionExceptionImplCopyWith<$Res> {
  __$$FilePermissionExceptionImplCopyWithImpl(
      _$FilePermissionExceptionImpl _value,
      $Res Function(_$FilePermissionExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
  }) {
    return _then(_$FilePermissionExceptionImpl(
      null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FilePermissionExceptionImpl implements FilePermissionException {
  const _$FilePermissionExceptionImpl(this.path);

  @override
  final String path;

  @override
  String toString() {
    return 'AppException.filePermission(path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilePermissionExceptionImpl &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilePermissionExceptionImplCopyWith<_$FilePermissionExceptionImpl>
      get copyWith => __$$FilePermissionExceptionImplCopyWithImpl<
          _$FilePermissionExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) {
    return filePermission(path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) {
    return filePermission?.call(path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) {
    if (filePermission != null) {
      return filePermission(path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) {
    return filePermission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) {
    return filePermission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) {
    if (filePermission != null) {
      return filePermission(this);
    }
    return orElse();
  }
}

abstract class FilePermissionException implements AppException {
  const factory FilePermissionException(final String path) =
      _$FilePermissionExceptionImpl;

  String get path;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilePermissionExceptionImplCopyWith<_$FilePermissionExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidFormatExceptionImplCopyWith<$Res> {
  factory _$$InvalidFormatExceptionImplCopyWith(
          _$InvalidFormatExceptionImpl value,
          $Res Function(_$InvalidFormatExceptionImpl) then) =
      __$$InvalidFormatExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$InvalidFormatExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$InvalidFormatExceptionImpl>
    implements _$$InvalidFormatExceptionImplCopyWith<$Res> {
  __$$InvalidFormatExceptionImplCopyWithImpl(
      _$InvalidFormatExceptionImpl _value,
      $Res Function(_$InvalidFormatExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$InvalidFormatExceptionImpl(
      null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InvalidFormatExceptionImpl implements InvalidFormatException {
  const _$InvalidFormatExceptionImpl(this.reason);

  @override
  final String reason;

  @override
  String toString() {
    return 'AppException.invalidFormat(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidFormatExceptionImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidFormatExceptionImplCopyWith<_$InvalidFormatExceptionImpl>
      get copyWith => __$$InvalidFormatExceptionImplCopyWithImpl<
          _$InvalidFormatExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) {
    return invalidFormat(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) {
    return invalidFormat?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) {
    if (invalidFormat != null) {
      return invalidFormat(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) {
    return invalidFormat(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) {
    return invalidFormat?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) {
    if (invalidFormat != null) {
      return invalidFormat(this);
    }
    return orElse();
  }
}

abstract class InvalidFormatException implements AppException {
  const factory InvalidFormatException(final String reason) =
      _$InvalidFormatExceptionImpl;

  String get reason;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvalidFormatExceptionImplCopyWith<_$InvalidFormatExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InvalidProjectExceptionImplCopyWith<$Res> {
  factory _$$InvalidProjectExceptionImplCopyWith(
          _$InvalidProjectExceptionImpl value,
          $Res Function(_$InvalidProjectExceptionImpl) then) =
      __$$InvalidProjectExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason});
}

/// @nodoc
class __$$InvalidProjectExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$InvalidProjectExceptionImpl>
    implements _$$InvalidProjectExceptionImplCopyWith<$Res> {
  __$$InvalidProjectExceptionImplCopyWithImpl(
      _$InvalidProjectExceptionImpl _value,
      $Res Function(_$InvalidProjectExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
  }) {
    return _then(_$InvalidProjectExceptionImpl(
      null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InvalidProjectExceptionImpl implements InvalidProjectException {
  const _$InvalidProjectExceptionImpl(this.reason);

  @override
  final String reason;

  @override
  String toString() {
    return 'AppException.invalidProject(reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvalidProjectExceptionImpl &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvalidProjectExceptionImplCopyWith<_$InvalidProjectExceptionImpl>
      get copyWith => __$$InvalidProjectExceptionImplCopyWithImpl<
          _$InvalidProjectExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) {
    return invalidProject(reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) {
    return invalidProject?.call(reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) {
    if (invalidProject != null) {
      return invalidProject(reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) {
    return invalidProject(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) {
    return invalidProject?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) {
    if (invalidProject != null) {
      return invalidProject(this);
    }
    return orElse();
  }
}

abstract class InvalidProjectException implements AppException {
  const factory InvalidProjectException(final String reason) =
      _$InvalidProjectExceptionImpl;

  String get reason;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvalidProjectExceptionImplCopyWith<_$InvalidProjectExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NodeNotFoundExceptionImplCopyWith<$Res> {
  factory _$$NodeNotFoundExceptionImplCopyWith(
          _$NodeNotFoundExceptionImpl value,
          $Res Function(_$NodeNotFoundExceptionImpl) then) =
      __$$NodeNotFoundExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String id});
}

/// @nodoc
class __$$NodeNotFoundExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$NodeNotFoundExceptionImpl>
    implements _$$NodeNotFoundExceptionImplCopyWith<$Res> {
  __$$NodeNotFoundExceptionImplCopyWithImpl(_$NodeNotFoundExceptionImpl _value,
      $Res Function(_$NodeNotFoundExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
  }) {
    return _then(_$NodeNotFoundExceptionImpl(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NodeNotFoundExceptionImpl implements NodeNotFoundException {
  const _$NodeNotFoundExceptionImpl(this.id);

  @override
  final String id;

  @override
  String toString() {
    return 'AppException.nodeNotFound(id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeNotFoundExceptionImpl &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeNotFoundExceptionImplCopyWith<_$NodeNotFoundExceptionImpl>
      get copyWith => __$$NodeNotFoundExceptionImplCopyWithImpl<
          _$NodeNotFoundExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) {
    return nodeNotFound(id);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) {
    return nodeNotFound?.call(id);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) {
    if (nodeNotFound != null) {
      return nodeNotFound(id);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) {
    return nodeNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) {
    return nodeNotFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) {
    if (nodeNotFound != null) {
      return nodeNotFound(this);
    }
    return orElse();
  }
}

abstract class NodeNotFoundException implements AppException {
  const factory NodeNotFoundException(final String id) =
      _$NodeNotFoundExceptionImpl;

  String get id;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeNotFoundExceptionImplCopyWith<_$NodeNotFoundExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CodeGenerationExceptionImplCopyWith<$Res> {
  factory _$$CodeGenerationExceptionImplCopyWith(
          _$CodeGenerationExceptionImpl value,
          $Res Function(_$CodeGenerationExceptionImpl) then) =
      __$$CodeGenerationExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CodeGenerationExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$CodeGenerationExceptionImpl>
    implements _$$CodeGenerationExceptionImplCopyWith<$Res> {
  __$$CodeGenerationExceptionImplCopyWithImpl(
      _$CodeGenerationExceptionImpl _value,
      $Res Function(_$CodeGenerationExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$CodeGenerationExceptionImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CodeGenerationExceptionImpl implements CodeGenerationException {
  const _$CodeGenerationExceptionImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AppException.codeGeneration(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CodeGenerationExceptionImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CodeGenerationExceptionImplCopyWith<_$CodeGenerationExceptionImpl>
      get copyWith => __$$CodeGenerationExceptionImplCopyWithImpl<
          _$CodeGenerationExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) {
    return codeGeneration(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) {
    return codeGeneration?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) {
    if (codeGeneration != null) {
      return codeGeneration(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) {
    return codeGeneration(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) {
    return codeGeneration?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) {
    if (codeGeneration != null) {
      return codeGeneration(this);
    }
    return orElse();
  }
}

abstract class CodeGenerationException implements AppException {
  const factory CodeGenerationException(final String message) =
      _$CodeGenerationExceptionImpl;

  String get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CodeGenerationExceptionImplCopyWith<_$CodeGenerationExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationExceptionImplCopyWith<$Res> {
  factory _$$ValidationExceptionImplCopyWith(_$ValidationExceptionImpl value,
          $Res Function(_$ValidationExceptionImpl) then) =
      __$$ValidationExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> errors});
}

/// @nodoc
class __$$ValidationExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$ValidationExceptionImpl>
    implements _$$ValidationExceptionImplCopyWith<$Res> {
  __$$ValidationExceptionImplCopyWithImpl(_$ValidationExceptionImpl _value,
      $Res Function(_$ValidationExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errors = null,
  }) {
    return _then(_$ValidationExceptionImpl(
      null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ValidationExceptionImpl implements ValidationException {
  const _$ValidationExceptionImpl(final List<String> errors) : _errors = errors;

  final List<String> _errors;
  @override
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  String toString() {
    return 'AppException.validation(errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationExceptionImpl &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_errors));

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationExceptionImplCopyWith<_$ValidationExceptionImpl> get copyWith =>
      __$$ValidationExceptionImplCopyWithImpl<_$ValidationExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path) fileNotFound,
    required TResult Function(String path) filePermission,
    required TResult Function(String reason) invalidFormat,
    required TResult Function(String reason) invalidProject,
    required TResult Function(String id) nodeNotFound,
    required TResult Function(String message) codeGeneration,
    required TResult Function(List<String> errors) validation,
  }) {
    return validation(errors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path)? fileNotFound,
    TResult? Function(String path)? filePermission,
    TResult? Function(String reason)? invalidFormat,
    TResult? Function(String reason)? invalidProject,
    TResult? Function(String id)? nodeNotFound,
    TResult? Function(String message)? codeGeneration,
    TResult? Function(List<String> errors)? validation,
  }) {
    return validation?.call(errors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path)? fileNotFound,
    TResult Function(String path)? filePermission,
    TResult Function(String reason)? invalidFormat,
    TResult Function(String reason)? invalidProject,
    TResult Function(String id)? nodeNotFound,
    TResult Function(String message)? codeGeneration,
    TResult Function(List<String> errors)? validation,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(errors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FileNotFoundException value) fileNotFound,
    required TResult Function(FilePermissionException value) filePermission,
    required TResult Function(InvalidFormatException value) invalidFormat,
    required TResult Function(InvalidProjectException value) invalidProject,
    required TResult Function(NodeNotFoundException value) nodeNotFound,
    required TResult Function(CodeGenerationException value) codeGeneration,
    required TResult Function(ValidationException value) validation,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FileNotFoundException value)? fileNotFound,
    TResult? Function(FilePermissionException value)? filePermission,
    TResult? Function(InvalidFormatException value)? invalidFormat,
    TResult? Function(InvalidProjectException value)? invalidProject,
    TResult? Function(NodeNotFoundException value)? nodeNotFound,
    TResult? Function(CodeGenerationException value)? codeGeneration,
    TResult? Function(ValidationException value)? validation,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FileNotFoundException value)? fileNotFound,
    TResult Function(FilePermissionException value)? filePermission,
    TResult Function(InvalidFormatException value)? invalidFormat,
    TResult Function(InvalidProjectException value)? invalidProject,
    TResult Function(NodeNotFoundException value)? nodeNotFound,
    TResult Function(CodeGenerationException value)? codeGeneration,
    TResult Function(ValidationException value)? validation,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationException implements AppException {
  const factory ValidationException(final List<String> errors) =
      _$ValidationExceptionImpl;

  List<String> get errors;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationExceptionImplCopyWith<_$ValidationExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
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
abstract class _$$ValidationExceptionImplCopyWith<$Res> {
  factory _$$ValidationExceptionImplCopyWith(_$ValidationExceptionImpl value,
          $Res Function(_$ValidationExceptionImpl) then) =
      __$$ValidationExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> errors, String? field});
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
    Object? field = freezed,
  }) {
    return _then(_$ValidationExceptionImpl(
      null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ValidationExceptionImpl implements ValidationException {
  const _$ValidationExceptionImpl(final List<String> errors, {this.field})
      : _errors = errors;

  final List<String> _errors;
  @override
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  final String? field;

  @override
  String toString() {
    return 'AppException.validation(errors: $errors, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationExceptionImpl &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.field, field) || other.field == field));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_errors), field);

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
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) {
    return validation(errors, field);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) {
    return validation?.call(errors, field);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(errors, field);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationException implements AppException {
  const factory ValidationException(final List<String> errors,
      {final String? field}) = _$ValidationExceptionImpl;

  List<String> get errors;
  String? get field;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationExceptionImplCopyWith<_$ValidationExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundExceptionImplCopyWith<$Res> {
  factory _$$NotFoundExceptionImplCopyWith(_$NotFoundExceptionImpl value,
          $Res Function(_$NotFoundExceptionImpl) then) =
      __$$NotFoundExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String resource, String? id, String? path});
}

/// @nodoc
class __$$NotFoundExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$NotFoundExceptionImpl>
    implements _$$NotFoundExceptionImplCopyWith<$Res> {
  __$$NotFoundExceptionImplCopyWithImpl(_$NotFoundExceptionImpl _value,
      $Res Function(_$NotFoundExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resource = null,
    Object? id = freezed,
    Object? path = freezed,
  }) {
    return _then(_$NotFoundExceptionImpl(
      null == resource
          ? _value.resource
          : resource // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NotFoundExceptionImpl implements NotFoundException {
  const _$NotFoundExceptionImpl(this.resource, {this.id, this.path});

  @override
  final String resource;
  @override
  final String? id;
  @override
  final String? path;

  @override
  String toString() {
    return 'AppException.notFound(resource: $resource, id: $id, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundExceptionImpl &&
            (identical(other.resource, resource) ||
                other.resource == resource) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resource, id, path);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundExceptionImplCopyWith<_$NotFoundExceptionImpl> get copyWith =>
      __$$NotFoundExceptionImplCopyWithImpl<_$NotFoundExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) {
    return notFound(resource, id, path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) {
    return notFound?.call(resource, id, path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(resource, id, path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundException implements AppException {
  const factory NotFoundException(final String resource,
      {final String? id, final String? path}) = _$NotFoundExceptionImpl;

  String get resource;
  String? get id;
  String? get path;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotFoundExceptionImplCopyWith<_$NotFoundExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermissionExceptionImplCopyWith<$Res> {
  factory _$$PermissionExceptionImplCopyWith(_$PermissionExceptionImpl value,
          $Res Function(_$PermissionExceptionImpl) then) =
      __$$PermissionExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String operation, String? resource, String? suggestion});
}

/// @nodoc
class __$$PermissionExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$PermissionExceptionImpl>
    implements _$$PermissionExceptionImplCopyWith<$Res> {
  __$$PermissionExceptionImplCopyWithImpl(_$PermissionExceptionImpl _value,
      $Res Function(_$PermissionExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
    Object? resource = freezed,
    Object? suggestion = freezed,
  }) {
    return _then(_$PermissionExceptionImpl(
      null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      resource: freezed == resource
          ? _value.resource
          : resource // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestion: freezed == suggestion
          ? _value.suggestion
          : suggestion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PermissionExceptionImpl implements PermissionException {
  const _$PermissionExceptionImpl(this.operation,
      {this.resource, this.suggestion});

  @override
  final String operation;
  @override
  final String? resource;
  @override
  final String? suggestion;

  @override
  String toString() {
    return 'AppException.permission(operation: $operation, resource: $resource, suggestion: $suggestion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionExceptionImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.resource, resource) ||
                other.resource == resource) &&
            (identical(other.suggestion, suggestion) ||
                other.suggestion == suggestion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operation, resource, suggestion);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionExceptionImplCopyWith<_$PermissionExceptionImpl> get copyWith =>
      __$$PermissionExceptionImplCopyWithImpl<_$PermissionExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) {
    return permission(operation, resource, suggestion);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) {
    return permission?.call(operation, resource, suggestion);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(operation, resource, suggestion);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionException implements AppException {
  const factory PermissionException(final String operation,
      {final String? resource,
      final String? suggestion}) = _$PermissionExceptionImpl;

  String get operation;
  String? get resource;
  String? get suggestion;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionExceptionImplCopyWith<_$PermissionExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FormatExceptionImplCopyWith<$Res> {
  factory _$$FormatExceptionImplCopyWith(_$FormatExceptionImpl value,
          $Res Function(_$FormatExceptionImpl) then) =
      __$$FormatExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reason, String? path, String? expectedFormat});
}

/// @nodoc
class __$$FormatExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$FormatExceptionImpl>
    implements _$$FormatExceptionImplCopyWith<$Res> {
  __$$FormatExceptionImplCopyWithImpl(
      _$FormatExceptionImpl _value, $Res Function(_$FormatExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = null,
    Object? path = freezed,
    Object? expectedFormat = freezed,
  }) {
    return _then(_$FormatExceptionImpl(
      null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedFormat: freezed == expectedFormat
          ? _value.expectedFormat
          : expectedFormat // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FormatExceptionImpl implements FormatException {
  const _$FormatExceptionImpl(this.reason, {this.path, this.expectedFormat});

  @override
  final String reason;
  @override
  final String? path;
  @override
  final String? expectedFormat;

  @override
  String toString() {
    return 'AppException.format(reason: $reason, path: $path, expectedFormat: $expectedFormat)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FormatExceptionImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.expectedFormat, expectedFormat) ||
                other.expectedFormat == expectedFormat));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason, path, expectedFormat);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FormatExceptionImplCopyWith<_$FormatExceptionImpl> get copyWith =>
      __$$FormatExceptionImplCopyWithImpl<_$FormatExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) {
    return format(reason, path, expectedFormat);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) {
    return format?.call(reason, path, expectedFormat);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) {
    if (format != null) {
      return format(reason, path, expectedFormat);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) {
    return format(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return format?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (format != null) {
      return format(this);
    }
    return orElse();
  }
}

abstract class FormatException implements AppException {
  const factory FormatException(final String reason,
      {final String? path,
      final String? expectedFormat}) = _$FormatExceptionImpl;

  String get reason;
  String? get path;
  String? get expectedFormat;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FormatExceptionImplCopyWith<_$FormatExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IOAppExceptionImplCopyWith<$Res> {
  factory _$$IOAppExceptionImplCopyWith(_$IOAppExceptionImpl value,
          $Res Function(_$IOAppExceptionImpl) then) =
      __$$IOAppExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String operation, String? path, Object? originalError});
}

/// @nodoc
class __$$IOAppExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$IOAppExceptionImpl>
    implements _$$IOAppExceptionImplCopyWith<$Res> {
  __$$IOAppExceptionImplCopyWithImpl(
      _$IOAppExceptionImpl _value, $Res Function(_$IOAppExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operation = null,
    Object? path = freezed,
    Object? originalError = freezed,
  }) {
    return _then(_$IOAppExceptionImpl(
      null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as String,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
      originalError:
          freezed == originalError ? _value.originalError : originalError,
    ));
  }
}

/// @nodoc

class _$IOAppExceptionImpl implements IOAppException {
  const _$IOAppExceptionImpl(this.operation, {this.path, this.originalError});

  @override
  final String operation;
  @override
  final String? path;
  @override
  final Object? originalError;

  @override
  String toString() {
    return 'AppException.io(operation: $operation, path: $path, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IOAppExceptionImpl &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.path, path) || other.path == path) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operation, path,
      const DeepCollectionEquality().hash(originalError));

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IOAppExceptionImplCopyWith<_$IOAppExceptionImpl> get copyWith =>
      __$$IOAppExceptionImplCopyWithImpl<_$IOAppExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) {
    return io(operation, path, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) {
    return io?.call(operation, path, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) {
    if (io != null) {
      return io(operation, path, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) {
    return io(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return io?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (io != null) {
      return io(this);
    }
    return orElse();
  }
}

abstract class IOAppException implements AppException {
  const factory IOAppException(final String operation,
      {final String? path, final Object? originalError}) = _$IOAppExceptionImpl;

  String get operation;
  String? get path;
  Object? get originalError;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IOAppExceptionImplCopyWith<_$IOAppExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StateExceptionImplCopyWith<$Res> {
  factory _$$StateExceptionImplCopyWith(_$StateExceptionImpl value,
          $Res Function(_$StateExceptionImpl) then) =
      __$$StateExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? expectedState, String? actualState});
}

/// @nodoc
class __$$StateExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$StateExceptionImpl>
    implements _$$StateExceptionImplCopyWith<$Res> {
  __$$StateExceptionImplCopyWithImpl(
      _$StateExceptionImpl _value, $Res Function(_$StateExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? expectedState = freezed,
    Object? actualState = freezed,
  }) {
    return _then(_$StateExceptionImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      expectedState: freezed == expectedState
          ? _value.expectedState
          : expectedState // ignore: cast_nullable_to_non_nullable
              as String?,
      actualState: freezed == actualState
          ? _value.actualState
          : actualState // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StateExceptionImpl implements StateException {
  const _$StateExceptionImpl(this.message,
      {this.expectedState, this.actualState});

  @override
  final String message;
  @override
  final String? expectedState;
  @override
  final String? actualState;

  @override
  String toString() {
    return 'AppException.state(message: $message, expectedState: $expectedState, actualState: $actualState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StateExceptionImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.expectedState, expectedState) ||
                other.expectedState == expectedState) &&
            (identical(other.actualState, actualState) ||
                other.actualState == actualState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, expectedState, actualState);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StateExceptionImplCopyWith<_$StateExceptionImpl> get copyWith =>
      __$$StateExceptionImplCopyWithImpl<_$StateExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) {
    return state(message, expectedState, actualState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) {
    return state?.call(message, expectedState, actualState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(message, expectedState, actualState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) {
    return state(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return state?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (state != null) {
      return state(this);
    }
    return orElse();
  }
}

abstract class StateException implements AppException {
  const factory StateException(final String message,
      {final String? expectedState,
      final String? actualState}) = _$StateExceptionImpl;

  String get message;
  String? get expectedState;
  String? get actualState;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StateExceptionImplCopyWith<_$StateExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownExceptionImplCopyWith<$Res> {
  factory _$$UnknownExceptionImplCopyWith(_$UnknownExceptionImpl value,
          $Res Function(_$UnknownExceptionImpl) then) =
      __$$UnknownExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Object? originalError, StackTrace? stackTrace});
}

/// @nodoc
class __$$UnknownExceptionImplCopyWithImpl<$Res>
    extends _$AppExceptionCopyWithImpl<$Res, _$UnknownExceptionImpl>
    implements _$$UnknownExceptionImplCopyWith<$Res> {
  __$$UnknownExceptionImplCopyWithImpl(_$UnknownExceptionImpl _value,
      $Res Function(_$UnknownExceptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_$UnknownExceptionImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _value.originalError : originalError,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$UnknownExceptionImpl implements UnknownException {
  const _$UnknownExceptionImpl(this.message,
      {this.originalError, this.stackTrace});

  @override
  final String message;
  @override
  final Object? originalError;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'AppException.unknown(message: $message, originalError: $originalError, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownExceptionImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(originalError), stackTrace);

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      __$$UnknownExceptionImplCopyWithImpl<_$UnknownExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> errors, String? field) validation,
    required TResult Function(String resource, String? id, String? path)
        notFound,
    required TResult Function(
            String operation, String? resource, String? suggestion)
        permission,
    required TResult Function(
            String reason, String? path, String? expectedFormat)
        format,
    required TResult Function(
            String operation, String? path, Object? originalError)
        io,
    required TResult Function(
            String message, String? expectedState, String? actualState)
        state,
    required TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)
        unknown,
  }) {
    return unknown(message, originalError, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> errors, String? field)? validation,
    TResult? Function(String resource, String? id, String? path)? notFound,
    TResult? Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult? Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult? Function(String operation, String? path, Object? originalError)?
        io,
    TResult? Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult? Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
  }) {
    return unknown?.call(message, originalError, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> errors, String? field)? validation,
    TResult Function(String resource, String? id, String? path)? notFound,
    TResult Function(String operation, String? resource, String? suggestion)?
        permission,
    TResult Function(String reason, String? path, String? expectedFormat)?
        format,
    TResult Function(String operation, String? path, Object? originalError)? io,
    TResult Function(
            String message, String? expectedState, String? actualState)?
        state,
    TResult Function(
            String message, Object? originalError, StackTrace? stackTrace)?
        unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, originalError, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ValidationException value) validation,
    required TResult Function(NotFoundException value) notFound,
    required TResult Function(PermissionException value) permission,
    required TResult Function(FormatException value) format,
    required TResult Function(IOAppException value) io,
    required TResult Function(StateException value) state,
    required TResult Function(UnknownException value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ValidationException value)? validation,
    TResult? Function(NotFoundException value)? notFound,
    TResult? Function(PermissionException value)? permission,
    TResult? Function(FormatException value)? format,
    TResult? Function(IOAppException value)? io,
    TResult? Function(StateException value)? state,
    TResult? Function(UnknownException value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ValidationException value)? validation,
    TResult Function(NotFoundException value)? notFound,
    TResult Function(PermissionException value)? permission,
    TResult Function(FormatException value)? format,
    TResult Function(IOAppException value)? io,
    TResult Function(StateException value)? state,
    TResult Function(UnknownException value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownException implements AppException {
  const factory UnknownException(final String message,
      {final Object? originalError,
      final StackTrace? stackTrace}) = _$UnknownExceptionImpl;

  String get message;
  Object? get originalError;
  StackTrace? get stackTrace;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownExceptionImplCopyWith<_$UnknownExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

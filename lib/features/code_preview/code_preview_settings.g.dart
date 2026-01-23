// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_preview_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CodeSettingsImpl _$$CodeSettingsImplFromJson(Map<String, dynamic> json) =>
    _$CodeSettingsImpl(
      dartVersion:
          $enumDecodeNullable(_$DartVersionEnumMap, json['dartVersion']) ??
              DartVersion.dart310,
      useDotShorthand: json['useDotShorthand'] as bool? ?? true,
    );

Map<String, dynamic> _$$CodeSettingsImplToJson(_$CodeSettingsImpl instance) =>
    <String, dynamic>{
      'dartVersion': _$DartVersionEnumMap[instance.dartVersion]!,
      'useDotShorthand': instance.useDotShorthand,
    };

const _$DartVersionEnumMap = {
  DartVersion.dart39: 'dart39',
  DartVersion.dart310: 'dart310',
};

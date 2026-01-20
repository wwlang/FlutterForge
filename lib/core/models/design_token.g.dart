// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TypographyValueImpl _$$TypographyValueImplFromJson(
        Map<String, dynamic> json) =>
    _$TypographyValueImpl(
      fontFamily: json['fontFamily'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 14.0,
      fontWeight: (json['fontWeight'] as num?)?.toInt() ?? 400,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.5,
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TypographyValueImplToJson(
        _$TypographyValueImpl instance) =>
    <String, dynamic>{
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'lineHeight': instance.lineHeight,
      'letterSpacing': instance.letterSpacing,
    };

_$DesignTokenImpl _$$DesignTokenImplFromJson(Map<String, dynamic> json) =>
    _$DesignTokenImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$TokenTypeEnumMap, json['type']),
      lightValue: json['lightValue'],
      darkValue: json['darkValue'],
      highContrastLightValue: json['highContrastLightValue'],
      highContrastDarkValue: json['highContrastDarkValue'],
      typography: json['typography'] == null
          ? null
          : TypographyValue.fromJson(
              json['typography'] as Map<String, dynamic>),
      aliasOf: json['aliasOf'] as String?,
    );

Map<String, dynamic> _$$DesignTokenImplToJson(_$DesignTokenImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$TokenTypeEnumMap[instance.type]!,
      'lightValue': instance.lightValue,
      'darkValue': instance.darkValue,
      'highContrastLightValue': instance.highContrastLightValue,
      'highContrastDarkValue': instance.highContrastDarkValue,
      'typography': instance.typography,
      'aliasOf': instance.aliasOf,
    };

const _$TokenTypeEnumMap = {
  TokenType.color: 'color',
  TokenType.typography: 'typography',
  TokenType.spacing: 'spacing',
  TokenType.radius: 'radius',
};

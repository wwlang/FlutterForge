// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyDefinitionImpl _$$PropertyDefinitionImplFromJson(
        Map<String, dynamic> json) =>
    _$PropertyDefinitionImpl(
      name: json['name'] as String,
      type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
      displayName: json['displayName'] as String,
      nullable: json['nullable'] as bool,
      defaultValue: json['defaultValue'],
      enumValues: (json['enumValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      category: json['category'] as String?,
      description: json['description'] as String?,
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PropertyDefinitionImplToJson(
        _$PropertyDefinitionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$PropertyTypeEnumMap[instance.type]!,
      'displayName': instance.displayName,
      'nullable': instance.nullable,
      'defaultValue': instance.defaultValue,
      'enumValues': instance.enumValues,
      'category': instance.category,
      'description': instance.description,
      'min': instance.min,
      'max': instance.max,
    };

const _$PropertyTypeEnumMap = {
  PropertyType.string: 'string',
  PropertyType.double_: 'double_',
  PropertyType.int_: 'int_',
  PropertyType.bool_: 'bool_',
  PropertyType.color: 'color',
  PropertyType.enum_: 'enum_',
  PropertyType.edgeInsets: 'edgeInsets',
  PropertyType.alignment: 'alignment',
};

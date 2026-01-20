// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WidgetDefinitionImpl _$$WidgetDefinitionImplFromJson(
        Map<String, dynamic> json) =>
    _$WidgetDefinitionImpl(
      type: json['type'] as String,
      category: $enumDecode(_$WidgetCategoryEnumMap, json['category']),
      displayName: json['displayName'] as String,
      acceptsChildren: json['acceptsChildren'] as bool,
      maxChildren: (json['maxChildren'] as num?)?.toInt(),
      properties: (json['properties'] as List<dynamic>)
          .map((e) => PropertyDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      iconName: json['iconName'] as String?,
      description: json['description'] as String?,
      import_: json['import_'] as String? ?? 'package:flutter/material.dart',
      parentConstraint: json['parentConstraint'] as String?,
    );

Map<String, dynamic> _$$WidgetDefinitionImplToJson(
        _$WidgetDefinitionImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'category': _$WidgetCategoryEnumMap[instance.category]!,
      'displayName': instance.displayName,
      'acceptsChildren': instance.acceptsChildren,
      'maxChildren': instance.maxChildren,
      'properties': instance.properties,
      'iconName': instance.iconName,
      'description': instance.description,
      'import_': instance.import_,
      'parentConstraint': instance.parentConstraint,
    };

const _$WidgetCategoryEnumMap = {
  WidgetCategory.layout: 'layout',
  WidgetCategory.content: 'content',
  WidgetCategory.input: 'input',
  WidgetCategory.scrolling: 'scrolling',
  WidgetCategory.structure: 'structure',
};

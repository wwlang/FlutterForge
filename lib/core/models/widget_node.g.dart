// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WidgetNodeImpl _$$WidgetNodeImplFromJson(Map<String, dynamic> json) =>
    _$WidgetNodeImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      properties: json['properties'] as Map<String, dynamic>,
      childrenIds: (json['childrenIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      parentId: json['parentId'] as String?,
    );

Map<String, dynamic> _$$WidgetNodeImplToJson(_$WidgetNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'properties': instance.properties,
      'childrenIds': instance.childrenIds,
      'parentId': instance.parentId,
    };

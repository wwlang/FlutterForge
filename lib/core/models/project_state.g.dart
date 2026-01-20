// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectStateImpl _$$ProjectStateImplFromJson(Map<String, dynamic> json) =>
    _$ProjectStateImpl(
      nodes: (json['nodes'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, WidgetNode.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, WidgetNode>{},
      rootIds: (json['rootIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      selection: (json['selection'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const <String>{},
      zoomLevel: (json['zoomLevel'] as num?)?.toDouble() ?? 1.0,
      panOffset: json['panOffset'] == null
          ? Offset.zero
          : const OffsetConverter()
              .fromJson(json['panOffset'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProjectStateImplToJson(_$ProjectStateImpl instance) =>
    <String, dynamic>{
      'nodes': instance.nodes,
      'rootIds': instance.rootIds,
      'selection': instance.selection.toList(),
      'zoomLevel': instance.zoomLevel,
      'panOffset': const OffsetConverter().toJson(instance.panOffset),
    };

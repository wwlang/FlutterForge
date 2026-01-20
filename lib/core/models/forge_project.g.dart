// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forge_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForgeProjectImpl _$$ForgeProjectImplFromJson(Map<String, dynamic> json) =>
    _$ForgeProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      screens: (json['screens'] as List<dynamic>)
          .map((e) => ScreenDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      metadata:
          ProjectMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      designTokens: (json['designTokens'] as List<dynamic>?)
              ?.map((e) => DesignToken.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DesignToken>[],
    );

Map<String, dynamic> _$$ForgeProjectImplToJson(_$ForgeProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'screens': instance.screens,
      'metadata': instance.metadata,
      'designTokens': instance.designTokens,
    };

_$ScreenDefinitionImpl _$$ScreenDefinitionImplFromJson(
        Map<String, dynamic> json) =>
    _$ScreenDefinitionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      rootNodeId: json['rootNodeId'] as String,
      nodes: json['nodes'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ScreenDefinitionImplToJson(
        _$ScreenDefinitionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rootNodeId': instance.rootNodeId,
      'nodes': instance.nodes,
    };

_$DesignTokenImpl _$$DesignTokenImplFromJson(Map<String, dynamic> json) =>
    _$DesignTokenImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$TokenTypeEnumMap, json['type']),
      valueLight: json['valueLight'],
      valueDark: json['valueDark'],
      alias: json['alias'] as String?,
    );

Map<String, dynamic> _$$DesignTokenImplToJson(_$DesignTokenImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$TokenTypeEnumMap[instance.type]!,
      'valueLight': instance.valueLight,
      'valueDark': instance.valueDark,
      'alias': instance.alias,
    };

const _$TokenTypeEnumMap = {
  TokenType.color: 'color',
  TokenType.typography: 'typography',
  TokenType.spacing: 'spacing',
  TokenType.radius: 'radius',
  TokenType.shadow: 'shadow',
};

_$ProjectMetadataImpl _$$ProjectMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectMetadataImpl(
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      forgeVersion: json['forgeVersion'] as String,
      description: json['description'] as String?,
      flutterSdkVersion: json['flutterSdkVersion'] as String? ?? '3.19.0',
    );

Map<String, dynamic> _$$ProjectMetadataImplToJson(
        _$ProjectMetadataImpl instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
      'forgeVersion': instance.forgeVersion,
      'description': instance.description,
      'flutterSdkVersion': instance.flutterSdkVersion,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KeyframeImpl _$$KeyframeImplFromJson(Map<String, dynamic> json) =>
    _$KeyframeImpl(
      id: json['id'] as String,
      timeMs: (json['timeMs'] as num).toInt(),
      property: json['property'] as String,
      value: json['value'],
      easing: $enumDecodeNullable(_$EasingTypeEnumMap, json['easing']),
    );

Map<String, dynamic> _$$KeyframeImplToJson(_$KeyframeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeMs': instance.timeMs,
      'property': instance.property,
      'value': instance.value,
      'easing': _$EasingTypeEnumMap[instance.easing],
    };

const _$EasingTypeEnumMap = {
  EasingType.linear: 'linear',
  EasingType.easeIn: 'easeIn',
  EasingType.easeOut: 'easeOut',
  EasingType.easeInOut: 'easeInOut',
  EasingType.bounce: 'bounce',
  EasingType.elastic: 'elastic',
};

_$WidgetAnimationImpl _$$WidgetAnimationImplFromJson(
        Map<String, dynamic> json) =>
    _$WidgetAnimationImpl(
      id: json['id'] as String,
      widgetId: json['widgetId'] as String,
      type: $enumDecode(_$AnimationTypeEnumMap, json['type']),
      durationMs: (json['durationMs'] as num).toInt(),
      delayMs: (json['delayMs'] as num?)?.toInt() ?? 0,
      easing: $enumDecodeNullable(_$EasingTypeEnumMap, json['easing']) ??
          EasingType.linear,
      keyframes: (json['keyframes'] as List<dynamic>?)
              ?.map((e) => Keyframe.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Keyframe>[],
    );

Map<String, dynamic> _$$WidgetAnimationImplToJson(
        _$WidgetAnimationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'widgetId': instance.widgetId,
      'type': _$AnimationTypeEnumMap[instance.type]!,
      'durationMs': instance.durationMs,
      'delayMs': instance.delayMs,
      'easing': _$EasingTypeEnumMap[instance.easing]!,
      'keyframes': instance.keyframes,
    };

const _$AnimationTypeEnumMap = {
  AnimationType.fade: 'fade',
  AnimationType.slide: 'slide',
  AnimationType.scale: 'scale',
  AnimationType.rotate: 'rotate',
  AnimationType.custom: 'custom',
};

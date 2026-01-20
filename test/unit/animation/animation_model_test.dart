import 'package:flutter_forge/core/models/animation_model.dart';
import 'package:flutter_forge/providers/animations_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Animation Model and Track (Task 3.8)', () {
    group('WidgetAnimation Model', () {
      test('creates animation with required fields', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        expect(animation.id, equals('anim-1'));
        expect(animation.widgetId, equals('widget-1'));
        expect(animation.type, equals(AnimationType.fade));
        expect(animation.durationMs, equals(300));
      });

      test('defaults to empty keyframes', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        expect(animation.keyframes, isEmpty);
      });

      test('defaults to no delay', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        expect(animation.delayMs, equals(0));
      });

      test('supports custom easing', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
          easing: EasingType.easeInOut,
        );

        expect(animation.easing, equals(EasingType.easeInOut));
      });

      test('defaults to linear easing', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        expect(animation.easing, equals(EasingType.linear));
      });

      test('serializes to JSON', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.slide,
          durationMs: 500,
          delayMs: 100,
          easing: EasingType.easeOut,
        );

        final json = animation.toJson();

        expect(json['id'], equals('anim-1'));
        expect(json['widgetId'], equals('widget-1'));
        expect(json['type'], equals('slide'));
        expect(json['durationMs'], equals(500));
        expect(json['delayMs'], equals(100));
        expect(json['easing'], equals('easeOut'));
      });

      test('deserializes from JSON', () {
        final json = {
          'id': 'anim-2',
          'widgetId': 'widget-2',
          'type': 'scale',
          'durationMs': 400,
          'delayMs': 50,
          'easing': 'easeIn',
          'keyframes': <dynamic>[],
        };

        final animation = WidgetAnimation.fromJson(json);

        expect(animation.id, equals('anim-2'));
        expect(animation.widgetId, equals('widget-2'));
        expect(animation.type, equals(AnimationType.scale));
        expect(animation.durationMs, equals(400));
        expect(animation.delayMs, equals(50));
        expect(animation.easing, equals(EasingType.easeIn));
      });

      test('copyWith creates modified copy', () {
        final original = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        final modified = original.copyWith(durationMs: 500);

        expect(modified.id, equals('anim-1'));
        expect(modified.durationMs, equals(500));
        expect(original.durationMs, equals(300));
      });
    });

    group('AnimationType', () {
      test('all types are defined', () {
        expect(AnimationType.values, contains(AnimationType.fade));
        expect(AnimationType.values, contains(AnimationType.slide));
        expect(AnimationType.values, contains(AnimationType.scale));
        expect(AnimationType.values, contains(AnimationType.rotate));
        expect(AnimationType.values, contains(AnimationType.custom));
      });

      test('serializes to string', () {
        expect(AnimationType.fade.name, equals('fade'));
        expect(AnimationType.slide.name, equals('slide'));
        expect(AnimationType.scale.name, equals('scale'));
        expect(AnimationType.rotate.name, equals('rotate'));
        expect(AnimationType.custom.name, equals('custom'));
      });
    });

    group('EasingType', () {
      test('all preset easings are defined', () {
        expect(EasingType.values, contains(EasingType.linear));
        expect(EasingType.values, contains(EasingType.easeIn));
        expect(EasingType.values, contains(EasingType.easeOut));
        expect(EasingType.values, contains(EasingType.easeInOut));
        expect(EasingType.values, contains(EasingType.bounce));
        expect(EasingType.values, contains(EasingType.elastic));
      });
    });

    group('Keyframe', () {
      test('creates keyframe with time and value', () {
        final keyframe = Keyframe(
          id: 'kf-1',
          timeMs: 150,
          property: 'opacity',
          value: 0.5,
        );

        expect(keyframe.id, equals('kf-1'));
        expect(keyframe.timeMs, equals(150));
        expect(keyframe.property, equals('opacity'));
        expect(keyframe.value, equals(0.5));
      });

      test('supports easing per keyframe', () {
        final keyframe = Keyframe(
          id: 'kf-1',
          timeMs: 150,
          property: 'opacity',
          value: 1.0,
          easing: EasingType.easeOut,
        );

        expect(keyframe.easing, equals(EasingType.easeOut));
      });

      test('defaults to null easing (inherit from animation)', () {
        final keyframe = Keyframe(
          id: 'kf-1',
          timeMs: 150,
          property: 'opacity',
          value: 1.0,
        );

        expect(keyframe.easing, isNull);
      });

      test('serializes to JSON', () {
        final keyframe = Keyframe(
          id: 'kf-1',
          timeMs: 200,
          property: 'x',
          value: 100.0,
          easing: EasingType.easeInOut,
        );

        final json = keyframe.toJson();

        expect(json['id'], equals('kf-1'));
        expect(json['timeMs'], equals(200));
        expect(json['property'], equals('x'));
        expect(json['value'], equals(100.0));
        expect(json['easing'], equals('easeInOut'));
      });

      test('deserializes from JSON', () {
        final json = {
          'id': 'kf-2',
          'timeMs': 300,
          'property': 'scale',
          'value': 2.0,
          'easing': 'bounce',
        };

        final keyframe = Keyframe.fromJson(json);

        expect(keyframe.id, equals('kf-2'));
        expect(keyframe.timeMs, equals(300));
        expect(keyframe.property, equals('scale'));
        expect(keyframe.value, equals(2.0));
        expect(keyframe.easing, equals(EasingType.bounce));
      });
    });

    group('Animation with Keyframes', () {
      test('animation contains keyframes', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.custom,
          durationMs: 1000,
          keyframes: [
            Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
            Keyframe(id: 'kf-2', timeMs: 500, property: 'opacity', value: 0.5),
            Keyframe(id: 'kf-3', timeMs: 1000, property: 'opacity', value: 1.0),
          ],
        );

        expect(animation.keyframes.length, equals(3));
        expect(animation.keyframes[0].value, equals(0.0));
        expect(animation.keyframes[1].value, equals(0.5));
        expect(animation.keyframes[2].value, equals(1.0));
      });

      test('keyframes accessible via animation', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
          keyframes: [
            Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
            Keyframe(id: 'kf-2', timeMs: 300, property: 'opacity', value: 1.0),
          ],
        );

        expect(animation.keyframes.length, equals(2));
        expect(animation.keyframes[0].timeMs, equals(0));
        expect(animation.keyframes[1].timeMs, equals(300));
      });

      test('deserializes animation with keyframes from JSON', () {
        final json = {
          'id': 'anim-1',
          'widgetId': 'widget-1',
          'type': 'custom',
          'durationMs': 1000,
          'delayMs': 0,
          'easing': 'linear',
          'keyframes': [
            {
              'id': 'kf-1',
              'timeMs': 0,
              'property': 'opacity',
              'value': 0.0,
            },
            {
              'id': 'kf-2',
              'timeMs': 1000,
              'property': 'opacity',
              'value': 1.0,
            },
          ],
        };

        final animation = WidgetAnimation.fromJson(json);

        expect(animation.keyframes.length, equals(2));
        expect(animation.keyframes[0].timeMs, equals(0));
        expect(animation.keyframes[0].value, equals(0.0));
        expect(animation.keyframes[1].timeMs, equals(1000));
        expect(animation.keyframes[1].value, equals(1.0));
      });
    });

    group('AnimationsNotifier', () {
      late ProviderContainer container;
      late AnimationsNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(animationsProvider.notifier);
      });

      tearDown(() {
        container.dispose();
      });

      test('starts empty', () {
        final animations = container.read(animationsProvider);
        expect(animations, isEmpty);
      });

      test('adds animation', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        notifier.addAnimation(animation);

        final animations = container.read(animationsProvider);
        expect(animations.length, equals(1));
        expect(animations.first.type, equals(AnimationType.fade));
      });

      test('removes animation', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        notifier.addAnimation(animation);
        notifier.removeAnimation('anim-1');

        final animations = container.read(animationsProvider);
        expect(animations, isEmpty);
      });

      test('updates animation', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        notifier.addAnimation(animation);
        notifier.updateAnimation(animation.copyWith(durationMs: 500));

        final animations = container.read(animationsProvider);
        expect(animations.first.durationMs, equals(500));
      });

      test('gets animation by id', () {
        final animation = WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        );

        notifier.addAnimation(animation);

        final found = notifier.getById('anim-1');
        expect(found, isNotNull);
        expect(found!.id, equals('anim-1'));
      });

      test('returns null for missing animation', () {
        final found = notifier.getById('nonexistent');
        expect(found, isNull);
      });

      test('gets animations for widget', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        ));
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-2',
          widgetId: 'widget-1',
          type: AnimationType.slide,
          durationMs: 500,
        ));
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-3',
          widgetId: 'widget-2',
          type: AnimationType.scale,
          durationMs: 400,
        ));

        final widget1Animations = notifier.getByWidgetId('widget-1');

        expect(widget1Animations.length, equals(2));
        expect(
          widget1Animations.every((a) => a.widgetId == 'widget-1'),
          isTrue,
        );
      });

      test('removes all animations for widget', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        ));
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-2',
          widgetId: 'widget-1',
          type: AnimationType.slide,
          durationMs: 500,
        ));
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-3',
          widgetId: 'widget-2',
          type: AnimationType.scale,
          durationMs: 400,
        ));

        notifier.removeAnimationsForWidget('widget-1');

        final animations = container.read(animationsProvider);
        expect(animations.length, equals(1));
        expect(animations.first.widgetId, equals('widget-2'));
      });
    });

    group('Multiple Animations per Widget', () {
      late ProviderContainer container;
      late AnimationsNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(animationsProvider.notifier);
      });

      tearDown(() {
        container.dispose();
      });

      test('supports multiple animations on same widget', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        ));
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-2',
          widgetId: 'widget-1',
          type: AnimationType.slide,
          durationMs: 500,
        ));

        final widget1Animations = notifier.getByWidgetId('widget-1');
        expect(widget1Animations.length, equals(2));

        final types = widget1Animations.map((a) => a.type).toSet();
        expect(types, containsAll([AnimationType.fade, AnimationType.slide]));
      });
    });

    group('Animation Serialization', () {
      late ProviderContainer container;
      late AnimationsNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(animationsProvider.notifier);
      });

      tearDown(() {
        container.dispose();
      });

      test('exports all animations to JSON', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        ));
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-2',
          widgetId: 'widget-2',
          type: AnimationType.scale,
          durationMs: 400,
        ));

        final jsonList = notifier.toJson();

        expect(jsonList.length, equals(2));
        expect(jsonList[0]['id'], equals('anim-1'));
        expect(jsonList[1]['id'], equals('anim-2'));
      });

      test('loads animations from JSON', () {
        final jsonList = [
          {
            'id': 'anim-1',
            'widgetId': 'widget-1',
            'type': 'fade',
            'durationMs': 300,
            'delayMs': 0,
            'easing': 'linear',
            'keyframes': <dynamic>[],
          },
          {
            'id': 'anim-2',
            'widgetId': 'widget-2',
            'type': 'rotate',
            'durationMs': 600,
            'delayMs': 100,
            'easing': 'easeInOut',
            'keyframes': <dynamic>[],
          },
        ];

        notifier.loadFromJson(jsonList);

        final animations = container.read(animationsProvider);
        expect(animations.length, equals(2));
        expect(animations[0].type, equals(AnimationType.fade));
        expect(animations[1].type, equals(AnimationType.rotate));
      });
    });

    group('hasAnimations Provider', () {
      late ProviderContainer container;
      late AnimationsNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(animationsProvider.notifier);
      });

      tearDown(() {
        container.dispose();
      });

      test('returns false when widget has no animations', () {
        final hasAnim = container.read(widgetHasAnimationsProvider('widget-1'));
        expect(hasAnim, isFalse);
      });

      test('returns true when widget has animations', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.fade,
          durationMs: 300,
        ));

        final hasAnim = container.read(widgetHasAnimationsProvider('widget-1'));
        expect(hasAnim, isTrue);
      });
    });

    group('Keyframe Operations', () {
      late ProviderContainer container;
      late AnimationsNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(animationsProvider.notifier);
      });

      tearDown(() {
        container.dispose();
      });

      test('adds keyframe to animation', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.custom,
          durationMs: 1000,
        ));

        notifier.addKeyframe(
          'anim-1',
          Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
        );

        final animation = notifier.getById('anim-1')!;
        expect(animation.keyframes.length, equals(1));
        expect(animation.keyframes[0].value, equals(0.0));
      });

      test('removes keyframe from animation', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.custom,
          durationMs: 1000,
          keyframes: [
            Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
            Keyframe(id: 'kf-2', timeMs: 1000, property: 'opacity', value: 1.0),
          ],
        ));

        notifier.removeKeyframe('anim-1', 'kf-1');

        final animation = notifier.getById('anim-1')!;
        expect(animation.keyframes.length, equals(1));
        expect(animation.keyframes[0].id, equals('kf-2'));
      });

      test('updates keyframe in animation', () {
        notifier.addAnimation(WidgetAnimation(
          id: 'anim-1',
          widgetId: 'widget-1',
          type: AnimationType.custom,
          durationMs: 1000,
          keyframes: [
            Keyframe(id: 'kf-1', timeMs: 0, property: 'opacity', value: 0.0),
          ],
        ));

        notifier.updateKeyframe(
          'anim-1',
          Keyframe(id: 'kf-1', timeMs: 100, property: 'opacity', value: 0.5),
        );

        final animation = notifier.getById('anim-1')!;
        expect(animation.keyframes[0].timeMs, equals(100));
        expect(animation.keyframes[0].value, equals(0.5));
      });
    });
  });
}

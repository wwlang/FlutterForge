import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Registry Expansion - Content (Task 2.10)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('Icon Widget', () {
      test('is registered', () {
        expect(registry.contains('Icon'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Icon');
        expect(def?.category, equals(WidgetCategory.content));
      });

      test('is leaf widget (no children)', () {
        final def = registry.get('Icon');
        expect(def?.acceptsChildren, isFalse);
        expect(def?.maxChildren, equals(0));
      });

      test('has icon property', () {
        final def = registry.get('Icon');
        final iconProp = def?.properties.where((p) => p.name == 'icon');
        expect(iconProp, isNotEmpty);
      });

      test('has size property', () {
        final def = registry.get('Icon');
        final sizeProp = def?.properties.where((p) => p.name == 'size');
        expect(sizeProp, isNotEmpty);
      });

      test('has color property', () {
        final def = registry.get('Icon');
        final colorProp = def?.properties.where((p) => p.name == 'color');
        expect(colorProp, isNotEmpty);
      });

      test('has correct display name', () {
        final def = registry.get('Icon');
        expect(def?.displayName, equals('Icon'));
      });

      test('has icon name for palette', () {
        final def = registry.get('Icon');
        expect(def?.iconName, isNotNull);
      });
    });

    group('Image Widget', () {
      test('is registered', () {
        expect(registry.contains('Image'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Image');
        expect(def?.category, equals(WidgetCategory.content));
      });

      test('is leaf widget (no children)', () {
        final def = registry.get('Image');
        expect(def?.acceptsChildren, isFalse);
        expect(def?.maxChildren, equals(0));
      });

      test('has width property', () {
        final def = registry.get('Image');
        final prop = def?.properties.where((p) => p.name == 'width');
        expect(prop, isNotEmpty);
      });

      test('has height property', () {
        final def = registry.get('Image');
        final prop = def?.properties.where((p) => p.name == 'height');
        expect(prop, isNotEmpty);
      });

      test('has fit property', () {
        final def = registry.get('Image');
        final fitProp = def?.properties.where((p) => p.name == 'fit');
        expect(fitProp, isNotEmpty);
      });

      test('has correct display name', () {
        final def = registry.get('Image');
        expect(def?.displayName, equals('Image'));
      });
    });

    group('Divider Widget', () {
      test('is registered', () {
        expect(registry.contains('Divider'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Divider');
        expect(def?.category, equals(WidgetCategory.content));
      });

      test('is leaf widget (no children)', () {
        final def = registry.get('Divider');
        expect(def?.acceptsChildren, isFalse);
        expect(def?.maxChildren, equals(0));
      });

      test('has thickness property', () {
        final def = registry.get('Divider');
        final prop = def?.properties.where((p) => p.name == 'thickness');
        expect(prop, isNotEmpty);
      });

      test('has color property', () {
        final def = registry.get('Divider');
        final colorProp = def?.properties.where((p) => p.name == 'color');
        expect(colorProp, isNotEmpty);
      });

      test('has indent property', () {
        final def = registry.get('Divider');
        final prop = def?.properties.where((p) => p.name == 'indent');
        expect(prop, isNotEmpty);
      });

      test('has endIndent property', () {
        final def = registry.get('Divider');
        final prop = def?.properties.where((p) => p.name == 'endIndent');
        expect(prop, isNotEmpty);
      });

      test('has correct display name', () {
        final def = registry.get('Divider');
        expect(def?.displayName, equals('Divider'));
      });
    });

    group('VerticalDivider Widget', () {
      test('is registered', () {
        expect(registry.contains('VerticalDivider'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('VerticalDivider');
        expect(def?.category, equals(WidgetCategory.content));
      });

      test('is leaf widget (no children)', () {
        final def = registry.get('VerticalDivider');
        expect(def?.acceptsChildren, isFalse);
        expect(def?.maxChildren, equals(0));
      });

      test('has thickness property', () {
        final def = registry.get('VerticalDivider');
        final prop = def?.properties.where((p) => p.name == 'thickness');
        expect(prop, isNotEmpty);
      });

      test('has width property', () {
        final def = registry.get('VerticalDivider');
        final prop = def?.properties.where((p) => p.name == 'width');
        expect(prop, isNotEmpty);
      });

      test('has color property', () {
        final def = registry.get('VerticalDivider');
        final colorProp = def?.properties.where((p) => p.name == 'color');
        expect(colorProp, isNotEmpty);
      });
    });

    group('Registry Statistics after Content Widgets', () {
      test('has 16+ widgets after Task 2.10', () {
        // Phase 1 (5) + Task 2.9 (7) + Task 2.10 (4) = 16
        expect(registry.all.length, greaterThanOrEqualTo(16));
      });

      test('content category has 5+ widgets', () {
        final contentWidgets = registry.byCategory(WidgetCategory.content);
        // Text (Phase 1) + Icon, Image, Divider, VerticalDivider = 5
        expect(contentWidgets.length, greaterThanOrEqualTo(5));
      });
    });
  });
}

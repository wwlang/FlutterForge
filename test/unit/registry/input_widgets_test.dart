import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Registry Expansion - Input (Task 2.11)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('ElevatedButton Widget', () {
      test('is registered', () {
        expect(registry.contains('ElevatedButton'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('ElevatedButton');
        expect(def?.category, equals(WidgetCategory.input));
      });

      test('is single-child widget', () {
        final def = registry.get('ElevatedButton');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, equals(1));
      });

      test('has onPressed property (placeholder)', () {
        final def = registry.get('ElevatedButton');
        final prop = def?.properties.where((p) => p.name == 'onPressed');
        expect(prop, isNotEmpty);
      });

      test('has style property', () {
        final def = registry.get('ElevatedButton');
        final prop = def?.properties.where((p) => p.name == 'style');
        expect(prop, isNotEmpty);
      });

      test('has correct display name', () {
        final def = registry.get('ElevatedButton');
        expect(def?.displayName, equals('Elevated Button'));
      });

      test('has icon name for palette', () {
        final def = registry.get('ElevatedButton');
        expect(def?.iconName, isNotNull);
      });

      test('has description', () {
        final def = registry.get('ElevatedButton');
        expect(def?.description, isNotNull);
        expect(def?.description, contains('button'));
      });
    });

    group('TextButton Widget', () {
      test('is registered', () {
        expect(registry.contains('TextButton'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('TextButton');
        expect(def?.category, equals(WidgetCategory.input));
      });

      test('is single-child widget', () {
        final def = registry.get('TextButton');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, equals(1));
      });

      test('has onPressed property (placeholder)', () {
        final def = registry.get('TextButton');
        final prop = def?.properties.where((p) => p.name == 'onPressed');
        expect(prop, isNotEmpty);
      });

      test('has style property', () {
        final def = registry.get('TextButton');
        final prop = def?.properties.where((p) => p.name == 'style');
        expect(prop, isNotEmpty);
      });

      test('has correct display name', () {
        final def = registry.get('TextButton');
        expect(def?.displayName, equals('Text Button'));
      });

      test('has icon name for palette', () {
        final def = registry.get('TextButton');
        expect(def?.iconName, isNotNull);
      });
    });

    group('IconButton Widget', () {
      test('is registered', () {
        expect(registry.contains('IconButton'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('IconButton');
        expect(def?.category, equals(WidgetCategory.input));
      });

      test('is leaf widget (no children)', () {
        final def = registry.get('IconButton');
        expect(def?.acceptsChildren, isFalse);
        expect(def?.maxChildren, equals(0));
      });

      test('has icon property', () {
        final def = registry.get('IconButton');
        final prop = def?.properties.where((p) => p.name == 'icon');
        expect(prop, isNotEmpty);
      });

      test('has iconSize property', () {
        final def = registry.get('IconButton');
        final prop = def?.properties.where((p) => p.name == 'iconSize');
        expect(prop, isNotEmpty);
      });

      test('has color property', () {
        final def = registry.get('IconButton');
        final prop = def?.properties.where((p) => p.name == 'color');
        expect(prop, isNotEmpty);
      });

      test('has onPressed property (placeholder)', () {
        final def = registry.get('IconButton');
        final prop = def?.properties.where((p) => p.name == 'onPressed');
        expect(prop, isNotEmpty);
      });

      test('has tooltip property', () {
        final def = registry.get('IconButton');
        final prop = def?.properties.where((p) => p.name == 'tooltip');
        expect(prop, isNotEmpty);
      });

      test('has correct display name', () {
        final def = registry.get('IconButton');
        expect(def?.displayName, equals('Icon Button'));
      });
    });

    group('Placeholder Widget', () {
      test('is registered', () {
        expect(registry.contains('Placeholder'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Placeholder');
        expect(def?.category, equals(WidgetCategory.content));
      });

      test('is leaf widget (no children)', () {
        final def = registry.get('Placeholder');
        expect(def?.acceptsChildren, isFalse);
        expect(def?.maxChildren, equals(0));
      });

      test('has fallbackWidth property', () {
        final def = registry.get('Placeholder');
        final prop = def?.properties.where((p) => p.name == 'fallbackWidth');
        expect(prop, isNotEmpty);
      });

      test('has fallbackHeight property', () {
        final def = registry.get('Placeholder');
        final prop = def?.properties.where((p) => p.name == 'fallbackHeight');
        expect(prop, isNotEmpty);
      });

      test('has color property', () {
        final def = registry.get('Placeholder');
        final prop = def?.properties.where((p) => p.name == 'color');
        expect(prop, isNotEmpty);
      });

      test('has strokeWidth property', () {
        final def = registry.get('Placeholder');
        final prop = def?.properties.where((p) => p.name == 'strokeWidth');
        expect(prop, isNotEmpty);
      });

      test('has correct display name', () {
        final def = registry.get('Placeholder');
        expect(def?.displayName, equals('Placeholder'));
      });
    });

    group('Registry Statistics after Input Widgets', () {
      test('has 20 widgets after Task 2.11', () {
        // Phase 1 (5) + Task 2.9 (7) + Task 2.10 (4) + Task 2.11 (4) = 20
        expect(registry.all.length, equals(20));
      });

      test('input category has 3 widgets', () {
        final inputWidgets = registry.byCategory(WidgetCategory.input);
        // ElevatedButton, TextButton, IconButton = 3
        expect(inputWidgets.length, equals(3));
      });

      test('content category has 6 widgets', () {
        final contentWidgets = registry.byCategory(WidgetCategory.content);
        // Text + Icon, Image, Divider, VerticalDivider + Placeholder = 6
        expect(contentWidgets.length, equals(6));
      });
    });
  });
}

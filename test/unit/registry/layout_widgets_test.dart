import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Registry Expansion - Layout (Task 2.9)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('Stack Widget', () {
      test('is registered', () {
        expect(registry.contains('Stack'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Stack');
        expect(def?.category, equals(WidgetCategory.layout));
      });

      test('accepts multiple children', () {
        final def = registry.get('Stack');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, isNull); // Unlimited
      });

      test('has alignment property', () {
        final def = registry.get('Stack');
        final alignmentProp = def?.properties.where(
          (p) => p.name == 'alignment',
        );
        expect(alignmentProp, isNotEmpty);
      });

      test('has fit property', () {
        final def = registry.get('Stack');
        final fitProp = def?.properties.where((p) => p.name == 'fit');
        expect(fitProp, isNotEmpty);
      });
    });

    group('Expanded Widget', () {
      test('is registered', () {
        expect(registry.contains('Expanded'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Expanded');
        expect(def?.category, equals(WidgetCategory.layout));
      });

      test('is single-child container', () {
        final def = registry.get('Expanded');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, equals(1));
      });

      test('has flex property', () {
        final def = registry.get('Expanded');
        final flexProp = def?.properties.where((p) => p.name == 'flex');
        expect(flexProp, isNotEmpty);
      });

      test('has parentConstraint for Flex', () {
        final def = registry.get('Expanded');
        expect(def?.parentConstraint, equals('Flex'));
      });
    });

    group('Flexible Widget', () {
      test('is registered', () {
        expect(registry.contains('Flexible'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Flexible');
        expect(def?.category, equals(WidgetCategory.layout));
      });

      test('is single-child container', () {
        final def = registry.get('Flexible');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, equals(1));
      });

      test('has flex property', () {
        final def = registry.get('Flexible');
        final flexProp = def?.properties.where((p) => p.name == 'flex');
        expect(flexProp, isNotEmpty);
      });

      test('has fit property', () {
        final def = registry.get('Flexible');
        final fitProp = def?.properties.where((p) => p.name == 'fit');
        expect(fitProp, isNotEmpty);
      });

      test('has parentConstraint for Flex', () {
        final def = registry.get('Flexible');
        expect(def?.parentConstraint, equals('Flex'));
      });
    });

    group('Padding Widget', () {
      test('is registered', () {
        expect(registry.contains('Padding'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Padding');
        expect(def?.category, equals(WidgetCategory.layout));
      });

      test('is single-child container', () {
        final def = registry.get('Padding');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, equals(1));
      });

      test('has padding property', () {
        final def = registry.get('Padding');
        final paddingProp = def?.properties.where((p) => p.name == 'padding');
        expect(paddingProp, isNotEmpty);
      });
    });

    group('Center Widget', () {
      test('is registered', () {
        expect(registry.contains('Center'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Center');
        expect(def?.category, equals(WidgetCategory.layout));
      });

      test('is single-child container', () {
        final def = registry.get('Center');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, equals(1));
      });

      test('has widthFactor property', () {
        final def = registry.get('Center');
        final prop = def?.properties.where((p) => p.name == 'widthFactor');
        expect(prop, isNotEmpty);
      });

      test('has heightFactor property', () {
        final def = registry.get('Center');
        final prop = def?.properties.where((p) => p.name == 'heightFactor');
        expect(prop, isNotEmpty);
      });
    });

    group('Align Widget', () {
      test('is registered', () {
        expect(registry.contains('Align'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Align');
        expect(def?.category, equals(WidgetCategory.layout));
      });

      test('is single-child container', () {
        final def = registry.get('Align');
        expect(def?.acceptsChildren, isTrue);
        expect(def?.maxChildren, equals(1));
      });

      test('has alignment property', () {
        final def = registry.get('Align');
        final prop = def?.properties.where((p) => p.name == 'alignment');
        expect(prop, isNotEmpty);
      });

      test('has widthFactor property', () {
        final def = registry.get('Align');
        final prop = def?.properties.where((p) => p.name == 'widthFactor');
        expect(prop, isNotEmpty);
      });

      test('has heightFactor property', () {
        final def = registry.get('Align');
        final prop = def?.properties.where((p) => p.name == 'heightFactor');
        expect(prop, isNotEmpty);
      });
    });

    group('Spacer Widget', () {
      test('is registered', () {
        expect(registry.contains('Spacer'), isTrue);
      });

      test('has correct category', () {
        final def = registry.get('Spacer');
        expect(def?.category, equals(WidgetCategory.layout));
      });

      test('is leaf widget (no children)', () {
        final def = registry.get('Spacer');
        expect(def?.acceptsChildren, isFalse);
        expect(def?.maxChildren, equals(0));
      });

      test('has flex property', () {
        final def = registry.get('Spacer');
        final flexProp = def?.properties.where((p) => p.name == 'flex');
        expect(flexProp, isNotEmpty);
      });

      test('has parentConstraint for Flex', () {
        final def = registry.get('Spacer');
        expect(def?.parentConstraint, equals('Flex'));
      });
    });

    group('Registry Statistics', () {
      test('has 11+ widgets after Phase 2 Task 9', () {
        // Original 5 + 6 new layout widgets + Spacer = 12
        expect(registry.all.length, greaterThanOrEqualTo(11));
      });

      test('layout category has 10+ widgets', () {
        final layoutWidgets = registry.byCategory(WidgetCategory.layout);
        // Container, Row, Column, SizedBox + Stack, Expanded, Flexible,
        // Padding, Center, Align, Spacer = 11
        expect(layoutWidgets.length, greaterThanOrEqualTo(10));
      });
    });
  });
}

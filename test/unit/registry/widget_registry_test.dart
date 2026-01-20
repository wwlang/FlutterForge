import 'package:flutter_forge/shared/registry/widget_definition.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetRegistry', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = WidgetRegistry();
    });

    test('should register widget definitions', () {
      const definition = WidgetDefinition(
        type: 'TestWidget',
        category: WidgetCategory.layout,
        displayName: 'Test Widget',
        acceptsChildren: false,
        maxChildren: 0,
        properties: [],
      );

      registry.register(definition);

      expect(registry.contains('TestWidget'), true);
    });

    test('should retrieve widget definition by type in O(1)', () {
      const definition = WidgetDefinition(
        type: 'Container',
        category: WidgetCategory.layout,
        displayName: 'Container',
        acceptsChildren: true,
        maxChildren: 1,
        properties: [],
      );

      registry.register(definition);
      final retrieved = registry.get('Container');

      expect(retrieved, isNotNull);
      expect(retrieved!.type, 'Container');
    });

    test('should return null for unknown widget type', () {
      final result = registry.get('UnknownWidget');
      expect(result, isNull);
    });

    test('should list all registered widgets', () {
      registry
        ..register(
          const WidgetDefinition(
            type: 'Widget1',
            category: WidgetCategory.layout,
            displayName: 'Widget 1',
            acceptsChildren: false,
            maxChildren: 0,
            properties: [],
          ),
        )
        ..register(
          const WidgetDefinition(
            type: 'Widget2',
            category: WidgetCategory.content,
            displayName: 'Widget 2',
            acceptsChildren: false,
            maxChildren: 0,
            properties: [],
          ),
        );

      final all = registry.all;

      expect(all.length, 2);
    });

    test('should filter widgets by category', () {
      registry
        ..register(
          const WidgetDefinition(
            type: 'LayoutWidget',
            category: WidgetCategory.layout,
            displayName: 'Layout Widget',
            acceptsChildren: true,
            maxChildren: null,
            properties: [],
          ),
        )
        ..register(
          const WidgetDefinition(
            type: 'ContentWidget',
            category: WidgetCategory.content,
            displayName: 'Content Widget',
            acceptsChildren: false,
            maxChildren: 0,
            properties: [],
          ),
        );

      final layoutWidgets = registry.byCategory(WidgetCategory.layout);
      final contentWidgets = registry.byCategory(WidgetCategory.content);

      expect(layoutWidgets.length, 1);
      expect(layoutWidgets.first.type, 'LayoutWidget');
      expect(contentWidgets.length, 1);
      expect(contentWidgets.first.type, 'ContentWidget');
    });

    test('should not allow duplicate registration', () {
      const definition = WidgetDefinition(
        type: 'Duplicate',
        category: WidgetCategory.layout,
        displayName: 'Duplicate',
        acceptsChildren: false,
        maxChildren: 0,
        properties: [],
      );

      registry.register(definition);

      expect(
        () => registry.register(definition),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('DefaultWidgetRegistry', () {
    test('should include Container widget', () {
      final registry = DefaultWidgetRegistry();
      final container = registry.get('Container');

      expect(container, isNotNull);
      expect(container!.type, 'Container');
      expect(container.category, WidgetCategory.layout);
      expect(container.acceptsChildren, true);
      expect(container.maxChildren, 1);
    });

    test('should include Text widget', () {
      final registry = DefaultWidgetRegistry();
      final text = registry.get('Text');

      expect(text, isNotNull);
      expect(text!.type, 'Text');
      expect(text.category, WidgetCategory.content);
      expect(text.acceptsChildren, false);
      expect(text.properties.any((p) => p.name == 'data'), true);
    });

    test('should include Row widget', () {
      final registry = DefaultWidgetRegistry();
      final row = registry.get('Row');

      expect(row, isNotNull);
      expect(row!.type, 'Row');
      expect(row.category, WidgetCategory.layout);
      expect(row.acceptsChildren, true);
      expect(row.maxChildren, isNull); // unlimited
      expect(row.isMultiChild, true);
    });

    test('should include Column widget', () {
      final registry = DefaultWidgetRegistry();
      final column = registry.get('Column');

      expect(column, isNotNull);
      expect(column!.type, 'Column');
      expect(column.category, WidgetCategory.layout);
      expect(column.acceptsChildren, true);
      expect(column.maxChildren, isNull); // unlimited
    });

    test('should include SizedBox widget', () {
      final registry = DefaultWidgetRegistry();
      final sizedBox = registry.get('SizedBox');

      expect(sizedBox, isNotNull);
      expect(sizedBox!.type, 'SizedBox');
      expect(sizedBox.category, WidgetCategory.layout);
      expect(sizedBox.acceptsChildren, true);
      expect(sizedBox.maxChildren, 1);
    });

    test('should include all Phase 1 basic widgets', () {
      final registry = DefaultWidgetRegistry();
      final all = registry.all;
      final widgetTypes = all.map((w) => w.type).toSet();

      // Phase 1 widgets must be present
      expect(
        widgetTypes,
        containsAll({
          'Container',
          'Text',
          'Row',
          'Column',
          'SizedBox',
        }),
      );

      // Registry can have additional widgets from later phases
      expect(all.length, greaterThanOrEqualTo(5));
    });

    test('should have Layout and Content categories populated', () {
      final registry = DefaultWidgetRegistry();

      final layout = registry.byCategory(WidgetCategory.layout);
      final content = registry.byCategory(WidgetCategory.content);

      // Phase 1: Container, Row, Column, SizedBox (4 layout)
      // Phase 2 Task 9: Stack, Expanded, Flexible, Padding, Center, Align, Spacer (7 more layout)
      expect(layout.length, greaterThanOrEqualTo(4));
      // Content: Text (at minimum)
      expect(content.length, greaterThanOrEqualTo(1));
    });

    test('Container should have width, height, color, padding properties', () {
      final registry = DefaultWidgetRegistry();
      final container = registry.get('Container')!;

      final propertyNames = container.properties.map((p) => p.name).toList();

      expect(
        propertyNames,
        containsAll(['width', 'height', 'color', 'padding']),
      );
    });

    test('Text should have data, fontSize, fontWeight, color properties', () {
      final registry = DefaultWidgetRegistry();
      final text = registry.get('Text')!;

      final propertyNames = text.properties.map((p) => p.name).toList();

      expect(
        propertyNames,
        containsAll(['data', 'fontSize', 'fontWeight', 'color']),
      );
    });
  });
}

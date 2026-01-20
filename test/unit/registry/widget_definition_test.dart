import 'package:flutter_forge/shared/registry/property_definition.dart';
import 'package:flutter_forge/shared/registry/widget_definition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetDefinition', () {
    test('should create widget definition with required fields', () {
      const definition = WidgetDefinition(
        type: 'Container',
        category: WidgetCategory.layout,
        displayName: 'Container',
        acceptsChildren: true,
        maxChildren: 1,
        properties: [],
      );

      expect(definition.type, 'Container');
      expect(definition.category, WidgetCategory.layout);
      expect(definition.displayName, 'Container');
      expect(definition.acceptsChildren, true);
      expect(definition.maxChildren, 1);
    });

    test('should create widget definition with properties', () {
      const definition = WidgetDefinition(
        type: 'Container',
        category: WidgetCategory.layout,
        displayName: 'Container',
        acceptsChildren: true,
        maxChildren: 1,
        properties: [
          PropertyDefinition(
            name: 'width',
            type: PropertyType.double_,
            displayName: 'Width',
            nullable: true,
          ),
          PropertyDefinition(
            name: 'height',
            type: PropertyType.double_,
            displayName: 'Height',
            nullable: true,
          ),
        ],
      );

      expect(definition.properties.length, 2);
      expect(definition.properties[0].name, 'width');
      expect(definition.properties[1].name, 'height');
    });

    test('should identify multi-child widgets', () {
      const columnDef = WidgetDefinition(
        type: 'Column',
        category: WidgetCategory.layout,
        displayName: 'Column',
        acceptsChildren: true,
        maxChildren: null, // unlimited
        properties: [],
      );

      const containerDef = WidgetDefinition(
        type: 'Container',
        category: WidgetCategory.layout,
        displayName: 'Container',
        acceptsChildren: true,
        maxChildren: 1,
        properties: [],
      );

      expect(columnDef.isMultiChild, true);
      expect(containerDef.isMultiChild, false);
    });

    test('should identify leaf widgets', () {
      const textDef = WidgetDefinition(
        type: 'Text',
        category: WidgetCategory.content,
        displayName: 'Text',
        acceptsChildren: false,
        maxChildren: 0,
        properties: [],
      );

      expect(textDef.isLeaf, true);
    });
  });

  group('PropertyDefinition', () {
    test('should create property with default value', () {
      const prop = PropertyDefinition(
        name: 'fontSize',
        type: PropertyType.double_,
        displayName: 'Font Size',
        nullable: true,
        defaultValue: 14.0,
      );

      expect(prop.name, 'fontSize');
      expect(prop.type, PropertyType.double_);
      expect(prop.defaultValue, 14.0);
      expect(prop.nullable, true);
    });

    test('should create enum property with options', () {
      const prop = PropertyDefinition(
        name: 'mainAxisAlignment',
        type: PropertyType.enum_,
        displayName: 'Main Axis Alignment',
        nullable: true,
        enumValues: [
          'MainAxisAlignment.start',
          'MainAxisAlignment.center',
          'MainAxisAlignment.end',
          'MainAxisAlignment.spaceBetween',
          'MainAxisAlignment.spaceAround',
          'MainAxisAlignment.spaceEvenly',
        ],
      );

      expect(prop.type, PropertyType.enum_);
      expect(prop.enumValues, isNotNull);
      expect(prop.enumValues!.length, 6);
    });

    test('should support all property types', () {
      expect(
        PropertyType.values,
        containsAll([
          PropertyType.string,
          PropertyType.double_,
          PropertyType.int_,
          PropertyType.bool_,
          PropertyType.color,
          PropertyType.enum_,
          PropertyType.edgeInsets,
          PropertyType.alignment,
        ]),
      );
    });
  });

  group('WidgetCategory', () {
    test('should have layout and content categories', () {
      expect(
        WidgetCategory.values,
        containsAll([
          WidgetCategory.layout,
          WidgetCategory.content,
        ]),
      );
    });
  });
}

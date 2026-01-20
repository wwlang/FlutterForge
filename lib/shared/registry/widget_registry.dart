import 'package:flutter_forge/shared/registry/property_definition.dart';
import 'package:flutter_forge/shared/registry/widget_definition.dart';

/// Registry for widget definitions.
///
/// Provides O(1) lookup of widget definitions by type
/// and category-based filtering for the palette.
class WidgetRegistry {
  final Map<String, WidgetDefinition> _definitions = {};

  /// Register a widget definition.
  ///
  /// Throws [ArgumentError] if widget type is already registered.
  void register(WidgetDefinition definition) {
    if (_definitions.containsKey(definition.type)) {
      throw ArgumentError(
        'Widget type "${definition.type}" is already registered',
      );
    }
    _definitions[definition.type] = definition;
  }

  /// Check if a widget type is registered.
  bool contains(String type) => _definitions.containsKey(type);

  /// Get widget definition by type. Returns null if not found.
  WidgetDefinition? get(String type) => _definitions[type];

  /// Get all registered widget definitions.
  List<WidgetDefinition> get all => _definitions.values.toList();

  /// Get widgets filtered by category.
  List<WidgetDefinition> byCategory(WidgetCategory category) {
    return _definitions.values
        .where((def) => def.category == category)
        .toList();
  }

  /// Get all available categories with registered widgets.
  Set<WidgetCategory> get categories {
    return _definitions.values.map((def) => def.category).toSet();
  }
}

/// Default widget registry with Phase 1 and Phase 2 widgets.
///
/// Phase 1: Container, Text, Row, Column, SizedBox
/// Phase 2 Task 9: Stack, Expanded, Flexible, Padding, Center, Align, Spacer
class DefaultWidgetRegistry extends WidgetRegistry {
  /// Creates the default registry with all widgets.
  DefaultWidgetRegistry() {
    // Phase 1 widgets
    _registerContainerWidget();
    _registerTextWidget();
    _registerRowWidget();
    _registerColumnWidget();
    _registerSizedBoxWidget();

    // Phase 2 Task 9: Layout widgets
    _registerStackWidget();
    _registerExpandedWidget();
    _registerFlexibleWidget();
    _registerPaddingWidget();
    _registerCenterWidget();
    _registerAlignWidget();
    _registerSpacerWidget();
  }

  void _registerContainerWidget() {
    register(
      const WidgetDefinition(
        type: 'Container',
        category: WidgetCategory.layout,
        displayName: 'Container',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'crop_square',
        description: 'A convenience widget for styling and sizing',
        properties: [
          PropertyDefinition(
            name: 'width',
            type: PropertyType.double_,
            displayName: 'Width',
            nullable: true,
            category: 'Size',
            description: 'Width in logical pixels',
            min: 0,
          ),
          PropertyDefinition(
            name: 'height',
            type: PropertyType.double_,
            displayName: 'Height',
            nullable: true,
            category: 'Size',
            description: 'Height in logical pixels',
            min: 0,
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Appearance',
            description: 'Background color',
          ),
          PropertyDefinition(
            name: 'padding',
            type: PropertyType.edgeInsets,
            displayName: 'Padding',
            nullable: true,
            category: 'Spacing',
            description: 'Inner padding',
          ),
          PropertyDefinition(
            name: 'margin',
            type: PropertyType.edgeInsets,
            displayName: 'Margin',
            nullable: true,
            category: 'Spacing',
            description: 'Outer margin',
          ),
          PropertyDefinition(
            name: 'alignment',
            type: PropertyType.alignment,
            displayName: 'Alignment',
            nullable: true,
            category: 'Layout',
            description: 'Child alignment within container',
          ),
        ],
      ),
    );
  }

  void _registerTextWidget() {
    register(
      const WidgetDefinition(
        type: 'Text',
        category: WidgetCategory.content,
        displayName: 'Text',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'text_fields',
        description: 'A run of text with a single style',
        properties: [
          PropertyDefinition(
            name: 'data',
            type: PropertyType.string,
            displayName: 'Text',
            nullable: false,
            defaultValue: 'Text',
            category: 'Content',
            description: 'The text to display',
          ),
          PropertyDefinition(
            name: 'fontSize',
            type: PropertyType.double_,
            displayName: 'Font Size',
            nullable: true,
            category: 'Style',
            description: 'Font size in logical pixels',
            min: 1,
            max: 200,
          ),
          PropertyDefinition(
            name: 'fontWeight',
            type: PropertyType.enum_,
            displayName: 'Font Weight',
            nullable: true,
            category: 'Style',
            description: 'The typeface thickness',
            enumValues: [
              'FontWeight.w100',
              'FontWeight.w200',
              'FontWeight.w300',
              'FontWeight.w400',
              'FontWeight.w500',
              'FontWeight.w600',
              'FontWeight.w700',
              'FontWeight.w800',
              'FontWeight.w900',
            ],
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Style',
            description: 'Text color',
          ),
          PropertyDefinition(
            name: 'textAlign',
            type: PropertyType.enum_,
            displayName: 'Text Align',
            nullable: true,
            category: 'Layout',
            description: 'How the text should be aligned horizontally',
            enumValues: [
              'TextAlign.left',
              'TextAlign.center',
              'TextAlign.right',
              'TextAlign.justify',
              'TextAlign.start',
              'TextAlign.end',
            ],
          ),
          PropertyDefinition(
            name: 'maxLines',
            type: PropertyType.int_,
            displayName: 'Max Lines',
            nullable: true,
            category: 'Layout',
            description: 'Maximum number of lines to display',
            min: 1,
          ),
          PropertyDefinition(
            name: 'overflow',
            type: PropertyType.enum_,
            displayName: 'Overflow',
            nullable: true,
            category: 'Layout',
            description: 'How to handle text overflow',
            enumValues: [
              'TextOverflow.clip',
              'TextOverflow.fade',
              'TextOverflow.ellipsis',
              'TextOverflow.visible',
            ],
          ),
        ],
      ),
    );
  }

  void _registerRowWidget() {
    register(
      const WidgetDefinition(
        type: 'Row',
        category: WidgetCategory.layout,
        displayName: 'Row',
        acceptsChildren: true,
        maxChildren: null, // unlimited
        iconName: 'view_column',
        description: 'A widget that displays children in a horizontal array',
        properties: [
          PropertyDefinition(
            name: 'mainAxisAlignment',
            type: PropertyType.enum_,
            displayName: 'Main Axis Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to place children along the main axis',
            enumValues: [
              'MainAxisAlignment.start',
              'MainAxisAlignment.center',
              'MainAxisAlignment.end',
              'MainAxisAlignment.spaceBetween',
              'MainAxisAlignment.spaceAround',
              'MainAxisAlignment.spaceEvenly',
            ],
          ),
          PropertyDefinition(
            name: 'crossAxisAlignment',
            type: PropertyType.enum_,
            displayName: 'Cross Axis Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to place children along the cross axis',
            enumValues: [
              'CrossAxisAlignment.start',
              'CrossAxisAlignment.center',
              'CrossAxisAlignment.end',
              'CrossAxisAlignment.stretch',
              'CrossAxisAlignment.baseline',
            ],
          ),
          PropertyDefinition(
            name: 'mainAxisSize',
            type: PropertyType.enum_,
            displayName: 'Main Axis Size',
            nullable: true,
            category: 'Layout',
            description: 'How much space to occupy in the main axis',
            enumValues: [
              'MainAxisSize.min',
              'MainAxisSize.max',
            ],
          ),
        ],
      ),
    );
  }

  void _registerColumnWidget() {
    register(
      const WidgetDefinition(
        type: 'Column',
        category: WidgetCategory.layout,
        displayName: 'Column',
        acceptsChildren: true,
        maxChildren: null, // unlimited
        iconName: 'view_agenda',
        description: 'A widget that displays children in a vertical array',
        properties: [
          PropertyDefinition(
            name: 'mainAxisAlignment',
            type: PropertyType.enum_,
            displayName: 'Main Axis Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to place children along the main axis',
            enumValues: [
              'MainAxisAlignment.start',
              'MainAxisAlignment.center',
              'MainAxisAlignment.end',
              'MainAxisAlignment.spaceBetween',
              'MainAxisAlignment.spaceAround',
              'MainAxisAlignment.spaceEvenly',
            ],
          ),
          PropertyDefinition(
            name: 'crossAxisAlignment',
            type: PropertyType.enum_,
            displayName: 'Cross Axis Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to place children along the cross axis',
            enumValues: [
              'CrossAxisAlignment.start',
              'CrossAxisAlignment.center',
              'CrossAxisAlignment.end',
              'CrossAxisAlignment.stretch',
              'CrossAxisAlignment.baseline',
            ],
          ),
          PropertyDefinition(
            name: 'mainAxisSize',
            type: PropertyType.enum_,
            displayName: 'Main Axis Size',
            nullable: true,
            category: 'Layout',
            description: 'How much space to occupy in the main axis',
            enumValues: [
              'MainAxisSize.min',
              'MainAxisSize.max',
            ],
          ),
        ],
      ),
    );
  }

  void _registerSizedBoxWidget() {
    register(
      const WidgetDefinition(
        type: 'SizedBox',
        category: WidgetCategory.layout,
        displayName: 'SizedBox',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'crop_din',
        description: 'A box with a specified size',
        properties: [
          PropertyDefinition(
            name: 'width',
            type: PropertyType.double_,
            displayName: 'Width',
            nullable: true,
            category: 'Size',
            description: 'Width in logical pixels',
            min: 0,
          ),
          PropertyDefinition(
            name: 'height',
            type: PropertyType.double_,
            displayName: 'Height',
            nullable: true,
            category: 'Size',
            description: 'Height in logical pixels',
            min: 0,
          ),
        ],
      ),
    );
  }

  // Phase 2 Task 9: Layout widgets

  void _registerStackWidget() {
    register(
      const WidgetDefinition(
        type: 'Stack',
        category: WidgetCategory.layout,
        displayName: 'Stack',
        acceptsChildren: true,
        maxChildren: null, // unlimited
        iconName: 'layers',
        description: 'A widget that positions children relative to its edges',
        properties: [
          PropertyDefinition(
            name: 'alignment',
            type: PropertyType.alignment,
            displayName: 'Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to align non-positioned children',
          ),
          PropertyDefinition(
            name: 'fit',
            type: PropertyType.enum_,
            displayName: 'Fit',
            nullable: true,
            category: 'Layout',
            description: 'How to size non-positioned children',
            enumValues: [
              'StackFit.loose',
              'StackFit.expand',
              'StackFit.passthrough',
            ],
          ),
          PropertyDefinition(
            name: 'clipBehavior',
            type: PropertyType.enum_,
            displayName: 'Clip Behavior',
            nullable: true,
            category: 'Layout',
            description: 'How to clip children that overflow',
            enumValues: [
              'Clip.none',
              'Clip.hardEdge',
              'Clip.antiAlias',
              'Clip.antiAliasWithSaveLayer',
            ],
          ),
        ],
      ),
    );
  }

  void _registerExpandedWidget() {
    register(
      const WidgetDefinition(
        type: 'Expanded',
        category: WidgetCategory.layout,
        displayName: 'Expanded',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'expand',
        description: 'Expands a child of Row/Column to fill available space',
        parentConstraint: 'Flex',
        properties: [
          PropertyDefinition(
            name: 'flex',
            type: PropertyType.int_,
            displayName: 'Flex',
            nullable: true,
            defaultValue: 1,
            category: 'Layout',
            description: 'Flex factor for space distribution',
            min: 1,
          ),
        ],
      ),
    );
  }

  void _registerFlexibleWidget() {
    register(
      const WidgetDefinition(
        type: 'Flexible',
        category: WidgetCategory.layout,
        displayName: 'Flexible',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'swap_horiz',
        description: 'Gives a child flexibility to expand in Row/Column',
        parentConstraint: 'Flex',
        properties: [
          PropertyDefinition(
            name: 'flex',
            type: PropertyType.int_,
            displayName: 'Flex',
            nullable: true,
            defaultValue: 1,
            category: 'Layout',
            description: 'Flex factor for space distribution',
            min: 1,
          ),
          PropertyDefinition(
            name: 'fit',
            type: PropertyType.enum_,
            displayName: 'Fit',
            nullable: true,
            category: 'Layout',
            description: 'How the child fills available space',
            enumValues: [
              'FlexFit.tight',
              'FlexFit.loose',
            ],
          ),
        ],
      ),
    );
  }

  void _registerPaddingWidget() {
    register(
      const WidgetDefinition(
        type: 'Padding',
        category: WidgetCategory.layout,
        displayName: 'Padding',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'padding',
        description: 'Insets its child by the given padding',
        properties: [
          PropertyDefinition(
            name: 'padding',
            type: PropertyType.edgeInsets,
            displayName: 'Padding',
            nullable: false,
            category: 'Spacing',
            description: 'The amount of space to inset the child',
          ),
        ],
      ),
    );
  }

  void _registerCenterWidget() {
    register(
      const WidgetDefinition(
        type: 'Center',
        category: WidgetCategory.layout,
        displayName: 'Center',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'center_focus_strong',
        description: 'Centers its child within itself',
        properties: [
          PropertyDefinition(
            name: 'widthFactor',
            type: PropertyType.double_,
            displayName: 'Width Factor',
            nullable: true,
            category: 'Size',
            description: 'Multiply child width to determine own width',
            min: 0,
          ),
          PropertyDefinition(
            name: 'heightFactor',
            type: PropertyType.double_,
            displayName: 'Height Factor',
            nullable: true,
            category: 'Size',
            description: 'Multiply child height to determine own height',
            min: 0,
          ),
        ],
      ),
    );
  }

  void _registerAlignWidget() {
    register(
      const WidgetDefinition(
        type: 'Align',
        category: WidgetCategory.layout,
        displayName: 'Align',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'format_align_center',
        description: 'Aligns its child within itself',
        properties: [
          PropertyDefinition(
            name: 'alignment',
            type: PropertyType.alignment,
            displayName: 'Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to align the child',
          ),
          PropertyDefinition(
            name: 'widthFactor',
            type: PropertyType.double_,
            displayName: 'Width Factor',
            nullable: true,
            category: 'Size',
            description: 'Multiply child width to determine own width',
            min: 0,
          ),
          PropertyDefinition(
            name: 'heightFactor',
            type: PropertyType.double_,
            displayName: 'Height Factor',
            nullable: true,
            category: 'Size',
            description: 'Multiply child height to determine own height',
            min: 0,
          ),
        ],
      ),
    );
  }

  void _registerSpacerWidget() {
    register(
      const WidgetDefinition(
        type: 'Spacer',
        category: WidgetCategory.layout,
        displayName: 'Spacer',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'space_bar',
        description: 'Takes up space proportional to its flex value',
        parentConstraint: 'Flex',
        properties: [
          PropertyDefinition(
            name: 'flex',
            type: PropertyType.int_,
            displayName: 'Flex',
            nullable: true,
            defaultValue: 1,
            category: 'Layout',
            description: 'Flex factor for space distribution',
            min: 1,
          ),
        ],
      ),
    );
  }
}

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

  /// Check if a parent widget can accept a child widget.
  ///
  /// Returns true if:
  /// - Parent widget accepts children
  /// - Child widget has no parent constraint, or its constraint matches parent
  ///
  /// Returns false if:
  /// - Parent widget type is not registered
  /// - Parent widget doesn't accept children
  /// - Child has a parent constraint that doesn't match parent type
  bool canAcceptChild(String parentType, String childType) {
    final parentDef = _definitions[parentType];
    if (parentDef == null) return false;
    if (!parentDef.acceptsChildren) return false;

    final childDef = _definitions[childType];
    if (childDef == null) {
      // Unknown child type - allow if parent accepts children
      return parentDef.acceptsChildren;
    }

    // Check if child has a parent constraint
    if (childDef.parentConstraint != null) {
      // 'Flex' constraint matches Row and Column
      if (childDef.parentConstraint == 'Flex') {
        return parentType == 'Row' || parentType == 'Column';
      }
      return parentType == childDef.parentConstraint;
    }

    return true;
  }
}

/// Default widget registry with Phase 1, Phase 2, and Phase 6 widgets.
///
/// Phase 1: Container, Text, Row, Column, SizedBox
/// Phase 2 Task 9: Stack, Expanded, Flexible, Padding, Center, Align, Spacer
/// Phase 2 Task 10: Icon, Image, Divider, VerticalDivider
/// Phase 2 Task 11: ElevatedButton, TextButton, IconButton, Placeholder
/// Phase 6: TextField, Checkbox, Switch, Slider, ListView, GridView,
///          SingleChildScrollView, Card, ListTile, AppBar, Scaffold, Wrap
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

    // Phase 2 Task 10: Content widgets
    _registerIconWidget();
    _registerImageWidget();
    _registerDividerWidget();
    _registerVerticalDividerWidget();

    // Phase 2 Task 11: Input widgets
    _registerElevatedButtonWidget();
    _registerTextButtonWidget();
    _registerIconButtonWidget();
    _registerPlaceholderWidget();

    // Phase 6: Form Input widgets
    _registerTextFieldWidget();
    _registerCheckboxWidget();
    _registerSwitchWidget();
    _registerSliderWidget();

    // Phase 6: Scrolling widgets
    _registerListViewWidget();
    _registerGridViewWidget();
    _registerSingleChildScrollViewWidget();

    // Phase 6: Structural widgets
    _registerCardWidget();
    _registerListTileWidget();
    _registerAppBarWidget();
    _registerScaffoldWidget();
    _registerWrapWidget();
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

  // Phase 2 Task 10: Content widgets

  void _registerIconWidget() {
    register(
      const WidgetDefinition(
        type: 'Icon',
        category: WidgetCategory.content,
        displayName: 'Icon',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'star',
        description: 'A Material Design icon',
        properties: [
          PropertyDefinition(
            name: 'icon',
            type: PropertyType.enum_,
            displayName: 'Icon',
            nullable: false,
            defaultValue: 'Icons.star',
            category: 'Content',
            description: 'The icon to display',
            enumValues: [
              'Icons.star',
              'Icons.favorite',
              'Icons.home',
              'Icons.settings',
              'Icons.person',
              'Icons.search',
              'Icons.menu',
              'Icons.close',
              'Icons.add',
              'Icons.remove',
              'Icons.check',
              'Icons.edit',
              'Icons.delete',
              'Icons.share',
              'Icons.info',
              'Icons.warning',
              'Icons.error',
              'Icons.help',
              'Icons.arrow_back',
              'Icons.arrow_forward',
            ],
          ),
          PropertyDefinition(
            name: 'size',
            type: PropertyType.double_,
            displayName: 'Size',
            nullable: true,
            category: 'Size',
            description: 'Icon size in logical pixels',
            min: 1,
            max: 200,
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Style',
            description: 'Icon color',
          ),
        ],
      ),
    );
  }

  void _registerImageWidget() {
    register(
      const WidgetDefinition(
        type: 'Image',
        category: WidgetCategory.content,
        displayName: 'Image',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'image',
        description: 'Displays an image',
        properties: [
          PropertyDefinition(
            name: 'width',
            type: PropertyType.double_,
            displayName: 'Width',
            nullable: true,
            category: 'Size',
            description: 'Image width in logical pixels',
            min: 0,
          ),
          PropertyDefinition(
            name: 'height',
            type: PropertyType.double_,
            displayName: 'Height',
            nullable: true,
            category: 'Size',
            description: 'Image height in logical pixels',
            min: 0,
          ),
          PropertyDefinition(
            name: 'fit',
            type: PropertyType.enum_,
            displayName: 'Fit',
            nullable: true,
            category: 'Layout',
            description: 'How to inscribe the image into the space',
            enumValues: [
              'BoxFit.contain',
              'BoxFit.cover',
              'BoxFit.fill',
              'BoxFit.fitWidth',
              'BoxFit.fitHeight',
              'BoxFit.none',
              'BoxFit.scaleDown',
            ],
          ),
          PropertyDefinition(
            name: 'alignment',
            type: PropertyType.alignment,
            displayName: 'Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to align the image within its bounds',
          ),
        ],
      ),
    );
  }

  void _registerDividerWidget() {
    register(
      const WidgetDefinition(
        type: 'Divider',
        category: WidgetCategory.content,
        displayName: 'Divider',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'horizontal_rule',
        description: 'A horizontal line divider',
        properties: [
          PropertyDefinition(
            name: 'thickness',
            type: PropertyType.double_,
            displayName: 'Thickness',
            nullable: true,
            category: 'Size',
            description: 'Line thickness in logical pixels',
            min: 0,
          ),
          PropertyDefinition(
            name: 'indent',
            type: PropertyType.double_,
            displayName: 'Indent',
            nullable: true,
            category: 'Spacing',
            description: 'Leading empty space',
            min: 0,
          ),
          PropertyDefinition(
            name: 'endIndent',
            type: PropertyType.double_,
            displayName: 'End Indent',
            nullable: true,
            category: 'Spacing',
            description: 'Trailing empty space',
            min: 0,
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Style',
            description: 'Line color',
          ),
        ],
      ),
    );
  }

  void _registerVerticalDividerWidget() {
    register(
      const WidgetDefinition(
        type: 'VerticalDivider',
        category: WidgetCategory.content,
        displayName: 'Vertical Divider',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'more_vert',
        description: 'A vertical line divider',
        properties: [
          PropertyDefinition(
            name: 'thickness',
            type: PropertyType.double_,
            displayName: 'Thickness',
            nullable: true,
            category: 'Size',
            description: 'Line thickness in logical pixels',
            min: 0,
          ),
          PropertyDefinition(
            name: 'width',
            type: PropertyType.double_,
            displayName: 'Width',
            nullable: true,
            category: 'Size',
            description: 'Total width including indents',
            min: 0,
          ),
          PropertyDefinition(
            name: 'indent',
            type: PropertyType.double_,
            displayName: 'Indent',
            nullable: true,
            category: 'Spacing',
            description: 'Top empty space',
            min: 0,
          ),
          PropertyDefinition(
            name: 'endIndent',
            type: PropertyType.double_,
            displayName: 'End Indent',
            nullable: true,
            category: 'Spacing',
            description: 'Bottom empty space',
            min: 0,
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Style',
            description: 'Line color',
          ),
        ],
      ),
    );
  }

  // Phase 2 Task 11: Input widgets

  void _registerElevatedButtonWidget() {
    register(
      const WidgetDefinition(
        type: 'ElevatedButton',
        category: WidgetCategory.input,
        displayName: 'Elevated Button',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'smart_button',
        description: 'A Material Design elevated button with shadow',
        properties: [
          PropertyDefinition(
            name: 'onPressed',
            type: PropertyType.bool_,
            displayName: 'Enabled',
            nullable: true,
            defaultValue: true,
            category: 'Behavior',
            description:
                'Whether the button is enabled (true) or disabled (false)',
          ),
          PropertyDefinition(
            name: 'style',
            type: PropertyType.enum_,
            displayName: 'Style',
            nullable: true,
            category: 'Style',
            description: 'Button style preset',
            enumValues: [
              'ButtonStyle.primary',
              'ButtonStyle.secondary',
              'ButtonStyle.error',
            ],
          ),
        ],
      ),
    );
  }

  void _registerTextButtonWidget() {
    register(
      const WidgetDefinition(
        type: 'TextButton',
        category: WidgetCategory.input,
        displayName: 'Text Button',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'touch_app',
        description: 'A Material Design text button without elevation',
        properties: [
          PropertyDefinition(
            name: 'onPressed',
            type: PropertyType.bool_,
            displayName: 'Enabled',
            nullable: true,
            defaultValue: true,
            category: 'Behavior',
            description:
                'Whether the button is enabled (true) or disabled (false)',
          ),
          PropertyDefinition(
            name: 'style',
            type: PropertyType.enum_,
            displayName: 'Style',
            nullable: true,
            category: 'Style',
            description: 'Button style preset',
            enumValues: [
              'ButtonStyle.primary',
              'ButtonStyle.secondary',
              'ButtonStyle.error',
            ],
          ),
        ],
      ),
    );
  }

  void _registerIconButtonWidget() {
    register(
      const WidgetDefinition(
        type: 'IconButton',
        category: WidgetCategory.input,
        displayName: 'Icon Button',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'radio_button_checked',
        description: 'A Material Design icon button',
        properties: [
          PropertyDefinition(
            name: 'icon',
            type: PropertyType.enum_,
            displayName: 'Icon',
            nullable: false,
            defaultValue: 'Icons.add',
            category: 'Content',
            description: 'The icon to display',
            enumValues: [
              'Icons.star',
              'Icons.favorite',
              'Icons.home',
              'Icons.settings',
              'Icons.person',
              'Icons.search',
              'Icons.menu',
              'Icons.close',
              'Icons.add',
              'Icons.remove',
              'Icons.check',
              'Icons.edit',
              'Icons.delete',
              'Icons.share',
              'Icons.info',
              'Icons.warning',
              'Icons.error',
              'Icons.help',
              'Icons.arrow_back',
              'Icons.arrow_forward',
            ],
          ),
          PropertyDefinition(
            name: 'iconSize',
            type: PropertyType.double_,
            displayName: 'Icon Size',
            nullable: true,
            category: 'Size',
            description: 'Icon size in logical pixels',
            min: 1,
            max: 200,
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Style',
            description: 'Icon color',
          ),
          PropertyDefinition(
            name: 'onPressed',
            type: PropertyType.bool_,
            displayName: 'Enabled',
            nullable: true,
            defaultValue: true,
            category: 'Behavior',
            description:
                'Whether the button is enabled (true) or disabled (false)',
          ),
          PropertyDefinition(
            name: 'tooltip',
            type: PropertyType.string,
            displayName: 'Tooltip',
            nullable: true,
            category: 'Content',
            description: 'Tooltip text shown on hover',
          ),
        ],
      ),
    );
  }

  void _registerPlaceholderWidget() {
    register(
      const WidgetDefinition(
        type: 'Placeholder',
        category: WidgetCategory.content,
        displayName: 'Placeholder',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'crop_free',
        description: 'A widget that draws a placeholder box',
        properties: [
          PropertyDefinition(
            name: 'fallbackWidth',
            type: PropertyType.double_,
            displayName: 'Fallback Width',
            nullable: true,
            defaultValue: 400.0,
            category: 'Size',
            description: 'Width when unconstrained',
            min: 0,
          ),
          PropertyDefinition(
            name: 'fallbackHeight',
            type: PropertyType.double_,
            displayName: 'Fallback Height',
            nullable: true,
            defaultValue: 400.0,
            category: 'Size',
            description: 'Height when unconstrained',
            min: 0,
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Style',
            description: 'Color of the placeholder lines',
          ),
          PropertyDefinition(
            name: 'strokeWidth',
            type: PropertyType.double_,
            displayName: 'Stroke Width',
            nullable: true,
            defaultValue: 2.0,
            category: 'Style',
            description: 'Width of the placeholder lines',
            min: 0,
          ),
        ],
      ),
    );
  }

  // Phase 6: Form Input widgets

  void _registerTextFieldWidget() {
    register(
      const WidgetDefinition(
        type: 'TextField',
        category: WidgetCategory.input,
        displayName: 'Text Field',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'text_format',
        description: 'A text input field with Material Design styling',
        properties: [
          PropertyDefinition(
            name: 'labelText',
            type: PropertyType.string,
            displayName: 'Label',
            nullable: true,
            category: 'Decoration',
            description: 'Label text displayed above the input',
          ),
          PropertyDefinition(
            name: 'hintText',
            type: PropertyType.string,
            displayName: 'Hint',
            nullable: true,
            category: 'Decoration',
            description: 'Hint text displayed when field is empty',
          ),
          PropertyDefinition(
            name: 'helperText',
            type: PropertyType.string,
            displayName: 'Helper',
            nullable: true,
            category: 'Decoration',
            description: 'Helper text displayed below the input',
          ),
          PropertyDefinition(
            name: 'errorText',
            type: PropertyType.string,
            displayName: 'Error',
            nullable: true,
            category: 'Decoration',
            description: 'Error text displayed below the input',
          ),
          PropertyDefinition(
            name: 'prefixIcon',
            type: PropertyType.enum_,
            displayName: 'Prefix Icon',
            nullable: true,
            category: 'Decoration',
            description: 'Icon displayed at the start of the input',
            enumValues: [
              'Icons.email',
              'Icons.phone',
              'Icons.person',
              'Icons.lock',
              'Icons.search',
              'Icons.location_on',
              'Icons.calendar_today',
              'Icons.access_time',
            ],
          ),
          PropertyDefinition(
            name: 'suffixIcon',
            type: PropertyType.enum_,
            displayName: 'Suffix Icon',
            nullable: true,
            category: 'Decoration',
            description: 'Icon displayed at the end of the input',
            enumValues: [
              'Icons.visibility',
              'Icons.visibility_off',
              'Icons.clear',
              'Icons.check',
              'Icons.arrow_drop_down',
            ],
          ),
          PropertyDefinition(
            name: 'obscureText',
            type: PropertyType.bool_,
            displayName: 'Obscure Text',
            nullable: true,
            defaultValue: false,
            category: 'Behavior',
            description: 'Hide text for password fields',
          ),
          PropertyDefinition(
            name: 'enabled',
            type: PropertyType.bool_,
            displayName: 'Enabled',
            nullable: true,
            defaultValue: true,
            category: 'Behavior',
            description: 'Whether the field accepts input',
          ),
          PropertyDefinition(
            name: 'maxLines',
            type: PropertyType.int_,
            displayName: 'Max Lines',
            nullable: true,
            defaultValue: 1,
            category: 'Layout',
            description: 'Maximum number of lines',
            min: 1,
          ),
          PropertyDefinition(
            name: 'keyboardType',
            type: PropertyType.enum_,
            displayName: 'Keyboard Type',
            nullable: true,
            category: 'Behavior',
            description: 'Type of keyboard to display',
            enumValues: [
              'TextInputType.text',
              'TextInputType.number',
              'TextInputType.emailAddress',
              'TextInputType.phone',
              'TextInputType.multiline',
              'TextInputType.url',
              'TextInputType.visiblePassword',
            ],
          ),
        ],
      ),
    );
  }

  void _registerCheckboxWidget() {
    register(
      const WidgetDefinition(
        type: 'Checkbox',
        category: WidgetCategory.input,
        displayName: 'Checkbox',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'check_box',
        description: 'A Material Design checkbox',
        properties: [
          PropertyDefinition(
            name: 'value',
            type: PropertyType.bool_,
            displayName: 'Value',
            nullable: true,
            defaultValue: false,
            category: 'State',
            description: 'Whether the checkbox is checked',
          ),
          PropertyDefinition(
            name: 'tristate',
            type: PropertyType.bool_,
            displayName: 'Tristate',
            nullable: true,
            defaultValue: false,
            category: 'Behavior',
            description: 'Allow null (indeterminate) state',
          ),
          PropertyDefinition(
            name: 'activeColor',
            type: PropertyType.color,
            displayName: 'Active Color',
            nullable: true,
            category: 'Style',
            description: 'Color when checked',
          ),
          PropertyDefinition(
            name: 'checkColor',
            type: PropertyType.color,
            displayName: 'Check Color',
            nullable: true,
            category: 'Style',
            description: 'Color of the check icon',
          ),
        ],
      ),
    );
  }

  void _registerSwitchWidget() {
    register(
      const WidgetDefinition(
        type: 'Switch',
        category: WidgetCategory.input,
        displayName: 'Switch',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'toggle_on',
        description: 'A Material Design toggle switch',
        properties: [
          PropertyDefinition(
            name: 'value',
            type: PropertyType.bool_,
            displayName: 'Value',
            nullable: false,
            defaultValue: false,
            category: 'State',
            description: 'Whether the switch is on',
          ),
          PropertyDefinition(
            name: 'activeColor',
            type: PropertyType.color,
            displayName: 'Active Color',
            nullable: true,
            category: 'Style',
            description: 'Thumb color when on',
          ),
          PropertyDefinition(
            name: 'activeTrackColor',
            type: PropertyType.color,
            displayName: 'Active Track Color',
            nullable: true,
            category: 'Style',
            description: 'Track color when on',
          ),
          PropertyDefinition(
            name: 'inactiveThumbColor',
            type: PropertyType.color,
            displayName: 'Inactive Thumb Color',
            nullable: true,
            category: 'Style',
            description: 'Thumb color when off',
          ),
          PropertyDefinition(
            name: 'inactiveTrackColor',
            type: PropertyType.color,
            displayName: 'Inactive Track Color',
            nullable: true,
            category: 'Style',
            description: 'Track color when off',
          ),
        ],
      ),
    );
  }

  void _registerSliderWidget() {
    register(
      const WidgetDefinition(
        type: 'Slider',
        category: WidgetCategory.input,
        displayName: 'Slider',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'linear_scale',
        description: 'A Material Design slider for selecting a value',
        properties: [
          PropertyDefinition(
            name: 'value',
            type: PropertyType.double_,
            displayName: 'Value',
            nullable: false,
            defaultValue: 0.5,
            category: 'State',
            description: 'Current value',
            min: 0,
            max: 1,
          ),
          PropertyDefinition(
            name: 'min',
            type: PropertyType.double_,
            displayName: 'Minimum',
            nullable: true,
            defaultValue: 0.0,
            category: 'Range',
            description: 'Minimum value',
          ),
          PropertyDefinition(
            name: 'max',
            type: PropertyType.double_,
            displayName: 'Maximum',
            nullable: true,
            defaultValue: 1.0,
            category: 'Range',
            description: 'Maximum value',
          ),
          PropertyDefinition(
            name: 'divisions',
            type: PropertyType.int_,
            displayName: 'Divisions',
            nullable: true,
            category: 'Behavior',
            description: 'Number of discrete divisions',
            min: 1,
          ),
          PropertyDefinition(
            name: 'label',
            type: PropertyType.string,
            displayName: 'Label',
            nullable: true,
            category: 'Display',
            description: 'Label shown above the slider',
          ),
          PropertyDefinition(
            name: 'activeColor',
            type: PropertyType.color,
            displayName: 'Active Color',
            nullable: true,
            category: 'Style',
            description: 'Color of the active portion',
          ),
          PropertyDefinition(
            name: 'inactiveColor',
            type: PropertyType.color,
            displayName: 'Inactive Color',
            nullable: true,
            category: 'Style',
            description: 'Color of the inactive portion',
          ),
        ],
      ),
    );
  }

  // Phase 6: Scrolling widgets

  void _registerListViewWidget() {
    register(
      const WidgetDefinition(
        type: 'ListView',
        category: WidgetCategory.layout,
        displayName: 'List View',
        acceptsChildren: true,
        maxChildren: null,
        iconName: 'view_list',
        description: 'A scrollable list of widgets',
        properties: [
          PropertyDefinition(
            name: 'scrollDirection',
            type: PropertyType.enum_,
            displayName: 'Scroll Direction',
            nullable: true,
            category: 'Layout',
            description: 'Direction of scrolling',
            enumValues: [
              'Axis.vertical',
              'Axis.horizontal',
            ],
          ),
          PropertyDefinition(
            name: 'reverse',
            type: PropertyType.bool_,
            displayName: 'Reverse',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Reverse scroll direction',
          ),
          PropertyDefinition(
            name: 'shrinkWrap',
            type: PropertyType.bool_,
            displayName: 'Shrink Wrap',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Shrink to content size',
          ),
          PropertyDefinition(
            name: 'padding',
            type: PropertyType.edgeInsets,
            displayName: 'Padding',
            nullable: true,
            category: 'Spacing',
            description: 'Padding around the list',
          ),
        ],
      ),
    );
  }

  void _registerGridViewWidget() {
    register(
      const WidgetDefinition(
        type: 'GridView',
        category: WidgetCategory.layout,
        displayName: 'Grid View',
        acceptsChildren: true,
        maxChildren: null,
        iconName: 'grid_view',
        description: 'A scrollable 2D grid of widgets',
        properties: [
          PropertyDefinition(
            name: 'crossAxisCount',
            type: PropertyType.int_,
            displayName: 'Columns',
            nullable: true,
            defaultValue: 2,
            category: 'Layout',
            description: 'Number of columns',
            min: 1,
          ),
          PropertyDefinition(
            name: 'mainAxisSpacing',
            type: PropertyType.double_,
            displayName: 'Main Axis Spacing',
            nullable: true,
            defaultValue: 0.0,
            category: 'Spacing',
            description: 'Spacing along main axis',
            min: 0,
          ),
          PropertyDefinition(
            name: 'crossAxisSpacing',
            type: PropertyType.double_,
            displayName: 'Cross Axis Spacing',
            nullable: true,
            defaultValue: 0.0,
            category: 'Spacing',
            description: 'Spacing along cross axis',
            min: 0,
          ),
          PropertyDefinition(
            name: 'childAspectRatio',
            type: PropertyType.double_,
            displayName: 'Child Aspect Ratio',
            nullable: true,
            defaultValue: 1.0,
            category: 'Layout',
            description: 'Width to height ratio of children',
            min: 0.1,
          ),
          PropertyDefinition(
            name: 'shrinkWrap',
            type: PropertyType.bool_,
            displayName: 'Shrink Wrap',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Shrink to content size',
          ),
          PropertyDefinition(
            name: 'padding',
            type: PropertyType.edgeInsets,
            displayName: 'Padding',
            nullable: true,
            category: 'Spacing',
            description: 'Padding around the grid',
          ),
        ],
      ),
    );
  }

  void _registerSingleChildScrollViewWidget() {
    register(
      const WidgetDefinition(
        type: 'SingleChildScrollView',
        category: WidgetCategory.layout,
        displayName: 'Scroll View',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'unfold_more',
        description: 'Makes a single child scrollable',
        properties: [
          PropertyDefinition(
            name: 'scrollDirection',
            type: PropertyType.enum_,
            displayName: 'Scroll Direction',
            nullable: true,
            category: 'Layout',
            description: 'Direction of scrolling',
            enumValues: [
              'Axis.vertical',
              'Axis.horizontal',
            ],
          ),
          PropertyDefinition(
            name: 'reverse',
            type: PropertyType.bool_,
            displayName: 'Reverse',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Reverse scroll direction',
          ),
          PropertyDefinition(
            name: 'padding',
            type: PropertyType.edgeInsets,
            displayName: 'Padding',
            nullable: true,
            category: 'Spacing',
            description: 'Padding around the content',
          ),
        ],
      ),
    );
  }

  // Phase 6: Structural widgets

  void _registerCardWidget() {
    register(
      const WidgetDefinition(
        type: 'Card',
        category: WidgetCategory.layout,
        displayName: 'Card',
        acceptsChildren: true,
        maxChildren: 1,
        iconName: 'credit_card',
        description: 'A Material Design card with elevation',
        properties: [
          PropertyDefinition(
            name: 'elevation',
            type: PropertyType.double_,
            displayName: 'Elevation',
            nullable: true,
            defaultValue: 1.0,
            category: 'Style',
            description: 'Shadow elevation',
            min: 0,
          ),
          PropertyDefinition(
            name: 'color',
            type: PropertyType.color,
            displayName: 'Color',
            nullable: true,
            category: 'Style',
            description: 'Background color',
          ),
          PropertyDefinition(
            name: 'shadowColor',
            type: PropertyType.color,
            displayName: 'Shadow Color',
            nullable: true,
            category: 'Style',
            description: 'Color of the shadow',
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
            name: 'borderRadius',
            type: PropertyType.double_,
            displayName: 'Border Radius',
            nullable: true,
            defaultValue: 12.0,
            category: 'Style',
            description: 'Corner radius',
            min: 0,
          ),
        ],
      ),
    );
  }

  void _registerListTileWidget() {
    register(
      const WidgetDefinition(
        type: 'ListTile',
        category: WidgetCategory.content,
        displayName: 'List Tile',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'view_headline',
        description: 'A single fixed-height row for lists',
        properties: [
          PropertyDefinition(
            name: 'title',
            type: PropertyType.string,
            displayName: 'Title',
            nullable: true,
            defaultValue: 'Title',
            category: 'Content',
            description: 'Primary text',
          ),
          PropertyDefinition(
            name: 'subtitle',
            type: PropertyType.string,
            displayName: 'Subtitle',
            nullable: true,
            category: 'Content',
            description: 'Secondary text',
          ),
          PropertyDefinition(
            name: 'leadingIcon',
            type: PropertyType.enum_,
            displayName: 'Leading Icon',
            nullable: true,
            category: 'Content',
            description: 'Icon at the start',
            enumValues: [
              'Icons.person',
              'Icons.email',
              'Icons.phone',
              'Icons.location_on',
              'Icons.star',
              'Icons.folder',
              'Icons.settings',
              'Icons.info',
            ],
          ),
          PropertyDefinition(
            name: 'trailingIcon',
            type: PropertyType.enum_,
            displayName: 'Trailing Icon',
            nullable: true,
            category: 'Content',
            description: 'Icon at the end',
            enumValues: [
              'Icons.chevron_right',
              'Icons.arrow_forward',
              'Icons.more_vert',
              'Icons.check',
              'Icons.close',
            ],
          ),
          PropertyDefinition(
            name: 'dense',
            type: PropertyType.bool_,
            displayName: 'Dense',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Reduce height',
          ),
          PropertyDefinition(
            name: 'enabled',
            type: PropertyType.bool_,
            displayName: 'Enabled',
            nullable: true,
            defaultValue: true,
            category: 'Behavior',
            description: 'Whether tappable',
          ),
          PropertyDefinition(
            name: 'selected',
            type: PropertyType.bool_,
            displayName: 'Selected',
            nullable: true,
            defaultValue: false,
            category: 'State',
            description: 'Whether selected',
          ),
        ],
      ),
    );
  }

  void _registerAppBarWidget() {
    register(
      const WidgetDefinition(
        type: 'AppBar',
        category: WidgetCategory.layout,
        displayName: 'App Bar',
        acceptsChildren: false,
        maxChildren: 0,
        iconName: 'web_asset',
        description: 'A Material Design app bar',
        properties: [
          PropertyDefinition(
            name: 'title',
            type: PropertyType.string,
            displayName: 'Title',
            nullable: true,
            defaultValue: 'App Bar',
            category: 'Content',
            description: 'Title text',
          ),
          PropertyDefinition(
            name: 'centerTitle',
            type: PropertyType.bool_,
            displayName: 'Center Title',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Center the title',
          ),
          PropertyDefinition(
            name: 'leadingIcon',
            type: PropertyType.enum_,
            displayName: 'Leading Icon',
            nullable: true,
            category: 'Content',
            description: 'Icon at the start',
            enumValues: [
              'Icons.menu',
              'Icons.arrow_back',
              'Icons.close',
            ],
          ),
          PropertyDefinition(
            name: 'backgroundColor',
            type: PropertyType.color,
            displayName: 'Background Color',
            nullable: true,
            category: 'Style',
            description: 'Background color',
          ),
          PropertyDefinition(
            name: 'foregroundColor',
            type: PropertyType.color,
            displayName: 'Foreground Color',
            nullable: true,
            category: 'Style',
            description: 'Text and icon color',
          ),
          PropertyDefinition(
            name: 'elevation',
            type: PropertyType.double_,
            displayName: 'Elevation',
            nullable: true,
            defaultValue: 4.0,
            category: 'Style',
            description: 'Shadow elevation',
            min: 0,
          ),
        ],
      ),
    );
  }

  void _registerScaffoldWidget() {
    register(
      const WidgetDefinition(
        type: 'Scaffold',
        category: WidgetCategory.layout,
        displayName: 'Scaffold',
        acceptsChildren: true,
        maxChildren: 1, // body only for now
        iconName: 'dashboard',
        description: 'Material Design visual layout structure',
        properties: [
          PropertyDefinition(
            name: 'backgroundColor',
            type: PropertyType.color,
            displayName: 'Background Color',
            nullable: true,
            category: 'Style',
            description: 'Background color',
          ),
          PropertyDefinition(
            name: 'extendBody',
            type: PropertyType.bool_,
            displayName: 'Extend Body',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Extend body behind bottom nav',
          ),
          PropertyDefinition(
            name: 'extendBodyBehindAppBar',
            type: PropertyType.bool_,
            displayName: 'Extend Body Behind AppBar',
            nullable: true,
            defaultValue: false,
            category: 'Layout',
            description: 'Extend body behind app bar',
          ),
        ],
      ),
    );
  }

  void _registerWrapWidget() {
    register(
      const WidgetDefinition(
        type: 'Wrap',
        category: WidgetCategory.layout,
        displayName: 'Wrap',
        acceptsChildren: true,
        maxChildren: null,
        iconName: 'wrap_text',
        description: 'A widget that wraps children to multiple lines',
        properties: [
          PropertyDefinition(
            name: 'direction',
            type: PropertyType.enum_,
            displayName: 'Direction',
            nullable: true,
            category: 'Layout',
            description: 'Direction of children flow',
            enumValues: [
              'Axis.horizontal',
              'Axis.vertical',
            ],
          ),
          PropertyDefinition(
            name: 'alignment',
            type: PropertyType.enum_,
            displayName: 'Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to align children within a run',
            enumValues: [
              'WrapAlignment.start',
              'WrapAlignment.center',
              'WrapAlignment.end',
              'WrapAlignment.spaceBetween',
              'WrapAlignment.spaceAround',
              'WrapAlignment.spaceEvenly',
            ],
          ),
          PropertyDefinition(
            name: 'spacing',
            type: PropertyType.double_,
            displayName: 'Spacing',
            nullable: true,
            defaultValue: 0.0,
            category: 'Spacing',
            description: 'Spacing between children',
            min: 0,
          ),
          PropertyDefinition(
            name: 'runSpacing',
            type: PropertyType.double_,
            displayName: 'Run Spacing',
            nullable: true,
            defaultValue: 0.0,
            category: 'Spacing',
            description: 'Spacing between runs',
            min: 0,
          ),
          PropertyDefinition(
            name: 'runAlignment',
            type: PropertyType.enum_,
            displayName: 'Run Alignment',
            nullable: true,
            category: 'Layout',
            description: 'How to align runs',
            enumValues: [
              'WrapAlignment.start',
              'WrapAlignment.center',
              'WrapAlignment.end',
              'WrapAlignment.spaceBetween',
              'WrapAlignment.spaceAround',
              'WrapAlignment.spaceEvenly',
            ],
          ),
        ],
      ),
    );
  }
}

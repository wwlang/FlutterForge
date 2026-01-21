import 'package:flutter/material.dart';

import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/design_proxy.dart';
import 'package:flutter_forge/features/canvas/nested_drop_zone.dart';
import 'package:flutter_forge/features/canvas/widget_selection_overlay.dart';
import 'package:flutter_forge/shared/registry/registry.dart';

/// Renders a WidgetNode tree as live Flutter widgets.
///
/// Recursively builds the widget tree from node definitions,
/// wrapping each in a DesignProxy for event interception.
class WidgetRenderer extends StatelessWidget {
  /// Creates a widget renderer.
  const WidgetRenderer({
    required this.nodeId,
    required this.nodes,
    required this.registry,
    required this.selectedWidgetId,
    required this.onWidgetSelected,
    this.onWidgetDropped,
    super.key,
  });

  /// ID of the node to render.
  final String nodeId;

  /// Map of all nodes in the tree.
  final Map<String, WidgetNode> nodes;

  /// Widget registry for type definitions.
  final WidgetRegistry registry;

  /// ID of the currently selected widget.
  final String? selectedWidgetId;

  /// Callback when a widget is selected.
  final void Function(String id) onWidgetSelected;

  /// Callback when a widget is dropped into a nested container.
  final void Function(String widgetType, String parentId)? onWidgetDropped;

  @override
  Widget build(BuildContext context) {
    final node = nodes[nodeId];
    if (node == null) {
      return ErrorWidget.withDetails(message: 'Node not found: $nodeId');
    }

    final definition = registry.get(node.type);
    if (definition == null) {
      return ErrorWidget.withDetails(
        message: 'Unknown widget type: ${node.type}',
      );
    }

    // Build the widget based on type
    var renderedWidget = _buildWidget(node, definition);

    // Wrap in nested drop zone if widget accepts children
    if (definition.acceptsChildren) {
      renderedWidget = NestedDropZone(
        parentId: nodeId,
        acceptsChildren: definition.acceptsChildren,
        hasChild: node.childrenIds.isNotEmpty && definition.isSingleChild,
        maxChildren: definition.maxChildren,
        childCount: node.childrenIds.length,
        onWidgetDropped: (type, parentId) {
          onWidgetDropped?.call(type, parentId);
        },
        child: renderedWidget,
      );
    }

    // Wrap in DesignProxy for event interception
    renderedWidget = DesignProxy(
      nodeId: nodeId,
      onTap: () => onWidgetSelected(nodeId),
      child: renderedWidget,
    );

    // Add selection overlay if selected
    if (selectedWidgetId == nodeId) {
      renderedWidget = WidgetSelectionOverlay(child: renderedWidget);
    }

    return renderedWidget;
  }

  Widget _buildWidget(WidgetNode node, WidgetDefinition definition) {
    switch (node.type) {
      case 'Container':
        return _buildContainer(node);
      case 'Text':
        return _buildText(node);
      case 'Row':
        return _buildRow(node);
      case 'Column':
        return _buildColumn(node);
      case 'SizedBox':
        return _buildSizedBox(node);
      case 'Icon':
        return _buildIcon(node);
      case 'Stack':
        return _buildStack(node);
      case 'Expanded':
        return _buildExpanded(node);
      case 'Flexible':
        return _buildFlexible(node);
      case 'Padding':
        return _buildPadding(node);
      case 'Center':
        return _buildCenter(node);
      case 'Align':
        return _buildAlign(node);
      case 'Spacer':
        return _buildSpacer(node);
      case 'Image':
        return _buildImage(node);
      case 'Divider':
        return _buildDivider(node);
      case 'VerticalDivider':
        return _buildVerticalDivider(node);
      case 'ElevatedButton':
        return _buildElevatedButton(node);
      case 'TextButton':
        return _buildTextButton(node);
      case 'IconButton':
        return _buildIconButton(node);
      case 'Placeholder':
        return _buildPlaceholder(node);
      default:
        return ErrorWidget.withDetails(
          message: 'Unhandled widget: ${node.type}',
        );
    }
  }

  Widget _buildContainer(WidgetNode node) {
    final width = node.properties['width'] as double?;
    final height = node.properties['height'] as double?;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;

    // Build child if present
    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    // If container has no visual properties (width, height, color, child),
    // show a design-time placeholder so users can see and interact with it
    final hasVisualProperties =
        width != null || height != null || color != null || child != null;

    if (!hasVisualProperties) {
      return const _DesignTimePlaceholder(
        label: 'Container',
        width: 100,
        height: 100,
      );
    }

    return Container(
      width: width,
      height: height,
      color: color,
      constraints: width != null || height != null
          ? BoxConstraints(
              maxWidth: width ?? double.infinity,
              maxHeight: height ?? double.infinity,
            )
          : null,
      child: child,
    );
  }

  Widget _buildText(WidgetNode node) {
    final data = node.properties['data'] as String? ?? 'Text';
    final fontSize = node.properties['fontSize'] as double?;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;

    return Text(
      data,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }

  Widget _buildRow(WidgetNode node) {
    final mainAxisAlignment = _parseMainAxisAlignment(
      node.properties['mainAxisAlignment'] as String?,
    );
    final crossAxisAlignment = _parseCrossAxisAlignment(
      node.properties['crossAxisAlignment'] as String?,
    );

    // If Row has no children, show a design-time placeholder
    if (node.childrenIds.isEmpty) {
      return const _DesignTimePlaceholder(
        label: 'Row',
        width: 150,
        height: 40,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildChildren(node.childrenIds),
    );
  }

  Widget _buildColumn(WidgetNode node) {
    final mainAxisAlignment = _parseMainAxisAlignment(
      node.properties['mainAxisAlignment'] as String?,
    );
    final crossAxisAlignment = _parseCrossAxisAlignment(
      node.properties['crossAxisAlignment'] as String?,
    );

    // If Column has no children, show a design-time placeholder
    if (node.childrenIds.isEmpty) {
      return const _DesignTimePlaceholder(
        label: 'Column',
        width: 40,
        height: 150,
      );
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildChildren(node.childrenIds),
    );
  }

  Widget _buildSizedBox(WidgetNode node) {
    final width = node.properties['width'] as double?;
    final height = node.properties['height'] as double?;

    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    // If SizedBox has no size and no child, show a design-time placeholder
    final hasVisualProperties =
        width != null || height != null || child != null;

    if (!hasVisualProperties) {
      return const _DesignTimePlaceholder(
        label: 'SizedBox',
        width: 50,
        height: 50,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }

  Widget _buildIcon(WidgetNode node) {
    final iconName = node.properties['icon'] as String? ?? 'Icons.star';
    final size = node.properties['size'] as double?;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;

    return Icon(
      _parseIconData(iconName),
      size: size,
      color: color,
    );
  }

  IconData _parseIconData(String iconName) {
    switch (iconName) {
      case 'Icons.star':
        return Icons.star;
      case 'Icons.favorite':
        return Icons.favorite;
      case 'Icons.home':
        return Icons.home;
      case 'Icons.settings':
        return Icons.settings;
      case 'Icons.person':
        return Icons.person;
      case 'Icons.search':
        return Icons.search;
      case 'Icons.menu':
        return Icons.menu;
      case 'Icons.close':
        return Icons.close;
      case 'Icons.add':
        return Icons.add;
      case 'Icons.remove':
        return Icons.remove;
      case 'Icons.check':
        return Icons.check;
      case 'Icons.edit':
        return Icons.edit;
      case 'Icons.delete':
        return Icons.delete;
      case 'Icons.share':
        return Icons.share;
      case 'Icons.info':
        return Icons.info;
      case 'Icons.warning':
        return Icons.warning;
      case 'Icons.error':
        return Icons.error;
      case 'Icons.help':
        return Icons.help;
      case 'Icons.arrow_back':
        return Icons.arrow_back;
      case 'Icons.arrow_forward':
        return Icons.arrow_forward;
      default:
        return Icons.star;
    }
  }

  Widget _buildStack(WidgetNode node) {
    if (node.childrenIds.isEmpty) {
      return const _DesignTimePlaceholder(
        label: 'Stack',
        width: 100,
        height: 100,
      );
    }

    return Stack(
      children: _buildChildren(node.childrenIds),
    );
  }

  Widget _buildExpanded(WidgetNode node) {
    final flex = node.properties['flex'] as int? ?? 1;

    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    if (child == null) {
      return const _DesignTimePlaceholder(
        label: 'Expanded',
        width: 60,
        height: 40,
      );
    }

    return Expanded(flex: flex, child: child);
  }

  Widget _buildFlexible(WidgetNode node) {
    final flex = node.properties['flex'] as int? ?? 1;

    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    if (child == null) {
      return const _DesignTimePlaceholder(
        label: 'Flexible',
        width: 60,
        height: 40,
      );
    }

    return Flexible(flex: flex, child: child);
  }

  Widget _buildPadding(WidgetNode node) {
    // Parse padding value - could be double (uniform) or EdgeInsets map
    EdgeInsets padding;
    final paddingValue = node.properties['padding'];
    if (paddingValue is double) {
      padding = EdgeInsets.all(paddingValue);
    } else if (paddingValue is Map) {
      padding = EdgeInsets.only(
        left: (paddingValue['left'] as num?)?.toDouble() ?? 0,
        top: (paddingValue['top'] as num?)?.toDouble() ?? 0,
        right: (paddingValue['right'] as num?)?.toDouble() ?? 0,
        bottom: (paddingValue['bottom'] as num?)?.toDouble() ?? 0,
      );
    } else {
      padding = const EdgeInsets.all(8);
    }

    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    if (child == null) {
      return _DesignTimePlaceholder(
        label:
            'Padding ${padding.horizontal.toInt()}x${padding.vertical.toInt()}',
        width: 60 + padding.horizontal,
        height: 40 + padding.vertical,
      );
    }

    return Padding(padding: padding, child: child);
  }

  Widget _buildCenter(WidgetNode node) {
    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    if (child == null) {
      return const _DesignTimePlaceholder(
        label: 'Center',
        width: 60,
        height: 40,
      );
    }

    return Center(child: child);
  }

  Widget _buildAlign(WidgetNode node) {
    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    if (child == null) {
      return const _DesignTimePlaceholder(
        label: 'Align',
        width: 60,
        height: 40,
      );
    }

    return Align(child: child);
  }

  Widget _buildSpacer(WidgetNode node) {
    final flex = node.properties['flex'] as int? ?? 1;
    return Spacer(flex: flex);
  }

  Widget _buildImage(WidgetNode node) {
    final width = node.properties['width'] as double?;
    final height = node.properties['height'] as double?;

    // Image widget needs a placeholder since we don't have actual images
    return Container(
      width: width ?? 100,
      height: height ?? 100,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.image, size: 48),
      ),
    );
  }

  Widget _buildDivider(WidgetNode node) {
    final thickness = node.properties['thickness'] as double?;
    final indent = node.properties['indent'] as double?;
    final endIndent = node.properties['endIndent'] as double?;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;

    return Divider(
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }

  Widget _buildVerticalDivider(WidgetNode node) {
    final thickness = node.properties['thickness'] as double?;
    final width = node.properties['width'] as double?;
    final indent = node.properties['indent'] as double?;
    final endIndent = node.properties['endIndent'] as double?;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;

    return VerticalDivider(
      thickness: thickness,
      width: width,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }

  Widget _buildElevatedButton(WidgetNode node) {
    final enabled = node.properties['onPressed'] as bool? ?? true;

    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    } else {
      child = const Text('Button');
    }

    return ElevatedButton(
      onPressed: enabled ? () {} : null,
      child: child,
    );
  }

  Widget _buildTextButton(WidgetNode node) {
    final enabled = node.properties['onPressed'] as bool? ?? true;

    Widget? child;
    if (node.childrenIds.isNotEmpty) {
      child = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    } else {
      child = const Text('Button');
    }

    return TextButton(
      onPressed: enabled ? () {} : null,
      child: child,
    );
  }

  Widget _buildIconButton(WidgetNode node) {
    final enabled = node.properties['onPressed'] as bool? ?? true;
    final iconName = node.properties['icon'] as String? ?? 'Icons.add';
    final iconSize = node.properties['iconSize'] as double?;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;
    final tooltip = node.properties['tooltip'] as String?;

    return IconButton(
      onPressed: enabled ? () {} : null,
      icon: Icon(
        _parseIconData(iconName),
        size: iconSize,
        color: color,
      ),
      tooltip: tooltip,
    );
  }

  Widget _buildPlaceholder(WidgetNode node) {
    final fallbackWidth = node.properties['fallbackWidth'] as double? ?? 400;
    final fallbackHeight = node.properties['fallbackHeight'] as double? ?? 400;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;
    final strokeWidth = node.properties['strokeWidth'] as double? ?? 2;

    return Placeholder(
      fallbackWidth: fallbackWidth,
      fallbackHeight: fallbackHeight,
      color: color ?? const Color(0xFF455A64),
      strokeWidth: strokeWidth,
    );
  }

  List<Widget> _buildChildren(List<String> childrenIds) {
    return childrenIds.map((childId) {
      return WidgetRenderer(
        nodeId: childId,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }).toList();
  }

  MainAxisAlignment _parseMainAxisAlignment(String? value) {
    switch (value) {
      case 'MainAxisAlignment.start':
        return MainAxisAlignment.start;
      case 'MainAxisAlignment.center':
        return MainAxisAlignment.center;
      case 'MainAxisAlignment.end':
        return MainAxisAlignment.end;
      case 'MainAxisAlignment.spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'MainAxisAlignment.spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'MainAxisAlignment.spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  CrossAxisAlignment _parseCrossAxisAlignment(String? value) {
    switch (value) {
      case 'CrossAxisAlignment.start':
        return CrossAxisAlignment.start;
      case 'CrossAxisAlignment.center':
        return CrossAxisAlignment.center;
      case 'CrossAxisAlignment.end':
        return CrossAxisAlignment.end;
      case 'CrossAxisAlignment.stretch':
        return CrossAxisAlignment.stretch;
      case 'CrossAxisAlignment.baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.center;
    }
  }
}

/// Design-time placeholder for widgets with no visual properties.
///
/// Shows a dashed border with label to indicate the widget exists
/// but has no configured visual appearance yet.
class _DesignTimePlaceholder extends StatelessWidget {
  const _DesignTimePlaceholder({
    required this.label,
    required this.width,
    required this.height,
  });

  final String label;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outline.withValues(alpha: 0.5);
    final textColor = theme.colorScheme.onSurfaceVariant;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        borderRadius: BorderRadius.circular(4),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Center(
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

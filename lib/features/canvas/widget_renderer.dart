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

    return SizedBox(
      width: width,
      height: height,
      child: child,
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

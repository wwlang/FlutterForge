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
      // Phase 1 widgets
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

      // Phase 2 Task 9: Layout widgets
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

      // Phase 2 Task 10: Content widgets
      case 'Image':
        return _buildImage(node);
      case 'Divider':
        return _buildDivider(node);
      case 'VerticalDivider':
        return _buildVerticalDivider(node);

      // Phase 2 Task 11: Input widgets
      case 'ElevatedButton':
        return _buildElevatedButton(node);
      case 'TextButton':
        return _buildTextButton(node);
      case 'IconButton':
        return _buildIconButton(node);
      case 'Placeholder':
        return _buildPlaceholder(node);

      // Phase 6: Form Input widgets
      case 'TextField':
        return _buildTextField(node);
      case 'Checkbox':
        return _buildCheckbox(node);
      case 'Switch':
        return _buildSwitch(node);
      case 'Slider':
        return _buildSlider(node);

      // Phase 6: Scrolling widgets
      case 'ListView':
        return _buildListView(node);
      case 'GridView':
        return _buildGridView(node);
      case 'SingleChildScrollView':
        return _buildSingleChildScrollView(node);

      // Phase 6: Structural widgets
      case 'Card':
        return _buildCard(node);
      case 'ListTile':
        return _buildListTile(node);
      case 'AppBar':
        return _buildAppBar(node);
      case 'Scaffold':
        return _buildScaffold(node);
      case 'Wrap':
        return _buildWrap(node);

      default:
        return ErrorWidget.withDetails(
          message: 'Unhandled widget: ${node.type}',
        );
    }
  }

  // Phase 1 widgets

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

  // Phase 2 Task 9: Layout widgets

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
      case 'Icons.email':
        return Icons.email;
      case 'Icons.phone':
        return Icons.phone;
      case 'Icons.lock':
        return Icons.lock;
      case 'Icons.location_on':
        return Icons.location_on;
      case 'Icons.calendar_today':
        return Icons.calendar_today;
      case 'Icons.access_time':
        return Icons.access_time;
      case 'Icons.visibility':
        return Icons.visibility;
      case 'Icons.visibility_off':
        return Icons.visibility_off;
      case 'Icons.clear':
        return Icons.clear;
      case 'Icons.arrow_drop_down':
        return Icons.arrow_drop_down;
      case 'Icons.folder':
        return Icons.folder;
      case 'Icons.chevron_right':
        return Icons.chevron_right;
      case 'Icons.more_vert':
        return Icons.more_vert;
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

  // Phase 2 Task 10: Content widgets

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

  // Phase 2 Task 11: Input widgets

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

  // Phase 6: Form Input widgets

  Widget _buildTextField(WidgetNode node) {
    final labelText = node.properties['labelText'] as String?;
    final hintText = node.properties['hintText'] as String?;
    final helperText = node.properties['helperText'] as String?;
    final errorText = node.properties['errorText'] as String?;
    final obscureText = node.properties['obscureText'] as bool? ?? false;
    final enabled = node.properties['enabled'] as bool? ?? true;
    final maxLines = node.properties['maxLines'] as int? ?? 1;
    final prefixIcon = node.properties['prefixIcon'] as String?;
    final suffixIcon = node.properties['suffixIcon'] as String?;

    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon:
            prefixIcon != null ? Icon(_parseIconData(prefixIcon)) : null,
        suffixIcon:
            suffixIcon != null ? Icon(_parseIconData(suffixIcon)) : null,
      ),
      obscureText: obscureText,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
    );
  }

  Widget _buildCheckbox(WidgetNode node) {
    final value = node.properties['value'] as bool? ?? false;
    final tristate = node.properties['tristate'] as bool? ?? false;
    final activeColorValue = node.properties['activeColor'] as int?;
    final activeColor =
        activeColorValue != null ? Color(activeColorValue) : null;
    final checkColorValue = node.properties['checkColor'] as int?;
    final checkColor = checkColorValue != null ? Color(checkColorValue) : null;

    return Checkbox(
      value: tristate ? (value ? true : null) : value,
      tristate: tristate,
      activeColor: activeColor,
      checkColor: checkColor,
      onChanged: (_) {},
    );
  }

  Widget _buildSwitch(WidgetNode node) {
    final value = node.properties['value'] as bool? ?? false;
    final activeColorValue = node.properties['activeColor'] as int?;
    final activeColor =
        activeColorValue != null ? Color(activeColorValue) : null;
    final activeTrackColorValue = node.properties['activeTrackColor'] as int?;
    final activeTrackColor =
        activeTrackColorValue != null ? Color(activeTrackColorValue) : null;
    final inactiveThumbColorValue =
        node.properties['inactiveThumbColor'] as int?;
    final inactiveThumbColor =
        inactiveThumbColorValue != null ? Color(inactiveThumbColorValue) : null;
    final inactiveTrackColorValue =
        node.properties['inactiveTrackColor'] as int?;
    final inactiveTrackColor =
        inactiveTrackColorValue != null ? Color(inactiveTrackColorValue) : null;

    return Switch(
      value: value,
      activeColor: activeColor,
      activeTrackColor: activeTrackColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      onChanged: (_) {},
    );
  }

  Widget _buildSlider(WidgetNode node) {
    final value = node.properties['value'] as double? ?? 0.5;
    final min = node.properties['min'] as double? ?? 0.0;
    final max = node.properties['max'] as double? ?? 1.0;
    final divisions = node.properties['divisions'] as int?;
    final label = node.properties['label'] as String?;
    final activeColorValue = node.properties['activeColor'] as int?;
    final activeColor =
        activeColorValue != null ? Color(activeColorValue) : null;
    final inactiveColorValue = node.properties['inactiveColor'] as int?;
    final inactiveColor =
        inactiveColorValue != null ? Color(inactiveColorValue) : null;

    return Slider(
      value: value.clamp(min, max),
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      onChanged: (_) {},
    );
  }

  // Phase 6: Scrolling widgets

  Widget _buildListView(WidgetNode node) {
    final scrollDirection = _parseAxis(
      node.properties['scrollDirection'] as String?,
    );
    final reverse = node.properties['reverse'] as bool? ?? false;
    final shrinkWrap = node.properties['shrinkWrap'] as bool? ?? false;
    final padding = _parseEdgeInsets(node.properties['padding']);

    if (node.childrenIds.isEmpty) {
      return const _DesignTimePlaceholder(
        label: 'ListView',
        width: 150,
        height: 200,
      );
    }

    return ListView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      padding: padding,
      children: _buildChildren(node.childrenIds),
    );
  }

  Widget _buildGridView(WidgetNode node) {
    final crossAxisCount = node.properties['crossAxisCount'] as int? ?? 2;
    final mainAxisSpacing = node.properties['mainAxisSpacing'] as double? ?? 0;
    final crossAxisSpacing =
        node.properties['crossAxisSpacing'] as double? ?? 0;
    final childAspectRatio =
        node.properties['childAspectRatio'] as double? ?? 1.0;
    final shrinkWrap = node.properties['shrinkWrap'] as bool? ?? false;
    final padding = _parseEdgeInsets(node.properties['padding']);

    if (node.childrenIds.isEmpty) {
      return const _DesignTimePlaceholder(
        label: 'GridView',
        width: 200,
        height: 200,
      );
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      shrinkWrap: shrinkWrap,
      padding: padding,
      children: _buildChildren(node.childrenIds),
    );
  }

  Widget _buildSingleChildScrollView(WidgetNode node) {
    final scrollDirection = _parseAxis(
      node.properties['scrollDirection'] as String?,
    );
    final reverse = node.properties['reverse'] as bool? ?? false;
    final padding = _parseEdgeInsets(node.properties['padding']);

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
        label: 'ScrollView',
        width: 100,
        height: 150,
      );
    }

    return SingleChildScrollView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      padding: padding,
      child: child,
    );
  }

  // Phase 6: Structural widgets

  Widget _buildCard(WidgetNode node) {
    final elevation = node.properties['elevation'] as double? ?? 1.0;
    final colorValue = node.properties['color'] as int?;
    final color = colorValue != null ? Color(colorValue) : null;
    final shadowColorValue = node.properties['shadowColor'] as int?;
    final shadowColor =
        shadowColorValue != null ? Color(shadowColorValue) : null;
    final margin = _parseEdgeInsets(node.properties['margin']);
    final borderRadius = node.properties['borderRadius'] as double? ?? 12.0;

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
      return Card(
        elevation: elevation,
        color: color,
        shadowColor: shadowColor,
        margin: margin,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: const SizedBox(
          width: 150,
          height: 100,
          child: Center(
            child: Text('Card', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
        ),
      );
    }

    return Card(
      elevation: elevation,
      color: color,
      shadowColor: shadowColor,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }

  Widget _buildListTile(WidgetNode node) {
    final title = node.properties['title'] as String? ?? 'Title';
    final subtitle = node.properties['subtitle'] as String?;
    final leadingIcon = node.properties['leadingIcon'] as String?;
    final trailingIcon = node.properties['trailingIcon'] as String?;
    final dense = node.properties['dense'] as bool? ?? false;
    final enabled = node.properties['enabled'] as bool? ?? true;
    final selected = node.properties['selected'] as bool? ?? false;

    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: leadingIcon != null ? Icon(_parseIconData(leadingIcon)) : null,
      trailing:
          trailingIcon != null ? Icon(_parseIconData(trailingIcon)) : null,
      dense: dense,
      enabled: enabled,
      selected: selected,
      onTap: enabled ? () {} : null,
    );
  }

  Widget _buildAppBar(WidgetNode node) {
    final title = node.properties['title'] as String? ?? 'App Bar';
    final centerTitle = node.properties['centerTitle'] as bool? ?? false;
    final leadingIcon = node.properties['leadingIcon'] as String?;
    final backgroundColorValue = node.properties['backgroundColor'] as int?;
    final backgroundColor =
        backgroundColorValue != null ? Color(backgroundColorValue) : null;
    final foregroundColorValue = node.properties['foregroundColor'] as int?;
    final foregroundColor =
        foregroundColorValue != null ? Color(foregroundColorValue) : null;
    final elevation = node.properties['elevation'] as double? ?? 4.0;

    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(_parseIconData(leadingIcon)),
              onPressed: () {},
            )
          : null,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
    );
  }

  Widget _buildScaffold(WidgetNode node) {
    final backgroundColorValue = node.properties['backgroundColor'] as int?;
    final backgroundColor =
        backgroundColorValue != null ? Color(backgroundColorValue) : null;
    final extendBody = node.properties['extendBody'] as bool? ?? false;
    final extendBodyBehindAppBar =
        node.properties['extendBodyBehindAppBar'] as bool? ?? false;

    Widget? body;
    if (node.childrenIds.isNotEmpty) {
      body = WidgetRenderer(
        nodeId: node.childrenIds.first,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: onWidgetSelected,
        onWidgetDropped: onWidgetDropped,
      );
    }

    // In design mode, wrap in a constrained box
    return Container(
      width: 300,
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Scaffold(
          backgroundColor: backgroundColor,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          body: body ??
              const Center(
                child: Text(
                  'Scaffold Body',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildWrap(WidgetNode node) {
    final direction = _parseAxis(node.properties['direction'] as String?);
    final alignment = _parseWrapAlignment(
      node.properties['alignment'] as String?,
    );
    final spacing = node.properties['spacing'] as double? ?? 0.0;
    final runSpacing = node.properties['runSpacing'] as double? ?? 0.0;
    final runAlignment = _parseWrapAlignment(
      node.properties['runAlignment'] as String?,
    );

    if (node.childrenIds.isEmpty) {
      return const _DesignTimePlaceholder(
        label: 'Wrap',
        width: 150,
        height: 60,
      );
    }

    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runSpacing: runSpacing,
      runAlignment: runAlignment,
      children: _buildChildren(node.childrenIds),
    );
  }

  // Helper methods

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

  Axis _parseAxis(String? value) {
    switch (value) {
      case 'Axis.horizontal':
        return Axis.horizontal;
      case 'Axis.vertical':
      default:
        return Axis.vertical;
    }
  }

  WrapAlignment _parseWrapAlignment(String? value) {
    switch (value) {
      case 'WrapAlignment.start':
        return WrapAlignment.start;
      case 'WrapAlignment.center':
        return WrapAlignment.center;
      case 'WrapAlignment.end':
        return WrapAlignment.end;
      case 'WrapAlignment.spaceBetween':
        return WrapAlignment.spaceBetween;
      case 'WrapAlignment.spaceAround':
        return WrapAlignment.spaceAround;
      case 'WrapAlignment.spaceEvenly':
        return WrapAlignment.spaceEvenly;
      default:
        return WrapAlignment.start;
    }
  }

  EdgeInsets? _parseEdgeInsets(dynamic value) {
    if (value == null) return null;
    if (value is double) return EdgeInsets.all(value);
    if (value is Map) {
      return EdgeInsets.only(
        left: (value['left'] as num?)?.toDouble() ?? 0,
        top: (value['top'] as num?)?.toDouble() ?? 0,
        right: (value['right'] as num?)?.toDouble() ?? 0,
        bottom: (value['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    return null;
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

import 'package:flutter/material.dart';

import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/widget_renderer.dart';
import 'package:flutter_forge/shared/registry/registry.dart';

/// The main design canvas for visual widget editing.
///
/// Accepts widget drops from palette, renders the widget tree,
/// and manages selection state.
class DesignCanvas extends StatelessWidget {
  /// Creates a design canvas.
  const DesignCanvas({
    required this.registry,
    required this.nodes,
    required this.rootId,
    required this.selectedWidgetId,
    required this.onWidgetSelected,
    required this.onWidgetDropped,
    super.key,
  });

  /// Widget registry for type definitions.
  final WidgetRegistry registry;

  /// Map of all nodes in the widget tree.
  final Map<String, WidgetNode> nodes;

  /// ID of the root node (null if empty).
  final String? rootId;

  /// ID of the currently selected widget.
  final String? selectedWidgetId;

  /// Callback when a widget is selected.
  final void Function(String id)? onWidgetSelected;

  /// Callback when a widget is dropped.
  /// Parameters: widgetType, parentId (null for root).
  final void Function(String widgetType, String? parentId)? onWidgetDropped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Clear selection when tapping empty canvas
        onWidgetSelected?.call('');
      },
      child: DragTarget<String>(
        onAcceptWithDetails: (details) {
          onWidgetDropped?.call(details.data, null);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              border: isHovering
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            child: _buildContent(context, isHovering),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isHovering) {
    if (rootId == null || nodes.isEmpty) {
      return _buildEmptyState(context, isHovering);
    }

    return Center(
      child: WidgetRenderer(
        nodeId: rootId!,
        nodes: nodes,
        registry: registry,
        selectedWidgetId: selectedWidgetId,
        onWidgetSelected: (id) => onWidgetSelected?.call(id),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isHovering) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHovering ? Icons.add_circle : Icons.widgets_outlined,
            size: 48,
            color: isHovering
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Drop widgets here',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isHovering
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (isHovering) ...[
            const SizedBox(height: 8),
            Text(
              'Release to add widget',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/features/tree/widget_tree_item.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Panel displaying the hierarchical widget tree.
///
/// Shows all widgets in the project as a tree structure with
/// expand/collapse support, selection highlighting, and widget icons.
class WidgetTreePanel extends ConsumerStatefulWidget {
  const WidgetTreePanel({super.key});

  @override
  ConsumerState<WidgetTreePanel> createState() => _WidgetTreePanelState();
}

class _WidgetTreePanelState extends ConsumerState<WidgetTreePanel> {
  /// Tracks which nodes are collapsed.
  final Set<String> _collapsedNodes = {};

  /// Previous selection for detecting changes.
  String? _previousSelection;

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final selectedId = ref.watch(selectionProvider);

    // Auto-expand ancestors when selection changes externally
    if (selectedId != null && selectedId != _previousSelection) {
      _autoExpandAncestors(selectedId, projectState);
    }
    _previousSelection = selectedId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        const Divider(height: 1),
        Expanded(
          child: projectState.rootIds.isEmpty
              ? _buildEmptyState(context)
              : _buildTree(context, projectState, selectedId),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(
        'Widget Tree',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_tree_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No widgets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Drag widgets from the palette to get started',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTree(
    BuildContext context,
    ProjectState projectState,
    String? selectedId,
  ) {
    final registry = ref.watch(widgetRegistryProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final rootId in projectState.rootIds)
          ..._buildNodeAndChildren(
            context,
            projectState: projectState,
            registry: registry,
            nodeId: rootId,
            selectedId: selectedId,
            depth: 0,
          ),
      ],
    );
  }

  List<Widget> _buildNodeAndChildren(
    BuildContext context, {
    required ProjectState projectState,
    required dynamic registry,
    required String nodeId,
    required String? selectedId,
    required int depth,
  }) {
    final node = projectState.nodes[nodeId];
    if (node == null) return [];

    final hasChildren = node.childrenIds.isNotEmpty;
    final isCollapsed = _collapsedNodes.contains(nodeId);

    final widgets = <Widget>[
      WidgetTreeItem(
        key: ValueKey(nodeId),
        nodeId: nodeId,
        widgetType: node.type,
        depth: depth,
        hasChildren: hasChildren,
        isExpanded: !isCollapsed,
        isSelected: nodeId == selectedId,
        onToggleExpanded: hasChildren ? () => _toggleExpanded(nodeId) : null,
        onTap: () => _selectNode(nodeId),
      ),
    ];

    // Add children if not collapsed
    if (hasChildren && !isCollapsed) {
      for (final childId in node.childrenIds) {
        widgets.addAll(
          _buildNodeAndChildren(
            context,
            projectState: projectState,
            registry: registry,
            nodeId: childId,
            selectedId: selectedId,
            depth: depth + 1,
          ),
        );
      }
    }

    return widgets;
  }

  void _toggleExpanded(String nodeId) {
    setState(() {
      if (_collapsedNodes.contains(nodeId)) {
        _collapsedNodes.remove(nodeId);
      } else {
        _collapsedNodes.add(nodeId);
      }
    });
  }

  // Riverpod StateProvider requires setting state property directly
  // ignore: use_setters_to_change_properties
  void _selectNode(String nodeId) {
    ref.read(selectionProvider.notifier).state = nodeId;
  }

  /// Auto-expands all ancestor nodes when a child is selected.
  ///
  /// This ensures the selected node is visible in the tree.
  void _autoExpandAncestors(String nodeId, ProjectState projectState) {
    final node = projectState.nodes[nodeId];
    if (node == null) return;

    // Walk up the parent chain and expand all ancestors
    var currentId = node.parentId;
    while (currentId != null) {
      _collapsedNodes.remove(currentId);
      final parent = projectState.nodes[currentId];
      currentId = parent?.parentId;
    }
  }
}

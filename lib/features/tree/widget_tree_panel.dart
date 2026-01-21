import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/commands/delete_widget_command.dart';
import 'package:flutter_forge/commands/move_widget_command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/features/tree/draggable_tree_item.dart';
import 'package:flutter_forge/features/tree/widget_tree_context_menu.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Panel displaying the hierarchical widget tree.
///
/// Shows all widgets in the project as a tree structure with
/// expand/collapse support, selection highlighting, widget icons,
/// drag-to-reorder functionality, and context menu operations.
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

  /// Focus node for keyboard handling.
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final selectedId = ref.watch(selectionProvider);

    // Auto-expand ancestors when selection changes externally
    if (selectedId != null && selectedId != _previousSelection) {
      _autoExpandAncestors(selectedId, projectState);
    }
    _previousSelection = selectedId;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) => _handleKeyEvent(event, selectedId),
      autofocus: true,
      child: Column(
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
      ),
    );
  }

  /// Handles keyboard events for delete shortcuts.
  void _handleKeyEvent(KeyEvent event, String? selectedId) {
    if (event is! KeyDownEvent) return;
    if (selectedId == null) return;

    // Handle Delete and Backspace keys
    if (event.logicalKey == LogicalKeyboardKey.delete ||
        event.logicalKey == LogicalKeyboardKey.backspace) {
      _deleteSelectedWidget(selectedId);
    }
  }

  /// Deletes the selected widget.
  void _deleteSelectedWidget(String nodeId) {
    final projectState = ref.read(projectProvider);
    final node = projectState.nodes[nodeId];
    if (node == null) return;

    // For nodes with children, show confirmation dialog
    if (node.childrenIds.isNotEmpty) {
      _showDeleteConfirmation(nodeId, projectState);
      return;
    }

    // For leaf nodes, delete immediately
    final command = DeleteWidgetCommand(nodeId: nodeId);
    ref.read(commandProvider.notifier).execute(command);
  }

  /// Shows delete confirmation dialog for nodes with children.
  Future<void> _showDeleteConfirmation(
    String nodeId,
    ProjectState projectState,
  ) async {
    final childCount = _countDescendants(nodeId, projectState);
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      childCount: childCount,
    );

    if ((confirmed ?? false) && mounted) {
      final command = DeleteWidgetCommand(nodeId: nodeId);
      ref.read(commandProvider.notifier).execute(command);
    }
  }

  /// Counts all descendants of a node.
  int _countDescendants(String nodeId, ProjectState state) {
    final node = state.nodes[nodeId];
    if (node == null) return 0;

    var count = node.childrenIds.length;
    for (final childId in node.childrenIds) {
      count += _countDescendants(childId, state);
    }
    return count;
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
    // Use SingleChildScrollView to prevent overflow in small spaces
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_tree_outlined,
                size: 32,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 8),
              Text(
                'No widgets',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Drag from palette',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
        for (var i = 0; i < projectState.rootIds.length; i++)
          ..._buildNodeAndChildren(
            context,
            projectState: projectState,
            registry: registry,
            nodeId: projectState.rootIds[i],
            selectedId: selectedId,
            depth: 0,
            parentId: null,
            indexInParent: i,
          ),
      ],
    );
  }

  List<Widget> _buildNodeAndChildren(
    BuildContext context, {
    required ProjectState projectState,
    required WidgetRegistry registry,
    required String nodeId,
    required String? selectedId,
    required int depth,
    required String? parentId,
    required int indexInParent,
  }) {
    final node = projectState.nodes[nodeId];
    if (node == null) return [];

    final hasChildren = node.childrenIds.isNotEmpty;
    final isCollapsed = _collapsedNodes.contains(nodeId);

    final widgets = <Widget>[
      GestureDetector(
        onSecondaryTapDown: (details) => _showContextMenu(
          context,
          details.globalPosition,
          nodeId,
        ),
        child: DraggableTreeItem(
          key: ValueKey(nodeId),
          nodeId: nodeId,
          widgetType: node.type,
          depth: depth,
          hasChildren: hasChildren,
          isExpanded: !isCollapsed,
          isSelected: nodeId == selectedId,
          parentId: parentId,
          currentIndex: indexInParent,
          onToggleExpanded: hasChildren ? () => _toggleExpanded(nodeId) : null,
          onTap: () {
            _selectNode(nodeId);
            _focusNode.requestFocus();
          },
          onDropValidation: (data, targetId) => _validateDrop(
            projectState,
            registry,
            data,
            targetId,
          ),
          onDrop: (data, validation) => _handleDrop(
            projectState,
            data,
            validation,
            targetId: nodeId,
          ),
        ),
      ),
    ];

    // Add children if not collapsed
    if (hasChildren && !isCollapsed) {
      for (var i = 0; i < node.childrenIds.length; i++) {
        widgets.addAll(
          _buildNodeAndChildren(
            context,
            projectState: projectState,
            registry: registry,
            nodeId: node.childrenIds[i],
            selectedId: selectedId,
            depth: depth + 1,
            parentId: nodeId,
            indexInParent: i,
          ),
        );
      }
    }

    return widgets;
  }

  /// Shows the context menu for a node.
  Future<void> _showContextMenu(
    BuildContext context,
    Offset position,
    String nodeId,
  ) async {
    // Select the node first
    _selectNode(nodeId);

    final action = await showWidgetTreeContextMenu(
      context: context,
      position: position,
      nodeId: nodeId,
      ref: ref,
    );

    if (action != null && context.mounted) {
      await handleContextMenuAction(
        context: context,
        action: action,
        nodeId: nodeId,
        ref: ref,
      );
    }
  }

  /// Validates a drop operation.
  DropValidation _validateDrop(
    ProjectState projectState,
    WidgetRegistry registry,
    TreeDragData data,
    String targetId,
  ) {
    // Can't drop on self
    if (data.nodeId == targetId) {
      return DropValidation.invalid('Cannot drop on self');
    }

    // Can't drop on descendant (circular reference)
    if (_isDescendant(projectState, data.nodeId, targetId)) {
      return DropValidation.invalid('Cannot drop on descendant');
    }

    final targetNode = projectState.nodes[targetId];
    if (targetNode == null) {
      return DropValidation.invalid('Target not found');
    }

    // Check if target can accept children
    final targetDef = registry.get(targetNode.type);
    if (targetDef == null || !targetDef.acceptsChildren) {
      return DropValidation.invalid('${targetNode.type} cannot have children');
    }

    // Check max children constraint
    if (targetDef.maxChildren != null) {
      final currentChildCount = targetNode.childrenIds.length;
      // If dropping into same parent at different position, don't count
      final isSameParent = data.parentId == targetId;

      if (!isSameParent && currentChildCount >= targetDef.maxChildren!) {
        return DropValidation.invalid(
          '${targetNode.type} already has a child',
        );
      }
    }

    // Valid drop - calculate target index
    final targetIndex = targetNode.childrenIds.length;

    return DropValidation.valid(
      targetParentId: targetId,
      targetIndex: targetIndex,
    );
  }

  /// Checks if potentialDescendant is a descendant of ancestorId.
  bool _isDescendant(
    ProjectState projectState,
    String ancestorId,
    String potentialDescendantId,
  ) {
    final ancestorNode = projectState.nodes[ancestorId];
    if (ancestorNode == null) return false;

    for (final childId in ancestorNode.childrenIds) {
      if (childId == potentialDescendantId) return true;
      if (_isDescendant(projectState, childId, potentialDescendantId)) {
        return true;
      }
    }

    return false;
  }

  /// Handles a successful drop operation.
  void _handleDrop(
    ProjectState projectState,
    TreeDragData data,
    DropValidation validation, {
    required String targetId,
  }) {
    if (!validation.isValid) return;

    final targetParentId = validation.targetParentId;
    final targetIndex = validation.targetIndex;

    if (targetParentId == null || targetIndex == null) return;

    // Determine old parent (use parentId or find in rootIds)
    final oldParentId = data.parentId;
    if (oldParentId == null) {
      // Moving from root - not supported in this implementation
      return;
    }

    // Create and execute move command
    final command = MoveWidgetCommand(
      nodeId: data.nodeId,
      oldParentId: oldParentId,
      newParentId: targetParentId,
      oldIndex: data.currentIndex,
      newIndex: targetIndex,
    );

    ref.read(commandProvider.notifier).execute(command);
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

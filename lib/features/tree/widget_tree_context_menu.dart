import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_forge/commands/add_widget_command.dart';
import 'package:flutter_forge/commands/delete_widget_command.dart';
import 'package:flutter_forge/commands/wrap_widget_command.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Actions available in the widget tree context menu.
enum ContextMenuAction {
  cut,
  copy,
  paste,
  duplicate,
  delete,
  wrapIn,
}

/// Shows a context menu for a widget tree node.
///
/// Returns the selected action, or null if the menu was dismissed.
Future<ContextMenuAction?> showWidgetTreeContextMenu({
  required BuildContext context,
  required Offset position,
  required String nodeId,
  required WidgetRef ref,
}) async {
  final projectState = ref.read(projectProvider);
  final node = projectState.nodes[nodeId];
  if (node == null) return null;

  final overlayContext = Overlay.of(context).context;
  final overlayBox = overlayContext.findRenderObject();
  if (overlayBox == null || overlayBox is! RenderBox) return null;

  final result = await showMenu<ContextMenuAction>(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(position.dx, position.dy, 0, 0),
      Offset.zero & overlayBox.size,
    ),
    items: _buildMenuItems(context),
  );

  return result;
}

/// Builds the context menu items.
List<PopupMenuEntry<ContextMenuAction>> _buildMenuItems(BuildContext context) {
  final isMacOS = !kIsWeb && Platform.isMacOS;
  final modifierKey = isMacOS ? '\u2318' : 'Ctrl+'; // Cmd symbol or Ctrl

  return [
    _buildMenuItem(
      context,
      action: ContextMenuAction.cut,
      label: 'Cut',
      shortcut: '${modifierKey}X',
      enabled: false, // Placeholder for Phase 4
    ),
    _buildMenuItem(
      context,
      action: ContextMenuAction.copy,
      label: 'Copy',
      shortcut: '${modifierKey}C',
      enabled: false, // Placeholder for Phase 4
    ),
    _buildMenuItem(
      context,
      action: ContextMenuAction.paste,
      label: 'Paste',
      shortcut: '${modifierKey}V',
      enabled: false, // Placeholder for Phase 4
    ),
    const PopupMenuDivider(),
    _buildMenuItem(
      context,
      action: ContextMenuAction.duplicate,
      label: 'Duplicate',
      shortcut: '${modifierKey}D',
    ),
    const PopupMenuDivider(),
    _buildMenuItem(
      context,
      action: ContextMenuAction.delete,
      label: 'Delete',
      shortcut: isMacOS ? '\u232B' : 'Del', // Backspace symbol or Del
    ),
    const PopupMenuDivider(),
    _buildMenuItem(
      context,
      action: ContextMenuAction.wrapIn,
      label: 'Wrap in...',
      shortcut: '',
    ),
  ];
}

PopupMenuItem<ContextMenuAction> _buildMenuItem(
  BuildContext context, {
  required ContextMenuAction action,
  required String label,
  required String shortcut,
  bool enabled = true,
}) {
  final theme = Theme.of(context);

  return PopupMenuItem<ContextMenuAction>(
    value: action,
    enabled: enabled,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: enabled
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        if (shortcut.isNotEmpty)
          Text(
            shortcut,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    ),
  );
}

/// Handles context menu actions.
Future<void> handleContextMenuAction({
  required BuildContext context,
  required ContextMenuAction action,
  required String nodeId,
  required WidgetRef ref,
}) async {
  switch (action) {
    case ContextMenuAction.cut:
    case ContextMenuAction.copy:
    case ContextMenuAction.paste:
      // Placeholder for Phase 4
      break;
    case ContextMenuAction.duplicate:
      _handleDuplicate(nodeId, ref);
    case ContextMenuAction.delete:
      await _handleDelete(context, nodeId, ref);
    case ContextMenuAction.wrapIn:
      await _showWrapInSubmenu(context, nodeId, ref);
  }
}

/// Handles duplicate action.
void _handleDuplicate(String nodeId, WidgetRef ref) {
  final projectState = ref.read(projectProvider);
  final node = projectState.nodes[nodeId];
  if (node == null) return;

  const uuid = Uuid();
  final newId = uuid.v4();

  // Create a copy of the node with new ID
  final newNode = WidgetNode(
    id: newId,
    type: node.type,
    properties: Map<String, dynamic>.from(node.properties),
    parentId: node.parentId,
    // Note: We don't copy children for simple duplication
    // Deep duplication would require recursive copying
  );

  // Determine parent and index for insertion
  final parentId = node.parentId;
  int insertIndex;

  if (parentId != null) {
    final parent = projectState.nodes[parentId];
    if (parent != null) {
      insertIndex = parent.childrenIds.indexOf(nodeId) + 1;
    } else {
      insertIndex = projectState.rootIds.length;
    }
  } else {
    insertIndex = projectState.rootIds.indexOf(nodeId) + 1;
  }

  final command = AddWidgetCommand.withNode(
    nodeId: newId,
    node: newNode,
    parentId: parentId,
    insertIndex: insertIndex,
  );

  ref.read(commandProvider.notifier).execute(command);
}

/// Handles delete action with confirmation for nodes with children.
Future<void> _handleDelete(
  BuildContext context,
  String nodeId,
  WidgetRef ref,
) async {
  final projectState = ref.read(projectProvider);
  final node = projectState.nodes[nodeId];
  if (node == null) return;

  // If node has children, show confirmation dialog
  if (node.childrenIds.isNotEmpty) {
    final confirmed = await showDeleteConfirmationDialog(
      context: context,
      childCount: _countDescendants(nodeId, projectState),
    );

    if (confirmed != true) return;
  }

  final command = DeleteWidgetCommand(nodeId: nodeId);
  ref.read(commandProvider.notifier).execute(command);
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

/// Shows a confirmation dialog for deleting a widget with children.
Future<bool?> showDeleteConfirmationDialog({
  required BuildContext context,
  required int childCount,
}) {
  final childText = childCount == 1 ? 'child' : 'children';
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Widget?'),
      content: Text(
        'This widget has $childCount $childText. '
        'Deleting it will also delete all its children.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}

/// Shows the "Wrap in..." submenu.
Future<void> _showWrapInSubmenu(
  BuildContext context,
  String nodeId,
  WidgetRef ref,
) async {
  final wrapperType = await showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Wrap in...'),
      children: [
        _buildWrapOption(context, 'Container'),
        _buildWrapOption(context, 'Padding'),
        _buildWrapOption(context, 'Center'),
        _buildWrapOption(context, 'SizedBox'),
        _buildWrapOption(context, 'Column'),
        _buildWrapOption(context, 'Row'),
      ],
    ),
  );

  if (wrapperType != null && context.mounted) {
    _handleWrapIn(nodeId, wrapperType, ref);
  }
}

Widget _buildWrapOption(BuildContext context, String type) {
  return SimpleDialogOption(
    onPressed: () => Navigator.of(context).pop(type),
    child: Text(type),
  );
}

/// Wraps a node in a new wrapper widget.
void _handleWrapIn(String nodeId, String wrapperType, WidgetRef ref) {
  final command = WrapWidgetCommand(
    targetId: nodeId,
    wrapperType: wrapperType,
  );

  ref.read(commandProvider.notifier).execute(command);
}

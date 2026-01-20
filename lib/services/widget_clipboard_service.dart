import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:uuid/uuid.dart';

/// Content stored in the widget clipboard.
class ClipboardContent {
  const ClipboardContent({
    required this.nodes,
    required this.rootId,
  });

  /// All nodes including children.
  final Map<String, WidgetNode> nodes;

  /// ID of the root node.
  final String rootId;
}

/// Result of a paste operation.
class PasteResult {
  const PasteResult({
    required this.nodes,
    required this.rootId,
  });

  /// All pasted nodes with new IDs.
  final Map<String, WidgetNode> nodes;

  /// ID of the new root node.
  final String rootId;
}

/// Service for copying and pasting widgets.
class WidgetClipboardService {
  static const _uuid = Uuid();

  ClipboardContent? _content;

  /// Whether the clipboard has content.
  bool get hasContent => _content != null;

  /// Gets the current clipboard content.
  ClipboardContent? getContent() => _content;

  /// Copies a widget and its children to the clipboard.
  void copy({
    required WidgetNode node,
    required Map<String, WidgetNode> allNodes,
  }) {
    // Collect the node and all descendants
    final collected = <String, WidgetNode>{};
    _collectNodeAndDescendants(node.id, allNodes, collected);

    _content = ClipboardContent(
      nodes: collected,
      rootId: node.id,
    );
  }

  void _collectNodeAndDescendants(
    String nodeId,
    Map<String, WidgetNode> allNodes,
    Map<String, WidgetNode> collected,
  ) {
    final node = allNodes[nodeId];
    if (node == null) return;

    collected[nodeId] = node;

    for (final childId in node.childrenIds) {
      _collectNodeAndDescendants(childId, allNodes, collected);
    }
  }

  /// Pastes the clipboard content with new IDs.
  ///
  /// Returns null if clipboard is empty.
  PasteResult? paste() {
    if (_content == null) return null;

    // Create ID mapping from old to new
    final idMapping = <String, String>{};
    for (final oldId in _content!.nodes.keys) {
      idMapping[oldId] = _uuid.v4();
    }

    // Create new nodes with remapped IDs
    final newNodes = <String, WidgetNode>{};
    for (final entry in _content!.nodes.entries) {
      final oldId = entry.key;
      final node = entry.value;
      final newId = idMapping[oldId]!;

      // Remap parent ID
      String? newParentId;
      if (node.parentId != null && idMapping.containsKey(node.parentId)) {
        newParentId = idMapping[node.parentId];
      }

      // Remap children IDs
      final newChildrenIds = node.childrenIds
          .where(idMapping.containsKey)
          .map((id) => idMapping[id]!)
          .toList();

      newNodes[newId] = WidgetNode(
        id: newId,
        type: node.type,
        properties: Map<String, dynamic>.from(node.properties),
        childrenIds: newChildrenIds,
        parentId: newParentId,
        appliedPresetId: node.appliedPresetId,
        propertyOverrides: List<String>.from(node.propertyOverrides),
      );
    }

    return PasteResult(
      nodes: newNodes,
      rootId: idMapping[_content!.rootId]!,
    );
  }

  /// Clears the clipboard.
  void clear() {
    _content = null;
  }
}

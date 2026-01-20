import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/palette/palette.dart';
import 'package:flutter_forge/features/properties/properties.dart';
import 'package:flutter_forge/generators/generators.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/shared/registry/registry.dart';

/// The main workbench layout with 3-panel design.
///
/// Displays:
/// - Widget Palette (left)
/// - Design Canvas (center)
/// - Properties Panel (right)
class Workbench extends ConsumerStatefulWidget {
  /// Creates the workbench.
  const Workbench({super.key});

  @override
  ConsumerState<Workbench> createState() => _WorkbenchState();
}

class _WorkbenchState extends ConsumerState<Workbench> {
  late final WidgetRegistry _registry;
  late final DartGenerator _generator;

  @override
  void initState() {
    super.initState();
    _registry = DefaultWidgetRegistry();
    _generator = DartGenerator();
  }

  void _handleWidgetDropped(String widgetType, String? parentId) {
    final notifier = ref.read(projectProvider.notifier);

    if (parentId == null) {
      // Drop on canvas root
      notifier.addWidget(type: widgetType);
    } else {
      // Drop on existing widget
      notifier.addChildWidget(parentId: parentId, type: widgetType);
    }
  }

  void _handleWidgetSelected(String id) {
    ref.read(selectionProvider.notifier).state = id.isEmpty ? null : id;
  }

  void _handlePropertyChanged(String propertyName, dynamic value) {
    final selectedId = ref.read(selectionProvider);
    if (selectedId == null) return;

    ref.read(projectProvider.notifier).updateProperty(
          nodeId: selectedId,
          propertyName: propertyName,
          value: value,
        );
  }

  Future<void> _handleExportCode() async {
    final projectState = ref.read(projectProvider);

    if (projectState.rootIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add widgets to generate code'),
        ),
      );
      return;
    }

    try {
      // Generate code for the first root widget
      final code = _generator.generate(
        nodes: projectState.nodes,
        rootId: projectState.rootIds.first,
        className: 'GeneratedWidget',
      );

      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: code));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code copied to clipboard'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating code: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final selectedId = ref.watch(selectionProvider);

    // Find the selected node
    final selectedNode =
        selectedId != null ? projectState.nodes[selectedId] : null;

    // Get the first root ID (for single-widget canvas)
    final rootId =
        projectState.rootIds.isNotEmpty ? projectState.rootIds.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterForge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Export Code',
            onPressed: _handleExportCode,
          ),
        ],
      ),
      body: Row(
        children: [
          // Palette panel (left)
          SizedBox(
            width: 250,
            child: WidgetPalette(registry: _registry),
          ),
          const VerticalDivider(width: 1),
          // Canvas (center)
          Expanded(
            flex: 2,
            child: DesignCanvas(
              registry: _registry,
              nodes: projectState.nodes,
              rootId: rootId,
              selectedWidgetId: selectedId,
              onWidgetSelected: _handleWidgetSelected,
              onWidgetDropped: _handleWidgetDropped,
            ),
          ),
          const VerticalDivider(width: 1),
          // Properties panel (right)
          SizedBox(
            width: 300,
            child: PropertiesPanel(
              registry: _registry,
              selectedNode: selectedNode,
              onPropertyChanged: _handlePropertyChanged,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/commands/commands.dart';
import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/animation/animation.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/code_preview/code_preview.dart';
import 'package:flutter_forge/features/design_system/design_system.dart';
import 'package:flutter_forge/features/palette/palette.dart';
import 'package:flutter_forge/features/properties/properties.dart';
import 'package:flutter_forge/features/tree/tree.dart';
import 'package:flutter_forge/generators/generators.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/services/services.dart';
import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Tabs for the right panel.
enum RightPanelTab { properties, designSystem, animation, code }

/// Provider for tracking the active right panel tab.
final rightPanelTabProvider = StateProvider<RightPanelTab>((ref) {
  return RightPanelTab.properties;
});

/// Provider for the widget clipboard (stores copied widget data).
final widgetClipboardProvider = StateProvider<WidgetNode?>((ref) => null);

/// The main workbench layout with multi-panel design.
///
/// Displays:
/// - Left panel: Widget Palette (top) + Widget Tree (bottom)
/// - Center: Design Canvas
/// - Right panel: Tabs for Properties, Design System, Animation, Code
///
/// Integrates:
/// - Keyboard shortcuts (Cmd+Z, Cmd+Shift+Z, Cmd+S, etc.)
/// - File menu (New, Open, Save)
/// - Undo/Redo buttons
class Workbench extends ConsumerStatefulWidget {
  /// Creates the workbench.
  const Workbench({super.key});

  @override
  ConsumerState<Workbench> createState() => _WorkbenchState();
}

class _WorkbenchState extends ConsumerState<Workbench>
    with SingleTickerProviderStateMixin {
  late final WidgetRegistry _registry;
  late final DartGenerator _generator;
  late final ThemeExtensionGenerator _themeGenerator;
  late final ProjectService _projectService;
  late final TabController _rightPanelController;

  static const _uuid = Uuid();

  /// Current project file path (null if never saved).
  String? _currentFilePath;

  /// Whether the project has unsaved changes.
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _registry = DefaultWidgetRegistry();
    _generator = DartGenerator();
    _themeGenerator = ThemeExtensionGenerator();
    _projectService = ProjectService();
    _rightPanelController = TabController(length: 4, vsync: this);
    _rightPanelController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _rightPanelController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    const tabs = RightPanelTab.values;
    ref.read(rightPanelTabProvider.notifier).state =
        tabs[_rightPanelController.index];
  }

  void _handleWidgetDropped(String widgetType, String? parentId) {
    // Use command system for undo/redo support
    final command = AddWidgetCommand(
      widgetType: widgetType,
      properties: const {},
      parentId: parentId,
    );
    ref.read(commandProvider.notifier).execute(command);
    _markUnsaved();
  }

  void _handleWidgetSelected(String id) {
    ref.read(selectionProvider.notifier).state = id.isEmpty ? null : id;
  }

  void _handlePropertyChanged(String propertyName, dynamic value) {
    final selectedId = ref.read(selectionProvider);
    if (selectedId == null) return;

    // Use command system for undo/redo support
    final command = PropertyChangeCommand(
      nodeId: selectedId,
      propertyName: propertyName,
      newValue: value,
      oldValue:
          ref.read(projectProvider).nodes[selectedId]?.properties[propertyName],
    );
    ref.read(commandProvider.notifier).execute(command);
    _markUnsaved();
  }

  void _markUnsaved() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  // ===== Keyboard Shortcuts =====

  Future<void> _handleNewProject() async {
    if (_hasUnsavedChanges) {
      final shouldContinue = await _showUnsavedChangesDialog();
      if (!shouldContinue) return;
    }

    ref.read(projectProvider.notifier).clear();
    ref.read(commandProvider.notifier).clear();
    ref.read(selectionProvider.notifier).state = null;
    setState(() {
      _currentFilePath = null;
      _hasUnsavedChanges = false;
    });
  }

  Future<void> _handleOpenProject() async {
    if (_hasUnsavedChanges) {
      final shouldContinue = await _showUnsavedChangesDialog();
      if (!shouldContinue) return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['forge'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.bytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Could not read file data'),
          ),
        );
      }
      return;
    }

    try {
      final bytes = file.bytes!;
      final project = await _projectService.deserializeFromForgeFormat(bytes);

      // Load the first screen into project state
      if (project.screens.isNotEmpty) {
        final screen = project.screens.first;
        ref.read(projectProvider.notifier).loadFromMap(
              nodes: screen.nodes,
              rootIds: screen.rootNodeId.isEmpty ? [] : [screen.rootNodeId],
            );
      } else {
        ref.read(projectProvider.notifier).clear();
      }

      ref.read(commandProvider.notifier).clear();
      ref.read(selectionProvider.notifier).state = null;

      setState(() {
        _currentFilePath = file.path ?? file.name;
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opened: ${project.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening project: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleSaveProject() async {
    final projectState = ref.read(projectProvider);

    final projectName =
        _currentFilePath?.split('/').last.replaceAll('.forge', '') ??
            'Untitled';
    final project = _projectService.createNewProject(
      name: projectName,
    );

    // Convert WidgetNode map to JSON-serializable map
    final nodesJson = <String, dynamic>{};
    for (final entry in projectState.nodes.entries) {
      nodesJson[entry.key] = entry.value.toJson();
    }

    // Update project with current state
    final updatedProject = project.copyWith(
      screens: [
        ScreenDefinition(
          id: 'screen-1',
          name: 'Screen 1',
          rootNodeId:
              projectState.rootIds.isNotEmpty ? projectState.rootIds.first : '',
          nodes: nodesJson,
        ),
      ],
    );

    try {
      final bytes =
          await _projectService.serializeToForgeFormat(updatedProject);

      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Project',
        fileName: '${updatedProject.name}.forge',
        type: FileType.custom,
        allowedExtensions: ['forge'],
        bytes: bytes,
      );

      if (savePath != null) {
        setState(() {
          _currentFilePath = savePath;
          _hasUnsavedChanges = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project saved')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving project: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleUndo() {
    ref.read(commandProvider.notifier).undo();
    _markUnsaved();
  }

  void _handleRedo() {
    ref.read(commandProvider.notifier).redo();
    _markUnsaved();
  }

  void _handleDelete() {
    final selectedId = ref.read(selectionProvider);
    if (selectedId == null || selectedId.isEmpty) return;

    final command = DeleteWidgetCommand(nodeId: selectedId);
    ref.read(commandProvider.notifier).execute(command);
    ref.read(selectionProvider.notifier).state = null;
    _markUnsaved();
  }

  void _handleCopy() {
    final selectedId = ref.read(selectionProvider);
    if (selectedId == null || selectedId.isEmpty) return;

    final projectState = ref.read(projectProvider);
    final node = projectState.nodes[selectedId];
    if (node == null) return;

    // Deep copy the node and its children
    ref.read(widgetClipboardProvider.notifier).state =
        _deepCopyNode(node, projectState);
  }

  void _handlePaste() {
    final clipboardNode = ref.read(widgetClipboardProvider);
    if (clipboardNode == null) return;

    // Create a new copy with a new ID
    final newNode = _createNodeCopy(clipboardNode);

    final command = AddWidgetCommand.withNode(
      nodeId: newNode.id,
      node: newNode,
    );
    ref.read(commandProvider.notifier).execute(command);
    _markUnsaved();
  }

  void _handleCut() {
    _handleCopy();
    _handleDelete();
  }

  void _handleDuplicate() {
    final selectedId = ref.read(selectionProvider);
    if (selectedId == null || selectedId.isEmpty) return;

    final projectState = ref.read(projectProvider);
    final node = projectState.nodes[selectedId];
    if (node == null) return;

    // Deep copy the node
    final copiedNode = _deepCopyNode(node, projectState);
    final newNode = _createNodeCopy(copiedNode);

    final command = AddWidgetCommand.withNode(
      nodeId: newNode.id,
      node: newNode,
      parentId: node.parentId, // Same parent as original
    );
    ref.read(commandProvider.notifier).execute(command);
    _markUnsaved();
  }

  /// Deep copies a node and all its children.
  WidgetNode _deepCopyNode(WidgetNode node, ProjectState state) {
    final children = <WidgetNode>[];
    for (final childId in node.childrenIds) {
      final child = state.nodes[childId];
      if (child != null) {
        children.add(_deepCopyNode(child, state));
      }
    }

    // Create a copy without children IDs (they'll be regenerated)
    return node.copyWith(
      childrenIds: node.childrenIds, // Keep the structure info
    );
  }

  /// Creates a new copy of a node with a new ID.
  WidgetNode _createNodeCopy(WidgetNode node) {
    return node.copyWith(
      id: _uuid.v4(),
      parentId: null, // Will be set by command
      childrenIds: [], // Children not supported in simple copy yet
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
      final code = _generator.generate(
        nodes: projectState.nodes,
        rootId: projectState.rootIds.first,
        className: 'GeneratedWidget',
      );

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

  Future<bool> _showUnsavedChangesDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content:
            const Text('You have unsaved changes. Do you want to save them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: const Text("Don't Save"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == 'cancel') return false;
    if (result == 'save') {
      await _handleSaveProject();
    }
    return true;
  }

  void _switchToTab(RightPanelTab tab) {
    _rightPanelController.animateTo(tab.index);
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final selectedId = ref.watch(selectionProvider);
    final commandState = ref.watch(commandProvider);

    final selectedNode =
        selectedId != null ? projectState.nodes[selectedId] : null;

    final rootId =
        projectState.rootIds.isNotEmpty ? projectState.rootIds.first : null;

    final title = _currentFilePath?.split('/').last ?? 'Untitled';
    final displayTitle = _hasUnsavedChanges
        ? 'FlutterForge - $title *'
        : 'FlutterForge - $title';

    final isMac = Theme.of(context).platform == TargetPlatform.macOS;

    return CallbackShortcuts(
      bindings: {
        // File shortcuts
        SingleActivator(
          LogicalKeyboardKey.keyN,
          meta: isMac,
          control: !isMac,
        ): _handleNewProject,
        SingleActivator(
          LogicalKeyboardKey.keyO,
          meta: isMac,
          control: !isMac,
        ): _handleOpenProject,
        SingleActivator(
          LogicalKeyboardKey.keyS,
          meta: isMac,
          control: !isMac,
        ): _handleSaveProject,
        // Edit shortcuts
        SingleActivator(
          LogicalKeyboardKey.keyZ,
          meta: isMac,
          control: !isMac,
        ): _handleUndo,
        SingleActivator(
          LogicalKeyboardKey.keyZ,
          meta: isMac,
          control: !isMac,
          shift: true,
        ): _handleRedo,
        // Widget shortcuts
        SingleActivator(
          LogicalKeyboardKey.keyC,
          meta: isMac,
          control: !isMac,
        ): _handleCopy,
        SingleActivator(
          LogicalKeyboardKey.keyV,
          meta: isMac,
          control: !isMac,
        ): _handlePaste,
        SingleActivator(
          LogicalKeyboardKey.keyX,
          meta: isMac,
          control: !isMac,
        ): _handleCut,
        SingleActivator(
          LogicalKeyboardKey.keyD,
          meta: isMac,
          control: !isMac,
        ): _handleDuplicate,
        const SingleActivator(LogicalKeyboardKey.delete): _handleDelete,
        const SingleActivator(LogicalKeyboardKey.backspace): _handleDelete,
        // View shortcuts - switch tabs
        SingleActivator(
          LogicalKeyboardKey.digit1,
          meta: isMac,
          control: !isMac,
        ): () => _switchToTab(RightPanelTab.properties),
        SingleActivator(
          LogicalKeyboardKey.digit2,
          meta: isMac,
          control: !isMac,
        ): () => _switchToTab(RightPanelTab.designSystem),
        SingleActivator(
          LogicalKeyboardKey.digit3,
          meta: isMac,
          control: !isMac,
        ): () => _switchToTab(RightPanelTab.animation),
        SingleActivator(
          LogicalKeyboardKey.digit4,
          meta: isMac,
          control: !isMac,
        ): () => _switchToTab(RightPanelTab.code),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text(displayTitle),
            actions: [
              // File actions
              IconButton(
                icon: const Icon(Icons.create_new_folder_outlined),
                tooltip: 'New Project (Cmd+N)',
                onPressed: _handleNewProject,
              ),
              IconButton(
                icon: const Icon(Icons.folder_open_outlined),
                tooltip: 'Open Project (Cmd+O)',
                onPressed: _handleOpenProject,
              ),
              IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: 'Save Project (Cmd+S)',
                onPressed: _handleSaveProject,
              ),
              const VerticalDivider(width: 16),
              // Edit actions
              IconButton(
                icon: const Icon(Icons.undo),
                tooltip: commandState.undoDescription != null
                    ? 'Undo: ${commandState.undoDescription} (Cmd+Z)'
                    : 'Undo (Cmd+Z)',
                onPressed: commandState.canUndo ? _handleUndo : null,
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                tooltip: commandState.redoDescription != null
                    ? 'Redo: ${commandState.redoDescription} (Cmd+Shift+Z)'
                    : 'Redo (Cmd+Shift+Z)',
                onPressed: commandState.canRedo ? _handleRedo : null,
              ),
              const VerticalDivider(width: 16),
              // Export
              IconButton(
                icon: const Icon(Icons.code),
                tooltip: 'Export Code to Clipboard',
                onPressed: _handleExportCode,
              ),
            ],
          ),
          body: Row(
            children: [
              // Left panel: Palette + Tree
              SizedBox(
                width: 260,
                child: Column(
                  children: [
                    // Widget Palette (upper 60%)
                    Expanded(
                      flex: 6,
                      child: WidgetPalette(registry: _registry),
                    ),
                    const Divider(height: 1),
                    // Widget Tree (lower 40%)
                    const Expanded(
                      flex: 4,
                      child: WidgetTreePanel(),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              // Canvas (center)
              Expanded(
                flex: 3,
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
              // Right panel: Tabbed
              // (Properties, Design System, Animation, Code)
              SizedBox(
                width: 320,
                child: Column(
                  children: [
                    TabBar(
                      controller: _rightPanelController,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.tune, size: 18),
                          text: 'Properties',
                        ),
                        Tab(
                          icon: Icon(Icons.palette_outlined, size: 18),
                          text: 'Design System',
                        ),
                        Tab(
                          icon: Icon(Icons.animation, size: 18),
                          text: 'Animation',
                        ),
                        Tab(
                          icon: Icon(Icons.code, size: 18),
                          text: 'Code',
                        ),
                      ],
                      labelPadding: EdgeInsets.zero,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _rightPanelController,
                        children: [
                          // Properties tab
                          PropertiesPanel(
                            registry: _registry,
                            selectedNode: selectedNode,
                            onPropertyChanged: _handlePropertyChanged,
                          ),
                          // Design System tab
                          const DesignSystemPanel(),
                          // Animation tab
                          const AnimationPanel(),
                          // Code preview tab with syntax highlighting
                          CodePreviewPanel(
                            generator: _generator,
                            themeGenerator: _themeGenerator,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/features/animation/animation.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/design_system/design_system.dart';
import 'package:flutter_forge/features/palette/palette.dart';
import 'package:flutter_forge/features/properties/properties.dart';
import 'package:flutter_forge/features/tree/tree.dart';
import 'package:flutter_forge/generators/generators.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/services/services.dart';
import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tabs for the right panel.
enum RightPanelTab { properties, designSystem, animation, code }

/// Provider for tracking the active right panel tab.
final rightPanelTabProvider = StateProvider<RightPanelTab>((ref) {
  return RightPanelTab.properties;
});

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
    _rightPanelController.removeListener(_onTabChanged);
    _rightPanelController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final tabs = RightPanelTab.values;
    ref.read(rightPanelTabProvider.notifier).state =
        tabs[_rightPanelController.index];
  }

  void _handleWidgetDropped(String widgetType, String? parentId) {
    final notifier = ref.read(projectProvider.notifier);

    if (parentId == null) {
      notifier.addWidget(type: widgetType);
    } else {
      notifier.addChildWidget(parentId: parentId, type: widgetType);
    }
    _markUnsaved();
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
      allowMultiple: false,
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
      withDefaultScreen: false,
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

    return CallbackShortcuts(
      bindings: {
        // File shortcuts
        SingleActivator(
          LogicalKeyboardKey.keyN,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
        ): _handleNewProject,
        SingleActivator(
          LogicalKeyboardKey.keyO,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
        ): _handleOpenProject,
        SingleActivator(
          LogicalKeyboardKey.keyS,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
        ): _handleSaveProject,
        // Edit shortcuts
        SingleActivator(
          LogicalKeyboardKey.keyZ,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
        ): _handleUndo,
        SingleActivator(
          LogicalKeyboardKey.keyZ,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
          shift: true,
        ): _handleRedo,
        // View shortcuts - switch tabs
        SingleActivator(
          LogicalKeyboardKey.digit1,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
        ): () => _switchToTab(RightPanelTab.properties),
        SingleActivator(
          LogicalKeyboardKey.digit2,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
        ): () => _switchToTab(RightPanelTab.designSystem),
        SingleActivator(
          LogicalKeyboardKey.digit3,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
        ): () => _switchToTab(RightPanelTab.animation),
        SingleActivator(
          LogicalKeyboardKey.digit4,
          meta: Theme.of(context).platform == TargetPlatform.macOS,
          control: Theme.of(context).platform != TargetPlatform.macOS,
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
              // Right panel: Tabbed (Properties, Design System, Animation, Code)
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
                          text: 'Design',
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
                      isScrollable: false,
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
                          // Code preview tab
                          _CodePreviewPanel(
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

/// Code preview panel showing generated Dart code.
class _CodePreviewPanel extends ConsumerWidget {
  const _CodePreviewPanel({
    required this.generator,
    required this.themeGenerator,
  });

  final DartGenerator generator;
  final ThemeExtensionGenerator themeGenerator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final designTokens = ref.watch(designTokensProvider);
    final theme = Theme.of(context);

    if (projectState.rootIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.code_off,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No widgets to generate',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add widgets to see generated code',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    String widgetCode;
    try {
      widgetCode = generator.generate(
        nodes: projectState.nodes,
        rootId: projectState.rootIds.first,
        className: 'GeneratedWidget',
      );
    } catch (e) {
      widgetCode = '// Error generating code: $e';
    }

    String? themeCode;
    if (designTokens.isNotEmpty) {
      try {
        themeCode = themeGenerator.generate(
          tokens: designTokens,
          extensionName: 'AppDesignTokens',
        );
      } catch (e) {
        themeCode = '// Error generating theme: $e';
      }
    }

    return DefaultTabController(
      length: themeCode != null ? 2 : 1,
      child: Column(
        children: [
          if (themeCode != null)
            TabBar(
              tabs: const [
                Tab(text: 'Widget'),
                Tab(text: 'Theme'),
              ],
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          Expanded(
            child: themeCode != null
                ? TabBarView(
                    children: [
                      _CodeView(code: widgetCode),
                      _CodeView(code: themeCode),
                    ],
                  )
                : _CodeView(code: widgetCode),
          ),
          // Copy button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final code = themeCode != null
                          ? '$widgetCode\n\n$themeCode'
                          : widgetCode;
                      await Clipboard.setData(ClipboardData(text: code));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Code copied to clipboard'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy All'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays code with basic formatting.
class _CodeView extends StatelessWidget {
  const _CodeView({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceContainerLowest,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SelectableText(
          code,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            color: theme.colorScheme.onSurface,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

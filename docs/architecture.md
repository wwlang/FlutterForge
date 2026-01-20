# FlutterForge: Technical Architecture

**Version:** 2.0 | **Date:** January 2026

> **Scope:** HOW to build FlutterForge. For WHAT/WHY, see [prd.md](prd.md). For code quality rules, see [coding-standards.md](coding-standards.md).

---

## 1. Architectural Pillars

| Pillar | Description | Implication |
|--------|-------------|-------------|
| **Fidelity via Isomorphism** | Editor uses same rendering engine as target | Wrap user widgets with interceptors, not alternatives |
| **Performance at Scale** | Support 5,000+ nodes at 60 FPS | Virtualization, QuadTree hit-testing, normalized state |
| **Data Sovereignty** | Offline-first, local file system | .forge bundles, security-scoped bookmarks on macOS |

---

## 2. System Layers (Clean Architecture)

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION                          │
│  Widgets, Screens, Riverpod Controllers                 │
├─────────────────────────────────────────────────────────┤
│                    APPLICATION                           │
│  Use Cases, Editor State, Command Processor             │
├─────────────────────────────────────────────────────────┤
│                      DOMAIN                              │
│  Entities (WidgetNode, Project), Repository Interfaces  │
├─────────────────────────────────────────────────────────┤
│                   INFRASTRUCTURE                         │
│  File I/O, Code Generator, Platform Services            │
└─────────────────────────────────────────────────────────┘
```

| Layer | Responsibility | Key Components |
|-------|----------------|----------------|
| Presentation | UI rendering, user interaction | Workbench, PropertyInspector, WidgetTreePanel |
| Application | Orchestration, editor state | EditorController, SelectionManager, CommandProcessor |
| Domain | Business entities, rules | WidgetNode, ForgeProject, ValidationRules |
| Infrastructure | External systems, I/O | FileService, CodeGenerator, BookmarkService |

---

## 3. Directory Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── models/              # WidgetNode, ForgeProject, DesignToken
│   ├── services/            # Abstract service interfaces
│   ├── errors/              # AppException hierarchy
│   └── utils/               # Extensions, helpers
├── features/
│   ├── canvas/
│   │   ├── data/            # Canvas state persistence
│   │   ├── domain/          # Canvas business logic
│   │   └── presentation/    # Canvas widgets, overlays
│   ├── palette/
│   ├── properties/
│   ├── tree/
│   ├── code_preview/
│   ├── project/
│   ├── theming/
│   └── animation/
├── shared/
│   ├── widgets/             # Reusable UI components
│   └── registry/            # Widget definitions
├── generators/
│   └── dart_generator.dart  # AST-based code generation
└── infrastructure/
    ├── file_service.dart
    ├── bookmark_service.dart
    └── logger_service.dart
```

---

## 4. Data Model (Normalized)

### 4.1 Core Entities

```dart
/// Normalized project state - O(1) node access
@freezed
class ProjectState with _$ProjectState {
  const factory ProjectState({
    required Map<String, WidgetNode> nodes,  // Normalized map
    required String rootNodeId,
    required Set<String> selection,
    @Default(1.0) double zoomLevel,
    @Default(Offset.zero) Offset panOffset,
  }) = _ProjectState;
}

/// Single widget in the design tree
@freezed
class WidgetNode with _$WidgetNode {
  const factory WidgetNode({
    required String id,
    required String type,                     // 'Container', 'Column', etc.
    required Map<String, dynamic> properties,
    required List<String> childrenIds,        // References, not objects
    String? parentId,
  }) = _WidgetNode;

  factory WidgetNode.fromJson(Map<String, dynamic> json) =>
      _$WidgetNodeFromJson(json);
}

/// Project container
@freezed
class ForgeProject with _$ForgeProject {
  const factory ForgeProject({
    required String id,
    required String name,
    required List<ScreenDefinition> screens,
    required List<DesignToken> designTokens,
    required ProjectMetadata metadata,
  }) = _ForgeProject;
}

/// Design token for theming
@freezed
class DesignToken with _$DesignToken {
  const factory DesignToken({
    required String id,
    required String name,
    required TokenType type,
    required dynamic valueLight,
    required dynamic valueDark,
  }) = _DesignToken;
}
```

### 4.2 Why Normalized?

| Operation | Recursive Tree | Normalized Map |
|-----------|----------------|----------------|
| Access node by ID | O(n) traversal | O(1) lookup |
| Move node | Deep copy chain | Update 3 fields |
| Serialize | Complex recursion | Simple Map encode |

---

## 5. State Management (Riverpod 3.0)

### 5.1 Provider Architecture

```dart
// Project state provider with code generation
@riverpod
class Project extends _$Project {
  @override
  ForgeProject build() => ForgeProject.empty();

  void load(ForgeProject project) => state = project;

  void updateNode(String id, WidgetNode node) {
    state = state.copyWith(
      nodes: {...state.nodes, id: node},
    );
  }

  void removeNode(String id) {
    final nodes = Map.of(state.nodes)..remove(id);
    state = state.copyWith(nodes: nodes);
  }
}

// Selection state
@riverpod
class Selection extends _$Selection {
  @override
  Set<String> build() => {};

  void select(String id) => state = {id};
  void toggle(String id) {
    state = state.contains(id)
        ? state.difference({id})
        : state.union({id});
  }
  void clear() => state = {};
}

// Derived provider - selected node
@riverpod
WidgetNode? selectedNode(Ref ref) {
  final selection = ref.watch(selectionProvider);
  if (selection.isEmpty) return null;

  final project = ref.watch(projectProvider);
  return project.nodes[selection.first];
}

// Family provider for individual nodes (performance)
@riverpod
WidgetNode? nodeById(Ref ref, String id) {
  return ref.watch(
    projectProvider.select((p) => p.nodes[id]),
  );
}
```

### 5.2 Provider Best Practices

| Do | Don't |
|----|-------|
| Use `ref.watch` in widgets | Use `ref.read` in build methods |
| Use `ref.read` in callbacks | Put navigation in providers |
| Use `.select()` for granular rebuilds | Watch entire state objects |
| Use `@Riverpod(keepAlive: true)` for global state | Create providers in widgets |

---

## 6. Command Pattern (Undo/Redo)

### 6.1 Command Interface

```dart
abstract class ForgeCommand {
  String get label;  // "Move Container", "Change Color"

  ProjectState execute(ProjectState state);
  ProjectState undo(ProjectState state);

  /// Merge with previous command (e.g., typing)
  bool canMerge(ForgeCommand other) => false;
  ForgeCommand merge(ForgeCommand other) => this;
}
```

### 6.2 Command Implementations

```dart
class PropertyChangeCommand extends ForgeCommand {
  final String nodeId;
  final String key;
  final dynamic oldValue;
  final dynamic newValue;

  PropertyChangeCommand({
    required this.nodeId,
    required this.key,
    required this.oldValue,
    required this.newValue,
  });

  @override
  String get label => 'Change $key';

  @override
  ProjectState execute(ProjectState state) {
    final node = state.nodes[nodeId]!;
    final updated = node.copyWith(
      properties: {...node.properties, key: newValue},
    );
    return state.copyWith(nodes: {...state.nodes, nodeId: updated});
  }

  @override
  ProjectState undo(ProjectState state) {
    final node = state.nodes[nodeId]!;
    final updated = node.copyWith(
      properties: {...node.properties, key: oldValue},
    );
    return state.copyWith(nodes: {...state.nodes, nodeId: updated});
  }
}

class MoveNodeCommand extends ForgeCommand {
  final String nodeId;
  final String oldParentId;
  final int oldIndex;
  final String newParentId;
  final int newIndex;
  // ... implementation
}
```

### 6.3 History Manager

```dart
@riverpod
class History extends _$History {
  static const maxSteps = 100;

  @override
  ({List<ForgeCommand> undo, List<ForgeCommand> redo}) build() =>
      (undo: [], redo: []);

  void execute(ForgeCommand command) {
    final projectNotifier = ref.read(projectProvider.notifier);
    final newState = command.execute(ref.read(projectProvider));
    projectNotifier.state = newState;

    final undoStack = [...state.undo, command];
    if (undoStack.length > maxSteps) undoStack.removeAt(0);

    state = (undo: undoStack, redo: []);
  }

  void undo() {
    if (state.undo.isEmpty) return;
    final command = state.undo.last;
    // ... execute undo
  }

  void redo() {
    if (state.redo.isEmpty) return;
    // ... execute redo
  }
}
```

---

## 7. Visual Engine

### 7.1 Canvas Layers

```
┌─────────────────────────────────────┐
│         Overlay Layer               │  ← Selection handles, drop indicators
│         (not transformed)           │     Drawn in screen coordinates
├─────────────────────────────────────┤
│         Content Layer               │  ← User's widget tree
│         (Matrix4 transform)         │     Zoom/pan applied
├─────────────────────────────────────┤
│         Grid Layer                  │  ← Alignment grid
│         (CustomPainter)             │     Hardware accelerated
└─────────────────────────────────────┘
```

### 7.2 Design Proxy (Event Interception)

```dart
/// Wraps user widgets to intercept events in edit mode
class DesignProxy extends StatelessWidget {
  final String nodeId;
  final Widget child;

  const DesignProxy({
    required this.nodeId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        // Intercept: select widget instead of triggering action
        context.read(selectionProvider.notifier).select(nodeId);
      },
      child: AbsorbPointer(
        absorbing: true,  // Block events to child
        child: child,
      ),
    );
  }
}
```

### 7.3 Hit Testing Strategy

| Node Count | Strategy |
|------------|----------|
| < 100 | Linear scan of RenderBox bounds |
| 100-1000 | Cached bounds with dirty tracking |
| > 1000 | QuadTree spatial index |

```dart
class LayoutRegistry {
  final Map<String, GlobalKey> _keys = {};
  QuadTree<String>? _spatialIndex;

  void register(String nodeId, GlobalKey key) {
    _keys[nodeId] = key;
    _invalidateSpatialIndex();
  }

  String? hitTest(Offset globalPosition) {
    if (_keys.length > 1000) {
      return _spatialIndex?.query(globalPosition);
    }
    // Linear scan for smaller trees
    for (final entry in _keys.entries) {
      final box = entry.value.currentContext?.findRenderObject() as RenderBox?;
      if (box?.paintBounds.contains(box.globalToLocal(globalPosition)) ?? false) {
        return entry.key;
      }
    }
    return null;
  }
}
```

---

## 8. Drag-and-Drop

### 8.1 Slot Detection Algorithm

```dart
int calculateInsertionIndex({
  required Axis axis,
  required Offset pointer,
  required List<RenderBox> childBoxes,
}) {
  for (int i = 0; i < childBoxes.length; i++) {
    final box = childBoxes[i];
    final center = box.localToGlobal(box.size.center(Offset.zero));

    final threshold = axis == Axis.vertical
        ? center.dy
        : center.dx;
    final pointerPos = axis == Axis.vertical
        ? pointer.dy
        : pointer.dx;

    if (pointerPos < threshold) return i;
  }
  return childBoxes.length;
}
```

### 8.2 Validation Rules

```dart
bool canDrop(String childType, String parentType) {
  // Expanded/Flexible require Flex parent
  if (['Expanded', 'Flexible'].contains(childType)) {
    return ['Row', 'Column', 'Flex'].contains(parentType);
  }

  // Single-child widgets
  const singleChild = {'Scaffold', 'Center', 'Padding', 'Container'};
  if (singleChild.contains(parentType)) {
    final parent = getNode(parentType);
    return parent.childrenIds.isEmpty;
  }

  return true;
}
```

### 8.3 Zero-Size Handling

```dart
/// Ensure empty containers have minimum size for drop targets
class MinSizeWrapper extends StatelessWidget {
  final Widget child;
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    if (!isEmpty) return child;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 50, minWidth: 50),
      child: child,
    );
  }
}
```

---

## 9. Code Generation Pipeline

### 9.1 AST Approach (code_builder)

```dart
class DartGenerator {
  final WidgetRegistry registry;

  String generate(ForgeProject project) {
    final library = Library((b) => b
      ..directives.addAll(_collectImports(project))
      ..body.add(_generateClass(project)));

    final emitter = DartEmitter.scoped();  // Auto-handles import collisions
    final code = library.accept(emitter).toString();

    return DartFormatter().format(code);
  }

  Expression _generateWidget(WidgetNode node) {
    final definition = registry.get(node.type);
    return definition.generateExpression(node, _generateWidget);
  }
}
```

### 9.2 Widget Definition

```dart
class ContainerDefinition extends WidgetDefinition {
  @override
  Expression generateExpression(
    WidgetNode node,
    Expression Function(WidgetNode) generateChild,
  ) {
    return refer('Container').newInstance([], {
      if (node.properties['width'] != null)
        'width': literalNum(node.properties['width']),
      if (node.properties['height'] != null)
        'height': literalNum(node.properties['height']),
      if (node.properties['color'] != null)
        'color': _generateColor(node.properties['color']),
      if (node.childrenIds.isNotEmpty)
        'child': generateChild(getNode(node.childrenIds.first)),
    });
  }
}
```

---

## 10. Error Handling

### 10.1 Exception Hierarchy

```dart
@freezed
sealed class AppException with _$AppException {
  // File operations
  const factory AppException.fileNotFound(String path) = FileNotFoundException;
  const factory AppException.filePermission(String path) = FilePermissionException;
  const factory AppException.invalidFormat(String reason) = InvalidFormatException;

  // Project operations
  const factory AppException.invalidProject(String reason) = InvalidProjectException;
  const factory AppException.nodeNotFound(String id) = NodeNotFoundException;

  // Code generation
  const factory AppException.codeGeneration(String message) = CodeGenerationException;

  // Validation
  const factory AppException.validation(List<String> errors) = ValidationException;
}
```

### 10.2 Result Type

```dart
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppException error) = Failure<T>;
}

// Usage
Future<Result<ForgeProject>> loadProject(String path) async {
  try {
    final file = File(path);
    if (!await file.exists()) {
      return Result.failure(AppException.fileNotFound(path));
    }
    final json = await file.readAsString();
    final project = ForgeProject.fromJson(jsonDecode(json));
    return Result.success(project);
  } catch (e) {
    return Result.failure(AppException.invalidFormat(e.toString()));
  }
}
```

---

## 11. Platform Integration

### 11.1 File Format (.forge)

```
project.forge (ZIP archive)
├── manifest.json       # Version, metadata
├── project.json        # Serialized ForgeProject
└── assets/
    ├── images/
    └── fonts/
```

### 11.2 macOS Security-Scoped Bookmarks

```dart
class MacOSBookmarkService {
  Future<void> saveBookmark(String path) async {
    final bookmark = await _createSecurityScopedBookmark(path);
    await _secureStorage.write(key: 'bookmark_$path', value: bookmark);
  }

  Future<String?> resolveBookmark(String key) async {
    final bookmark = await _secureStorage.read(key: key);
    if (bookmark == null) return null;

    final url = await _resolveBookmark(bookmark);
    await _startAccessingSecurityScopedResource(url);
    return url;
  }

  Future<void> stopAccessing(String url) async {
    await _stopAccessingSecurityScopedResource(url);
  }
}
```

### 11.3 Native Menus

```dart
PlatformMenuBar(
  menus: [
    PlatformMenu(
      label: 'File',
      menus: [
        PlatformMenuItem(
          label: 'New Project',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyN, meta: true),
          onSelected: () => ref.read(projectProvider.notifier).newProject(),
        ),
        PlatformMenuItem(
          label: 'Save',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyS, meta: true),
          onSelected: () => ref.read(projectProvider.notifier).save(),
        ),
      ],
    ),
    PlatformMenu(
      label: 'Edit',
      menus: [
        PlatformMenuItem(
          label: 'Undo',
          shortcut: const SingleActivator(LogicalKeyboardKey.keyZ, meta: true),
          onSelected: () => ref.read(historyProvider.notifier).undo(),
        ),
      ],
    ),
  ],
  child: child,
)
```

---

## 12. Performance Strategies

| Strategy | Where | Impact |
|----------|-------|--------|
| Normalized state | Data model | O(1) updates |
| `ref.select()` | Providers | Granular rebuilds |
| RepaintBoundary | Canvas layers | Isolated repaints |
| SliverList | Tree panel | Virtualized rendering |
| QuadTree | Hit testing | O(log n) spatial queries |
| const widgets | Generated code | Compile-time optimization |

---

## 13. Widget Metadata System

### 13.1 Schema Definition

```json
{
  "type": "Container",
  "category": "Layout",
  "acceptsChildren": true,
  "maxChildren": 1,
  "properties": [
    {"name": "width", "type": "double", "nullable": true},
    {"name": "height", "type": "double", "nullable": true},
    {"name": "color", "type": "Color", "nullable": true},
    {"name": "padding", "type": "EdgeInsets", "nullable": true}
  ]
}
```

### 13.2 Dynamic Property Inspector

```dart
Widget buildEditor(PropertyDefinition prop, dynamic value, ValueChanged onChange) {
  return switch (prop.type) {
    'double' => NumberInput(value: value, onChanged: onChange),
    'Color' => ColorPicker(value: value, onChanged: onChange),
    'EdgeInsets' => EdgeInsetsEditor(value: value, onChanged: onChange),
    'Alignment' => AlignmentPicker(value: value, onChanged: onChange),
    _ when prop.isEnum => EnumDropdown(values: prop.enumValues, ...),
    _ => TextField(controller: TextEditingController(text: value?.toString())),
  };
}
```

---

## 14. Navigation

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const ProjectListScreen(),
      ),
      GoRoute(
        path: '/project/:id',
        builder: (_, state) => EditorScreen(
          projectId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
    ],
  );
});
```

---

## 15. Technology Stack

| Component | Package | Version |
|-----------|---------|---------|
| Framework | flutter | 3.19+ |
| Language | dart | 3.3+ |
| State | riverpod + riverpod_generator | 3.0+ |
| Data classes | freezed + json_serializable | 2.5+ |
| Code gen | code_builder | 4.10+ |
| Formatting | dart_style | 2.3+ |
| Navigation | go_router | 14+ |
| File picker | file_picker | latest |
| Path provider | path_provider | latest |
| Archive | archive | latest |
| Secure storage | flutter_secure_storage | latest |
| Linting | very_good_analysis | 6.0+ |

---

*See [prd.md](prd.md) for requirements, [coding-standards.md](coding-standards.md) for code quality rules.*

# FlutterForge: Coding Standards

**Version:** 2.0 | **Date:** January 2026

> **Scope:** Code quality RULES and PATTERNS. For WHAT/WHY, see [prd.md](prd.md). For HOW, see [architecture.md](architecture.md).

---

## 1. Dart 3+ Requirements

### 1.1 Minimum Versions

| Component | Version | Required Features |
|-----------|---------|-------------------|
| Dart | 3.3+ | Records, Patterns, Sealed Classes |
| Flutter | 3.19+ | Latest desktop support |

### 1.2 Language Features to Use

| Feature | Use Case | Example |
|---------|----------|---------|
| Records | Multiple return values | `(Article, bool isCached)` |
| Patterns | Destructuring, switch expressions | `final (x, y) = point;` |
| Sealed classes | Exhaustive state handling | `sealed class Result` |
| Class modifiers | API control | `final`, `interface`, `base` |

---

## 2. Data Modeling Rules

### 2.1 Freezed Classes

**Required for:** All domain entities, state classes, DTOs.

```dart
// ✅ CORRECT: Freezed with sealed for union types
@freezed
sealed class LoadState<T> with _$LoadState<T> {
  const factory LoadState.idle() = Idle<T>;
  const factory LoadState.loading() = Loading<T>;
  const factory LoadState.success(T data) = Success<T>;
  const factory LoadState.error(String message) = Error<T>;
}

// ✅ CORRECT: Freezed for data classes
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### 2.2 Pattern Matching

**Required for:** All state consumption, type discrimination.

```dart
// ✅ CORRECT: Switch expression with exhaustive matching
Widget build(BuildContext context) {
  return switch (state) {
    Idle() => const IdleView(),
    Loading() => const CircularProgressIndicator(),
    Success(:final data) => DataView(data: data),
    Error(:final message) => ErrorView(message: message),
  };
}

// ❌ WRONG: Manual type checking
if (state is Loading) {
  return CircularProgressIndicator();
} else if (state is Success) {
  return DataView(data: (state as Success).data);  // Casting!
}
```

### 2.3 Records

**Use for:** Multiple return values, temporary groupings.
**Don't use for:** Public API types (use named classes).

```dart
// ✅ CORRECT: Internal multi-value return
(WidgetNode?, int) findNodeWithIndex(String id) {
  final index = nodes.indexWhere((n) => n.id == id);
  return (index >= 0 ? nodes[index] : null, index);
}

// ❌ WRONG: Public API with record
class Repository {
  (User, List<Post>) getUserWithPosts(); // Hard to evolve
}

// ✅ CORRECT: Public API with named class
class Repository {
  UserWithPosts getUserWithPosts();
}
```

---

## 3. State Management Rules (Riverpod 3.0)

### 3.1 Provider Types

| Provider Type | Use Case |
|---------------|----------|
| `@riverpod` on function | Read-only computed values |
| `@riverpod` on class (Notifier) | Mutable state with methods |
| `@Riverpod(keepAlive: true)` | Global/persistent state |

### 3.2 Required Patterns

```dart
// ✅ CORRECT: Watch in build, read in callbacks
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);  // ✅ watch for reactivity

    return ElevatedButton(
      onPressed: () => ref.read(counterProvider.notifier).increment(),  // ✅ read in callback
      child: Text('Count: $count'),
    );
  }
}

// ❌ WRONG: Read in build
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.read(counterProvider);  // Won't rebuild!
}
```

### 3.3 Granular Selects

**Required when:** Provider state is larger than what widget needs.

```dart
// ✅ CORRECT: Select specific field
final userName = ref.watch(userProvider.select((u) => u.name));

// ❌ WRONG: Watch entire object when only need one field
final user = ref.watch(userProvider);
Text(user.name);  // Rebuilds on ANY user change
```

### 3.4 Family Providers

**Required for:** Parameterized state access.

```dart
@riverpod
WidgetNode? nodeById(Ref ref, String id) {
  return ref.watch(projectProvider.select((p) => p.nodes[id]));
}

// Usage
final node = ref.watch(nodeByIdProvider(selectedId));
```

---

## 4. Widget Rules

### 4.1 Extract Widgets, Not Methods

**Always extract separate widget classes. Never use helper methods.**

```dart
// ✅ CORRECT: Separate widget class
class UserAvatar extends StatelessWidget {
  final String imageUrl;
  const UserAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) => CircleAvatar(/* ... */);
}

// ❌ WRONG: Helper method
class ProfileScreen extends StatelessWidget {
  Widget _buildAvatar(String url) => CircleAvatar(/* ... */);  // No caching!

  @override
  Widget build(BuildContext context) => _buildAvatar(user.imageUrl);
}
```

**Why:** Helper methods rebuild with parent. Separate widgets can be cached by framework.

### 4.2 Const Constructors

**Required for:** All stateless widgets, all immutable parameters.

```dart
// ✅ CORRECT: const constructor, const usage
class AppButton extends StatelessWidget {
  final String label;
  const AppButton({required this.label});  // ✅ const constructor
}

// Usage
const AppButton(label: 'Submit');  // ✅ Canonical instance

// ❌ WRONG: Missing const
AppButton(label: 'Submit');  // New instance every build
```

### 4.3 Keys

**Required when:** Widgets in lists, widgets that move, widget identity matters.

```dart
// ✅ CORRECT: ValueKey for stable identity
ListView.builder(
  itemBuilder: (_, i) => WidgetCard(
    key: ValueKey(nodes[i].id),  // ✅ Stable key
    node: nodes[i],
  ),
);

// ❌ WRONG: Index as key (breaks on reorder)
ListView.builder(
  itemBuilder: (_, i) => WidgetCard(
    key: ValueKey(i),  // ❌ Changes on reorder
    node: nodes[i],
  ),
);
```

---

## 5. Performance Rules

### 5.1 RepaintBoundary

**Required for:** High-frequency updates isolated from static content.

```dart
// ✅ CORRECT: Isolate animated overlay from static tree
Stack(
  children: [
    RepaintBoundary(child: WidgetTree()),  // Static, expensive
    RepaintBoundary(child: SelectionOverlay()),  // Animates frequently
  ],
);
```

### 5.2 Avoid Intrinsic Widgets

**Never use:** `IntrinsicHeight`, `IntrinsicWidth` in performance-critical paths.

```dart
// ❌ WRONG: O(n²) layout
IntrinsicHeight(child: Row(children: [...]));

// ✅ CORRECT: Explicit constraints
SizedBox(height: 48, child: Row(children: [...]));
```

### 5.3 ListView.builder

**Required for:** Lists > 20 items.

```dart
// ✅ CORRECT: Lazy building
ListView.builder(
  itemCount: nodes.length,
  itemBuilder: (_, i) => NodeTile(node: nodes[i]),
);

// ❌ WRONG: Eager building
ListView(
  children: nodes.map((n) => NodeTile(node: n)).toList(),  // Builds ALL
);
```

---

## 6. Code Generation Rules

### 6.1 AST Over Strings

**Required:** Use `code_builder` for all code generation.

```dart
// ✅ CORRECT: AST-based
refer('Container').newInstance([], {
  'width': literalNum(100),
});

// ❌ WRONG: String interpolation
'Container(width: $width)';  // Fragile, no syntax checking
```

### 6.2 Scoped Emitter

**Required:** Always use `DartEmitter.scoped()` for import handling.

```dart
// ✅ CORRECT: Auto-handles name collisions
final emitter = DartEmitter.scoped();
final code = library.accept(emitter).toString();

// ❌ WRONG: Manual import tracking
final emitter = DartEmitter();  // Name collisions possible
```

### 6.3 Format Output

**Required:** All generated code through `DartFormatter`.

```dart
// ✅ CORRECT: Formatted output
return DartFormatter().format(rawCode);

// ❌ WRONG: Unformatted (single-line mess)
return rawCode;
```

### 6.4 Const in Generated Code

**Required:** Emit `const` for all immutable expressions.

```dart
// ✅ CORRECT: const EdgeInsets
refer('EdgeInsets').property('all').call([literalNum(8)])
  .annotation(refer('const'));  // Results in: const EdgeInsets.all(8)

// ❌ WRONG: Non-const (allocates at runtime)
// EdgeInsets.all(8)
```

---

## 7. Linting Configuration

### 7.1 Required Package

```yaml
# pubspec.yaml
dev_dependencies:
  very_good_analysis: ^6.0.0
```

```yaml
# analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    # Project-specific overrides only if justified
```

### 7.2 Critical Rules

| Rule | Reason |
|------|--------|
| `prefer_const_constructors` | Widget caching |
| `avoid_dynamic_calls` | Type safety |
| `prefer_final_locals` | Immutability |
| `unawaited_futures` | Async safety |
| `public_member_api_docs` | API documentation |

### 7.3 Generated Code Exemptions

```dart
// In generated files only:
// ignore_for_file: type=lint
```

---

## 8. File Organization

### 8.1 One Export Per File

```dart
// ✅ CORRECT: One class per file
// user.dart
class User { ... }

// ❌ WRONG: Multiple classes
// models.dart
class User { ... }
class Post { ... }
class Comment { ... }
```

### 8.2 Part Files for Generated Code

```dart
// user.dart
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User { ... }
```

### 8.3 Barrel Exports

```dart
// features/canvas/canvas.dart
export 'presentation/canvas_widget.dart';
export 'presentation/overlay_widget.dart';
export 'domain/canvas_state.dart';
// Don't export implementation details
```

---

## 9. Naming Conventions

### 9.1 Files

| Type | Convention | Example |
|------|------------|---------|
| Classes | `snake_case.dart` | `widget_node.dart` |
| Tests | `*_test.dart` | `widget_node_test.dart` |
| Generated | `*.g.dart`, `*.freezed.dart` | `widget_node.g.dart` |

### 9.2 Identifiers

| Type | Convention | Example |
|------|------------|---------|
| Classes | `PascalCase` | `WidgetNode` |
| Variables/Functions | `camelCase` | `nodeById` |
| Constants | `camelCase` | `defaultPadding` |
| Enums | `PascalCase.camelCase` | `TokenType.color` |
| Providers | `camelCaseProvider` | `projectProvider` |

### 9.3 Riverpod Naming

```dart
// Provider names match what they provide
@riverpod
ForgeProject project(Ref ref) => ...;  // → projectProvider

@riverpod
class Selection extends _$Selection { ... }  // → selectionProvider
```

---

## 10. Testing Rules

### 10.1 Test Organization

```
test/
├── unit/
│   ├── models/
│   │   └── widget_node_test.dart
│   └── services/
│       └── code_generator_test.dart
├── widget/
│   └── property_panel_test.dart
├── integration/
│   └── drag_drop_test.dart
└── golden/
    └── generated_code_test.dart
```

### 10.2 Test Naming

```dart
// Pattern: should_expectedBehavior_when_condition
test('should return null when node not found', () { ... });
test('should generate valid Dart when all properties set', () { ... });
```

### 10.3 Riverpod Testing

```dart
// ✅ CORRECT: ProviderContainer for unit tests
void main() {
  test('selection updates correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(selectionProvider.notifier).select('node-1');

    expect(container.read(selectionProvider), {'node-1'});
  });
}
```

---

## 11. Error Handling Rules

### 11.1 Result Type Pattern

**Required for:** All operations that can fail.

```dart
// ✅ CORRECT: Explicit Result type
Future<Result<Project>> loadProject(String path);

// Usage with pattern matching
final result = await loadProject(path);
return switch (result) {
  Success(:final data) => ProjectScreen(project: data),
  Failure(:final error) => ErrorScreen(error: error),
};

// ❌ WRONG: Throwing exceptions for expected failures
Future<Project> loadProject(String path) {
  throw FileNotFoundException();  // Untyped, easy to miss
}
```

### 11.2 Exception Hierarchy

**Required:** Use sealed class hierarchy (see architecture.md §10).

---

## 12. Documentation Rules

### 12.1 Public API Documentation

**Required for:** All public classes, methods, properties.

```dart
/// Represents a single widget in the design tree.
///
/// Use [childrenIds] to access children by reference.
/// See also: [ForgeProject], [ProjectState].
@freezed
class WidgetNode with _$WidgetNode {
  /// Creates a new widget node.
  ///
  /// [id] must be a valid UUID.
  /// [type] must match a registered widget definition.
  const factory WidgetNode({
    required String id,
    required String type,
    // ...
  }) = _WidgetNode;
}
```

### 12.2 Code Comments

**Use sparingly. Code should be self-documenting.**

```dart
// ✅ CORRECT: Explain WHY, not WHAT
// QuadTree provides O(log n) hit testing for large node counts
if (_keys.length > 1000) {
  return _spatialIndex?.query(position);
}

// ❌ WRONG: Explain WHAT (code already shows this)
// Loop through keys and check bounds
for (final entry in _keys.entries) { ... }
```

---

## 13. Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Helper methods returning widgets | No framework caching | Extract StatelessWidget |
| `ref.read` in build | No reactivity | Use `ref.watch` |
| Watching entire provider | Excessive rebuilds | Use `.select()` |
| String-based code generation | Syntax errors, no imports | Use code_builder |
| IntrinsicHeight/Width | O(n²) layout | Explicit constraints |
| Index keys in lists | Wrong widget identity | ValueKey with ID |
| Throwing for expected errors | Untyped, easy to miss | Result type |
| Dynamic types | No type safety | Explicit types, generics |

---

## Quick Reference Card

```
DO                                  DON'T
─────────────────────────────────   ─────────────────────────────────
ref.watch() in build                ref.read() in build
ref.read() in callbacks             ref.watch() in callbacks
Extract StatelessWidget             Helper methods (_buildX)
const constructors                  Non-const widgets
ValueKey with ID                    Index-based keys
switch expressions                  if-else type checking
code_builder for codegen            String interpolation
Result<T> for errors                Throwing exceptions
very_good_analysis                  flutter_lints (too permissive)
```

---

*See [prd.md](prd.md) for requirements, [architecture.md](architecture.md) for implementation details.*

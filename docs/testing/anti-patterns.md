# Testing Anti-Patterns

This document captures testing anti-patterns discovered through real bugs that escaped our test suite.

## Case Study: Nested Drop Bug (January 2026)

### The Bug

`onWidgetDropped` wasn't passed from `DesignCanvas` to `WidgetRenderer` at `design_canvas.dart:78-87`. Users couldn't drop widgets INTO containers - the drop silently failed.

### Why Tests Missed It

| Test Level | What It Tests | Why It Missed the Bug |
|------------|---------------|----------------------|
| Unit tests | `NestedDropZone` in isolation | Mocks `onWidgetDropped` directly - bypasses real chain |
| Unit tests | `WidgetRenderer` in isolation | Invokes `DragTarget.onAcceptWithDetails` directly |
| Integration | `DesignCanvas` + `WidgetRenderer` | **Only tests root drops** - never drops INTO containers |

### The Untested Signal Path

```
DesignCanvas → WidgetRenderer (root) → NestedDropZone
                    ↓
              onWidgetDropped ← NOT PASSED (THE BUG)
                    ↓
              WidgetRenderer (child) → NestedDropZone
```

Unit tests verified each box works. No test verified the arrows (callback wiring).

---

## Anti-Pattern 1: Mocking Callbacks Instead of Testing Through UI

**Problem:** Unit tests that mock callbacks bypass the real callback chain, hiding wiring bugs.

```dart
// BAD: Bypasses callback chain - directly invokes handler
testWidgets('drop fires callback', (tester) async {
  bool callbackFired = false;

  await tester.pumpWidget(
    NestedDropZone(
      onWidgetDropped: (type, parentId) {
        callbackFired = true;
      },
      // ... other params
    ),
  );

  // This test PASSES even if DesignCanvas never passes the callback!
  final dragTarget = tester.widget<DragTarget>(find.byType(DragTarget));
  dragTarget.onAcceptWithDetails?.call(mockDetails);

  expect(callbackFired, isTrue); // FALSE CONFIDENCE
});
```

```dart
// GOOD: Tests through real UI interaction
testWidgets('nested drop fires callback with correct parentId', (tester) async {
  String? droppedParentId;

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              const WidgetPalette(),
              DesignCanvas(
                // Full widget tree with real wiring
                onWidgetDropped: (type, parentId) {
                  droppedParentId = parentId;
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Actually drag from palette to container
  await dragWidgetToCanvas(tester, 'Container');
  await dragWidgetToParent(tester, 'Text', find.byType(NestedDropZone));

  expect(droppedParentId, equals('container-id')); // TRUE CONFIDENCE
});
```

---

## Anti-Pattern 2: Only Testing Happy Path at Root Level

**Problem:** Tests that only verify root-level operations miss nested interaction bugs.

```dart
// BAD: Only tests root drops
testWidgets('can add widgets to canvas', (tester) async {
  await tester.pumpWidget(const FlutterForgeApp());

  // Only tests dropping to root - never into containers
  await dragWidgetToCanvas(tester, 'Container');
  await dragWidgetToCanvas(tester, 'Text');
  await dragWidgetToCanvas(tester, 'Row');

  expect(find.text('Drop widgets here'), findsNothing);
});
```

```dart
// GOOD: Tests nested drops too
testWidgets('can add widgets to canvas AND into containers', (tester) async {
  await tester.pumpWidget(const FlutterForgeApp());

  // Root drop
  await dragWidgetToCanvas(tester, 'Container');

  // Nested drop - THIS IS WHAT CAUGHT THE BUG
  final dropZone = find.byType(NestedDropZone);
  await dragWidgetToParent(tester, 'Text', dropZone);

  // Verify nested widget appears in correct parent
  expect(textAppearsInContainer, isTrue);
});
```

---

## Anti-Pattern 3: Unused Test Helpers

**Problem:** Helper functions exist but aren't used, leaving critical paths untested.

### The Evidence

`dragWidgetToParent()` existed in `test/integration/test_utils.dart:64-91` but was **NEVER USED** in any test file.

```dart
// Helper existed but was never called:
Future<void> dragWidgetToParent(
  WidgetTester tester,
  String widgetName,
  Finder parentFinder,
) async {
  // Implementation exists but nobody uses it
}
```

### The Fix

Audit all test helpers periodically. If a helper exists but isn't used:
1. Either add tests that use it
2. Or remove it (dead code)

---

## Anti-Pattern 4: Testing Internal State Instead of User-Visible Behavior

**Problem:** Tests verify internal model state but miss actual UI behavior.

```dart
// BAD: Tests state, not behavior
testWidgets('widget tree updates on drop', (tester) async {
  final state = WorkbenchState();
  state.addWidget('Container', null);

  expect(state.nodes.length, equals(1)); // State is correct
  // BUT: Does the UI actually render it? Does the callback work?
});
```

```dart
// GOOD: Tests user-visible behavior
testWidgets('dropped widget appears on canvas', (tester) async {
  await tester.pumpWidget(const FlutterForgeApp());

  await dragWidgetToCanvas(tester, 'Container');

  // Verify what the USER sees
  expect(find.text('Drop widgets here'), findsNothing);
  expect(find.descendant(
    of: find.byType(DesignCanvas),
    matching: find.text('Container'),
  ), findsOneWidget);
});
```

---

## Anti-Pattern 5: No Regression Prevention Tests

**Problem:** After fixing a bug, no test exists to prevent it from recurring.

### Regression Prevention Pattern

After fixing any bug:

1. **Write a test that FAILS with the bug present**
2. **Verify the test PASSES with the fix**
3. **Add comment explaining what bug it prevents**

```dart
// Regression test for: onWidgetDropped not passed to WidgetRenderer
// Bug report: Nested drops silently failed
// Fixed in: design_canvas.dart:85-86
testWidgets('REGRESSION: nested drop fires callback', (tester) async {
  // This test fails if onWidgetDropped is not passed from
  // DesignCanvas to WidgetRenderer

  String? capturedParentId;
  // ... setup ...

  await dragWidgetToParent(tester, 'Text', containerDropZone);

  expect(
    capturedParentId,
    isNotNull,
    reason: 'Callback chain must propagate through WidgetRenderer',
  );
});
```

---

## Testing Checklist for Callback Chains

When testing any callback chain:

- [ ] Test fires from actual UI interaction (not direct method call)
- [ ] Test at every level of nesting (root, 1-deep, 2-deep)
- [ ] Test callback parameters are correct at each level
- [ ] Test rejection scenarios (full containers, invalid drops)
- [ ] Test with real widget tree (not isolated components)
- [ ] Add regression test for any bug found

---

## Summary: What This Bug Taught Us

1. **Unit tests give false confidence** when they mock the exact thing that's broken
2. **Test helpers must be used** - unused helpers indicate coverage gaps
3. **Integration tests must test ALL interaction levels** - not just root level
4. **Every callback chain needs E2E coverage** from source to handler
5. **Blackbox tests are invaluable** - they test what users experience, not implementation details

---

## Related Files

- `test/integration/callback_chain_test.dart` - E2E callback chain tests
- `test/integration/blackbox_canvas_test.dart` - True blackbox tests
- `test/integration/journey_canvas_test.dart` - Updated with nested drop tests
- `test/integration/test_utils.dart` - Contains `dragWidgetToParent()` helper

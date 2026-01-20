# FlutterForge Roadmap

**Last Updated:** 2026-01-21

## Overview

This roadmap tracks implementation tasks for FlutterForge. Each task maps to user journey acceptance criteria for traceability.

---

## Phase 1: Foundation (COMPLETE)

**Milestone:** Drag Container with Text child, edit padding, export basic code

**Completed:** 2026-01-21 | **Tasks:** 7/7 | **Tests:** 109

See `.claude/PROGRESS.md` for detailed Phase 1 completion records.

| Task ID | Description | Status |
|---------|-------------|--------|
| phase-1-task-01 | Widget Registry System | COMPLETE |
| phase-1-task-02 | Widget Palette UI | COMPLETE |
| phase-1-task-03 | Basic Canvas | COMPLETE |
| phase-1-task-04 | Single-Level Widget Insertion | COMPLETE |
| phase-1-task-05 | Properties Panel | COMPLETE |
| phase-1-task-06 | Code Generation | COMPLETE |
| phase-1-task-07 | App Shell Integration | COMPLETE |

---

## Phase 2: Core Editor (COMPLETE)

**Milestone:** Widget tree panel, undo/redo, 20 widgets, multi-level drag-drop

**Completed:** 2026-01-21 | **Tasks:** 12/12 | **Tests:** 404

### Task 2.1: Command Pattern Foundation

| Field | Value |
|-------|-------|
| ID | phase-2-task-01 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J07 (Edit Operations) S1-2, Command Pattern Reference |
| Requirements | FR7.1 |
| Location | `lib/commands/` |

**Deliverables:**
- [x] `Command` abstract base class with `execute()` and `undo()` methods
- [x] `CommandProcessor` for managing undo/redo stacks
- [x] `AddWidgetCommand` for widget insertion
- [x] `DeleteWidgetCommand` for widget removal
- [x] `PropertyChangeCommand` for property modifications
- [x] `MoveWidgetCommand` for reordering/reparenting

**Acceptance Criteria (from J07 Command Pattern Reference):**
- [x] Each command implements `execute()` and `undo()` methods
- [x] Commands are serializable for future persistence
- [x] Undo stack limit of 100 actions
- [x] Oldest undo discarded when limit exceeded
- [x] Redo stack clears on new action
- [x] Tests: Command execution and reversal for all command types

---

### Task 2.2: Undo/Redo Provider Integration

| Field | Value |
|-------|-------|
| ID | phase-2-task-02 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J07 (Edit Operations) S1 (Undo), S2 (Redo) |
| Requirements | FR7.1 |
| Depends On | phase-2-task-01 |
| Location | `lib/providers/` |

**Deliverables:**
- [x] `CommandProvider` Riverpod provider for command processor
- [x] Integration with `ProjectProvider` for state changes
- [x] Undo keyboard shortcut: Cmd/Ctrl+Z
- [x] Redo keyboard shortcut: Cmd/Ctrl+Shift+Z
- [x] Edit menu Undo/Redo items with action labels

**Acceptance Criteria (from J07 S1-S2):**
- [x] Undo property change reverts to previous value (S1)
- [x] Undo widget add removes widget (S1)
- [x] Undo widget delete restores widget with children (S1)
- [x] Undo move restores original position (S1)
- [x] Redo restores undone change (S2)
- [x] Redo chain: 3 undos + 3 redos returns to original state (S2)
- [x] New action clears redo stack (S2)
- [x] Menu shows "Undo: [action]" label (S1)
- [x] Response: <50ms state update (NFR)
- [x] Tests: Undo/redo cycles for all command types

---

### Task 2.3: Widget Tree Panel UI

| Field | Value |
|-------|-------|
| ID | phase-2-task-03 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J04 (Widget Tree) S1 |
| Requirements | FR3.1, FR3.5 |
| Location | `lib/features/tree/` |

**Deliverables:**
- [x] `WidgetTreePanel` component with hierarchical display
- [x] `TreeNode` widget with expand/collapse toggle
- [x] Indentation for parent-child relationships (16-20px per level)
- [x] Widget type icons and names per node
- [x] Expand All / Collapse All context menu options

**Acceptance Criteria (from J04 S1):**
- [x] Tree shows root widget as top node (FR3.1)
- [x] Children indented under parents
- [x] Expandable nodes show expand/collapse controls (FR3.5)
- [x] Node shows widget type icon and name
- [x] Expand/collapse toggles children visibility
- [x] Keyboard: Right arrow expands, Left arrow collapses
- [x] Empty canvas shows "No widgets" placeholder
- [x] Tree render: <50ms after state change (NFR)
- [x] Node height: minimum 28px for touch target
- [x] Tests: Tree rendering, expand/collapse behavior

---

### Task 2.4: Widget Tree Selection Sync

| Field | Value |
|-------|-------|
| ID | phase-2-task-04 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J04 (Widget Tree) S2 |
| Requirements | FR3.2 |
| Depends On | phase-2-task-03 |
| Location | `lib/features/tree/` |

**Deliverables:**
- [x] Tree node click updates selection state
- [x] Selection state syncs to canvas overlay
- [x] Canvas selection syncs to tree highlight
- [x] Auto-expand collapsed parents when child selected via canvas
- [x] Scroll-into-view for selected node if needed

**Acceptance Criteria (from J04 S2):**
- [x] Click tree node selects widget (FR3.2)
- [x] Canvas overlay appears on corresponding widget (FR3.2)
- [x] Properties panel updates to show selected widget
- [x] Canvas click highlights corresponding tree node
- [x] Collapsed parent auto-expands if child selected
- [x] Tree scrolls to make selected node visible
- [x] Keyboard Up/Down moves selection between nodes
- [x] Selection sync: <16ms tree-to-canvas, <50ms canvas-to-tree (NFR)
- [x] Tests: Bidirectional selection sync

---

### Task 2.5: Widget Tree Drag Reorder

| Field | Value |
|-------|-------|
| ID | phase-2-task-05 |
| Status | COMPLETE |
| Priority | P1 |
| Journey AC | J04 (Widget Tree) S3 |
| Requirements | FR3.3 |
| Depends On | phase-2-task-04, phase-2-task-01 |
| Location | `lib/features/tree/` |

**Deliverables:**
- [x] Drag initiation on tree node (4px threshold)
- [x] Drag indicator showing grabbed node
- [x] Insertion indicator (line between nodes)
- [x] Drop target validation against widget constraints
- [x] Canvas update after tree reorder

**Acceptance Criteria (from J04 S3):**
- [x] Reorder within same parent: [A, B, C] -> [B, A, C] (FR3.3)
- [x] Move to different parent updates both parent's children
- [x] Invalid target (e.g., Expanded in Container) shows rejection
- [x] Tooltip shows reason for invalid target
- [x] Escape cancels drag, preserves original hierarchy
- [x] Canvas updates immediately after reorder
- [x] Drag threshold: 4px before drag initiates
- [x] Auto-scroll when dragging near tree viewport edge
- [x] Uses MoveWidgetCommand for undo support
- [x] Tests: Reorder, reparent, validation, cancel

---

### Task 2.6: Widget Tree Context Menu

| Field | Value |
|-------|-------|
| ID | phase-2-task-06 |
| Status | COMPLETE |
| Priority | P1 |
| Journey AC | J04 (Widget Tree) S4 |
| Requirements | FR3.4 |
| Depends On | phase-2-task-04, phase-2-task-01 |
| Location | `lib/features/tree/` |

**Deliverables:**
- [x] Right-click context menu on tree nodes
- [x] Delete option with keyboard shortcut
- [x] Cut/Copy/Paste options (preparation for Phase 4)
- [x] Duplicate option with keyboard shortcut
- [x] "Wrap in..." submenu for common wrappers

**Acceptance Criteria (from J04 S4):**
- [x] Delete leaf widget removes it (FR3.4)
- [x] Delete widget with children shows confirmation dialog
- [x] Context menu shows: Cut, Copy, Paste, Duplicate, Delete, Wrap in...
- [x] Each menu item shows keyboard shortcut
- [x] Delete/Backspace key triggers delete
- [x] Context menu appears within <100ms
- [x] Uses DeleteWidgetCommand for undo support
- [x] WrapWidgetCommand for wrap operations with undo support
- [x] Tests: Delete operations, confirmation dialog, duplicate, wrap

---

### Task 2.7: Multi-Level Nested Drop Zones

| Field | Value |
|-------|-------|
| ID | phase-2-task-07 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J03 (Design Canvas) S2 |
| Requirements | FR2.3 |
| Depends On | phase-2-task-01 |
| Location | `lib/features/canvas/` |

**Deliverables:**
- [x] Enhanced `NestedDropZone` for arbitrary nesting depth
- [x] Insertion indicators between children in multi-child containers
- [x] Parent-child compatibility validation during drag
- [x] Visual feedback for valid/invalid drop targets
- [x] Stack-specific z-ordering on drop

**Acceptance Criteria (from J03 S2):**
- [x] Drop into nested containers works (depth 3+) (FR2.3)
- [x] Insertion indicators appear between children in Row/Column
- [x] Indicator shows exact insertion position
- [x] Single-child container rejects drop if already has child
- [x] Expanded widget rejected by non-Flex containers
- [x] Tooltip shows reason for rejection
- [x] Stack places dropped widget on top (highest z-index)
- [x] Nested zone appearance: <50ms after hover
- [x] Uses AddWidgetCommand for undo support
- [x] Tests: Multi-level nesting, insertion positions, validation

---

### Task 2.8: Canvas Widget Reordering

| Field | Value |
|-------|-------|
| ID | phase-2-task-08 |
| Status | COMPLETE |
| Priority | P1 |
| Journey AC | J03 (Design Canvas) S4 |
| Requirements | FR2.6 |
| Depends On | phase-2-task-07, phase-2-task-01 |
| Location | `lib/features/canvas/` |

**Deliverables:**
- [x] Drag widget within parent to reorder
- [x] Animated gap preview showing insertion position
- [x] Drop threshold: 50% of sibling dimension
- [x] Same-position drop results in no-op
- [x] Escape cancels reorder

**Acceptance Criteria (from J03 S4):**
- [x] Drag widget within Row/Column shows reorder indicators (FR2.6)
- [x] Siblings animate to show gap at insertion point
- [x] Row [A, B, C] + drag B after C = [A, C, B]
- [x] Drop at original position = no-op
- [x] Escape during drag cancels, preserves order
- [x] Animation: smooth sibling repositioning (200ms)
- [x] Uses MoveWidgetCommand for undo support
- [x] Tests: Reorder within parent, cancel behavior

---

### Task 2.9: Widget Registry Expansion - Layout

| Field | Value |
|-------|-------|
| ID | phase-2-task-09 |
| Status | COMPLETE |
| Priority | P1 |
| Journey AC | J02 (Widget Palette) S1 |
| Requirements | FR1.1 |
| Location | `lib/shared/registry/` |

**Deliverables:**
- [x] Stack widget (multi-child, z-ordering)
- [x] Expanded widget (Flex child only constraint)
- [x] Flexible widget (Flex child only constraint)
- [x] Padding widget (single-child)
- [x] Center widget (single-child)
- [x] Align widget (single-child, alignment property)
- [x] Spacer widget (Flex child only, leaf)

**New Widgets (7):**
| Widget | Category | Children | Constraint |
|--------|----------|----------|------------|
| Stack | Layout | Multi | None |
| Expanded | Layout | Single | Flex parent |
| Flexible | Layout | Single | Flex parent |
| Padding | Layout | Single | None |
| Center | Layout | Single | None |
| Align | Layout | Single | None |
| Spacer | Layout | None | Flex parent |

**Acceptance Criteria:**
- [x] Each widget registered with type, category, properties
- [x] Expanded/Flexible/Spacer have `parentConstraint: 'Flex'`
- [x] Stack has alignment, fit, clipBehavior properties
- [x] Align has alignment property
- [x] Widget palette shows new widgets in Layout category
- [x] Tests: Registration and constraints for each widget (38 tests)

---

### Task 2.10: Widget Registry Expansion - Content

| Field | Value |
|-------|-------|
| ID | phase-2-task-10 |
| Status | COMPLETE |
| Priority | P1 |
| Journey AC | J02 (Widget Palette) S1 |
| Requirements | FR1.1 |
| Location | `lib/shared/registry/` |

**Deliverables:**
- [x] Icon widget (icon property, size, color)
- [x] Image widget (width, height, fit, alignment)
- [x] Divider widget (thickness, indent, endIndent, color)
- [x] VerticalDivider widget (thickness, width, indent, endIndent, color)

**New Widgets (4):**
| Widget | Category | Children | Constraint |
|--------|----------|----------|------------|
| Icon | Content | None | None |
| Image | Content | None | None |
| Divider | Content | None | None |
| VerticalDivider | Content | None | None |

**Acceptance Criteria:**
- [x] Icon has icon enum, size, color properties
- [x] Image has width, height, fit, alignment properties
- [x] Divider has thickness, color, indent, endIndent properties
- [x] VerticalDivider has thickness, width, color, indent properties
- [x] Tests: Registration and properties for each widget (31 tests)

---

### Task 2.11: Widget Registry Expansion - Input

| Field | Value |
|-------|-------|
| ID | phase-2-task-11 |
| Status | COMPLETE |
| Priority | P2 |
| Journey AC | J02 (Widget Palette) S1 |
| Requirements | FR1.1 |
| Location | `lib/shared/registry/` |

**Deliverables:**
- [x] ElevatedButton widget (child, onPressed placeholder)
- [x] TextButton widget (child, onPressed placeholder)
- [x] IconButton widget (icon, onPressed placeholder)
- [x] Placeholder widget (fallback size, color)

**New Widgets (4):**
| Widget | Category | Children | Constraint |
|--------|----------|----------|------------|
| ElevatedButton | Input | Single | None |
| TextButton | Input | Single | None |
| IconButton | Input | None | None |
| Placeholder | Content | None | None |

**New Category:** Input

**Acceptance Criteria:**
- [x] Button widgets have child slot and style properties
- [x] IconButton has icon, size, color properties
- [x] Placeholder has fallbackWidth, fallbackHeight, color
- [x] Input category added to WidgetCategory enum
- [x] Tests: Registration and rendering for each widget (35 tests)

---

### Task 2.12: Code Generation Updates

| Field | Value |
|-------|-------|
| ID | phase-2-task-12 |
| Status | COMPLETE |
| Priority | P1 |
| Journey AC | J06 (Code Generation) S1, S3 |
| Requirements | FR5.1, FR5.2 |
| Depends On | phase-2-task-09, phase-2-task-10, phase-2-task-11 |
| Location | `lib/generators/` |

**Deliverables:**
- [x] Code generation for all new Phase 2 widgets
- [x] Flex child handling (Expanded, Flexible, Spacer)
- [x] Stack children with Positioned wrapper support
- [x] Button onPressed callback generation
- [x] Icon data code generation

**Acceptance Criteria (from J06):**
- [x] Valid, compilable Dart code for all 20 widgets (FR5.1)
- [x] Proper import statements generated
- [x] Expanded/Flexible wrapped in valid Flex context
- [x] Stack children generate correctly
- [x] Button callbacks generate as empty closures
- [x] Code formatted with dart_style (FR5.2)
- [x] Generation <500ms for 100 widgets (NFR1.2)
- [x] Tests: Code generation for all new widgets (21 tests)

---

## Phase 2 Definition of Done

- [x] Undo/Redo system with command pattern
- [x] Widget tree panel with selection sync
- [x] Tree drag-reorder with canvas sync
- [x] Context menu for tree operations
- [x] Multi-level nested drop zones (3+ depth)
- [x] Canvas widget reordering
- [x] 20 widgets in registry
- [x] Code generation for all widgets
- [x] `flutter analyze` passes (info-level only)
- [x] `flutter test` passes (404 tests)
- [x] Demo: Complex layout with undo/redo, tree reorder

---

## Task-Journey Mapping (Phase 2)

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-2-task-01 | J07 Edit Operations | Command Reference | COMPLETE |
| phase-2-task-02 | J07 Edit Operations | S1, S2 | COMPLETE |
| phase-2-task-03 | J04 Widget Tree | S1 | COMPLETE |
| phase-2-task-04 | J04 Widget Tree | S2 | COMPLETE |
| phase-2-task-05 | J04 Widget Tree | S3 | COMPLETE |
| phase-2-task-06 | J04 Widget Tree | S4 | COMPLETE |
| phase-2-task-07 | J03 Design Canvas | S2 | COMPLETE |
| phase-2-task-08 | J03 Design Canvas | S4 | COMPLETE |
| phase-2-task-09 | J02 Widget Palette | S1 | COMPLETE |
| phase-2-task-10 | J02 Widget Palette | S1 | COMPLETE |
| phase-2-task-11 | J02 Widget Palette | S1 | COMPLETE |
| phase-2-task-12 | J06 Code Generation | S1, S3 | COMPLETE |

---

## Future Phases

### Phase 3: Design System & Animation (Weeks 7-9)
- DesignToken model
- Theme Manager UI
- Animation studio

### Phase 4: Polish & Save/Load (Weeks 10-11)
- Project persistence
- Keyboard shortcuts
- Copy/paste widgets

### Phase 5: Beta Release (Weeks 12-13)
- Cross-platform testing
- Performance optimization
- Documentation

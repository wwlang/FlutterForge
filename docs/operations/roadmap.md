# FlutterForge Roadmap

**Last Updated:** 2026-01-21

## Overview

This roadmap tracks implementation tasks for FlutterForge Phase 1: Foundation. Each task maps to user journey acceptance criteria for traceability.

---

## Phase 1: Foundation (COMPLETE)

**Milestone:** Drag Container with Text child, edit padding, export basic code

### Task 1.1: Widget Registry System

| Field | Value |
|-------|-------|
| ID | phase-1-task-01 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J02 (Widget Palette) Stage 1, Stage 4 |
| Requirements | FR1.1, FR1.2 |
| Location | `lib/shared/registry/` |

**Deliverables:**
- [x] Widget definition interface with metadata, properties, constraints
- [x] 5 basic widgets: Container, Text, Row, Column, SizedBox
- [x] Property schema definitions for each widget
- [x] Widget category system (Layout, Content)

**Acceptance Criteria:**
- [x] Each widget has type, category, acceptsChildren, maxChildren
- [x] Each widget has property definitions with types and defaults
- [x] Registry provides O(1) lookup by widget type
- [x] Tests verify all 5 widgets registered correctly (23 tests)

---

### Task 1.2: Widget Palette UI

| Field | Value |
|-------|-------|
| ID | phase-1-task-02 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J02 (Widget Palette) Stage 1-4 |
| Requirements | FR1.1, FR1.2 |
| Location | `lib/features/palette/` |

**Deliverables:**
- [x] Categorized widget list component
- [x] Collapsible category headers
- [x] Draggable widget items
- [x] Drag feedback widget

**Acceptance Criteria (from J02):**
- [x] Categories display: Layout, Content (FR1.1)
- [x] Each category collapsible
- [x] Widget shows name and icon
- [x] Drag initiates with pointer anchor strategy (FR1.2)
- [x] Drag preview follows cursor with reduced opacity
- [x] Original item shows at 50% opacity during drag
- [x] Tests: 21 unit tests covering all acceptance criteria

---

### Task 1.3: Basic Canvas

| Field | Value |
|-------|-------|
| ID | phase-1-task-03 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J03 (Design Canvas) Stage 1-3 |
| Requirements | FR2.1, FR2.2, FR2.4, FR2.5 |
| Location | `lib/features/canvas/` |

**Deliverables:**
- [x] Canvas widget with drop zone
- [x] DesignProxy wrapper for event interception
- [x] Selection state and overlay
- [x] Widget renderer from WidgetNode tree

**Acceptance Criteria (from J03):**
- [x] Drop zone indicator appears on drag enter (FR2.2)
- [x] Widget renders at drop location (FR2.1)
- [x] Selection overlay visible on selected widget (FR2.4)
- [x] Click-to-select identifies correct widget (FR2.5)
- [x] Tests: 15 unit tests covering all acceptance criteria

---

### Task 1.4: Single-Level Widget Insertion

| Field | Value |
|-------|-------|
| ID | phase-1-task-04 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J01 (First Export) Stage 4; J03 Stage 2 |
| Requirements | FR2.3 |
| Location | `lib/features/canvas/` |

**Deliverables:**
- [x] Nested drop zone detection
- [x] Parent-child relationship creation
- [x] Single-child container constraint enforcement
- [x] Widget tree update on drop

**Acceptance Criteria (from J01/J03):**
- [x] Nested drop zone appears inside Container (FR2.3)
- [x] Text becomes child of Container on drop
- [x] Single-child containers reject second child
- [x] Widget tree reflects hierarchy
- [x] Tests: 19 unit tests covering widget insertion

---

### Task 1.5: Properties Panel

| Field | Value |
|-------|-------|
| ID | phase-1-task-05 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J05 (Properties Panel) Stage 1-2, 4 |
| Requirements | FR4.1, FR4.2, FR4.4, FR4.5 |
| Location | `lib/features/properties/` |

**Deliverables:**
- [x] Property panel component
- [x] Property editors: String, double, int, bool, Color
- [x] Enum editor for dropdown selection
- [x] Live canvas preview integration

**Acceptance Criteria (from J05):**
- [x] Panel shows properties for selected widget (FR4.1, FR4.4)
- [x] Editable: String, double, int, bool, Color types (FR4.2)
- [x] Canvas updates within 16ms of property change (FR4.5, NFR1.1)
- [x] Properties grouped by category
- [x] Tests: 14 unit tests covering properties panel

---

### Task 1.6: Code Generation

| Field | Value |
|-------|-------|
| ID | phase-1-task-06 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J06 (Code Generation) Stage 1, 3 |
| Requirements | FR5.1, FR5.2, FR5.3, FR5.6 |
| Location | `lib/generators/` |

**Deliverables:**
- [x] DartGenerator using code_builder
- [x] StatelessWidget class generation
- [x] dart_style formatting
- [x] Copy to clipboard functionality

**Acceptance Criteria (from J06):**
- [x] Valid, compilable Dart code output (FR5.1)
- [x] Code formatted with dart_style (FR5.2)
- [x] StatelessWidget structure generated (FR5.3)
- [x] Copy to clipboard works (FR5.6)
- [x] Generation <500ms for 100 widgets (NFR1.2)
- [x] Tests: 9 unit tests for code generation

---

### Task 1.7: App Shell and Integration

| Field | Value |
|-------|-------|
| ID | phase-1-task-07 |
| Status | COMPLETE |
| Priority | P0 |
| Journey AC | J01 (First Export) All Stages |
| Requirements | NFR3.1 |
| Location | `lib/app.dart`, `lib/main.dart` |

**Deliverables:**
- [x] Workbench layout with 3-panel design
- [x] Riverpod providers for project and selection state
- [x] Panel integration (palette, canvas, properties)
- [x] Code preview panel

**Acceptance Criteria (from J01):**
- [x] Main interface displays within 3 seconds (NFR1.3)
- [x] Palette visible on left
- [x] Canvas in center
- [x] Properties on right
- [x] Code preview accessible
- [x] First export achievable within 5 minutes (NFR3.1)
- [x] Tests: 8 integration tests for workbench

---

## Phase 1 Definition of Done

- [x] All 5 widgets in registry with tests
- [x] Widget palette UI with drag support (21 tests)
- [x] Canvas renders widgets, accepts drops (15 tests)
- [x] Properties panel edits work with live preview
- [x] Code generator outputs valid Dart
- [x] `flutter analyze` passes
- [x] `flutter test` passes (109 tests)
- [x] Demo: Container with Text child, padding edited, code exported

---

## Task-Journey Mapping

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-1-task-01 | J02 Widget Palette | 1, 4 | COMPLETE |
| phase-1-task-02 | J02 Widget Palette | 1-4 | COMPLETE |
| phase-1-task-03 | J03 Design Canvas | 1-3 | COMPLETE |
| phase-1-task-04 | J03 Design Canvas | 2 | COMPLETE |
| phase-1-task-05 | J05 Properties Panel | 1-2, 4 | COMPLETE |
| phase-1-task-06 | J06 Code Generation | 1, 3 | COMPLETE |
| phase-1-task-07 | J01 First Export | All | COMPLETE |

---

## Future Phases

### Phase 2: Core Editor (Weeks 4-6)
- Nested DnD with multi-level drop zones
- Widget tree panel with drag reorder
- 15+ widgets
- Undo/Redo command system

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

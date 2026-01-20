# FlutterForge Roadmap

**Last Updated:** 2026-01-21

## Overview

This roadmap tracks implementation tasks for FlutterForge Phase 1: Foundation. Each task maps to user journey acceptance criteria for traceability.

---

## Phase 1: Foundation

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
| Status | PENDING |
| Priority | P0 |
| Journey AC | J02 (Widget Palette) Stage 1-4 |
| Requirements | FR1.1, FR1.2 |
| Location | `lib/features/palette/` |

**Deliverables:**
- Categorized widget list component
- Collapsible category headers
- Draggable widget items
- Drag feedback widget

**Acceptance Criteria (from J02):**
- Categories display: Layout, Content (FR1.1)
- Each category collapsible
- Widget shows name and icon
- Drag initiates with 4px movement (FR1.2)
- Drag preview follows cursor at 70% opacity
- Escape cancels drag operation

---

### Task 1.3: Basic Canvas

| Field | Value |
|-------|-------|
| ID | phase-1-task-03 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J03 (Design Canvas) Stage 1-3 |
| Requirements | FR2.1, FR2.2, FR2.4, FR2.5 |
| Location | `lib/features/canvas/` |

**Deliverables:**
- Canvas widget with drop zone
- DesignProxy wrapper for event interception
- Selection state and overlay
- Widget renderer from WidgetNode tree

**Acceptance Criteria (from J03):**
- Drop zone indicator appears on drag enter (FR2.2)
- Widget renders at drop location (FR2.1)
- Selection overlay visible on selected widget (FR2.4)
- Click-to-select identifies correct widget (FR2.5)
- Canvas render <16ms (NFR1.1)

---

### Task 1.4: Single-Level Widget Insertion

| Field | Value |
|-------|-------|
| ID | phase-1-task-04 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J01 (First Export) Stage 4; J03 Stage 2 |
| Requirements | FR2.3 |
| Location | `lib/features/canvas/` |

**Deliverables:**
- Nested drop zone detection
- Parent-child relationship creation
- Single-child container constraint enforcement
- Widget tree update on drop

**Acceptance Criteria (from J01/J03):**
- Nested drop zone appears inside Container (FR2.3)
- Text becomes child of Container on drop
- Single-child containers reject second child
- Widget tree reflects hierarchy

---

### Task 1.5: Properties Panel

| Field | Value |
|-------|-------|
| ID | phase-1-task-05 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J05 (Properties Panel) Stage 1-2, 4 |
| Requirements | FR4.1, FR4.2, FR4.4, FR4.5 |
| Location | `lib/features/properties/` |

**Deliverables:**
- Property panel component
- Property editors: String, double, int, bool, Color
- EdgeInsets editor (basic)
- Live canvas preview integration

**Acceptance Criteria (from J05):**
- Panel shows properties for selected widget (FR4.1, FR4.4)
- Editable: String, double, int, bool, Color types (FR4.2)
- Canvas updates within 16ms of property change (FR4.5, NFR1.1)
- EdgeInsets editor with all/individual modes

---

### Task 1.6: Code Generation

| Field | Value |
|-------|-------|
| ID | phase-1-task-06 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J06 (Code Generation) Stage 1, 3 |
| Requirements | FR5.1, FR5.2, FR5.3, FR5.6 |
| Location | `lib/generators/` |

**Deliverables:**
- DartGenerator using code_builder
- StatelessWidget class generation
- dart_style formatting
- Copy to clipboard functionality

**Acceptance Criteria (from J06):**
- Valid, compilable Dart code output (FR5.1)
- Code formatted with dart_style (FR5.2)
- StatelessWidget structure generated (FR5.3)
- Copy to clipboard works (FR5.6)
- Generation <500ms for 100 widgets (NFR1.2)

---

### Task 1.7: App Shell and Integration

| Field | Value |
|-------|-------|
| ID | phase-1-task-07 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J01 (First Export) All Stages |
| Requirements | NFR3.1 |
| Location | `lib/app.dart`, `lib/main.dart` |

**Deliverables:**
- Workbench layout with 3-panel design
- Riverpod providers for project and selection state
- Panel integration (palette, canvas, properties)
- Code preview panel

**Acceptance Criteria (from J01):**
- Main interface displays within 3 seconds (NFR1.3)
- Palette visible on left
- Canvas in center
- Properties on right
- Code preview accessible
- First export achievable within 5 minutes (NFR3.1)

---

## Phase 1 Definition of Done

- [x] All 5 widgets in registry with tests
- [ ] Canvas renders widgets, accepts drops
- [ ] Properties panel edits work with live preview
- [ ] Code generator outputs valid Dart
- [x] `flutter analyze` passes
- [x] `flutter test` passes
- [ ] Demo: Container with Text child, padding edited, code exported

---

## Task-Journey Mapping

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-1-task-01 | J02 Widget Palette | 1, 4 | COMPLETE |
| phase-1-task-02 | J02 Widget Palette | 1-4 | PENDING |
| phase-1-task-03 | J03 Design Canvas | 1-3 | PENDING |
| phase-1-task-04 | J03 Design Canvas | 2 | PENDING |
| phase-1-task-05 | J05 Properties Panel | 1-2, 4 | PENDING |
| phase-1-task-06 | J06 Code Generation | 1, 3 | PENDING |
| phase-1-task-07 | J01 First Export | All | PENDING |

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

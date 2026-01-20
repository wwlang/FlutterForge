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

See `.claude/PROGRESS.md` for detailed Phase 2 completion records.

| Task ID | Description | Status |
|---------|-------------|--------|
| phase-2-task-01 | Command Pattern Foundation | COMPLETE |
| phase-2-task-02 | Undo/Redo Provider Integration | COMPLETE |
| phase-2-task-03 | Widget Tree Panel UI | COMPLETE |
| phase-2-task-04 | Widget Tree Selection Sync | COMPLETE |
| phase-2-task-05 | Widget Tree Drag Reorder | COMPLETE |
| phase-2-task-06 | Widget Tree Context Menu | COMPLETE |
| phase-2-task-07 | Multi-Level Nested Drop Zones | COMPLETE |
| phase-2-task-08 | Canvas Widget Reordering | COMPLETE |
| phase-2-task-09 | Widget Registry Expansion - Layout | COMPLETE |
| phase-2-task-10 | Widget Registry Expansion - Content | COMPLETE |
| phase-2-task-11 | Widget Registry Expansion - Input | COMPLETE |
| phase-2-task-12 | Code Generation Updates | COMPLETE |

---

## Phase 3: Design System & Animation (COMPLETE)

**Milestone:** Design tokens, theme modes, animation studio with timeline and keyframes

**Completed:** 2026-01-21 | **Tasks:** 13/13 | **Tests:** 741 | **Journey References:** J08 (Design System), J09 (Animation Studio)

### Task 3.1: Design Token Model (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-01 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J08 (Design System) S1 |
| Requirements | FR8.1 |
| Location | `lib/core/models/`, `lib/providers/` |
| Tests Added | 46 |

**Deliverables:**
- [x] `DesignToken` model with name, type, value(s)
- [x] `TokenType` enum (color, typography, spacing, radius)
- [x] Light/dark value support for color tokens
- [x] `DesignTokensProvider` for project-level token management
- [x] Token serialization for project persistence

---

### Task 3.2: Design System Panel UI (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-02 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J08 (Design System) S1 |
| Requirements | FR8.1 |
| Depends On | phase-3-task-01 |
| Location | `lib/features/design_system/` |
| Tests Added | 54 |

**Deliverables:**
- [x] `DesignSystemPanel` widget with category tabs
- [x] Token list per category with add/edit/delete
- [x] Token form for creating/editing tokens
- [x] Color picker integration for color tokens

---

### Task 3.3: Semantic Token Aliasing (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-03 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | J08 (Design System) S2 |
| Requirements | FR8.2 |
| Depends On | phase-3-task-01 |
| Location | `lib/providers/`, `lib/features/design_system/` |
| Tests Added | 25 |

**Deliverables:**
- [x] Alias token type with reference to base token
- [x] Alias resolution logic (token -> base -> value)
- [x] UI for creating alias tokens
- [x] "Convert to Value" action to break alias
- [x] Alias chain visualization

---

### Task 3.4: Theme Mode Toggle (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-04 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J08 (Design System) S3 |
| Requirements | FR8.3 |
| Depends On | phase-3-task-01 |
| Location | `lib/providers/` |
| Tests Added | 14 |

**Deliverables:**
- [x] `ThemeSettingsProvider` for Light/Dark/System/High-Contrast state
- [x] Theme mode cycling (Light -> Dark -> System)
- [x] High contrast mode toggle
- [x] Keyboard shortcut Ctrl/Cmd+Shift+T to cycle themes
- [x] `getTokenColorValue` helper for resolving values by mode

---

### Task 3.5: Token Application to Widgets (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-05 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J08 (Design System) S4 |
| Requirements | FR8.4 |
| Depends On | phase-3-task-02, phase-3-task-04 |
| Location | `lib/features/properties/` |
| Tests Added | 41 |

**Deliverables:**
- [x] Token picker in properties panel
- [x] Token binding storage in widget properties (`{$token: "name"}`)
- [x] Token resolution for canvas preview
- [x] Visual indicator for token-bound properties
- [x] "Clear Token" action to revert to literal

---

### Task 3.6: Style Presets (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-06 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P2 |
| Journey AC | J08 (Design System) S5 |
| Requirements | FR8.4 |
| Depends On | phase-3-task-05 |
| Location | `lib/features/design_system/`, `lib/providers/` |
| Tests Added | 26 |

**Deliverables:**
- [x] `StylePreset` model with multiple token/value properties
- [x] `StylePresetsNotifier` provider for preset management
- [x] Apply preset to widget action
- [x] Override tracking for individual properties
- [x] Built-in preset library

---

### Task 3.7: ThemeExtension Export (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-07 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | J08 (Design System) S6 |
| Requirements | FR8.5 |
| Depends On | phase-3-task-01 |
| Location | `lib/generators/` |
| Tests Added | 30 |

**Deliverables:**
- [x] `ThemeExtensionGenerator` class
- [x] Generated code includes light/dark instances
- [x] Generated code includes copyWith, lerp methods
- [x] Usage example in comments
- [x] All token types supported (color, spacing, radius, typography)

---

### Task 3.8: Animation Model and Track (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-08 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J09 (Animation Studio) S1 |
| Requirements | FR9.1 |
| Location | `lib/core/models/`, `lib/providers/` |
| Tests Added | 36 |

**Deliverables:**
- [x] `WidgetAnimation` model with type, track, keyframes
- [x] `AnimationType` enum (fade, slide, scale, rotate, custom)
- [x] `EasingType` enum with standard curves
- [x] `Keyframe` model for time-value pairs
- [x] `animationsProvider` for managing animations
- [x] Animation serialization with Freezed/JSON

---

### Task 3.9: Animation Panel and Timeline (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-09 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J09 (Animation Studio) S1, S2 |
| Requirements | FR9.1 |
| Depends On | phase-3-task-08 |
| Location | `lib/features/animation/` |
| Tests Added | 17 |

**Deliverables:**
- [x] `AnimationPanel` widget with track list
- [x] `TimelineEditor` with horizontal timeline and playhead
- [x] `TimelinePainter` for time markers rendering
- [x] Playhead scrubbing with value updates
- [x] Track operations (add via provider)

---

### Task 3.10: Property Keyframing (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-10 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P0 |
| Journey AC | J09 (Animation Studio) S3 |
| Requirements | FR9.2 |
| Depends On | phase-3-task-09 |
| Location | `lib/features/animation/` |
| Tests Added | 17 |

**Deliverables:**
- [x] `KeyframeEditor` widget with keyframe markers
- [x] `KeyframeMarker` widget with selection
- [x] Add keyframe at time position
- [x] Keyframe value editing
- [x] `interpolateKeyframes()` function for value interpolation

---

### Task 3.11: Easing Editor (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-11 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | J09 (Animation Studio) S4 |
| Requirements | FR9.3 |
| Depends On | phase-3-task-10 |
| Location | `lib/features/animation/` |
| Tests Added | 17 |

**Deliverables:**
- [x] `EasingEditor` widget with preset curves
- [x] `CubicBezier` model with evaluate() method
- [x] Curve preview with CustomPaint
- [x] Custom bezier editor with control points
- [x] `easingTypeToCurve()` conversion function

---

### Task 3.12: Animation Triggers (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-12 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P1 |
| Journey AC | J09 (Animation Studio) S5 |
| Requirements | FR9.4 |
| Depends On | phase-3-task-08 |
| Location | `lib/features/animation/` |
| Tests Added | 17 |

**Deliverables:**
- [x] `TriggerType` enum (onLoad, onTap, onVisible, onScroll)
- [x] `AnimationTrigger` model with type and parameters
- [x] `TriggerSelector` widget for trigger type selection
- [x] `TriggerConfigPanel` for trigger configuration
- [x] `triggersProvider` for trigger state management
- [x] Trigger delay and scroll threshold support

---

### Task 3.13: Staggered Animation and Preview (COMPLETE)

| Field | Value |
|-------|-------|
| ID | phase-3-task-13 |
| Status | COMPLETE |
| Completed | 2026-01-21 |
| Priority | P2 |
| Journey AC | J09 (Animation Studio) S6, S7 |
| Requirements | FR9.5 |
| Depends On | phase-3-task-09, phase-3-task-10 |
| Location | `lib/features/animation/` |
| Tests Added | 22 |

**Deliverables:**
- [x] `StaggerConfig` model with delay/overlap
- [x] `StaggerConfigPanel` widget for configuration
- [x] `AnimationPreview` widget with play/pause/reset
- [x] `generateAnimationCode()` for Flutter code export
- [x] `CodeExportPanel` with copy-to-clipboard
- [x] `StaggeredAnimationOrchestrator` for multi-animation coordination

---

## Phase 3 Definition of Done

- [x] Design token model with light/dark values
- [x] Design system panel with token CRUD
- [x] Semantic aliasing with propagation
- [x] Theme mode toggle (Light/Dark/System/High-Contrast)
- [x] Token application to widget properties
- [x] Style presets with override support
- [x] ThemeExtension code export
- [x] Animation model with tracks and keyframes
- [x] Timeline editor with scrubbing
- [x] Property keyframing with interpolation
- [x] Easing editor with presets and custom curves
- [x] Animation triggers (OnLoad, OnTap, OnVisible, OnScroll)
- [x] Staggered animation orchestration
- [x] Animation preview and code export
- [x] `flutter analyze` passes
- [x] `flutter test` passes
- [x] Demo: Themed design with animations exported

---

## Phase 3 Task-Journey Mapping

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-3-task-01 | J08 Design System | S1 | COMPLETE |
| phase-3-task-02 | J08 Design System | S1 | COMPLETE |
| phase-3-task-03 | J08 Design System | S2 | COMPLETE |
| phase-3-task-04 | J08 Design System | S3 | COMPLETE |
| phase-3-task-05 | J08 Design System | S4 | COMPLETE |
| phase-3-task-06 | J08 Design System | S5 | COMPLETE |
| phase-3-task-07 | J08 Design System | S6 | COMPLETE |
| phase-3-task-08 | J09 Animation Studio | S1 | COMPLETE |
| phase-3-task-09 | J09 Animation Studio | S1, S2 | COMPLETE |
| phase-3-task-10 | J09 Animation Studio | S3 | COMPLETE |
| phase-3-task-11 | J09 Animation Studio | S4 | COMPLETE |
| phase-3-task-12 | J09 Animation Studio | S5 | COMPLETE |
| phase-3-task-13 | J09 Animation Studio | S6, S7 | COMPLETE |

---

## Phase 4: Polish & Save/Load

**Milestone:** Project persistence, recent files, auto-save, keyboard shortcuts, copy/paste

**Status:** PENDING | **Estimated Tasks:** 10 | **Journey Reference:** J10 (Project Management)

### Task 4.1: Project Model and Serialization

| Field | Value |
|-------|-------|
| ID | phase-4-task-01 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J10 (Project Management) S2 |
| Requirements | FR6.1 |
| Location | `lib/models/`, `lib/services/` |

**Deliverables:**
- [ ] `ForgeProject` model with screens, tokens, metadata
- [ ] JSON serialization for all project components
- [ ] .forge file format (ZIP containing manifest + project JSON)
- [ ] `ProjectService` for save/load operations
- [ ] File extension association

**Acceptance Criteria (from J10 S2):**
- [ ] Project serializes to .forge file (FR6.1)
- [ ] .forge is ZIP archive with manifest.json, project.json
- [ ] All widget hierarchy preserved on save/load
- [ ] All properties, tokens, animations preserved
- [ ] File size proportional to content
- [ ] Tests: Serialization round-trip, format validation

---

### Task 4.2: New Project Flow

| Field | Value |
|-------|-------|
| ID | phase-4-task-02 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J10 (Project Management) S1 |
| Requirements | FR6.1 |
| Depends On | phase-4-task-01 |
| Location | `lib/features/project/`, `lib/app/` |

**Deliverables:**
- [ ] New project dialog with name input
- [ ] Unsaved changes confirmation dialog
- [ ] File > New Project menu item
- [ ] Cmd/Ctrl+N keyboard shortcut
- [ ] Default project state initialization

**Acceptance Criteria (from J10 S1):**
- [ ] File > New Project opens dialog
- [ ] Cmd/Ctrl+N triggers new project
- [ ] Default name suggested ("Untitled Project")
- [ ] Unsaved changes prompt: Save/Don't Save/Cancel
- [ ] New project has empty canvas, empty tokens
- [ ] Undo history clears
- [ ] Tests: New project flow, unsaved changes handling

---

### Task 4.3: Save and Save As

| Field | Value |
|-------|-------|
| ID | phase-4-task-03 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J10 (Project Management) S2 |
| Requirements | FR6.1 |
| Depends On | phase-4-task-01 |
| Location | `lib/features/project/` |

**Deliverables:**
- [ ] Save dialog with native file picker
- [ ] Save to existing location (quick save)
- [ ] Save As to new location
- [ ] Save confirmation feedback
- [ ] Title bar shows filename and unsaved indicator (*)

**Acceptance Criteria (from J10 S2):**
- [ ] Cmd/Ctrl+S saves project (FR6.1)
- [ ] First save opens file dialog
- [ ] Subsequent saves use same location
- [ ] Cmd/Ctrl+Shift+S opens Save As
- [ ] Default filename is project name + ".forge"
- [ ] Save <500ms for typical project
- [ ] Title bar shows filename, * for unsaved
- [ ] Brief "Saved" confirmation appears
- [ ] Tests: Save flow, title bar state, quick save

---

### Task 4.4: Open Project

| Field | Value |
|-------|-------|
| ID | phase-4-task-04 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J10 (Project Management) S3 |
| Requirements | FR6.2 |
| Depends On | phase-4-task-01 |
| Location | `lib/features/project/` |

**Deliverables:**
- [ ] Open dialog with native file picker (.forge filter)
- [ ] Project deserialization and loading
- [ ] Canvas, tree, properties update with loaded state
- [ ] Unsaved changes confirmation before open
- [ ] Corrupted file error handling

**Acceptance Criteria (from J10 S3):**
- [ ] File > Open opens file dialog (FR6.2)
- [ ] Cmd/Ctrl+O triggers open
- [ ] Filter shows .forge files only
- [ ] Load time <2s for typical project
- [ ] Progress indicator for files >10MB
- [ ] Corrupted file shows error message
- [ ] Unsaved changes prompt before open
- [ ] Tests: Open flow, error handling, state restoration

---

### Task 4.5: Recent Projects

| Field | Value |
|-------|-------|
| ID | phase-4-task-05 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J10 (Project Management) S4 |
| Requirements | FR6.3 |
| Depends On | phase-4-task-04 |
| Location | `lib/features/project/`, `lib/services/` |

**Deliverables:**
- [ ] Recent projects storage (platform-appropriate)
- [ ] File > Recent Projects submenu
- [ ] Welcome screen with recent projects list
- [ ] Recent project click opens project
- [ ] Clear Recent Projects option

**Acceptance Criteria (from J10 S4):**
- [ ] Recent Projects submenu shows up to 10 items (FR6.3)
- [ ] Each shows name and path
- [ ] Click opens project
- [ ] File not found shows error with locate/remove options
- [ ] Clear Recent Projects clears list
- [ ] Welcome screen shows recent projects
- [ ] Recent list persists across app restarts
- [ ] Tests: Recent list CRUD, persistence, not-found handling

---

### Task 4.6: Auto-Save and Recovery

| Field | Value |
|-------|-------|
| ID | phase-4-task-06 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J10 (Project Management) S5 |
| Requirements | FR6.4 |
| Depends On | phase-4-task-01 |
| Location | `lib/services/` |

**Deliverables:**
- [ ] Auto-save timer (60 seconds default)
- [ ] Recovery data storage (OS-appropriate temp directory)
- [ ] Recovery dialog on launch after crash
- [ ] Recover/Discard options
- [ ] Recovery data cleanup after successful save

**Acceptance Criteria (from J10 S5):**
- [ ] Auto-save every 60 seconds (FR6.4)
- [ ] Auto-save non-intrusive (no workflow interruption)
- [ ] Recovery dialog shows on relaunch after crash
- [ ] "Recover" restores project state
- [ ] "Discard" deletes recovery data
- [ ] Recovery data deleted after manual save
- [ ] Auto-save disable option in settings
- [ ] Tests: Auto-save trigger, recovery flow

---

### Task 4.7: Multiple Screens

| Field | Value |
|-------|-------|
| ID | phase-4-task-07 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J10 (Project Management) S6 |
| Requirements | FR6.5 |
| Depends On | phase-4-task-01 |
| Location | `lib/models/`, `lib/features/screens/` |

**Deliverables:**
- [ ] `Screen` model with widget tree and name
- [ ] Screens list in sidebar
- [ ] Add Screen button and action
- [ ] Switch between screens
- [ ] Rename and delete screen operations

**Acceptance Criteria (from J10 S6):**
- [ ] Add Screen creates new empty screen (FR6.5)
- [ ] Screens list shows all project screens
- [ ] Click screen switches canvas to that screen
- [ ] Rename screen with double-click
- [ ] Delete screen with confirmation (if has content)
- [ ] Cannot delete last screen
- [ ] Export specific screen or all screens option
- [ ] Tests: Screen CRUD, switching, export

---

### Task 4.8: Keyboard Shortcuts Consolidation

| Field | Value |
|-------|-------|
| ID | phase-4-task-08 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | Multiple Journeys |
| Requirements | NFR |
| Location | `lib/features/shortcuts/` |

**Deliverables:**
- [ ] Centralized keyboard shortcut manager
- [ ] Shortcuts help panel (Cmd/Ctrl+?)
- [ ] Shortcuts documentation
- [ ] Conflict detection and resolution
- [ ] Platform-aware shortcuts (Cmd vs Ctrl)

**Keyboard Shortcuts:**
- Cmd/Ctrl+N: New Project
- Cmd/Ctrl+O: Open Project
- Cmd/Ctrl+S: Save
- Cmd/Ctrl+Shift+S: Save As
- Cmd/Ctrl+Z: Undo
- Cmd/Ctrl+Shift+Z: Redo
- Cmd/Ctrl+C: Copy Widget
- Cmd/Ctrl+V: Paste Widget
- Cmd/Ctrl+X: Cut Widget
- Cmd/Ctrl+D: Duplicate Widget
- Delete/Backspace: Delete Widget
- Cmd/Ctrl+1: Widget Palette panel
- Cmd/Ctrl+2: Properties panel
- Cmd/Ctrl+3: Widget Tree panel
- Cmd/Ctrl+4: Design System panel
- Cmd/Ctrl+5: Animation panel
- Cmd/Ctrl+Shift+T: Cycle Theme Mode
- Space: Play/Pause Animation
- Arrow Keys: Navigate tree/canvas

**Acceptance Criteria:**
- [ ] All shortcuts documented in help panel
- [ ] Cmd/Ctrl+? opens shortcuts help
- [ ] Platform-aware (macOS: Cmd, Windows/Linux: Ctrl)
- [ ] No conflicts between shortcuts
- [ ] Tests: Shortcut triggering, help panel

---

### Task 4.9: Copy/Paste Widgets

| Field | Value |
|-------|-------|
| ID | phase-4-task-09 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J04 (Widget Tree) S4 |
| Requirements | FR3.4 |
| Depends On | phase-2-task-01 |
| Location | `lib/commands/`, `lib/features/clipboard/` |

**Deliverables:**
- [ ] `CopyWidgetCommand` captures widget and children
- [ ] `PasteWidgetCommand` inserts copied widget
- [ ] Clipboard integration (internal, not system)
- [ ] Copy preserves all properties
- [ ] Paste creates new IDs for widgets

**Acceptance Criteria (from J04 S4):**
- [ ] Cmd/Ctrl+C copies selected widget with children
- [ ] Cmd/Ctrl+V pastes at valid target
- [ ] Cmd/Ctrl+X cuts (copy + delete)
- [ ] Pasted widgets get new unique IDs
- [ ] All properties and children preserved
- [ ] Paste uses AddWidgetCommand for undo
- [ ] Paste disabled if no valid paste target
- [ ] Tests: Copy, paste, cut, ID generation

---

### Task 4.10: Canvas Pan and Zoom

| Field | Value |
|-------|-------|
| ID | phase-4-task-10 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J03 (Design Canvas) |
| Requirements | NFR |
| Depends On | None |
| Location | `lib/features/canvas/` |

**Deliverables:**
- [ ] Canvas zoom with scroll wheel + modifier
- [ ] Canvas pan with space+drag or two-finger scroll
- [ ] Zoom to fit action
- [ ] Zoom percentage indicator
- [ ] Minimum/maximum zoom limits

**Acceptance Criteria:**
- [ ] Cmd/Ctrl+scroll zooms canvas
- [ ] Space+drag pans canvas
- [ ] Two-finger scroll pans (touchpad)
- [ ] Zoom range: 25% to 400%
- [ ] "Fit to Window" button resets view
- [ ] Zoom percentage shown in toolbar
- [ ] Tests: Zoom, pan, reset view

---

## Phase 4 Definition of Done

- [ ] Project save/load with .forge format
- [ ] New project with unsaved changes handling
- [ ] Open project with error handling
- [ ] Recent projects list (10 max)
- [ ] Auto-save with crash recovery
- [ ] Multiple screens per project
- [ ] All keyboard shortcuts documented
- [ ] Copy/paste/cut widgets
- [ ] Canvas pan and zoom
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Demo: Create, design, save, close, reopen with identical state

---

## Phase 4 Task-Journey Mapping

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-4-task-01 | J10 Project Management | S2 | PENDING |
| phase-4-task-02 | J10 Project Management | S1 | PENDING |
| phase-4-task-03 | J10 Project Management | S2 | PENDING |
| phase-4-task-04 | J10 Project Management | S3 | PENDING |
| phase-4-task-05 | J10 Project Management | S4 | PENDING |
| phase-4-task-06 | J10 Project Management | S5 | PENDING |
| phase-4-task-07 | J10 Project Management | S6 | PENDING |
| phase-4-task-08 | Multiple | - | PENDING |
| phase-4-task-09 | J04 Widget Tree | S4 | PENDING |
| phase-4-task-10 | J03 Design Canvas | - | PENDING |

---

## Phase 5: Beta Release

**Milestone:** Cross-platform validation, performance optimization, documentation, CI/CD, release packaging

**Status:** PENDING | **Estimated Tasks:** 8

(Phase 5 tasks remain unchanged...)

---

## Overall Progress Summary

| Phase | Status | Tasks |
|-------|--------|-------|
| Phase 1: Foundation | COMPLETE | 7/7 |
| Phase 2: Core Editor | COMPLETE | 12/12 |
| Phase 3: Design System & Animation | COMPLETE | 13/13 |
| Phase 4: Polish & Save/Load | PENDING | 0/10 |
| Phase 5: Beta Release | PENDING | 0/8 |
| **Total** | | **32/50** |

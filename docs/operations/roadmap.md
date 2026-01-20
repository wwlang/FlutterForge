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

## Phase 3: Design System & Animation

**Milestone:** Design tokens, theme modes, animation studio with timeline and keyframes

**Status:** PENDING | **Estimated Tasks:** 13 | **Journey References:** J08 (Design System), J09 (Animation Studio)

### Task 3.1: Design Token Model

| Field | Value |
|-------|-------|
| ID | phase-3-task-01 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J08 (Design System) S1 |
| Requirements | FR8.1 |
| Location | `lib/models/`, `lib/providers/` |

**Deliverables:**
- [ ] `DesignToken` model with name, type, value(s)
- [ ] `TokenType` enum (color, typography, spacing, radius)
- [ ] Light/dark value support for color tokens
- [ ] `DesignTokensProvider` for project-level token management
- [ ] Token serialization for project persistence

**Acceptance Criteria (from J08 S1):**
- [ ] Token has name, type, value(s) (FR8.1)
- [ ] Color tokens support light and dark values
- [ ] Typography tokens have fontFamily, fontSize, fontWeight, lineHeight
- [ ] Spacing tokens have numeric value
- [ ] Radius tokens have numeric value
- [ ] Token name validation (camelCase, no duplicates)
- [ ] Tests: Token creation, validation, serialization

---

### Task 3.2: Design System Panel UI

| Field | Value |
|-------|-------|
| ID | phase-3-task-02 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J08 (Design System) S1 |
| Requirements | FR8.1 |
| Depends On | phase-3-task-01 |
| Location | `lib/features/design_system/` |

**Deliverables:**
- [ ] `DesignSystemPanel` widget with category tabs
- [ ] Token list per category with add/edit/delete
- [ ] Token form for creating/editing tokens
- [ ] Color picker integration for color tokens
- [ ] Keyboard shortcut Cmd/Ctrl+4 to open panel

**Acceptance Criteria (from J08 S1):**
- [ ] Panel shows Colors, Typography, Spacing, Radii categories
- [ ] "Add Token" button per category
- [ ] Token form inline or modal, quick to complete
- [ ] Color picker for color values
- [ ] Token creation <100ms to save
- [ ] Name validation with camelCase suggestion
- [ ] Tests: Panel rendering, token CRUD operations

---

### Task 3.3: Semantic Token Aliasing

| Field | Value |
|-------|-------|
| ID | phase-3-task-03 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J08 (Design System) S2 |
| Requirements | FR8.2 |
| Depends On | phase-3-task-01 |
| Location | `lib/models/`, `lib/features/design_system/` |

**Deliverables:**
- [ ] Alias token type with reference to base token
- [ ] Alias resolution logic (token -> base -> value)
- [ ] UI for creating alias tokens
- [ ] "Convert to Value" action to break alias
- [ ] Alias chain visualization

**Acceptance Criteria (from J08 S2):**
- [ ] Alias token references base token (FR8.2)
- [ ] Alias resolves to base token's current value
- [ ] Changes to base propagate to aliases instantly
- [ ] Circular reference detection and prevention
- [ ] "Convert to Value" breaks alias, retains current value
- [ ] Visual indicator showing token is alias
- [ ] Deep alias chain warning (>3 levels)
- [ ] Tests: Alias creation, resolution, circular prevention

---

### Task 3.4: Theme Mode Toggle

| Field | Value |
|-------|-------|
| ID | phase-3-task-04 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J08 (Design System) S3 |
| Requirements | FR8.3 |
| Depends On | phase-3-task-01 |
| Location | `lib/providers/`, `lib/features/toolbar/` |

**Deliverables:**
- [ ] `ThemeModeProvider` for Light/Dark/High-Contrast state
- [ ] Theme toggle button in toolbar
- [ ] Canvas preview respects current theme mode
- [ ] Keyboard shortcut Cmd/Ctrl+Shift+T to cycle themes
- [ ] Theme mode persistence in project

**Acceptance Criteria (from J08 S3):**
- [ ] Toggle between Light, Dark, High-Contrast (FR8.3)
- [ ] Canvas updates within 16ms of theme switch
- [ ] All token-based colors switch values
- [ ] Non-token colors remain unchanged
- [ ] Theme mode persists in project file
- [ ] Keyboard Cmd/Ctrl+Shift+T cycles modes
- [ ] Tests: Theme toggle, canvas update, persistence

---

### Task 3.5: Token Application to Widgets

| Field | Value |
|-------|-------|
| ID | phase-3-task-05 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J08 (Design System) S4 |
| Requirements | FR8.4 |
| Depends On | phase-3-task-02, phase-3-task-04 |
| Location | `lib/features/properties/`, `lib/models/` |

**Deliverables:**
- [ ] Token picker in properties panel
- [ ] Token binding storage in widget properties (`{$token: "name"}`)
- [ ] Token resolution for canvas preview
- [ ] Visual indicator for token-bound properties
- [ ] "Clear Token" action to revert to literal

**Acceptance Criteria (from J08 S4):**
- [ ] Property editor shows "Use Token" option (FR8.4)
- [ ] Token picker filters by compatible type
- [ ] Property field shows token name when bound
- [ ] Tooltip shows resolved value
- [ ] Token changes propagate to bound widgets instantly
- [ ] "Clear Token" converts to literal value
- [ ] Tests: Token binding, picker, propagation

---

### Task 3.6: Style Presets

| Field | Value |
|-------|-------|
| ID | phase-3-task-06 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J08 (Design System) S5 |
| Requirements | FR8.4 |
| Depends On | phase-3-task-05 |
| Location | `lib/models/`, `lib/features/design_system/` |

**Deliverables:**
- [ ] `StylePreset` model with multiple token/value properties
- [ ] Preset list in Design System panel
- [ ] Preset creation form
- [ ] Apply preset to widget action
- [ ] Override tracking for individual properties

**Acceptance Criteria (from J08 S5):**
- [ ] Create preset with backgroundColor, foregroundColor, borderRadius, padding
- [ ] Apply preset to widget with one click
- [ ] Edit preset updates all widgets using it
- [ ] Individual property override supported
- [ ] Override indicated visually
- [ ] Delete preset preserves current values on widgets
- [ ] Tests: Preset CRUD, application, override tracking

---

### Task 3.7: ThemeExtension Export

| Field | Value |
|-------|-------|
| ID | phase-3-task-07 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J08 (Design System) S6 |
| Requirements | FR8.5 |
| Depends On | phase-3-task-01 |
| Location | `lib/generators/` |

**Deliverables:**
- [ ] `ThemeExtensionGenerator` class
- [ ] Export UI with preview, copy, save options
- [ ] Generated code includes light/dark instances
- [ ] Generated code includes copyWith, lerp methods
- [ ] Usage example in comments

**Acceptance Criteria (from J08 S6):**
- [ ] Export generates valid ThemeExtension class (FR8.5)
- [ ] Light and dark static instances generated
- [ ] copyWith and lerp methods generated
- [ ] Code formatted with dart_style
- [ ] Copy to clipboard works
- [ ] Save to file with native dialog
- [ ] Usage example in comments
- [ ] Tests: ThemeExtension generation, compilation

---

### Task 3.8: Animation Model and Track

| Field | Value |
|-------|-------|
| ID | phase-3-task-08 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J09 (Animation Studio) S1 |
| Requirements | FR9.1 |
| Location | `lib/models/`, `lib/providers/` |

**Deliverables:**
- [ ] `Animation` model with type, track, keyframes
- [ ] `AnimationType` enum (fade, slide, scale, rotate, custom)
- [ ] Animation storage in widget nodes
- [ ] `AnimationsProvider` for managing animations
- [ ] Animation serialization for persistence

**Acceptance Criteria (from J09 S1):**
- [ ] Animation has type, duration, keyframes (FR9.1)
- [ ] Animation types: Fade, Slide, Scale, Rotate, Custom
- [ ] Animation attached to widget node
- [ ] Multiple animations per widget supported
- [ ] Animation indicator on canvas widget
- [ ] Tests: Animation creation, attachment, serialization

---

### Task 3.9: Animation Panel and Timeline

| Field | Value |
|-------|-------|
| ID | phase-3-task-09 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J09 (Animation Studio) S1, S2 |
| Requirements | FR9.1 |
| Depends On | phase-3-task-08 |
| Location | `lib/features/animation/` |

**Deliverables:**
- [ ] `AnimationPanel` widget with track list
- [ ] `TimelineEditor` with horizontal timeline and playhead
- [ ] Timeline zoom and scroll
- [ ] Playhead scrubbing with canvas preview
- [ ] Track operations (duplicate, delete, lock, hide)

**Acceptance Criteria (from J09 S1, S2):**
- [ ] Panel shows animation tracks for selected widget (FR9.1)
- [ ] Timeline shows time markers and keyframes
- [ ] Playhead draggable to scrub animation
- [ ] Canvas updates at 60fps during scrub
- [ ] Timeline zoom with Cmd/Ctrl+wheel
- [ ] Track resize by dragging dividers
- [ ] Keyboard shortcut Cmd/Ctrl+5 to open panel
- [ ] Tests: Timeline rendering, scrubbing, zoom

---

### Task 3.10: Property Keyframing

| Field | Value |
|-------|-------|
| ID | phase-3-task-10 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | J09 (Animation Studio) S3 |
| Requirements | FR9.2 |
| Depends On | phase-3-task-09 |
| Location | `lib/features/animation/` |

**Deliverables:**
- [ ] `Keyframe` model with time and value
- [ ] Keyframe markers on timeline
- [ ] Add keyframe at playhead position
- [ ] Keyframe editing (value, time)
- [ ] Keyframe drag to change time
- [ ] Multi-property keyframes for custom animations

**Acceptance Criteria (from J09 S3):**
- [ ] Keyframe created at playhead position (FR9.2)
- [ ] Property value interpolates between keyframes
- [ ] Keyframe markers visible on track
- [ ] Click keyframe to edit value
- [ ] Drag keyframe to change timing
- [ ] Delete keyframe removes it
- [ ] Snap to frame (16.67ms at 60fps)
- [ ] Tests: Keyframe CRUD, interpolation, drag

---

### Task 3.11: Easing Editor

| Field | Value |
|-------|-------|
| ID | phase-3-task-11 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J09 (Animation Studio) S4 |
| Requirements | FR9.3 |
| Depends On | phase-3-task-10 |
| Location | `lib/features/animation/` |

**Deliverables:**
- [ ] `EasingEditor` widget with curve visualization
- [ ] Preset easing curves (linear, easeIn, easeOut, easeInOut, bounce, spring)
- [ ] Custom cubic-bezier editor with draggable control points
- [ ] Per-segment easing support
- [ ] Easing preview animation

**Acceptance Criteria (from J09 S4):**
- [ ] Easing presets available (FR9.3)
- [ ] Custom cubic-bezier with draggable handles
- [ ] Curve visualization updates in real-time
- [ ] Preview shows animation with current easing
- [ ] Per-segment easing (A-B different from B-C)
- [ ] Design token integration for motion tokens
- [ ] Tests: Easing selection, custom curve, preview

---

### Task 3.12: Animation Triggers

| Field | Value |
|-------|-------|
| ID | phase-3-task-12 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | J09 (Animation Studio) S5 |
| Requirements | FR9.4 |
| Depends On | phase-3-task-08 |
| Location | `lib/models/`, `lib/features/animation/` |

**Deliverables:**
- [ ] `AnimationTrigger` model with type and parameters
- [ ] Trigger types: OnLoad, OnTap, OnVisible, OnScroll
- [ ] Trigger configuration UI
- [ ] Trigger delay support
- [ ] Multiple triggers per animation

**Acceptance Criteria (from J09 S5):**
- [ ] OnLoad trigger plays on widget mount (FR9.4)
- [ ] OnTap trigger plays on widget tap
- [ ] OnVisible trigger plays when widget enters viewport
- [ ] OnScroll trigger ties progress to scroll position
- [ ] Trigger delay configurable
- [ ] Multiple triggers supported (OR logic)
- [ ] Tests: Trigger configuration, delay, multiple triggers

---

### Task 3.13: Staggered Animation and Preview

| Field | Value |
|-------|-------|
| ID | phase-3-task-13 |
| Status | PENDING |
| Priority | P2 |
| Journey AC | J09 (Animation Studio) S6, S7 |
| Requirements | FR9.5 |
| Depends On | phase-3-task-09, phase-3-task-10 |
| Location | `lib/features/animation/` |

**Deliverables:**
- [ ] Stagger controls for parent widgets
- [ ] Stagger order options (first-to-last, last-to-first, random, custom)
- [ ] Preview playback controls (play, pause, stop, loop, speed)
- [ ] Animation code generation (flutter_animate or raw controller)
- [ ] StatefulWidget generation for animated widgets

**Acceptance Criteria (from J09 S6, S7):**
- [ ] Enable stagger on parent with child animations (FR9.5)
- [ ] Stagger delay configurable
- [ ] Stagger order selectable
- [ ] Preview plays at 60fps
- [ ] Space key toggles play/pause
- [ ] Speed options: 0.25x, 0.5x, 1x, 2x
- [ ] Animation code generates using flutter_animate
- [ ] Complex animations generate raw AnimationController
- [ ] StatefulWidget used for animated widgets
- [ ] Tests: Stagger configuration, preview playback, code generation

---

## Phase 3 Definition of Done

- [ ] Design token model with light/dark values
- [ ] Design system panel with token CRUD
- [ ] Semantic aliasing with propagation
- [ ] Theme mode toggle (Light/Dark/High-Contrast)
- [ ] Token application to widget properties
- [ ] Style presets with override support
- [ ] ThemeExtension code export
- [ ] Animation model with tracks and keyframes
- [ ] Timeline editor with scrubbing
- [ ] Property keyframing with interpolation
- [ ] Easing editor with presets and custom curves
- [ ] Animation triggers (OnLoad, OnTap, OnVisible, OnScroll)
- [ ] Staggered animation orchestration
- [ ] Animation preview and code export
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Demo: Themed design with animations exported

---

## Phase 3 Task-Journey Mapping

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-3-task-01 | J08 Design System | S1 | PENDING |
| phase-3-task-02 | J08 Design System | S1 | PENDING |
| phase-3-task-03 | J08 Design System | S2 | PENDING |
| phase-3-task-04 | J08 Design System | S3 | PENDING |
| phase-3-task-05 | J08 Design System | S4 | PENDING |
| phase-3-task-06 | J08 Design System | S5 | PENDING |
| phase-3-task-07 | J08 Design System | S6 | PENDING |
| phase-3-task-08 | J09 Animation Studio | S1 | PENDING |
| phase-3-task-09 | J09 Animation Studio | S1, S2 | PENDING |
| phase-3-task-10 | J09 Animation Studio | S3 | PENDING |
| phase-3-task-11 | J09 Animation Studio | S4 | PENDING |
| phase-3-task-12 | J09 Animation Studio | S5 | PENDING |
| phase-3-task-13 | J09 Animation Studio | S6, S7 | PENDING |

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

### Task 5.1: Cross-Platform Testing - macOS

| Field | Value |
|-------|-------|
| ID | phase-5-task-01 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | All journeys |
| Requirements | NFR3.1 |
| Location | Integration tests |

**Deliverables:**
- [ ] Full journey smoke tests on macOS
- [ ] macOS-specific bug fixes
- [ ] Native file picker integration verified
- [ ] Keyboard shortcuts verified (Cmd modifier)
- [ ] Performance benchmarks recorded

**Acceptance Criteria:**
- [ ] All user journeys complete successfully on macOS
- [ ] Native dialogs work correctly
- [ ] Keyboard shortcuts use Cmd modifier
- [ ] Canvas renders at 60fps
- [ ] Memory usage stable over extended use
- [ ] Tests: macOS integration test suite

---

### Task 5.2: Cross-Platform Testing - Windows

| Field | Value |
|-------|-------|
| ID | phase-5-task-02 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | All journeys |
| Requirements | NFR3.1 |
| Location | Integration tests |

**Deliverables:**
- [ ] Full journey smoke tests on Windows
- [ ] Windows-specific bug fixes
- [ ] Native file picker integration verified
- [ ] Keyboard shortcuts verified (Ctrl modifier)
- [ ] Performance benchmarks recorded

**Acceptance Criteria:**
- [ ] All user journeys complete successfully on Windows
- [ ] Native dialogs work correctly
- [ ] Keyboard shortcuts use Ctrl modifier
- [ ] Canvas renders at 60fps
- [ ] Memory usage stable over extended use
- [ ] Tests: Windows integration test suite

---

### Task 5.3: Cross-Platform Testing - Linux

| Field | Value |
|-------|-------|
| ID | phase-5-task-03 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | All journeys |
| Requirements | NFR3.1 |
| Location | Integration tests |

**Deliverables:**
- [ ] Full journey smoke tests on Linux (Ubuntu)
- [ ] Linux-specific bug fixes
- [ ] File picker integration (GTK)
- [ ] Keyboard shortcuts verified (Ctrl modifier)
- [ ] Performance benchmarks recorded

**Acceptance Criteria:**
- [ ] All user journeys complete successfully on Linux
- [ ] File dialogs work (GTK integration)
- [ ] Keyboard shortcuts use Ctrl modifier
- [ ] Canvas renders at 60fps
- [ ] Tests: Linux integration test suite

---

### Task 5.4: Performance Optimization

| Field | Value |
|-------|-------|
| ID | phase-5-task-04 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | NFR requirements |
| Requirements | NFR1.1, NFR1.2, NFR1.3 |
| Location | Performance profiling |

**Deliverables:**
- [ ] Canvas render time profiling and optimization
- [ ] Large project performance (100+ widgets)
- [ ] Memory leak detection and fixes
- [ ] Code generation performance optimization
- [ ] Startup time optimization

**Performance Targets (from NFR):**
- [ ] Canvas render <16ms for 50 widgets (NFR1.1)
- [ ] Property edit to canvas update <50ms (NFR1.1)
- [ ] Code generation <500ms for 100 widgets (NFR1.2)
- [ ] File save/load <2s for typical project (NFR1.3)
- [ ] Memory growth <50MB over 1 hour of use
- [ ] Tests: Performance benchmarks, memory profiling

---

### Task 5.5: Documentation

| Field | Value |
|-------|-------|
| ID | phase-5-task-05 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | - |
| Requirements | - |
| Location | `docs/` |

**Deliverables:**
- [ ] User guide with screenshots
- [ ] Feature documentation per journey
- [ ] Keyboard shortcuts reference
- [ ] FAQ/troubleshooting guide
- [ ] API documentation for generators

**Acceptance Criteria:**
- [ ] Getting started guide covers first export journey
- [ ] Each major feature documented with examples
- [ ] Keyboard shortcuts complete and accurate
- [ ] Common issues addressed in FAQ
- [ ] Docs reviewed for accuracy

---

### Task 5.6: GitHub Actions CI/CD

| Field | Value |
|-------|-------|
| ID | phase-5-task-06 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | - |
| Requirements | NFR4.1 |
| Location | `.github/workflows/` |

**Deliverables:**
- [ ] CI workflow for PRs (analyze, test)
- [ ] CD workflow for releases (build, package)
- [ ] macOS, Windows, Linux matrix builds
- [ ] Artifact upload for each platform
- [ ] Release automation on tag push

**Acceptance Criteria:**
- [ ] PRs run flutter analyze + flutter test
- [ ] Builds succeed on macOS, Windows, Linux
- [ ] Artifacts uploaded for each platform
- [ ] Tagged releases auto-build and upload
- [ ] Build times <15 minutes per platform

---

### Task 5.7: Release Packaging - macOS

| Field | Value |
|-------|-------|
| ID | phase-5-task-07 |
| Status | PENDING |
| Priority | P0 |
| Journey AC | - |
| Requirements | NFR4.1 |
| Location | Release scripts |

**Deliverables:**
- [ ] DMG installer with proper signing
- [ ] App bundle with correct Info.plist
- [ ] Code signing with Developer ID
- [ ] Notarization with Apple
- [ ] Universal binary (Intel + Apple Silicon)

**Acceptance Criteria:**
- [ ] DMG installs FlutterForge to Applications
- [ ] App is signed and notarized
- [ ] Universal binary runs on Intel and M-series Macs
- [ ] First launch does not show Gatekeeper warning
- [ ] Tests: Install, launch, basic smoke test

---

### Task 5.8: Release Packaging - Windows/Linux

| Field | Value |
|-------|-------|
| ID | phase-5-task-08 |
| Status | PENDING |
| Priority | P1 |
| Journey AC | - |
| Requirements | NFR4.1 |
| Location | Release scripts |

**Deliverables:**
- [ ] Windows MSIX or installer
- [ ] Linux AppImage or deb/rpm
- [ ] Proper icons and metadata
- [ ] Install/uninstall tested
- [ ] Update mechanism consideration

**Acceptance Criteria:**
- [ ] Windows installer works on Windows 10/11
- [ ] Linux AppImage runs on Ubuntu 22.04+
- [ ] Icons display correctly
- [ ] Uninstall removes all files
- [ ] Tests: Install, launch, basic smoke test

---

## Phase 5 Definition of Done

- [ ] All journeys work on macOS, Windows, Linux
- [ ] Performance meets NFR targets
- [ ] User documentation complete
- [ ] CI/CD pipelines operational
- [ ] Release packages for all platforms
- [ ] Code signed (macOS) and notarized
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes (all platforms)
- [ ] Beta release tagged and published

---

## Phase 5 Task-Journey Mapping

| Task | Primary Journey | Stages | Status |
|------|-----------------|--------|--------|
| phase-5-task-01 | All | All | PENDING |
| phase-5-task-02 | All | All | PENDING |
| phase-5-task-03 | All | All | PENDING |
| phase-5-task-04 | NFR | - | PENDING |
| phase-5-task-05 | - | - | PENDING |
| phase-5-task-06 | - | - | PENDING |
| phase-5-task-07 | - | - | PENDING |
| phase-5-task-08 | - | - | PENDING |

---

## Overall Progress Summary

| Phase | Status | Tasks |
|-------|--------|-------|
| Phase 1: Foundation | COMPLETE | 7/7 |
| Phase 2: Core Editor | COMPLETE | 12/12 |
| Phase 3: Design System & Animation | PENDING | 0/13 |
| Phase 4: Polish & Save/Load | PENDING | 0/10 |
| Phase 5: Beta Release | PENDING | 0/8 |
| **Total** | | **19/50** |
